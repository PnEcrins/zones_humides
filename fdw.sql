
-- Tentative de lire un flux WFS en FDW non fructueuse
-- -> ERREUR:  GDAL AppDefined [1] Line 2: Didn't find element token after open angle bracket.


-- USER ADMIN

drop server fdw_data_sud cascade;
CREATE SERVER fdw_data_sud FOREIGN DATA WRAPPER ogr_fdw
OPTIONS (
    datasource 'WFS:https://www.datasud.fr/geoserver/parcs-naturels-regionaux-de-provence-alpes-cote-dazur/ows',
    format 'WFS',
    config_options 'OGR_SKIP=NAS',
    updateable 'false'
);


GRANT USAGE ON FOREIGN SERVER fdw_data_sud TO zh_user;


CREATE FOREIGN TABLE zones_humides.inventaire_paca (
	id bigint,
    code text,
    "site" text,
	geom Geometry(MultiPolygon,4326),
    date_crea timestamp,
    org_cre text
)
	SERVER "fdw_data_sud"
	OPTIONS (layer 'parcs-naturels-regionaux-de-provence-alpes-cote-dazur:inventaire-des-zones-humides-de-provence-alpes-cote-d-azur');

