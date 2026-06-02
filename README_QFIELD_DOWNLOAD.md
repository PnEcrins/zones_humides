Usage: téléchargement des pièces jointes QField Cloud

Prérequis

- Python 3.8+
- Installer le SDK officiel:

```bash
pip install qfieldcloud-sdk
```

Exemples

Exporter et télécharger les fichiers JPG d'un projet:

```bash
export QFIELDCLOUD_TOKEN="votre_token"
python3 download_qfieldcloud_attachments.py --project 123e4567-e89b-12d3-a456-426614174000 --outdir ./downloads --filter "*.jpg"
```

Forcer le téléchargement (remplacer les fichiers locaux existants):

```bash
python3 download_qfieldcloud_attachments.py --project 123e4567-e89b-12d3-a456-426614174000 --outdir ./downloads --filter "*.jpg" --force
```

Utiliser l'export QField (package) avant téléchargement:

```bash
python3 download_qfieldcloud_attachments.py --project 123e4567-e89b-12d3-a456-426614174000 --package --outdir ./downloads
```

Notes

- Le script utilise la variable d'environnement `QFIELDCLOUD_TOKEN` si `--token` n'est pas fournie.
- Si nécessaire, précisez l'URL de l'API via `--url` ou `QFIELDCLOUD_URL`.
