
#!/bin/bash

# Date du traitement
today=$(date +%F)

# Fonction de journalisation
log() {
    echo "[$(date '+%F %T')] $1" >> "logs/$today.log"
}

# Fonction de traitement d'un fichier
process_file() {
    f="$1"

    # Vérifier la présence de reason
    if ! head -n 1 "$f" | grep -q "reason"; then
        log "Fichier invalide : $f"
        echo "Fichier invalide : $f"
        return
    fi

    # Extraire la ville
    city=$(basename "$f" .csv | sed 's/returns_//')

    log "Traitement de $f"

    # Compter les trois catégories
    for reason in defective wrong_item changed_mind; do

        count=$(grep -c ",$reason," "$f")

        # Ajouter le résultat au rapport
        echo "$id,$today,$city,$reason,$count" >> output/report.csv

        log "$city : $reason = $count"

        id=$((id+1))
    done

    # Archiver le fichier traité
    mv "$f" "archive/$(basename "$f" .csv)_$today.csv"

    log "Archivage de $city terminé"
}

# Créer les dossiers nécessaires
mkdir -p output archive logs

# Initialiser le rapport
echo "id,date,city,reason,count" > output/report.csv

# Initialiser les identifiants
id=1

# Nettoyer les fichiers temporaires
find input -type f -name "*.tmp" -delete

log "Nettoyage des fichiers temporaires terminé"

# Parcourir tous les fichiers CSV
for f in input/*.csv; do

    [ -f "$f" ] || continue

    process_file "$f"

done

log "Traitement terminé"

echo "Traitement terminé !"
