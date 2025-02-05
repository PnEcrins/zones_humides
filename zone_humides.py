import json
import toml
import psycopg2
import flatdict
from pathlib import Path
from datetime import datetime
from pathlib import Path

from pyodk.client import Client


BASE_DIR = Path(__file__).resolve().parent

client = Client(BASE_DIR / "config.toml")
config = toml.load(BASE_DIR / "config.toml")


con = psycopg2.connect(
    database=config["output"]["DATABASE_NAME"],
    host=config["output"]["DATABASE_HOST"],
    port=config["output"]["DATABASE_PORT"],
    user=config["output"]["DATABASE_USER"],
    password=config["output"]["DATABASE_PASS"]
)
cur = con.cursor()

media_path = Path(config["output"]["EXPORT_PHOTO_PATH"])
if not media_path.exists():
    media_path.mkdir(parents=True)

def get_attachment(project_id, form_id, uuid_sub, media_name):
    response = client.get(
        f"projects/{project_id}/forms/{form_id}/submissions/{uuid_sub}/attachments/{media_name}"
    )
    if response.status_code == 200:
        return response.content
    else:
        None


def format_multiple(val):
    if val:
        val = str(set(val.split(' '))).replace("'", '"')
        return val
    else:
        return None


def format_espece_nitro(sub):
    tab_espece_nitro = []
    tab_autre_espece_nitro = []
    if sub["presence_espece_nitro"]:
        tab_espece_nitro = sub["presence_espece_nitro"].split(" ") 
    
    if sub["autre_espece_eutrophisation"]:
        tab_autre_espece_nitro = sub["autre_espece_eutrophisation"].split(" ")
    return json.dumps(tab_espece_nitro + tab_autre_espece_nitro)


def format_espece_pietinement(sub):
    tab_espece_piet = []
    tab_autre_espece_piet = []

    if sub["espece_indicatrice_pietinement"]:
        tab_espece_piet = sub["espece_indicatrice_pietinement"].split(" ") 
    
    if sub["autre_espece_pietinement"]:
        tab_autre_espece_piet = sub["autre_espece_pietinement"].split(" ")
    return json.dumps(tab_espece_piet + tab_autre_espece_piet)


def format_espece(sub, main_key, completement_key):
    tab_espece_main = []
    tab_autre_espece = []

    if sub[main_key]:
        tab_espece_main = sub[main_key].split(" ")
    
    if sub[completement_key]:
        tab_autre_espece = sub[completement_key].split(" ")
    all_especes = tab_espece_main + tab_autre_espece
    if 'autre' in all_especes:
        all_especes.remove("autre")
    return all_especes


def get_submissions(project_id, form_id):
    # Creation client odk central
    form_data = None
    with client:
        form_data = client.submissions.get_table(
            form_id=form_id,
            project_id=project_id,
            expand="*",
            filter="__system/reviewState ne 'hasIssues' and __system/reviewState ne 'rejected'",
        )
        return form_data["value"]
    
def flat_sub(sub):
    geom = sub.get("geom_zh")
    val = flatdict.FlatDict(sub, delimiter=".")
    output_dict = {}
    for key, val in val.items():
        path = key.split(".")
        output_dict[path[len(path) - 1]] = val
    return geom, output_dict

def insert_especes(table_name, list_espece):
    insert_especes = f"""
    INSERT INTO {table_name} (id_zh, cd_nom)
    VALUES (%(id_zh)s, %(cd_nom)s)
    """

    cur.executemany(insert_especes, ({"id_zh": result[0], "cd_nom": cd_nom} for cd_nom in list_espece if cd_nom != "aucune"))



def update_review_state(project_id, form_id, submission_id, review_state):
    """Update the review state

    :param projet id : the project id
    :type projecet_id: int

    :param form_id id : the xml form id
    :type form_id: str

    :param review_state id : the value of the state for update
    :type form_id: str ("approved", "hasIssues", "rejected")
    """"cd_nom"
    token = client.session.auth.service.get_token(
        username=client.config.central.username,
        password=client.config.central.password,
    )
    # pourquoi classe requests ici et non la methode de la classe Client de pyODK?
    url = f"{client.config.central.base_url}/v1/projects/{project_id}/forms/{form_id}/submissions/{submission_id}"
    review_submission_response = client.patch(
        url,
        data=json.dumps({"reviewState": review_state}),
        headers={
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token,
        },
    )
    try:
        assert review_submission_response.status_code == 200
    except AssertionError:
        print(review_submission_response.status_code)
        print("Error while update submision state")


