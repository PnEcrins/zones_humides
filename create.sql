
-- nomenclatures definition

CREATE TABLE zones_humides.zh (
	pk serial4 NOT NULL,
	geom public.geometry(polygon, 4326) NULL,
	"date" date NULL,
	heure_debut time NULL,
	nom_zh text NULL,
	observateur text NULL,
	typo_sdage text NULL,
	type_milieu text NULL,
	pietinement text NULL,
	autre_procesus_visible_text text NULL,
	localisation_pratique_gestion_eau text NULL,
	localisation_pratique_agri_pasto text NULL,
	localisation_pratique_travaux_foret text NULL,
	localisation_pratique_loisirs text NULL,
	uuid_sub text NULL,
	espece_envahissante int4 NULL,
	code_zh varchar(255) NULL,
	secteur varchar(255) NULL,
	"action" varchar(255) NULL,
  geom_overlap boolean default false,
  geom_valid boolean default false,
  geom_intersect_reg boolean default true,
  valid_topology boolean default false,
  diffusion boolean default true,
  comment_diffusion text,

	CONSTRAINT zh_pkey PRIMARY KEY (pk),
	CONSTRAINT fk_zh_espece_envahissante FOREIGN KEY (espece_envahissante) REFERENCES taxonomie.taxref(cd_nom)
);

COMMENT ON COLUMN zones_humides.zh.geom_overlap IS 'Vrai si deux ZH de l''inventaire PNE se superposent';

COMMENT ON COLUMN zones_humides.zh.geom_valid IS 'Vrai si la géométrie est valide (ST_IsValid)';

COMMENT ON COLUMN zones_humides.zh.geom_intersect_reg IS 'Vrai si la géométrie d''une ZH PNE intersecte une geom de l''inventaire régionale';


CREATE TABLE zones_humides.cor_espece_indic_zh (
"pk" serial PRIMARY KEY, 
"id_zh" integer NOT NULL,
"cd_nom" integer NOT NULL,
FOREIGN KEY(id_zh) REFERENCES zones_humides.zh(pk) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED,
FOREIGN KEY(cd_nom) REFERENCES taxonomie.taxref(cd_nom) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED
);


create table zones_humides.cor_espece_nitro_zh (
"pk" serial PRIMARY KEY, 
"id_zh" integer NOT NULL,
"cd_nom" integer NOT NULL,
FOREIGN KEY(id_zh) REFERENCES zones_humides.zh(pk) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED,
FOREIGN KEY(cd_nom) REFERENCES taxonomie.taxref(cd_nom) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED
);


CREATE TABLE zones_humides.cor_espece_pietinement_zh (
	pk serial4 NOT NULL,
	id_zh int4 NOT NULL,
	cd_nom int4 NOT NULL,
	CONSTRAINT cor_espece_pietinement_zh_pkey PRIMARY KEY (pk),
	CONSTRAINT cor_espece_pietinement_zh_cd_nom_fkey FOREIGN KEY (cd_nom) REFERENCES taxonomie.taxref(cd_nom),
	CONSTRAINT cor_espece_pietinement_zh_id_zh_fkey FOREIGN KEY (id_zh) REFERENCES zones_humides.zh(pk) ON DELETE CASCADE
);


create table zones_humides.bib_champs(
  pk serial primary key,
  nom_champ character varying(255)
);

CREATE TABLE zones_humides.cor_champs_addi (
	pk serial4 NOT NULL,
	id_zh int4 NULL,
	id_type_champ int4 NULL,
	"label" varchar(255) NULL,
	CONSTRAINT cor_champs_addi_pkey PRIMARY KEY (pk),
	CONSTRAINT cor_champs_addi_id_type_champ_fkey FOREIGN KEY (id_type_champ) REFERENCES zones_humides.bib_champs(pk) ON DELETE CASCADE,
	CONSTRAINT cor_champs_addi_id_zh_fkey FOREIGN KEY (id_zh) REFERENCES zones_humides.zh(pk) ON DELETE CASCADE
);


CREATE TABLE zones_humides.nomenclatures (
id serial primary key,
label text not null,
value text not null,
related_question text not null,
cd_nomenclature_coresp character varying(255),
code_activite_hum character varying(255),
code_impact character varying(255)
);

create table zones_humides.cor_rhomeo_eunis_corine_biotope (
id serial primary key,
code_rhomeo character varying(255),
value_dest character varying(255),
type_ref character varying(255)
);


