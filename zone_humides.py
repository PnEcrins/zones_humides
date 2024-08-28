import json

import spatialite
import flatdict


from pyodk.client import Client


client = Client("./config.toml")
con = spatialite.connect("/home/theo/Documents/AMENAGEMENT/Acclimo/ODK-zones-humides/bdd/zone_humide.sqlite")
cur = con.cursor()



FORM_CODE = "ZONES_HUMIDES"
PROJECT_ID = 5

def get_attachment(project_id, form_id, uuid_sub, media_name, sub=None):
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
            # filter="__system/reviewState ne 'approved' and __system/reviewState ne 'hasIssues' and __system/reviewState ne 'rejected'",
        )
        return form_data["value"]
    
def flat_sub(sub):
    val = flatdict.FlatDict(sub, delimiter=".")
    output_dict = {}
    for key, val in val.items():
        path = key.split(".")
        output_dict[path[len(path) - 1]] = val
    return output_dict

def insert_especes(table_name, list_espece):
    insert_especes = f"""
    INSERT INTO {table_name} (id_zh, cd_nom)
    VALUES (:id_zh, :cd_nom)
    """

    cur.executemany(insert_especes, ({"id_zh": result[0], "cd_nom": cd_nom} for cd_nom in list_espece))



def update_review_state(project_id, form_id, submission_id, review_state):
    """Update the review state

    :param projet id : the project id
    :type projecet_id: int

    :param form_id id : the xml form id
    :type form_id: str

    :param review_state id : the value of the state for update
    :type form_id: str ("approved", "hasIssues", "rejected")
    """
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






subs = get_submissions(PROJECT_ID, FORM_CODE)


fields = [
    "date", "heure_debut", "nom_zh", "observateur", "critere_delimitation", "typo_sdage", "type_milieu", 
    "pietinement", "source_pietinement", "autre_procesus_visible", "autre_procesus_visible_text", 
    "pratique_gestion_eau", "localisation_pratique_gestion_eau", "pratique_agri_pasto", 
    "localisation_pratique_agri_pasto", "pratique_travaux_foret", 
    "localisation_pratique_travaux_foret", "pratique_loisirs", 
    "localisation_pratique_loisirs", 
    "image_zh"
]

insert_stmt = f"""
INSERT INTO zh
(
    {",".join(fields)}
    )
VALUES({",".join(["?" for f in fields])});
"""

for sub in subs:
    formated_sub = flat_sub(sub)
    param = (formated_sub["nom_zh"],)
    select_query = "SELECT * from zh where nom_zh = ? "
    q = cur.execute(select_query, param)
    value = [
        formated_sub["date_de_debut_saisie"],
        formated_sub["heure_de_debut_saisie"],
        formated_sub["nom_zh"],
        formated_sub["observateur"],
        format_multiple(formated_sub["critere_delimitation"]),
        formated_sub["typo_sdage"],
        formated_sub["type_milieu"],
        formated_sub["pietinement"],
        format_multiple(formated_sub["source_pietinement"]),
        format_multiple("autre_procesus_visible"),
        formated_sub["autre_procesus_visible_text"],
        format_multiple(formated_sub["pratique_gestion_eau"]),
        formated_sub["localisation_pratique_gestion_eau"],
        format_multiple(formated_sub["pratique_agri_pasto"]),
        formated_sub["localisation_pratique_agri_pasto"],
        format_multiple(formated_sub["pratique_travaux_foret"]),
        formated_sub["localisation_pratique_travaux_foret"],
        format_multiple(formated_sub["pratique_loisirs"]),
        formated_sub["localisation_pratique_loisirs"],
        get_attachment(PROJECT_ID, FORM_CODE, formated_sub["__id"], formated_sub["image_zh"], formated_sub)
        ]
    cur.execute(insert_stmt, value)
    con.commit()


    photos_esp = []
    for meta_photo in formated_sub.get("photos", []):
        img = get_attachment(PROJECT_ID, FORM_CODE, formated_sub["__id"], meta_photo["image_espece_indic"], formated_sub)
        if img:
            photos_esp.append(img)
    
    select_query = "SELECT * from zh where nom_zh = ? LIMIT 1"
    q = cur.execute(select_query, param)
    result = q.fetchone()
    if result and len(photos_esp) > 0:

        insert_img = """
        INSERT INTO cor_zh_photos_especes (fk_zh, photo)
        VALUES (:fk_zh, :photo)
        """

        cur.executemany(insert_img, ({"fk_zh": result[0], "photo": photo} for photo in photos_esp))
    
    espece_indic = format_espece(formated_sub, "espece_indicatrice", "autre_espece_indic")
    espece_nitro = format_espece(formated_sub, "presence_espece_nitro", "autre_espece_eutrophisation")
    espece_pietin = format_espece(formated_sub, "espece_indicatrice_pietinement", "autre_espece_pietinement")

    if espece_indic:
        insert_especes("cor_espece_indic_zh", espece_indic)

    if espece_nitro:
        insert_especes("cor_espece_nitro_zh", espece_nitro)

    if espece_pietin:
        insert_especes("cor_espece_pietinement_zh", espece_pietin)

    con.commit()

    update_review_state(
        PROJECT_ID,
        FORM_CODE,
        formated_sub["instanceID"],
        "approved"
    )


