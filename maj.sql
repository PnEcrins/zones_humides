alter table zones_humides.zh 
add column geom_overlap boolean default false;

alter table zones_humides.zh 
add column geom_valid boolean default true;

alter table zones_humides.zh 
add column geom_intersect_reg boolean default false;


alter table zones_humides.zh 
add column comment_diffusion boolean default true;

alter table zones_humides.zh 
add column comment_diffuion text;

update zones_humides.zh z 
set geom_intersect_reg = true where action = 'Problème'

update zones_humides.zh z 
set diffusion = false where action = 'Problème'

COMMENT ON COLUMN zones_humides.zh.geom_overlap IS 'Vrai si deux ZH de l''inventaire PNE se superposent';

COMMENT ON COLUMN zones_humides.zh.geom_valid IS 'Vrai si la géométrie est valide (ST_IsValid)';

COMMENT ON COLUMN zones_humides.zh.geom_intersect_reg IS 'Vrai si la géométrie d''une ZH PNE intersecte une geom de l''inventaire régionale';

