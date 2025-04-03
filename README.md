# zones_humides

Scripts de rapatriement de l'inventaire des ZH de ODK-central vers une base de données PostgreSQL.

Les données sont ensuite mis à disposition des inventaires régionaux via un flux geojson (module export GeoNature). Pour cela, elles sont remise au standard du module ZH GeoNature.

Chaque ZH a un "code" (code_zh) qui lui est propre et qui est necessaire pour l'integration dans les base régionales. Pour cela on a créé trois séquences PostgreSQL (code_zh_oisans, code_zh_valbo, code_zh_paca) qui incrémente le code en fonction de là ou elle la ZH.