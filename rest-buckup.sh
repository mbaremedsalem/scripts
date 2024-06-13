#!/bin/bash

# Fonction pour afficher le menu
display_menu() {
    echo "1. Copier DB"
    echo "2. Connecter les utilisateurs et arrêter le serveur"
    echo "3. Supprimer les utilisateurs"
    echo "4. Création de schéma"
    echo "5. Restauration"
    echo "6. Redémarrer le service"
    echo "7. Vérifier le système"
    echo "8. Quitter"
}

# Fonction pour la copie de DB via SFTP
copier_db() {
    echo "Connexion via SFTP pour copier le fichier DB..."
    sftp aub@srvbkp <<EOF
    cp /export/home2/aub/demp/test.dmp /export/home2/aub/demp/
    scp aub@172.16.3.66:/export/home2/aub/dmp/
EOF

    if [[ $? -eq 0 ]]; then
        echo "Le fichier a été copié avec succès."
    else
        echo "Erreur lors de la copie du fichier. Code d'erreur: $?"
    fi
}


# 
#!/bin/bash

# copier_db() {
#     echo "Connexion via SFTP pour copier le fichier DB..."
#     /usr/bin/expect <<EOF
#     spawn sftp aub@srvbkp
#     expect "password:"
#     send "votre_mot_de_passe\r"
#     expect "sftp>"
#     send "cp /export/home2/aub/demp/test.dmp /export/home2/aub/demp/\r"
#     expect "sftp>"
#     send "bye\r"
#     expect eof
# EOF

#     if [[ $? -eq 0 ]]; then
#         echo "Le fichier a été copié avec succès."
#     else
#         echo "Erreur lors de la copie du fichier. Code d'erreur: $?"
#     fi
# }

copier_db

# 
# Fonction pour arrêter le serveur
stop_server() {
    su - oamw -c "systemctl stop admin"
    su - oamw -c "systemctl stop server"
    su - oamw -c "systemctl stop cb_manager"
    echo "Le traitement a été terminé."
}

# Fonction pour supprimer les utilisateurs
drop_users() {
    su - oracle -c "sqlplus / as sysdba <<EOF
    DROP USER user_name CASCADE;
    EXIT;
EOF"
    echo "Les utilisateurs ont été supprimés."
}

# Fonction pour créer un schéma
creer_shema() {
    su - oracle -c "sqlplus / as sysdba <<EOF
    -- Commande de création de schéma 
    EXIT;
EOF"
    echo "Le schéma a été créé."
}

# Fonction pour la restauration
restoration() {
    su - oracle -c "sqlplus / as sysdba <<EOF
    -- Commande de restauration
    EXIT;
EOF"
    echo "Restauration terminée."
}

# Fonction pour redémarrer le service
restart_service() {
    su - oamw -c "systemctl restart service_name"
    echo "Le service a été redémarré."
}

# Fonction pour vérifier le système
verifier_systeme() {
    echo "Merci de vérifier le système de Core Banking."
}

# Authentification utilisateur
echo -n "Nom d'utilisateur : "
read username
echo -n "Mot de passe : "
read -s password
echo

# Validation des informations d'identification
# Ici vous pouvez ajouter votre propre logique d'authentification
if [[ "$username" == "mbare" && "$password" == "1234" ]]; then
    echo "Authentification réussie."
else
    echo "Nom d'utilisateur ou mot de passe incorrect."
    exit 1
fi

# Affichage du menu et gestion des choix utilisateur
while true; do
    display_menu
    echo -n "Choisissez une option : "
    read choice
    case $choice in
        1) copier_db ;;
        2) stop_server ;;
        3) drop_users ;;
        4) creer_shema ;;
        5) restoration ;;
        6) restart_service ;;
        7) verifier_systeme ;;
        8) echo "Au revoir!" ; exit 0 ;;
        *) echo "Option invalide." ;;
    esac
done