-- zones_humides.export_zh source


CREATE OR REPLACE VIEW zones_humides.export_zh
AS WITH indic AS (
         SELECT string_agg(t_1.lb_nom::text, ', '::text) AS especes,
            cor_espece_indic_zh.id_zh
           FROM zones_humides.cor_espece_indic_zh
             JOIN taxonomie.taxref t_1 ON t_1.cd_nom = cor_espece_indic_zh.cd_nom
          GROUP BY cor_espece_indic_zh.id_zh
        ), nitro AS (
         SELECT string_agg(t_1.lb_nom::text, ', '::text) AS especes,
            cor_espece_nitro_zh.id_zh
           FROM zones_humides.cor_espece_nitro_zh
             JOIN taxonomie.taxref t_1 ON t_1.cd_nom = cor_espece_nitro_zh.cd_nom
          GROUP BY cor_espece_nitro_zh.id_zh
        ), pieti AS (
         SELECT string_agg(t_1.lb_nom::text, ', '::text) AS especes,
            cor_espece_pietinement_zh.id_zh
           FROM zones_humides.cor_espece_pietinement_zh
             JOIN taxonomie.taxref t_1 ON t_1.cd_nom = cor_espece_pietinement_zh.cd_nom
          GROUP BY cor_espece_pietinement_zh.id_zh
        ), delim AS (
         SELECT string_agg(addi.label::text, ' '::text) AS delimitation_zh,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'critere_delimitation'::text
          GROUP BY addi.id_zh
        ), source_pietinement AS (
         SELECT string_agg(addi.label::text, ', '::text) AS source_pietinement,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'source_pietinement'::text
          GROUP BY addi.id_zh
        ), autre_procesus_visible AS (
         SELECT string_agg(addi.label::text, ', '::text) AS autre_procesus_visible,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'autre_procesus_visible'::text
          GROUP BY addi.id_zh
        ), pratique_gestion_eau AS (
         SELECT string_agg(addi.label::text, ', '::text) AS pratique_gestion_eau,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'pratique_gestion_eau'::text
          GROUP BY addi.id_zh
        ), pratique_agri_pasto AS (
         SELECT string_agg(addi.label::text, ', '::text) AS pratique_agri_pasto,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'pratique_agri_pasto'::text
          GROUP BY addi.id_zh
        ), pratique_travaux_foret AS (
         SELECT string_agg(addi.label::text, ', '::text) AS pratique_travaux_foret,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'pratique_travaux_foret'::text
          GROUP BY addi.id_zh
        ), pratique_loisirs AS (
         SELECT string_agg(addi.label::text, ', '::text) AS pratique_loisirs,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
          WHERE bc.nom_champ::text = 'pratique_loisirs'::text
          GROUP BY addi.id_zh
        )
 SELECT z.pk,
    z.date AS heure_debut,
    z.nom_zh,
    delim.delimitation_zh,
    z.geom,
    z.observateur,
    z.typo_sdage,
    z.type_milieu,
    autre_procesus_visible.autre_procesus_visible,
    z.pietinement,
    source_pietinement.source_pietinement,
    t.lb_nom AS espece_envahissante,
    pratique_gestion_eau.pratique_gestion_eau,
    z.localisation_pratique_gestion_eau,
    pratique_agri_pasto.pratique_agri_pasto,
    z.localisation_pratique_agri_pasto,
    pratique_travaux_foret.pratique_travaux_foret,
    z.localisation_pratique_travaux_foret,
    pratique_loisirs.pratique_loisirs,
    z.localisation_pratique_loisirs,
    indic.especes AS espece_indic,
    nitro.especes AS espece_nitro,
    pieti.especes AS espece_pieti,
    concat('https://geonature.ecrins-parcnational.fr/api/media/zh/', replace(z.nom_zh, ' '::text, '_'::text), '_', z.uuid_sub, '.jpg') AS url_image
   FROM zones_humides.zh z
     LEFT JOIN taxonomie.taxref t ON t.cd_nom = z.espece_envahissante
     LEFT JOIN indic ON indic.id_zh = z.pk
     LEFT JOIN nitro ON nitro.id_zh = z.pk
     LEFT JOIN pieti ON pieti.id_zh = z.pk
     LEFT JOIN delim ON delim.id_zh = z.pk
     LEFT JOIN source_pietinement ON source_pietinement.id_zh = z.pk
     LEFT JOIN autre_procesus_visible ON autre_procesus_visible.id_zh = z.pk
     LEFT JOIN pratique_gestion_eau ON pratique_gestion_eau.id_zh = z.pk
     LEFT JOIN pratique_agri_pasto ON pratique_agri_pasto.id_zh = z.pk
     LEFT JOIN pratique_travaux_foret ON pratique_travaux_foret.id_zh = z.pk
     LEFT JOIN pratique_loisirs ON pratique_loisirs.id_zh = z.pk;

