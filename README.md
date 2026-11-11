# Livrables Bash & Docker

Exercices du **module 2 (Bash & Docker)** du Data Maroc Bootcamps : automatiser un traitement de données avec des scripts Bash, puis le containeriser avec Docker et Docker Compose.

## Compétences démontrées

| Domaine | Ce que je sais faire |
|---|---|
| **Bash** | Écrire des scripts shell pour traiter des fichiers de données (awk, coreutils), automatiser une chaîne de traitement |
| **Docker** | Écrire un `Dockerfile`, choisir une image de base légère (Alpine), installer les paquets nécessaires, construire et versionner une image (`bim-returns:1.0`) |
| **Conteneurs** | Lancer un conteneur avec un *bind mount*, observer son état (`docker ps`) et ses journaux (`docker logs -f`), choisir entre un conteneur ponctuel et un conteneur persistant |
| **Docker Compose** | Orchestrer plusieurs services (`docker compose up -d` / `down`), partager des fichiers entre services avec des volumes |

## Contenu

```
.
├── Bash/        # scripts Bash (traitement de données)
└── Docker/      # containerisation de returns_processor.sh
    ├── Dockerfile
    └── docker-compose.yml
```

## Exercice Docker : containeriser `returns_processor.sh`

**Objectif** : appliquer la recette du lab Docker (Dockerfile puis Compose) au script `returns_processor.sh`, qui traite des retours de commandes. Pas de Python ni de base de données : le script reste toute l'application.

### Architecture

```
┌──────────────────────┐   écrit    ┌──────────────┐   lit    ┌──────────────────┐
│ processor            │ ─────────► │  output/     │ ◄─────── │ viewer (nginx)   │
│ (alpine + bash +     │            │  report.csv  │          │ http://localhost │
│  gawk + coreutils)   │            └──────────────┘          │ :8080/report.csv │
│ exécute              │            (volume partagé)          └──────────────────┘
│ returns_processor.sh │
└──────────────────────┘
```

- **`processor`** : image `bim-returns:1.0`, construite depuis le `Dockerfile` (Alpine + bash + gawk + coreutils). Le workspace est monté en *bind mount*.
- **`viewer`** : conteneur nginx qui sert le dossier `output/` pour consulter le rapport dans un navigateur.

### Utilisation

```bash
# 1. Construire l'image
docker build -t bim-returns:1.0 .

# 2. Lancer l'ensemble des services
docker compose up -d

# 3. Vérifier
docker ps
docker logs -f <nom-du-conteneur-processor>

# 4. Consulter le rapport
#    http://localhost:8080/report.csv

# 5. Tout arrêter
docker compose down
```

> Sous Git Bash (Windows), préfixez par `MSYS_NO_PATHCONV=1` les commandes `docker` qui contiennent un chemin commençant par `/`.

### Choix de conception

- **Image légère** : Alpine, avec seulement les paquets utiles au script (bash, gawk, coreutils).
- **Bind mount du workspace** : les fichiers d'entrée et de sortie restent sur la machine hôte, on peut modifier les données sans reconstruire l'image.
- **Conteneur ponctuel ou persistant** : *à compléter avec votre réponse à la question 2 de l'exercice, en une phrase.*
- **Séparation des responsabilités** : un service traite les données, un autre les expose. Chacun peut être relancé indépendamment.

## Exercice Bash

*À compléter : décrivez en 2-3 phrases le ou les scripts du dossier `Bash/` (ce qu'ils lisent, ce qu'ils produisent, les commandes utilisées).*

## Prérequis

- Docker Desktop (avec Docker Compose)
- Un terminal Bash (Git Bash sous Windows)
