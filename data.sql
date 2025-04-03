INSERT INTO zones_humides.bib_champs(nom_champ)
VALUES 
('critere_delimitation'),
('source_pietinement'),
('autre_procesus_visible'),
('pratique_gestion_eau'),
('pratique_agri_pasto'),
('pratique_travaux_foret'),
('pratique_loisirs')
;


INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('Alluvions (Végétation herbacée pionnière Des)','AL_alluvions','type_milieu',NULL,NULL,NULL),
	 ('Bas-marais et marais de transition','BM_bas_marais','type_milieu',NULL,NULL,NULL),
	 ('Boisement de conifères humide','BCH_boisement_coniferes_hum','type_milieu',NULL,NULL,NULL),
	 ('Boisement feuillu humide','BFH_boisement_feuillu_humide','type_milieu',NULL,NULL,NULL),
	 ('Bordure d’eaux courantes (Végétation amphibie des)','EC_bordure_eaux_courantes','type_milieu',NULL,NULL,NULL),
	 ('Fourré humide','FU_fourré_humide','type_milieu',NULL,NULL,NULL),
	 ('Grands hélophytes (Communauté de)','GH_grands_helophytes','type_milieu',NULL,NULL,NULL),
	 ('Magnocariçaie','MC_magnocariçaie','type_milieu',NULL,NULL,NULL),
	 ('Mégaphorbiaie','MG_mégaphorbiaie','type_milieu',NULL,NULL,NULL),
	 ('Petits hélophytes (Communauté de )','RB_petit_helophytes','type_milieu',NULL,NULL,NULL);
INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('Prairie humide (et pelouse humide)','PH_prairie_humide','type_milieu',NULL,NULL,NULL),
	 ('Végétation aquatique','AQ_vegetation_aqua','type_milieu',NULL,NULL,NULL),
	 ('Végétation fontinale (sources, mouillères)','FO_vegetation_fontinale','type_milieu',NULL,NULL,NULL),
	 ('Animale sauvage','1_animal_sauvage','source_pietinement',NULL,NULL,NULL),
	 ('Ne sait pas','4_ne_sait_pas','source_pietinement',NULL,NULL,NULL),
	 ('Aucune','00_0_aucun','pratique_gestion_eau',NULL,NULL,NULL),
	 ('Hydrologie (balancement des eaux, crues, zones d''inondation, fluctuation de la nappe)','hydrologie','critere_delimitation','4',NULL,NULL),
	 ('10 – Marais et landes humides de plateaux','10_marais_landes','typo_sdage','10',NULL,NULL),
	 ('11 – Zones humides ponctuelles','11_zones_humides_ponctuelles','typo_sdage','11',NULL,NULL),
	 ('12 – Marais aménagés dans un but agricole ou sylvicole','12_marais_amenage_but_agri_sylvi','typo_sdage','12',NULL,NULL);
INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('13 – Zones humides artificielles','13_zones_humides_artif','typo_sdage','13',NULL,NULL),
	 ('1 – Trace de passage rapide (crottes et/ou pas)','03_45_1_passage_rapide','pietinement',NULL,'3','45.0'),
	 ('2 – Traces de passages plus fréquents et dispersés sans création de sol nu','03_45_2_passage_frequent','pietinement',NULL,'3','45.0'),
	 ('3 – Plages de sol nu localisées','03_45_3_plages_sol_nu_localisees','pietinement',NULL,'3','45.0'),
	 ('4 – Plages de sol nu >10 % de la surface','03_45_4_plages_sol_nu_sup10','pietinement',NULL,'3','45.0'),
	 ('5 – Plages de sol nu > 50 % de la surface','03_45_5_plages_sol_nu_sup50','pietinement',NULL,'3','45.0'),
	 ('7 – Zones humides de bas fonds en tête de bassin','7_zones_humides_bas_fond','typo_sdage','7',NULL,NULL),
	 ('Prélèvements d’eau pour l’abreuvement (captage et prise d’eau)','20_45_captage_eau_abreuvement','pratique_agri_pasto',NULL,'20','45.0'),
	 ('Non déterminée','non_determinee','localisation_pratique','0',NULL,NULL),
	 ('Abreuvement du troupeau dans la zone humide','20_45_abreuvement_troupeau_zh','pratique_agri_pasto',NULL,'20','45.0');
INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('0 – Pas de pâturage, ni traces de fréquentation : pas de crottes observées, ni traces de pas','03_45_0_pas_de_paturage','pietinement',NULL,NULL,NULL),
	 ('Aucun','00_0_aucun','autre_procesus_visible',NULL,NULL,''),
	 ('Non déterminée','non_determinee','localisation_pratique','0',NULL,NULL),
	 ('1 - au niveau de la zone humide','1_au_niveau_zh','localisation_pratique','1',NULL,NULL),
	 ('2 – au niveau de l''espace de fonctionnalité','2_au_niveau_espace_fonctionnalite','localisation_pratique','2',NULL,NULL),
	 ('3 – au niveau de la zone humide et de l''espace de fonctionnalité','3_au_niveau_zh_et_espace_fonctionnalite','localisation_pratique','3',NULL,NULL),
	 ('Comblement, assèchement, drainage des zones humides','21_31_comblement_assechement_drainage','pratique_gestion_eau',NULL,'21','31.0'),
	 ('Création de retenues collinaires','21_32_retenue_collinaire','pratique_gestion_eau',NULL,'21','32.0'),
	 ('Activité hydroélectrique (microcentrales et autres)','17_36_hydroelectricite','pratique_gestion_eau',NULL,'17','36.0'),
	 ('Modification du fonctionnement hydraulique','21_36_modification_fonctionnement_hydraulique','pratique_gestion_eau',NULL,'21','36.0'),
	 ('Action sur la végétation immergée, flottante ou amphibie, y compris faucardage et démottage','21_37_action_vegetation_immergee','pratique_gestion_eau',NULL,'21','37.0');
INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('Débroussaillage, suppression haies et bosquets, remembrement et travaux connexes','01_42_debroussaillage_suppression_haies_et_bosquets','pratique_agri_pasto',NULL,'01','42.0'),
	 ('Atterrissement, envasement, assèchement','82_imp_atterissement_evasement_assechement','autre_procesus_visible',NULL,'21','82'),
	 ('Autre','autre','autre_procesus_visible',NULL,NULL,NULL),
	 ('Érosion naturelle','81_imp_erosion_naturelle','autre_procesus_visible',NULL,'21','81'),
	 ('Envahissement d''une espèce','94_imp_envahissement_esepece','autre_procesus_visible',NULL,'21','91'),
	 ('Mouvement de terrain','21_84_mouvement_terrain','autre_procesus_visible',NULL,'21','84'),
	 ('Animale domestique','2_animal_domestique','source_pietinement',NULL,'3','45.0'),
	 ('Humaine','3_humaine','source_pietinement',NULL,'7','24.0'),
	 ('Aucune','00_0_aucun','pratique_agri_pasto',NULL,NULL,NULL),
	 ('Aucune','00_0_aucun','pratique_travaux_foret',NULL,NULL,NULL);
INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('Aucune','00_0_aucun','pratique_loisirs',NULL,NULL,NULL),
	 ('Présence d''une végétation hygrophile','vegetation','critere_delimitation','1',NULL,NULL),
	 ('Suppression ou entretien de la végétation fauchage et fenaison','03_46_suppression_ou_entretien_vegetation_fauchage_fenaison','pratique_agri_pasto',NULL,'3','46.0'),
	 ('Infrastructure pastorale (cabane d’alpage, parc de tri…)','03_17_infrastructure_pastorale','pratique_agri_pasto',NULL,'3','17.0'),
	 ('Création de pistes pastorales','03_13_piste_pastorale','pratique_agri_pasto',NULL,'3','13.0'),
	 ('Abandon de systèmes pastoraux','03_47_abandon_syst_pastoraux','pratique_agri_pasto',NULL,'3','47.4'),
	 ('Coupes, abattages, arrachages et déboisements','02_51_coupe','pratique_travaux_foret',NULL,'2','51.0'),
	 ('Taille, élagage','02_52_taille_elagage','pratique_travaux_foret',NULL,'2','52.0'),
	 ('Plantations','02_53_plantations','pratique_travaux_foret',NULL,'2','53.0'),
	 ('Création de traînes et pistes forestières','02_55_piste_forestiere','pratique_travaux_foret',NULL,'2','55.0');
