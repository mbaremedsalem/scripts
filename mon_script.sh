#!/bin/bash

# Demander le nom d'utilisateur et le mot de passe
read -p "Entrez votre nom d'utilisateur : " username
read -sp "Entrez votre mot de passe : " password
echo
echo "Bienvenue, $username"

# Boucle pour afficher le menu et traiter les choix
while true; do
    # Afficher le menu
    echo "Menu des choix :"
    echo "1. Dire bonjour"
    echo "2. Dire bonsoir"
    echo "3. Autre"
    echo "4. Quitter"
    echo "5. Copier un fichier"

    # Lire le choix de l'utilisateur
    read -p "Entrez votre choix : " choix

    # Traiter le choix de l'utilisateur
    case $choix in
        1)
            echo "Bonjour $username!"
            ;;
        2)
            echo "Bonsoir $username!"
            ;;
        3)
            echo "Option autre sélectionnée."
            ;;
        4)
            echo "Au revoir!"
            exit 0
            ;;
        5)
            read -p "Entrez le chemin du fichier source : " fichier_source
            read -p "Entrez le chemin du répertoire de destination : " repertoire_destination
            if cp "$fichier_source" "$repertoire_destination"; then
                echo "Le fichier a été copié avec succès."
            else
                echo "Erreur lors de la copie du fichier."
            fi
            ;;            
        *)
            echo "Choix invalide. Veuillez réessayer."
            ;;
    esac
done
