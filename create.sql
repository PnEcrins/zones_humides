

MDP zh_user : 4yUv5f2r7HAa6T

set search_path = zones_humides;


CREATE TABLE zh_attr (
"pk" serial PRIMARY KEY,
"date" date,
"heure_debut" time,
"nom_zh" TEXT,
"observateur" TEXT,
"critere_delimitation" TEXT,
"typo_sdage" INTEGER,
"type_milieu" TEXT,
"pietinement" TEXT,
"source_pietinement" TEXT,
"autre_procesus_visible" TEXT,
"autre_procesus_visible_text" TEXT,
"pratique_gestion_eau" TEXT,
"localisation_pratique_gestion_eau" TEXT,
"pratique_agri_pasto" TEXT,
"localisation_pratique_agri_pasto" TEXT,
"pratique_travaux_foret" TEXT,
"localisation_pratique_travaux_foret" TEXT,
"pratique_loisirs" TEXT,
"localisation_pratique_loisirs" TEXT,
"image_zh" bytea
);

create table zh_geom(
id serial primary key,
geom geometry(Polygon, 4326),
nom_zh text
);



-- On ne peut pas ordonné les relation dans QGIS
-- on obligé de créer une PK "id" pour la table taxre et d'inserer dedans en ordonnant par lb_nom


CREATE TABLE zones_humides.taxref(
id serial PRIMARY KEY ,set search_path = zones_humides;

cd_nom integer UNIQUE,
lb_nom text,
nom_vern text,
lb_nom_nom_vern text
);


INSERT INTO zones_humides.taxref(cd_nom, lb_nom, nom_vern, lb_nom_nom_vern)
SELECT t.cd_nom, lb_nom, nom_vern, concat(lb_nom, ' - ', nom_vern) 
FROM taxonomie.taxref t
join taxonomie.bib_noms b on b.cd_nom = t.cd_nom 
join taxonomie.cor_nom_liste cor on cor.id_nom = b.id_nom and cor.id_liste = 1003
ORDER BY lb_nom ASC;
set search_path = zones_humides;


drop table cor_espece_indic_zh;


CREATE TABLE cor_espece_indic_zh (
"pk" serial PRIMARY KEY, 
"id_zh" integer NOT NULL,
"cd_nom" integer NOT NULL,
-- PRIMARY KEY (id_zh, cd_nom),
FOREIGN KEY(id_zh) REFERENCES zh(pk) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED,
FOREIGN KEY(cd_nom) REFERENCES taxref(cd_nom) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED
);


create table cor_espece_nitro_zh (
"pk" serial PRIMARY KEY, 
"id_zh" integer NOT NULL,
"cd_nom" integer NOT NULL,
FOREIGN KEY(id_zh) REFERENCES zh(pk) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED,
FOREIGN KEY(cd_nom) REFERENCES taxref(cd_nom) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED
);

create table cor_espece_pietinement_zh (
"pk" INTEGER PRIMARY KEY AUTOINCREMENT, 
"id_zh" integer NOT NULL,
"cd_nom" integer NOT NULL,
FOREIGN KEY(id_zh) REFERENCES zh(pk) ON DELETE CASCADE,
FOREIGN KEY(cd_nom) REFERENCES taxref(cd_nom)
);



-- cor_zh_photos_especes definition
CREATE TABLE "cor_zh_photos_especes" (
"pk" INTEGER PRIMARY KEY AUTOINCREMENT, 
"fk_zh" INTEGER, 
"photo" BLOB,
FOREIGN KEY(fk_zh) REFERENCES zh(pk)
);


-- zh definition




--- A executer dans QGIS
    SELECT RecoverGeometryColumn('zh', 'geom', 4326, 'POLYGON', 'XY');


-- nomenclatures definition

CREATE TABLE zones_humides.nomenclatures (
id serial primary key,
label text not null,
value text not null,
related_question text not null
);



insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('critere_delimitation','vegetation','Présence d''une végétation hygrophile'),
('critere_delimitation','hydrologie', 'Hydrologie (balancement des eaux, crues, zones d''inondation, fluctuation de la nappe)');
		

insert into nomenclatures (value, label, related_question) VALUES 
('AL_alluvions','Alluvions (Végétation herbacée pionnière Des)', 'type_milieu'),
('BM_bas_marais','Bas-marais et marais de transition', 'type_milieu'),
('BCH_boisement_coniferes_hum','Boisement de conifères humide', 'type_milieu'),
('BFH_boisement_feuillu_humide','Boisement feuillu humide', 'type_milieu'),
('EC_bordure_eaux_courantes','Bordure d’eaux courantes (Végétation amphibie des)', 'type_milieu'),
('FU_fourré_humide','Fourré humide', 'type_milieu'),
('GH_grands_helophytes','Grands hélophytes (Communauté de)', 'type_milieu'),
('MC_magnocariçaie','Magnocariçaie', 'type_milieu'),
('MG_mégaphorbiaie','Mégaphorbiaie', 'type_milieu'),
('RB_petit_helophytes','Petits hélophytes (Communauté de )', 'type_milieu'),
('PH_prairie_humide','Prairie humide (et pelouse humide)', 'type_milieu'),
('AQ_vegetation_aqua','Végétation aquatique', 'type_milieu'),
('FO_vegetation_fontinale','Végétation fontinale (sources, mouillères)', 'type_milieu');



insert into nomenclatures (related_question, value, label) VALUES 
('pietinement','03_45_0_pas_de_paturage' ,'0 – Pas de pâturage, ni traces de fréquentation : pas de crottes observées, ni traces de pas'),
('pietinement','03_45_1_passage_rapide','1 – Trace de passage rapide (crottes et/ou pas)'),
('pietinement','03_45_2_passage_frequent','2 – Traces de passages plus fréquents et dispersés sans création de sol nu'),
('pietinement','03_45_3_plages_sol_nu_localisees','3 – Plages de sol nu localisées'),
('pietinement','03_45_4_plages_sol_nu_sup10','4 – Plages de sol nu >10 % de la surface'),
('pietinement','03_45_5_plages_sol_nu_sup50','5 – Plages de sol nu > 50 % de la surface');


insert into nomenclatures (related_question, value, label) VALUES 
('typo_sdage', '7_zones_humides_bas_fond', '7 – Zones humides de bas fonds en tête de bassin'),
('typo_sdage', '10_marais_landes', '10 – Marais et landes humides de plateaux'),
('typo_sdage', '11_zones_humides_ponctuelles', '11 – Zones humides ponctuelles'),
('typo_sdage', '12_marais_amenage_but_agri_sylvi', '12 – Marais aménagés dans un but agricole ou sylvicole'),
('typo_sdage', '13_zones_humides_artif', '13 – Zones humides artificielles')


insert into nomenclatures (related_question, value, label) VALUES 
('source_pietinement', '1_animal_sauvage', 'Animale sauvage'),
('source_pietinement', '2_animal_domestique', 'Animale domestique'),
('source_pietinement', '3_humaine', 'Humaine'),
('source_pietinement', '4_ne_sait_pas', 'Ne sait pas');



insert into nomenclatures (related_question, value, label) VALUES 
('autre_procesus_visible', '81_imp_erosion_naturelle', 'Érosion naturelle'),
('autre_procesus_visible', '82_imp_atterissement_evasement_assechement', 'Atterrissement, envasement, assèchement'),
('autre_procesus_visible', '94_imp_envahissement_esepece', 'Envahissement d''une espèce'),
('autre_procesus_visible', '21_84_mouvement_terrain', 'Mouvement de terrain'),
('autre_procesus_visible', 'autre', 'Autre'),
('autre_procesus_visible', '00_0_aucun', 'Aucun');


