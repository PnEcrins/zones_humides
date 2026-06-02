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



CREATE TABLE zones_humides.zh_v2 (
	old_pk integer,
	unique_uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
	geom public.geometry(polygon, 4326) NULL,
	critere_delimitation _int4 NULL,
	espece_indicatrice _int4 NULL,
	image_espece_indic text NULL,
	presence_espece_nitro _int4 NULL,
	"date" timestamp NOT NULL,
	nom_zh text NULL,
	id_role int4 NOT NULL,
	typo_sdage int4 NULL,
	type_milieu int4 NULL,
	pietinement int4 NULL,
	espece_indicatrice_pietinement _int4 NULL,
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


	insert into zones_humides.zh_v2 (
	    old_pk,
		unique_uuid,
		geom,
		critere_delimitation,
		espece_indicatrice,
		espece_nitro,
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
	    z.pk,
		uuid_generate_v4(),
		z.geom,
		criter_delim.id_array,
		ceiz.cd_nom_array,
		cenz.cd_nom_array,
		z."date",
		z.nom_zh,
		r.id_role,
		typo_sdage.id,
		type_milieu.id,
		pieti.id,
		cepz.cd_nom_array,
		autre_proc.id_array,
		z.autre_procesus_visible_text,
		gestion_eau.id_array,
		loc_gest_eau.id,
		aggro_pasto.id_array,
		loc_aggri_pasto.id,
		trav_for.id_array,
		loc_trav.id,
		loisir.id_array,
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
	left join (
		select cca.id_zh, array_agg(DISTINCT n.id) as id_array
		from zones_humides.cor_champs_addi cca
		join zones_humides.nomenclatures n on n.value = cca."label" and n.id_type_nomenclature = cca.id_type_champ
		where cca.id_type_champ = 1
		group by cca.id_zh
	) criter_delim on criter_delim.id_zh = z.pk
	left join (
		select id_zh, array_agg(cd_nom) as cd_nom_array
		from zones_humides.cor_espece_indic_zh
		group by id_zh
	) ceiz on ceiz.id_zh = z.pk
	left join (
		select id_zh, array_agg(cd_nom) as cd_nom_array
		from zones_humides.cor_espece_nitro_zh
		group by id_zh
	) cenz on cenz.id_zh = z.pk
	left join utilisateurs.t_roles r on concat(r.nom_role, ' ', r.prenom_role) = z.observateur
	left join zones_humides.nomenclatures typo_sdage on typo_sdage.value = z.typo_sdage and typo_sdage.related_question = 'typo_sdage'
	left join zones_humides.nomenclatures type_milieu on type_milieu.value = z.type_milieu and type_milieu.related_question = 'type_milieu'
	left join zones_humides.nomenclatures pieti on pieti.value = z.pietinement and pieti.related_question = 'pietinement'
	left join (
		select id_zh, array_agg(cd_nom) as cd_nom_array
		from zones_humides.cor_espece_pietinement_zh
		group by id_zh
	) cepz on cepz.id_zh = z.pk
	left join (
		select cca.id_zh, array_agg(DISTINCT n.id) as id_array
		from zones_humides.cor_champs_addi cca
		join zones_humides.nomenclatures n on n.value = cca."label" and n.id_type_nomenclature = cca.id_type_champ
		where cca.id_type_champ = 3
		group by cca.id_zh
	) autre_proc on autre_proc.id_zh = z.pk
	left join (
		select cca.id_zh, array_agg(DISTINCT n.id) as id_array
		from zones_humides.cor_champs_addi cca
		join zones_humides.nomenclatures n on n.value = cca."label" and n.id_type_nomenclature = cca.id_type_champ
		where cca.id_type_champ = 4
		group by cca.id_zh
	) gestion_eau on gestion_eau.id_zh = z.pk
	left join zones_humides.nomenclatures loc_gest_eau on loc_gest_eau.value = z.localisation_pratique_gestion_eau
	left join (
		select cca.id_zh, array_agg(DISTINCT n.id) as id_array
		from zones_humides.cor_champs_addi cca
		join zones_humides.nomenclatures n on n.value = cca."label" and n.id_type_nomenclature = cca.id_type_champ
		where cca.id_type_champ = 5
		group by cca.id_zh
	) aggro_pasto on aggro_pasto.id_zh = z.pk
	left join zones_humides.nomenclatures loc_aggri_pasto on loc_aggri_pasto.value = z.localisation_pratique_agri_pasto
	left join (
		select cca.id_zh, array_agg(DISTINCT n.id) as id_array
		from zones_humides.cor_champs_addi cca
		join zones_humides.nomenclatures n on n.value = cca."label" and n.id_type_nomenclature = cca.id_type_champ
		where cca.id_type_champ = 6
		group by cca.id_zh
	) trav_for on trav_for.id_zh = z.pk
	left join zones_humides.nomenclatures loc_trav on loc_trav.value = z.localisation_pratique_travaux_foret
	left join (
		select cca.id_zh, array_agg(DISTINCT n.id) as id_array
		from zones_humides.cor_champs_addi cca
		join zones_humides.nomenclatures n on n.value = cca."label" and n.id_type_nomenclature = cca.id_type_champ
		where cca.id_type_champ = 7
		group by cca.id_zh
	) loisir on loisir.id_zh = z.pk
	left join zones_humides.nomenclatures loc_lois on loc_lois.value = z.localisation_pratique_loisirs;





CREATE OR REPLACE VIEW zones_humides.export_zh_v2 AS
SELECT
	z.old_pk AS pk,
	z.unique_uuid,
	z."date" AS heure_debut,
	z.nom_zh,
	(SELECT string_agg(n.label, '- ' ORDER BY n.label)
	 FROM unnest(z.critere_delimitation) AS cid(id)
	 JOIN zones_humides.nomenclatures n ON n.id = cid.id) AS delimitation_zh,
	z.geom,
	(SELECT concat(r.nom_role, ' ', r.prenom_role)
	 FROM utilisateurs.t_roles r WHERE r.id_role = z.id_role) AS observateur,
	(SELECT n.label FROM zones_humides.nomenclatures n WHERE n.id = z.typo_sdage) AS typo_sdage,
	(SELECT n.label FROM zones_humides.nomenclatures n WHERE n.id = z.type_milieu) AS type_milieu,
	(SELECT string_agg(n.label, '- ' ORDER BY n.label)
	 FROM unnest(z.autre_procesus_visible) AS aid(id)
	 JOIN zones_humides.nomenclatures n ON n.id = aid.id) AS autre_procesus_visible,
	(SELECT n.label FROM zones_humides.nomenclatures n WHERE n.id = z.pietinement) AS pietinement,
	(SELECT string_agg(n.label, '- ' ORDER BY n.label)
	 FROM unnest(z.pratique_gestion_eau) AS pid(id)
	 JOIN zones_humides.nomenclatures n ON n.id = pid.id) AS pratique_gestion_eau,
	loc_gest.label AS localisation_pratique_gestion_eau,
	(SELECT string_agg(n.label, '- ' ORDER BY n.label)
	 FROM unnest(z.pratique_agri_pasto) AS aid2(id)
	 JOIN zones_humides.nomenclatures n ON n.id = aid2.id) AS pratique_agri_pasto,
	loc_aggri.label AS localisation_pratique_agri_pasto,
	(SELECT string_agg(n.label, '- ' ORDER BY n.label)
	 FROM unnest(z.pratique_travaux_foret) AS tid(id)
	 JOIN zones_humides.nomenclatures n ON n.id = tid.id) AS pratique_travaux_foret,
	loc_trav.label AS localisation_pratique_travaux_foret,
	(SELECT string_agg(n.label, '- ' ORDER BY n.label)
	 FROM unnest(z.pratique_loisirs) AS lid(id)
	 JOIN zones_humides.nomenclatures n ON n.id = lid.id) AS pratique_loisirs,
	loc_lois.label AS localisation_pratique_loisirs,
	(SELECT string_agg(t.lb_nom, ', ' ORDER BY t.lb_nom)
	 FROM unnest(z.espece_indicatrice) AS cd(cd_nom)
	 JOIN taxonomie.taxref t ON t.cd_nom = cd.cd_nom) AS espece_indic,
	(SELECT string_agg(t.lb_nom, ', ' ORDER BY t.lb_nom)
	 FROM unnest(z.espece_nitro) AS cd2(cd_nom)
	 JOIN taxonomie.taxref t ON t.cd_nom = cd2.cd_nom) AS espece_nitro,
	(SELECT string_agg(t.lb_nom, ', ' ORDER BY t.lb_nom)
	 FROM unnest(z.espece_indicatrice_pietinement) AS cd3(cd_nom)
	 JOIN taxonomie.taxref t ON t.cd_nom = cd3.cd_nom) AS espece_pieti,
	tx_env.lb_nom AS espece_envahissante,
	concat('https://geonature.ecrins-parcnational.fr/api/media/zh/', replace(z.nom_zh, ' '::text, '_'::text), '_', z.uuid_sub, '.jpg') AS url_image
FROM zones_humides.zh_v2 z
LEFT JOIN zones_humides.nomenclatures loc_gest
	ON loc_gest.id = z.localisation_pratique_gestion_eau
	AND loc_gest.related_question = 'localisation_pratique'
LEFT JOIN zones_humides.nomenclatures loc_aggri
	ON loc_aggri.id = z.localisation_pratique_agri_pasto
	AND loc_aggri.related_question = 'localisation_pratique'
LEFT JOIN zones_humides.nomenclatures loc_trav
	ON loc_trav.id = z.localisation_pratique_travaux_foret
	AND loc_trav.related_question = 'localisation_pratique'
LEFT JOIN zones_humides.nomenclatures loc_lois
	ON loc_lois.id = z.localisation_pratique_loisirs
	AND loc_lois.related_question = 'localisation_pratique'
LEFT JOIN taxonomie.taxref tx_env ON tx_env.cd_nom = z.espece_envahissante;