# zones_humides

### V1 dépreciée

Scripts de rapatriement de l'inventaire des ZH de ODK-central vers une base de données PostgreSQL.

Les données sont ensuite mis à disposition des inventaires régionaux via un flux geojson (module export GeoNature). Pour cela, elles sont remise au standard du module ZH GeoNature.

Chaque ZH a un "code" (code_zh) qui lui est propre et qui est necessaire pour l'integration dans les base régionales. Pour cela on a créé trois séquences PostgreSQL (code_zh_oisans, code_zh_valbo, code_zh_paca) qui incrémente le code en fonction de là ou elle la ZH.

Lors de la synchronisation, les soumissions sont marquées comme "approuvées" dans Central. Elles ne seront plus synchronisé au prochain cron (ainsi que celle taggués "rejectée" ou "comporte des erreurs" )
Une projet QGIS permet de modifier les géométries pour corriger les erreurs de saisies. Une fois synchronisées les modifications effectuées dans Central ne sont pas repercutés dans la BDD zones humides, il ne faut donc pas les modifier dans Central. La seule exception est celle des taxons rattachés au ZH (comme on a pas d'interface dans QGIS pour les renseigner), les modifications faites sur les taxons dans Central sont rappatrié sans la base PostgreSQL.

### v2

Les données sont maintenant saisies dans un projet qfield/qfieldcloud et automatiquement synchronisé avec la base PG (table zones_humides.zh_v2).
Un projet lizmap est toujours en place pour que tout le monde puisse consulter les données. Ce projet lizmap s'appuye sur un fichier geojson généré par l'export de GeoNature.
Les images des zones humides sont rappatrié sur le serveur GeoNature via le script `download_qfieldcloud_attachments.py`. Elles sont mise dans un fichier servie via la conf Apache de GeoNature pour être affiché dans Lizmap.