insert into nomenclatures (related_question, value, label) VALUES 
('pratique_gestion_eau', '21_31_comblement_assechement_drainage', 'Comblement, assèchement, drainage des zones humides'),
('pratique_gestion_eau', '21_32_retenue_collinaire', 'Création de retenues collinaires'),
('pratique_gestion_eau', '17_36_hydroelectricite', 'Activité hydroélectrique (microcentrales et autres)'),
('pratique_gestion_eau', '21_36_modification_fonctionnement_hydraulique', 'Modification du fonctionnement hydraulique'),
('pratique_gestion_eau', '21_37_action_vegetation_immergee', 'Action sur la végétation immergée, flottante ou amphibie, y compris faucardage et démottage'),
('pratique_gestion_eau', '00_0_aucun', 'Aucune');

insert into nomenclatures (related_question, value, label) VALUES 
('localisation_pratique' , '1_au_niveau_zh' , '1 - au niveau de la zone humide'),
('localisation_pratique' , '2_au_niveau_espace_fonctionnalite' , '2 – au niveau de l''espace de fonctionnalité'),
('localisation_pratique' , '3_au_niveau_zh_et_espace_fonctionnalite' , '3 – au niveau de la zone humide et de l''espace de fonctionnalité'),
('localisation_pratique' , 'non_determinee' , 'Non déterminée');



insert into nomenclatures (related_question, value, label) VALUES 
('pratique_agri_pasto' , '01_42_debroussaillage_suppression_haies_et_bosquets' , 'Débroussaillage, suppression haies et bosquets, remembrement et travaux connexes'),
('pratique_agri_pasto' , '20_45_captage_eau_abreuvement' , 'Prélèvements d’eau pour l’abreuvement (captage et prise d’eau)'),
('pratique_agri_pasto' , '20_45_abreuvement_troupeau_zh' , 'Abreuvement du troupeau dans la zone humide'),
('pratique_agri_pasto' , '03_46_suppression_ou_entretien_vegetation_fauchage_fenaison' , 'Suppression ou entretien de la végétation fauchage et fenaison'),
('pratique_agri_pasto' , '03_17_infrastructure_pastorale' , 'Infrastructure pastorale (cabane d’alpage, parc de tri…)'),
('pratique_agri_pasto' , '03_13_piste_pastorale' , 'Création de pistes pastorales'),
('pratique_agri_pasto' , '03_47_abandon_syst_pastoraux' , 'Abandon de systèmes pastoraux'),
('pratique_agri' , '00_0_aucun' , 'Aucune');


insert into nomenclatures (related_question, value, label) VALUES 
('pratique_travaux_foret' , '02_51_coupe' , 'Coupes, abattages, arrachages et déboisements'),
('pratique_travaux_foret' , '02_52_taille_elagage' , 'Taille, élagage'),
('pratique_travaux_foret' , '02_53_plantations' , 'Plantations'),
('pratique_travaux_foret' , '02_55_piste_forestiere' , 'Création de traînes et pistes forestières'),
('pratique_travaux_foret' , '00_0_aucun' , 'Aucune');





insert into nomenclatures (related_question, value, label) VALUES 
('pratique_loisirs' , '07_61_baignade' , 'Baignade'),
('pratique_loisirs' , '07_61_proximite_sentier' , 'Proximité d’un sentier dans les 100 m'),
('pratique_loisirs' , '07_61_dechets' , 'Présence de déchets'),
('pratique_loisirs' , '07_61_bivouac' , 'Bivouac'),"cd_nom"
('pratique_loisirs' , '07_16_proximite_refuge' , 'Proximité d’un refuge dans l’espace de fonctionnalité'),
('pratique_loisirs' , '20_61_prelevement_eau_refuge' , 'Prélèvements d’eau pour le fonctionnement d’un refuge'),
('pratique_loisirs' , '05_62_chasse' , 'Chasse'),
('pratique_loisirs' , '04_63_pêche' , 'Pêche'),
('pratique_loisirs' , '04_63_alevinage' , 'Alevinage'),
('pratique_loisirs' , '07_64_cueillette_et_ramassage' , 'Cueillette et ramassage'),
('pratique_loisirs' , '00_0_aucun' , 'Aucune');



