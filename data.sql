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

insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('critere_delimitation','vegetation','Présence d''une végétation hygrophile'),
('critere_delimitation','hydrologie', 'Hydrologie (balancement des eaux, crues, zones d''inondation, fluctuation de la nappe)');
		

insert into zones_humides.nomenclatures (value, label, related_question) VALUES 
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



insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('pietinement','03_45_0_pas_de_paturage' ,'0 – Pas de pâturage, ni traces de fréquentation : pas de crottes observées, ni traces de pas'),
('pietinement','03_45_1_passage_rapide','1 – Trace de passage rapide (crottes et/ou pas)'),
('pietinement','03_45_2_passage_frequent','2 – Traces de passages plus fréquents et dispersés sans création de sol nu'),
('pietinement','03_45_3_plages_sol_nu_localisees','3 – Plages de sol nu localisées'),
('pietinement','03_45_4_plages_sol_nu_sup10','4 – Plages de sol nu >10 % de la surface'),
('pietinement','03_45_5_plages_sol_nu_sup50','5 – Plages de sol nu > 50 % de la surface');


insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('typo_sdage', '7_zones_humides_bas_fond', '7 – Zones humides de bas fonds en tête de bassin'),
('typo_sdage', '10_marais_landes', '10 – Marais et landes humides de plateaux'),
('typo_sdage', '11_zones_humides_ponctuelles', '11 – Zones humides ponctuelles'),
('typo_sdage', '12_marais_amenage_but_agri_sylvi', '12 – Marais aménagés dans un but agricole ou sylvicole'),
('typo_sdage', '13_zones_humides_artif', '13 – Zones humides artificielles');


insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('source_pietinement', '1_animal_sauvage', 'Animale sauvage'),
('source_pietinement', '2_animal_domestique', 'Animale domestique'),
('source_pietinement', '3_humaine', 'Humaine'),
('source_pietinement', '4_ne_sait_pas', 'Ne sait pas');



insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('autre_procesus_visible', '81_imp_erosion_naturelle', 'Érosion naturelle'),
('autre_procesus_visible', '82_imp_atterissement_evasement_assechement', 'Atterrissement, envasement, assèchement'),
('autre_procesus_visible', '94_imp_envahissement_esepece', 'Envahissement d''une espèce'),
('autre_procesus_visible', '21_84_mouvement_terrain', 'Mouvement de terrain'),
('autre_procesus_visible', 'autre', 'Autre'),
('autre_procesus_visible', '00_0_aucun', 'Aucun');


insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('pratique_gestion_eau', '21_31_comblement_assechement_drainage', 'Comblement, assèchement, drainage des zones humides'),
('pratique_gestion_eau', '21_32_retenue_collinaire', 'Création de retenues collinaires'),
('pratique_gestion_eau', '17_36_hydroelectricite', 'Activité hydroélectrique (microcentrales et autres)'),
('pratique_gestion_eau', '21_36_modification_fonctionnement_hydraulique', 'Modification du fonctionnement hydraulique'),
('pratique_gestion_eau', '21_37_action_vegetation_immergee', 'Action sur la végétation immergée, flottante ou amphibie, y compris faucardage et démottage'),
('pratique_gestion_eau', '00_0_aucun', 'Aucune');

insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('localisation_pratique' , '1_au_niveau_zh' , '1 - au niveau de la zone humide'),
('localisation_pratique' , '2_au_niveau_espace_fonctionnalite' , '2 – au niveau de l''espace de fonctionnalité'),
('localisation_pratique' , '3_au_niveau_zh_et_espace_fonctionnalite' , '3 – au niveau de la zone humide et de l''espace de fonctionnalité'),
('localisation_pratique' , 'non_determinee' , 'Non déterminée');



insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('pratique_agri_pasto' , '01_42_debroussaillage_suppression_haies_et_bosquets' , 'Débroussaillage, suppression haies et bosquets, remembrement et travaux connexes'),
('pratique_agri_pasto' , '20_45_captage_eau_abreuvement' , 'Prélèvements d’eau pour l’abreuvement (captage et prise d’eau)'),
('pratique_agri_pasto' , '20_45_abreuvement_troupeau_zh' , 'Abreuvement du troupeau dans la zone humide'),
('pratique_agri_pasto' , '03_46_suppression_ou_entretien_vegetation_fauchage_fenaison' , 'Suppression ou entretien de la végétation fauchage et fenaison'),
('pratique_agri_pasto' , '03_17_infrastructure_pastorale' , 'Infrastructure pastorale (cabane d’alpage, parc de tri…)'),
('pratique_agri_pasto' , '03_13_piste_pastorale' , 'Création de pistes pastorales'),
('pratique_agri_pasto' , '03_47_abandon_syst_pastoraux' , 'Abandon de systèmes pastoraux'),
('pratique_agri_pasto' , '00_0_aucun' , 'Aucune');


insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('pratique_travaux_foret' , '02_51_coupe' , 'Coupes, abattages, arrachages et déboisements'),
('pratique_travaux_foret' , '02_52_taille_elagage' , 'Taille, élagage'),
('pratique_travaux_foret' , '02_53_plantations' , 'Plantations'),
('pratique_travaux_foret' , '02_55_piste_forestiere' , 'Création de traînes et pistes forestières'),
('pratique_travaux_foret' , '00_0_aucun' , 'Aucune');


insert into zones_humides.nomenclatures (related_question, value, label) VALUES 
('pratique_loisirs' , '07_61_baignade' , 'Baignade'),
('pratique_loisirs' , '07_61_proximite_sentier' , 'Proximité d’un sentier dans les 100 m'),
('pratique_loisirs' , '07_61_dechets' , 'Présence de déchets'),
('pratique_loisirs' , '07_61_bivouac' , 'Bivouac'),
('pratique_loisirs' , '07_16_proximite_refuge' , 'Proximité d’un refuge dans l’espace de fonctionnalité'),
('pratique_loisirs' , '20_61_prelevement_eau_refuge' , 'Prélèvements d’eau pour le fonctionnement d’un refuge'),
('pratique_loisirs' , '05_62_chasse' , 'Chasse'),
('pratique_loisirs' , '04_63_pêche' , 'Pêche'),
('pratique_loisirs' , '04_63_alevinage' , 'Alevinage'),
('pratique_loisirs' , '07_64_cueillette_et_ramassage' , 'Cueillette et ramassage'),
('pratique_loisirs' , '00_0_aucun' , 'Aucune');
