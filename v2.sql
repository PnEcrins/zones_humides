-- zones_humides.zh_qfield_test definition

-- Drop table

-- DROP TABLE zones_humides.zh_qfield_test;

CREATE TABLE zones_humides.zh_qfield_test (
	unique_uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
	geom public.geometry(polygon, 4326) NULL,
	"date" date NULL,
	heure_debut time NULL,
	nom_zh text NULL,
	id_role integer not NULL,
	typo_sdage integer NULL,
	type_milieu integer NULL,
	pietinement integer NULL,
	autre_procesus_visible_text integer NULL,
	localisation_pratique_gestion_eau integer NULL,
	localisation_pratique_agri_pasto integer NULL,
	localisation_pratique_travaux_foret integer NULL,
	localisation_pratique_loisirs integer NULL,
	uuid_sub text NULL,
	espece_envahissante integer NULL,
	code_zh varchar(255) NULL,
	secteur varchar(255) NULL,
	"action" varchar(255) NULL,
	geom_overlap bool DEFAULT false NULL,
	geom_valid bool DEFAULT true NULL,
	geom_intersect_reg bool DEFAULT true NULL,
	diffusion bool DEFAULT true NULL,
	comment_diffusion text NULL,
	valid_topology bool DEFAULT false NULL,
	CONSTRAINT zh_qfield_test_pkey PRIMARY KEY (unique_uuid)
);

ALTER TABLE zones_humides.zh_qfield_test
    ADD CONSTRAINT fk_zh_typo_sdage 
        FOREIGN KEY (typo_sdage) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_type_milieu 
        FOREIGN KEY (type_milieu) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_pietinement 
        FOREIGN KEY (pietinement) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_autre_procesus 
        FOREIGN KEY (autre_procesus_visible_text) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_gestion_eau 
        FOREIGN KEY (localisation_pratique_gestion_eau) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_agri_pasto 
        FOREIGN KEY (localisation_pratique_agri_pasto) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_travaux_foret 
        FOREIGN KEY (localisation_pratique_travaux_foret) REFERENCES zones_humides.nomenclatures(id),
    ADD CONSTRAINT fk_zh_loisirs 
        FOREIGN KEY (localisation_pratique_loisirs) REFERENCES zones_humides.nomenclatures(id);

ALTER TABLE zones_humides.zh_qfield_test
    ADD CONSTRAINT fk_zh_id_role 
        FOREIGN KEY (id_role) REFERENCES utilisateurs.t_roles(id_role);

ALTER TABLE zones_humides.zh_qfield_test
    ADD CONSTRAINT fk_zh_espece_envahissante 
        FOREIGN KEY (espece_envahissante) REFERENCES taxonomie.taxref(cd_nom);



-- CREATE view utilisateurs.t_roles


-- related_question = 'typo_sdage'


CREATE OR REPLACE VIEW zones_humides.especes_indic_zh
AS SELECT t.cd_nom,
    concat(t.lb_nom, ' - ', t.nom_vern) AS concat
   FROM taxonomie.taxref t
     JOIN taxonomie.cor_nom_liste cor ON cor.cd_nom = t.cd_nom AND cor.id_liste = 1020;


CREATE OR REPLACE VIEW zones_humides.taxref_list
AS SELECT t.cd_nom,
    concat(t.lb_nom, ' - ', t.nom_vern) AS concat
   FROM taxonomie.taxref t
     JOIN taxonomie.cor_nom_liste cor ON cor.cd_nom = t.cd_nom AND cor.id_liste = 1019;





CASE 
	WHEN array_contains(pratique_gestion_eau, 86) THEN localisation_pratique_gestion_eau IS NULL
	ELSE localisation_pratique_gestion_eau IS NOT NULL
	
END









CREATE TABLE zones_humides.zh_qfield_test (
	unique_uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
	geom public.geometry(polygon, 4326) NULL,
	critere_delimitation _int4 NULL,
	espece_indicatrice _int4 NULL,
	autre_espece_indic _int4 NULL,
	image_espece_indic text NULL,
	presence_espece_nitro _int4 NULL,
	autre_espece_eutrophisation _int4 NULL,
	"date" timestamp NOT NULL,
	nom_zh text NULL,
	id_role int4 NOT NULL,
	typo_sdage int4 NULL,
	type_milieu int4 NULL,
	pietinement int4 NULL,
	espece_indicatrice_pietinement _int4 NULL,
	autre_espece_pietinement _int4 NULL,
	autre_procesus_visible _int4 NULL,
	autre_procesus_visible_text text NULL,
	pratique_gestion_eau _int4 NULL,
	localisation_pratique_gestion_eau int4 NULL,
	pratique_agri_pasto _int4 NULL,
	localisation_pratique_agri_pasto int4 NULL,
	pratique_travaux_foret _int4 NULL,
	localisation_pratique_travaux_foret int4 NULL,
	pratique_loisirs _int4 NULL,
	localisation_pratique_loisirs int4 NULL,
	image_zh text NULL,
	uuid_sub text NULL,
	espece_envahissante int4 NULL,
	code_zh varchar(255) NULL,
	secteur varchar(255) NULL,
	"action" varchar(255) NULL,
	geom_overlap bool DEFAULT false NULL,
	geom_valid bool DEFAULT true NULL,
	geom_intersect_reg bool DEFAULT true NULL,
	diffusion bool DEFAULT true NULL,
	comment_diffusion text NULL,
	valid_topology bool DEFAULT false NULL,
	CONSTRAINT zh_qfield_test_pkey PRIMARY KEY (unique_uuid)
);



