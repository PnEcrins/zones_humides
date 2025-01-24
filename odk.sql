--Generer la liste de taxon pour ODK

select distinct t.cd_nom as name,  concat(lb_nom, ' - ', nom_vern ) as label
from taxonomie.taxref t
join taxonomie.bib_noms b on b.cd_nom = t.cd_nom 
join taxonomie.cor_nom_liste c on c.id_nom = b.id_nom and c.id_liste = 500 or c.id_liste = 1003
where t.regne = 'Plantae';