-- Vue intemediaire qui décode toutes les activité humaines / impact de chaque ZH avec les code_nomenclatures
-- utilisées par le module ZH GN


-- zones_humides.cor_activite_impact_zh_decoded source
CREATE OR REPLACE VIEW zones_humides.cor_activite_impact_zh_decoded
AS 
SELECT DISTINCT nom.code_activite_hum,
    nom.code_impact,
    addi.id_zh,
    '1' as loc -- au niveau de la zone humide
   FROM zones_humides.cor_champs_addi addi
    JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
    JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value
  WHERE bc.nom_champ::text = 'source_pietinement'::text AND nom.code_activite_hum IS NOT NULL
UNION
 SELECT DISTINCT nom.code_activite_hum,
    nom.code_impact,
    addi.id_zh,
    '0' as loc -- on ne connait pas la localisation des autres procesus visibles
   FROM zones_humides.cor_champs_addi addi
     JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
     JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value
  WHERE bc.nom_champ::text = 'autre_procesus_visible'::text AND nom.code_activite_hum IS NOT NULL
UNION
 SELECT DISTINCT nom.code_activite_hum,
    nom.code_impact,
    addi.id_zh,
    loc.cd_nomenclature_coresp as loc
   FROM zones_humides.cor_champs_addi addi
     JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
     JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value and bc.nom_champ::text = 'pratique_gestion_eau'::text
     join zones_humides.zh z on addi.id_zh = z.pk
     left join zones_humides.nomenclatures loc on loc.value = z.localisation_pratique_gestion_eau
  WHERE nom.code_activite_hum IS NOT NULL
UNION
 SELECT DISTINCT nom.code_activite_hum,
    nom.code_impact,
    addi.id_zh,
    loc.cd_nomenclature_coresp as loc
   FROM zones_humides.cor_champs_addi addi
     JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
     JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value and bc.nom_champ::text = 'pratique_agri_pasto'::text
     join zones_humides.zh z on addi.id_zh = z.pk
     left join zones_humides.nomenclatures loc on loc.value = z.localisation_pratique_agri_pasto
  WHERE   nom.code_activite_hum IS NOT NULL
UNION
 SELECT DISTINCT nom.code_activite_hum,
    nom.code_impact,
    addi.id_zh,
    loc.cd_nomenclature_coresp as loc
   FROM zones_humides.cor_champs_addi addi
     JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
     JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value and bc.nom_champ::text = 'pratique_travaux_foret'::text
     join zones_humides.zh z on addi.id_zh = z.pk
     left join zones_humides.nomenclatures loc on loc.value = z.localisation_pratique_travaux_foret
  WHERE  nom.code_activite_hum IS NOT NULL
UNION
 SELECT DISTINCT nom.code_activite_hum,
    nom.code_impact,
    addi.id_zh,
    loc.cd_nomenclature_coresp as loc
   FROM zones_humides.cor_champs_addi addi
     JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
     JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value and bc.nom_champ::text = 'pratique_loisirs'::text
     join zones_humides.zh z on addi.id_zh = z.pk
     left join zones_humides.nomenclatures loc on loc.value = z.localisation_pratique_loisirs
  WHERE  nom.code_activite_hum IS NOT NULL;
-- zones_humides.export_regional source