def save_photo(img, sub):
    file_name = sub["nom_zh"] + "_" + sub["__id"]+".jpg"
    if not (media_path / file_name).exists():
        with open(str(media_path / file_name), "wb") as f:
            f.write(img)


def get_addi_fields_list():
    """ 
    return a list of dict like {"field_name" : <LABEL_FIELDS>", "field_id" :"<ID_FIELD>"}
    """
    cur.execute("select pk, nom_champ from zones_humides.bib_champs")
    fields = cur.fetchall()
    return [{"field_name": f[1], "field_id": f[0]} for f in fields]

################################################
################### MAIN ########################
#################################################

cur.execute("DELETE FROM zones_humides.zh")


for f in config["CENTRAL_ADDI"]["FORMS"]:
    PROJECT_ID = f["PROJECT_ID"]
    FORM_CODE = f["FORM_CODE"]
    subs = get_submissions(PROJECT_ID, FORM_CODE)



    fields = [
        "date", "heure_debut", "nom_zh", "geom", "observateur", "typo_sdage", "type_milieu", 
        "pietinement", "autre_procesus_visible_text", "espece_envahissante",
        "localisation_pratique_gestion_eau", 
        "localisation_pratique_agri_pasto", 
        "localisation_pratique_travaux_foret", 
        "localisation_pratique_loisirs", "uuid_sub",
    ]

    insert_stmt = f"""
    INSERT INTO zones_humides.zh
    (
        {",".join(fields)}
        )
    VALUES({",".join(["%s" for f in fields])});
    """

    addi_field_list = get_addi_fields_list()
    for sub in subs:
        geom, formated_sub = flat_sub(sub)

        binary_geom = None
        # calculate geom
        if geom:
            query_geom = "select ST_Force2D(ST_GeomFromGeoJSON(%s))"
            cur.execute(query_geom, [json.dumps(geom)])
            tuple_result = cur.fetchone()
            if tuple_result:
                binary_geom = tuple_result[0]

        value = [
            formated_sub["date_de_debut_saisie"],
            formated_sub["heure_de_debut_saisie"],
            formated_sub["nom_zh"],
            binary_geom,
            formated_sub["observateur"],
            formated_sub["typo_sdage"],
            formated_sub["type_milieu"],
            formated_sub["pietinement"],
            formated_sub["autre_procesus_visible_text"],
            formated_sub.get("espece_envahissance", None),
            formated_sub["localisation_pratique_gestion_eau"],
            formated_sub["localisation_pratique_agri_pasto"],
            formated_sub["localisation_pratique_travaux_foret"],
            formated_sub["localisation_pratique_loisirs"],
            # get_attachment(PROJECT_ID, FORM_CODE, formated_sub["__id"], formated_sub["image_zh"], formated_sub)
            formated_sub['__id']
            ]
        cur.execute(insert_stmt, value)
        con.commit()

        img = get_attachment(PROJECT_ID, FORM_CODE, formated_sub["__id"], formated_sub["image_zh"])
        if img:
            save_photo(img, formated_sub)

        inserted_id_zh = None
        select_query = "SELECT pk from zones_humides.zh where uuid_sub = %s"
        cur.execute(select_query, [formated_sub['__id']])
        result = cur.fetchone()
        if result:
            inserted_id_zh = result[0]

        espece_indic = format_espece(formated_sub, "espece_indicatrice", "autre_espece_indic")
        espece_nitro = format_espece(formated_sub, "presence_espece_nitro", "autre_espece_eutrophisation")
        espece_pietin = format_espece(formated_sub, "espece_indicatrice_pietinement", "autre_espece_pietinement")

        if espece_indic:
            insert_especes("zones_humides.cor_espece_indic_zh", espece_indic)

        if espece_nitro:
            insert_especes("zones_humides.cor_espece_nitro_zh", espece_nitro)

        if espece_pietin:
            insert_especes("zones_humides.cor_espece_pietinement_zh", espece_pietin)


        # insert in cor_champs_addi
        for field in addi_field_list:
            if formated_sub[field["field_name"]]:
                for val in formated_sub[field["field_name"]].split(" "):
                    query = """
                    INSERT INTO zones_humides.cor_champs_addi (id_zh, id_type_champ, label)
                    VALUES (%s, %s, %s)
                        """
                    cur.execute(query, [inserted_id_zh, field["field_id"], val])

        con.commit()



cur.close()
con.close()