CREATE TABLE users (
name text PRIMARY KEY,
label text
);











--SAVE

select t.cd_nom, lb_nom, nom_vern, concat(lb_nom, ' - ', nom_vern)
from taxonomie.taxref t
join taxonomie.bib_noms b on b.cd_nom = t.cd_nom 
join taxonomie.cor_nom_liste c on c.id_nom = b.id_nom and c.id_liste = 500 or c.id_liste = 1003
where t.regne = 'Plantae' and t.cd_nom = 994837;


--Generer la liste de taxon pour ODK

select distinct t.cd_nom as name,  concat(lb_nom, ' - ', nom_vern ) as label
from taxonomie.taxref t
join taxonomie.bib_noms b on b.cd_nom = t.cd_nom 
join taxonomie.cor_nom_liste c on c.id_nom = b.id_nom and c.id_liste = 500 or c.id_liste = 1003
where t.regne = 'Plantae';



-- zones_humides.export_zh source

CREATE OR REPLACE VIEW zones_humides.export_zh_attr
AS WITH indic AS (
         SELECT array_agg(t.lb_nom) AS especes,
            cor_espece_indic_zh.id_zh
           FROM zones_humides.cor_espece_indic_zh
             JOIN taxonomie.taxref t ON t.cd_nom = cor_espece_indic_zh.cd_nom
          GROUP BY cor_espece_indic_zh.id_zh
        ), nitro AS (
         SELECT array_agg(t.lb_nom) AS especes,
            cor_espece_nitro_zh.id_zh
           FROM zones_humides.cor_espece_nitro_zh
             JOIN taxonomie.taxref t ON t.cd_nom = cor_espece_nitro_zh.cd_nom
          GROUP BY cor_espece_nitro_zh.id_zh
        ), pieti AS (
         SELECT array_agg(t.lb_nom) AS especes,
            cor_espece_pietinement_zh.id_zh
           FROM zones_humides.cor_espece_pietinement_zh
             JOIN taxonomie.taxref t ON t.cd_nom = cor_espece_pietinement_zh.cd_nom
          GROUP BY cor_espece_pietinement_zh.id_zh
        ), photo AS (
         SELECT count(*) AS nb_photo, czpe.fk_zh
           FROM zones_humides.cor_zh_photos_especes czpe 
          GROUP BY czpe.fk_zh
        )
        
 SELECT z.pk,
    z.date AS heure_debut,
    z.nom_zh,
    z.observateur,
    z.critere_delimitation,
    z.typo_sdage,
    z.type_milieu,
    z.pietinement,
    z.source_pietinement,
    z.autre_procesus_visible,
    z.autre_procesus_visible_text,
    z.pratique_gestion_eau,
    z.localisation_pratique_gestion_eau,
    z.pratique_agri_pasto,
    z.localisation_pratique_agri_pasto,
    z.pratique_travaux_foret,
    z.localisation_pratique_travaux_foret,
    z.pratique_loisirs,
    z.localisation_pratique_loisirs,
    indic.especes AS espece_indic,
    nitro.especes AS espece_nitro,
    pieti.especes AS espece_pieti,
    photo.nb_photo as nb_photo_espece
   FROM zones_humides.zh_attr z
     LEFT JOIN indic ON indic.id_zh = z.pk
     LEFT JOIN nitro ON nitro.id_zh = z.pk
     LEFT JOIN pieti ON pieti.id_zh = z.pk
          LEFT JOIN photo ON photo.fk_zh = z.pk;





grant SELECT ON taxonomie.taxref to zh_user;
grant usage on schema taxonomie to zh_user;

grant SELECT ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant UPDATE ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant DELETE ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant INSERT ON ALL TABLES IN SCHEMA zones_humides to zh_user;


grant SELECT ON ALL VIEWS IN SCHEMA zones_humides to zh_user;


<script>document.write(expression.evaluate(" '<img width=500 src=' || '\"data:image/png;base64,' || to_base64(\"image_zh\") || '\">' "))</script>