CREATE OR REPLACE VIEW zones_humides.export_regional
AS WITH delim AS (
         SELECT array_agg(nom.cd_nomenclature_coresp) AS cd_nomenclature_delimitation,
            addi.id_zh
           FROM zones_humides.cor_champs_addi addi
             JOIN zones_humides.bib_champs bc ON bc.pk = addi.id_type_champ
             LEFT JOIN zones_humides.nomenclatures nom ON addi.label::text = nom.value
          WHERE bc.nom_champ::text = 'critere_delimitation'::text
          GROUP BY addi.id_zh
        ), tmp AS (
         SELECT json_build_object('cd_activite_humaine', cor_decod.code_activite_hum, 'localisation', cor_decod.loc, 'impact', array_agg(DISTINCT cor_decod.code_impact)) AS obj,
            cor_decod.id_zh
           FROM zones_humides.cor_activite_impact_zh_decoded cor_decod
          GROUP BY cor_decod.id_zh, cor_decod.code_activite_hum, cor_decod.loc
        ), habitat_corine AS (
         SELECT z_1.pk,
            string_agg(cor_hab.value_dest::text, ', '::text) AS habitat_corine_biotope
           FROM zones_humides.zh z_1
             JOIN zones_humides.cor_rhomeo_eunis_corine_biotope cor_hab ON cor_hab.code_rhomeo::text = "substring"(z_1.type_milieu, 0, 3) AND cor_hab.type_ref::text = 'CB'::text
          GROUP BY z_1.pk
        )
 SELECT z.pk,
    z.code_zh,
    z.action,
    z.date AS date_visite,
    z.nom_zh,
    delim.cd_nomenclature_delimitation,
    nom_sdage.cd_nomenclature_coresp AS cd_typo_sdage,
    z.geom,
    z.observateur,
    array_to_json(array_agg(tmp.obj)) AS acti_impact,
    hab.habitat_corine_biotope,
    case 
    	when z.secteur in ('Oisans', 'Valbonnais') then '38'
    	else '05'
    end as departement
    
   FROM zones_humides.zh z
     LEFT JOIN zones_humides.nomenclatures nom_sdage ON z.typo_sdage = nom_sdage.value
     LEFT JOIN delim ON delim.id_zh = z.pk
     LEFT JOIN tmp ON tmp.id_zh = z.pk
     LEFT JOIN habitat_corine hab ON hab.pk = z.pk
  WHERE geom_overlap is FALSE and geom_valid is TRUE and geom_intersect_reg = FALSE and diffusion = true and valid_topology = true
  GROUP BY z.pk, z.code_zh, z.action, z.date, z.nom_zh, delim.cd_nomenclature_delimitation, 
  nom_sdage.cd_nomenclature_coresp, z.geom, z.observateur, hab.habitat_corine_biotope;
  
  
  
  


 -- AJOUT SEQUENCES

 -- sequence PACA
 CREATE SEQUENCE zones_humides.code_zh_paca START 1;

 -- sequence Valbo

 CREATE SEQUENCE zones_humides.code_zh_valbo START 1;

 -- sequence Oisans
 CREATE SEQUENCE zones_humides.code_zh_oisans START 1;


GRANT select, UPDATE ON zones_humides.code_zh_paca TO zh_user;
GRANT select, UPDATE ON zones_humides.code_zh_valbo TO zh_user;
GRANT select, UPDATE ON zones_humides.code_zh_oisans TO zh_user;
GRANT select, UPDATE ON zones_humides.cor_rhomeo_eunis_corine_biotope TO zh_user;


-- SELECT setval('zones_humides.code_zh_paca', 1, true);
--  SELECT nextval('zones_humides.code_zh_paca ');


---------------------------------
--------TRIGGERS-----------------
---------------------------------



-- DROP FUNCTION gn_synthese.fct_trig_update_in_cor_area_synthese();

CREATE OR REPLACE FUNCTION zones_humides.check_geom_overlap()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
      DECLARE
      BEGIN
	update zones_humides.zh
	set geom_overlap = true where pk in ( 
		SELECT a.pk
		FROM zones_humides.zh a
		INNER JOIN zones_humides.zh b ON 
		(a.geom && b.geom AND ST_Overlaps(a.geom, b.geom))
		WHERE a.pk != b.pk
);
	update zones_humides.zh
	set geom_overlap = false where pk not in ( 
		SELECT a.pk
		FROM zones_humides.zh a
		INNER JOIN zones_humides.zh b ON 
		(a.geom && b.geom AND ST_Overlaps(a.geom, b.geom))
		WHERE a.pk != b.pk
);
      RETURN NULL;
      END;
      $function$
;


create trigger tri_insert_update_check_overlap after insert or update
    of geom on
    zones_humides.zh for each row execute function zones_humides.check_geom_overlap();



CREATE OR REPLACE FUNCTION zones_humides.check_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
      DECLARE
      BEGIN
		update zones_humides.zh
		set geom_valid = ST_IsValid(new.geom)
		where zh.pk = new.pk;

      RETURN NULL;
      END;
      $function$
;


create trigger tri_insert_update_check_geom_val after insert or update
    of geom on
    zones_humides.zh for each row execute function zones_humides.check_validity();