insert
	into
	zones_humides.zh_v2
(
    unique_uuid,
	geom,
	critere_delimitation,
	espece_indicatrice,
	presence_espece_nitro,
	"date",
	nom_zh,
	id_role,
	typo_sdage,
	type_milieu,
	pietinement,
	espece_indicatrice_pietinement,
	autre_procesus_visible,
	autre_procesus_visible_text,
	pratique_gestion_eau,
	localisation_pratique_gestion_eau,
	pratique_agri_pasto,
	localisation_pratique_agri_pasto,
	pratique_travaux_foret,
	localisation_pratique_travaux_foret,
	pratique_loisirs,
	localisation_pratique_loisirs,
	image_zh,
	uuid_sub,
	espece_envahissante,
	code_zh,
	secteur,
	"action",
	geom_overlap,
	geom_valid,
	geom_intersect_reg,
	diffusion,
	comment_diffusion,
	valid_topology
)
select 
uuid_generate_v4(), 
z.geom,
array_agg(criter_delim.id ),
array_agg(ceiz.cd_nom),
array_agg(cenz.cd_nom),
z."date",
z.nom_zh, 
r.id_role,
typo_sdage.id,
type_milieu.id,
pieti.id,
array_agg(cepz.cd_nom),
array_agg(autre_proc.id ),
z.autre_procesus_visible_text,
array_agg(gestion_eau.id ),
loc_gest_eau.id,
array_agg(aggro_pasto.id ),
loc_aggri_pasto.id,
array_agg(trav_for.id ),
loc_trav.id,
array_agg(loisir.id ),
loc_lois.id,
'TODO_IMAGE',
z.uuid_sub,
z.espece_envahissante,
code_zh,
secteur,
"action",
geom_overlap,
geom_valid,
geom_intersect_reg,
diffusion,
comment_diffusion,
valid_topology
from zones_humides.zh z
left join zones_humides.cor_champs_addi cca on cca.id_zh = z.pk and cca.id_type_champ =1
left join zones_humides.nomenclatures criter_delim on criter_delim.value = cca."label"
left join zones_humides.cor_espece_indic_zh ceiz on ceiz.id_zh = z.pk 
left join zones_humides.cor_espece_nitro_zh cenz on cenz.id_zh = z.pk
left join utilisateurs.t_roles r on concat(r.nom_role, ' ', r.prenom_role) = z.observateur
left join zones_humides.cor_champs_addi cca2 on cca2.id_zh = z.pk and cca2.id_type_champ = 12
left join zones_humides.nomenclatures typo_sdage on typo_sdage.value = cca2."label"
left join zones_humides.cor_champs_addi cca3 on cca3.id_zh = z.pk and cca3.id_type_champ = 8
left join zones_humides.nomenclatures type_milieu on type_milieu.value = cca3."label"
left join zones_humides.cor_champs_addi cca4 on cca4.id_zh = z.pk and cca4.id_type_champ = 9
left join zones_humides.nomenclatures pieti on pieti.value = cca4."label"
left join zones_humides.cor_espece_pietinement_zh cepz on cepz.id_zh = z.pk 
left join zones_humides.cor_champs_addi cca5 on cca5.id_zh = z.pk and cca5.id_type_champ = 3
left join zones_humides.nomenclatures autre_proc on autre_proc.value = cca5."label"
left join zones_humides.cor_champs_addi cca6 on cca6.id_zh = z.pk and cca6.id_type_champ = 4
left join zones_humides.nomenclatures gestion_eau on gestion_eau.value = cca6."label"
left join zones_humides.cor_champs_addi cca7 on cca7.id_zh = z.pk and cca7.id_type_champ = 5
left join zones_humides.nomenclatures aggro_pasto on aggro_pasto.value = cca7."label"
left join zones_humides.cor_champs_addi cca8 on cca8.id_zh = z.pk and cca8.id_type_champ = 6
left join zones_humides.nomenclatures trav_for on trav_for.value = cca8."label"
left join zones_humides.cor_champs_addi cca9 on cca9.id_zh = z.pk and cca9.id_type_champ = 7
left join zones_humides.nomenclatures loisir on loisir.value = cca9."label"
left join zones_humides.nomenclatures loc_gest_eau on loc_gest_eau.value = z.localisation_pratique_gestion_eau
left join zones_humides.nomenclatures loc_aggri_pasto on loc_aggri_pasto.value = z.localisation_pratique_agri_pasto
left join zones_humides.nomenclatures loc_trav on loc_trav.value = z.localisation_pratique_travaux_foret
left join zones_humides.nomenclatures loc_lois on loc_trav.value = z.localisation_pratique_loisirs
group by 
z.geom,
z."date",
z.nom_zh, 
r.id_role,
typo_sdage.id,
type_milieu.id,
pieti.id,
z.autre_procesus_visible_text,
z.uuid_sub,
z.espece_envahissante,
code_zh,
secteur,
"action",
geom_overlap,
geom_valid,
geom_intersect_reg,
diffusion,
comment_diffusion,
valid_topology,
loc_gest_eau.id,
loc_aggri_pasto.id,
loc_trav.id,
loc_lois.id
;