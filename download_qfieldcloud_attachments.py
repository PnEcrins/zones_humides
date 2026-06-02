#!/usr/bin/env python3
"""
download_qfieldcloud_attachments.py

Télécharge les fichiers attachés d'un projet QField Cloud en utilisant le SDK officiel.

Usage examples:
  python3 download_qfieldcloud_attachments.py --project 123e4567-e89b-12d3-a456-426614174000 \
    --outdir ./downloads --filter '*.jpg' --force

Installez le SDK si nécessaire:
  pip install qfieldcloud-sdk

"""

import os
import sys
import argparse
from pathlib import Path
import fnmatch
import logging

from dotenv import load_dotenv
from qfieldcloud_sdk import sdk

load_dotenv()


def parse_args():
    parser = argparse.ArgumentParser(
        description="Télécharger fichiers attachés d'un projet QField Cloud"
    )
    parser.add_argument(
        "--project",
        "-p",
        required=True,
        help="Project ID (UUID) ou nom de projet (owner/name possible)",
    )
    parser.add_argument(
        "--outdir", "-o", default="qfieldcloud_downloads", help="Dossier de destination"
    )
    parser.add_argument(
        "--filter",
        "-f",
        default="*",
        help="Glob filter pour les fichiers (ex: '*.jpg')",
    )
    parser.add_argument(
        "--token",
        "-t",
        default=None,
        help="Jeton d'authentification QFieldCloud (ou via QFIELDCLOUD_TOKEN env)",
    )
    parser.add_argument(
        "--url",
        "-U",
        default=None,
        help="URL de l'API (ex: https://app.qfield.cloud/api/v1/). Peut aussi être défini dans QFIELDCLOUD_URL",
    )
    parser.add_argument(
        "--package",
        action="store_true",
        help="Utiliser package_download (export QField) au lieu de download_project",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Forcer le téléchargement même si le fichier existe localement",
    )
    parser.add_argument(
        "--no-progress",
        action="store_true",
        help="Ne pas afficher la barre de progression",
    )
    parser.add_argument("--verbose", "-v", action="store_true", help="Mode verbeux")
    return parser.parse_args()


def resolve_project_id(client, identifier):
    if identifier is None:
        raise ValueError("Aucun identifiant de projet fourni")
    # Si l'utilisateur fournit un UUID
    if "-" in identifier and len(identifier) >= 20:
        return identifier
    # sinon chercher dans la liste des projets accessibles
    projects = client.list_projects()
    for p in projects:
        pid = p.get("id") or p.get("project_id") or p.get("uuid")
        name = p.get("name") or p.get("project") or p.get("display_name") or ""
        owner = p.get("owner") or p.get("owner_username") or p.get("username") or ""
        full = f"{owner}/{name}" if owner else name
        if (
            identifier == pid
            or identifier == name
            or identifier == full
            or identifier in name
            or identifier in full
        ):
            return pid or p.get("id")
    raise ValueError(
        f"Projet '{identifier}' introuvable parmi les projets accessibles."
    )


def main():
    args = parse_args()
    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=log_level, format="%(levelname)s: %(message)s")
    token = args.token or os.environ.get("QFIELDCLOUD_TOKEN")
    api_url = (
        args.url
        or os.environ.get("QFIELDCLOUD_URL")
        or "https://app.qfield.cloud/api/v1/"
    )
    client = sdk.Client(url=api_url, token=token) if token else sdk.Client(url=api_url)
    try:
        project_id = resolve_project_id(client, args.project)
    except Exception as e:
        logging.error("Impossible de résoudre l'identifiant du projet: %s", e)
        sys.exit(2)
    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    filter_glob = args.filter
    try:
        if args.package:
            logging.info(
                "Préparation du package et téléchargement des fichiers exportés..."
            )
            files_info = client.package_download(
                project_id=project_id,
                local_dir=str(outdir),
                filter_glob=filter_glob,
                show_progress=not args.no_progress,
                force_download=args.force,
            )
            logging.info(
                "Téléchargement package terminé: %d fichiers", len(files_info or [])
            )
        else:
            logging.info("Récupération de la liste des fichiers du projet...")
            remote_files = client.list_remote_files(project_id)
            selected = []
            for f in remote_files:
                name = (
                    f.get("name")
                    or f.get("filename")
                    or f.get("path")
                    or f.get("remote_filename")
                    or ""
                )
                if not name:
                    continue
                if fnmatch.fnmatchcase(name, filter_glob):
                    selected.append({"name": name})
            if not selected:
                logging.info(
                    "Aucun fichier correspondant au filtre '%s'. Fin.", filter_glob
                )
                return
            logging.info("Téléchargement de %d fichiers vers %s", len(selected), outdir)
            client.download_files(
                files=selected,
                project_id=project_id,
                download_type=sdk.FileTransferType.PROJECT,
                local_dir=str(outdir),
                filter_glob=filter_glob,
                show_progress=not args.no_progress,
                force_download=args.force,
            )
            logging.info("Téléchargement terminé.")
    except Exception as e:
        logging.error("Erreur lors du téléchargement: %s", e)
        sys.exit(1)


if __name__ == "__main__":
    main()
