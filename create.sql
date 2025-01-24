
-- nomenclatures definition

CREATE TABLE zones_humides.zh (
	pk serial primary key,
	geom public.geometry(Polygon, 4326),
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
	CONSTRAINT fk_zh_espece_envahissante FOREIGN KEY (espece_envahissante) REFERENCES taxonomie.taxref(cd_nom)
);


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
related_question text not null
);


CREATE OR REPLACE VIEW zones_humides.export_zh
AS WITH indic AS (
         SELECT array_agg(t_1.lb_nom) AS especes,
            cor_espece_indic_zh.id_zh
           FROM zones_humides.cor_espece_indic_zh
             JOIN taxonomie.taxref t_1 ON t_1.cd_nom = cor_espece_indic_zh.cd_nom
          GROUP BY cor_espece_indic_zh.id_zh
        ), nitro AS (
         SELECT array_agg(t_1.lb_nom) AS especes,
            cor_espece_nitro_zh.id_zh
           FROM zones_humides.cor_espece_nitro_zh
             JOIN taxonomie.taxref t_1 ON t_1.cd_nom = cor_espece_nitro_zh.cd_nom
          GROUP BY cor_espece_nitro_zh.id_zh
        ), pieti AS (
         SELECT array_agg(t_1.lb_nom) AS especes,
            cor_espece_pietinement_zh.id_zh
           FROM zones_humides.cor_espece_pietinement_zh
             JOIN taxonomie.taxref t_1 ON t_1.cd_nom = cor_espece_pietinement_zh.cd_nom
          GROUP BY cor_espece_pietinement_zh.id_zh
        ),
        delim as (
        	select array_agg(addi.label) as delimitation_zh, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'critere_delimitation'
        	group by addi.id_zh
        ),
        source_pietinement as (
        	select array_agg(addi.label) as source_pietinement, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'source_pietinement'
        	group by addi.id_zh
        ),
        autre_procesus_visible as (
        	select array_agg(addi.label) as autre_procesus_visible, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'autre_procesus_visible'
        	group by addi.id_zh
        ),
        pratique_gestion_eau as (
        	select array_agg(addi.label) as pratique_gestion_eau, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'pratique_gestion_eau'
        	group by addi.id_zh
        ),
        pratique_agri_pasto as (
        	select array_agg(addi.label) as pratique_agri_pasto, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'pratique_agri_pasto'
        	group by addi.id_zh
        ),
        pratique_travaux_foret as (
        	select array_agg(addi.label) as pratique_travaux_foret, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'pratique_travaux_foret'
        	group by addi.id_zh
        ),
        pratique_loisirs as (
        	select array_agg(addi.label) as pratique_loisirs, addi.id_zh
        	from zones_humides.cor_champs_addi addi
        	join zones_humides.bib_champs bc on bc.pk = addi.id_type_champ
        	where bc.nom_champ = 'pratique_loisirs'
        	group by addi.id_zh
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
    pieti.especes AS espece_pieti
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
     

