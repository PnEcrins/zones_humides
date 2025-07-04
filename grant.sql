
grant usage ON SCHEMA zones_humides TO zh_user;
grant SELECT ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant UPDATE ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant DELETE ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant INSERT ON ALL TABLES IN SCHEMA zones_humides to zh_user;
grant SELECT ON zones_humides.export_zh to zh_user;

grant SELECT ON ALL VIEWS IN SCHEMA zones_humides to zh_user;

GRANT SELECT
ON ALL SEQUENCES IN SCHEMA zones_humides
    TO zh_user;

GRANT UPDATE
ON ALL SEQUENCES IN SCHEMA zones_humides
    TO zh_user;



grant usage on schema taxonomie to zh_user;
grant SELECT ON taxonomie.taxref to zh_user;
grant references on taxonomie.taxref to zh_user;


grant usage on schema ref_geo to zh_user;
grant SELECT ON ref_geo.l_areas to zh_user;