INSERT INTO zones_humides.nomenclatures ("label",value,related_question,cd_nomenclature_coresp,code_activite_hum,code_impact) VALUES
	 ('Baignade','07_61_baignade','pratique_loisirs',NULL,'7','61.0'),
	 ('Proximité d’un sentier dans les 100 m','07_61_proximite_sentier','pratique_loisirs',NULL,'7','61.0'),
	 ('Présence de déchets','07_61_dechets','pratique_loisirs',NULL,'7','61.0'),
	 ('Bivouac','07_61_bivouac','pratique_loisirs',NULL,'7','61.0'),
	 ('Proximité d’un refuge dans l’espace de fonctionnalité','07_16_proximite_refuge','pratique_loisirs',NULL,'7','16.0'),
	 ('Prélèvements d’eau pour le fonctionnement d’un refuge','20_61_prelevement_eau_refuge','pratique_loisirs',NULL,'20','61.0'),
	 ('Chasse','05_62_chasse','pratique_loisirs',NULL,'5','62.0'),
	 ('Pêche','04_63_pêche','pratique_loisirs',NULL,'4','63.0'),
	 ('Alevinage','04_63_alevinage','pratique_loisirs',NULL,'4','63.0'),
	 ('Cueillette et ramassage','07_64_cueillette_et_ramassage','pratique_loisirs',NULL,'7','64.0');




INSERT INTO zones_humides.cor_rhomeo_eunis_corine_biotope
(code_rhomeo, value_dest, type_ref)
VALUES
('FU', 'F9.1', 'EUNIS'),
('FU', 'F9.2', 'EUNIS'),
('FU', '24.2', 'CB'),
('FU', '44.1', 'CB'),
('FU', '44.9', 'CB'),
('BFH', 'F9.2', 'EUNIS'),
('BFH', 'G1.1', 'EUNIS'),
('BFH', '44.1', 'CB'),
('BFH', '44.9', 'CB'),
('BFH', '44.2', 'CB'),
('BFH', '44.5', 'CB'),
('BCH', 'G3.E', 'EUNIS'),
('BCH', '44.A', 'CB'),
('AL', 'C3.6', 'EUNIS'),
('AL', '24.22', 'CB'),
('AL', '24.32', 'CB'),
('AL', '24.52', 'CB'),
('AL', '24.53', 'CB'),

('GH', 'C3.1', 'EUNIS'),
('GH', 'C3.2', 'EUNIS'),
('GH', 'D5.1', 'EUNIS'),
('GH', 'D5.2', 'EUNIS'),
('GH', '53.4', 'CB'),
('GH', '53.1', 'CB'),
('GH', '53.3', 'CB'),

('RB', 'D5.3', 'EUNIS'),
('RB', '53.5', 'CB'),
('RB', '37.241', 'CB'),

('MC', 'C3.2', 'EUNIS'),
('MC', 'D5.2', 'EUNIS'),
('MC', '53.2', 'CB'),

('BM', 'D4.1', 'EUNIS'),
('BM', 'D4.2', 'EUNIS'),
('BM', '54.1', 'CB'),
('BM', '54.2', 'CB'),

('MG', 'E5.5', 'EUNIS'),
('MG', '37.8', 'CB'),

('AQ', 'C1.1', 'EUNIS'),
('AQ', 'C1.2', 'EUNIS'),
('AQ', 'C1.3', 'EUNIS'),
('AQ', 'C1.4', 'EUNIS'),
('AQ', '22.1', 'CB'),
('AQ', '22.4', 'CB'),

('FO', 'C2.1', 'EUNIS'),
('FO', 'D2.2', 'EUNIS'),
('FO', '24.1', 'CB'),
('FO', '24.4', 'CB'),
('FO', '54.1', 'CB'),
('FO', '54.4', 'CB'),

('EC', 'C3.4', 'EUNIS'),
('EC', '22.3', 'CB'),

('PH', 'E3.4', 'EUNIS'),
('PH', 'E3.5', 'EUNIS'),
('PH', '37.2', 'CB'),
('PH', '37.3', 'CB')
;











