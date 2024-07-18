cp -r /home/exploi/dmp/expdppcAUBV4.dmp#!/bin/bash

# Fonction pour afficher le menu
display_menu() {
    echo "1. Rénommer  le fichier dmp"
    echo "2. Copier DB"
    echo "3. Arrêter les services"
    echo "4. Drop"
    echo "5. Création User"
    echo "6. Affecter les droits"
    echo "7. Création de schéma"
    echo "8. IMPORT"
    echo "9. Redémarrer les services admin"
    echo "10. Redémarrer les services manager"
    echo "11.Vérifier le système"
    echo "12.Quitter"
}

# Fonction renommer le fichier demp
move_demp(){

   mv /export/home2/aub/dmp/expdppcAUBV4.dmp /export/home2/aub/dmp/expdppcAUBV4_old.dmp
    if [[ $? -eq 0 ]]; then
        echo "Le traitement a été terminé." >> /home/scripts/debug.log
    else
        echo "Le traitement a échoué. Code d'erreur: $?" >> /home/scripts/debug.log
    fi

   echo "Les users a été créé." >> /home/scripts/debug.log

}

# Fonction pour la copie de DB via SFTP
copier_db() {
    echo "Connexion via SFTP pour copier le fichier DB..." >> /home/scripts/debug.log
    #scp aub@172.16.3.66:/export/home2/aub/dmp/expdppcAUBV4.dmp /export/home2/aub/dmp/
    scp oracle@172.16.3.1:/export/home2/aub/dmp/expdppcAUBV4.dmp /export/home2/aub/dmp/
   # cp -r /home/exploi/dmp/expdppcAUBV4.dmp /export/home2/aub/dmp/
    if [[ $? -eq 0 ]]; then
        echo "Le fichier a été copié avec succès."  >> /home/scripts/debug.log
    else
        echo "Erreur lors de la copie du fichier. Code d'erreur: $?"  >> /home/scripts/debug.log
    fi
}


# Fonction pour arrêter le serveur
stop_server() {
    echo "Connexion au serveur distant pour arrêter le serveur..."  >> /home/scripts/debug.log
    ssh -o StrictHostKeyChecking=no -t oramw@172.16.3.66'
        cd /home/scripts/
        ./cbsCtl.sh 12 stop cbdom 6556 AdminServer && ./cbsCtl.sh 12 stop cbdom 6556 cb_ManagedServer_1'

    if [[ $? -eq 0 ]]; then
        echo "Le traitement a été terminé." >> /home/scripts/debug.log
    else
        echo "Le traitement a échoué. Code d'erreur: $?" >> /home/scripts/debug.log
        if [[ $? -eq 255 ]]; then
            echo "La connexion au serveur distant a échoué." >> /home/scripts/debug.log
        fi
    fi
}

# Fonction pour supprimer les utilisateurs
drop_users() {
    su - oracle -c 'sqlplus / as sysdba
    DROP USER aub CASCADE; <<EOF

EOF'
    echo "Les utilisateurs ont été supprimés." >> /home/scripts/debug.log
}

# Fonction pour cree les utilisateurs
cree_users(){
   su - oracle -c "sqlplus / as sysdba @AUB.gen <<EOF

  # EXIT;

EOF"
   echo "Les users a été créé." >> /home/scripts/debug.log

}

# Fonction pour créer un schéma
droit() {
    # Afficher les droits du fichier avant de les changer
    ls -ltr /export/home2/aub/dmp/expdppcAUBV4.dmp

    # Changer les droits du fichier
    #su - root
    sudo chown -R oracle:oinstall /export/home2/aub/dmp/expdppcAUBV4.dmp

    # Afficher à nouveau les droits du fichier après les avoir changés
    ls -ltr /export/home2/aub/dmp/expdppcAUBV4.dmp

    # Log de succès
    echo "Le doit a été affecter." >> /home/scripts/debug.log
}

creer_schema() {
    # Exécuter le script pour créer le schéma
    su - oracle -c "cd /u01/inst/scripts && ./createDBSchema.sh CAPITALBANKER AUB BKPROD manager1 USR N aub"

    # Log de succès
    echo "Le schéma a été créé." >> /home/scripts/debug.log

}


# Fonction pour la restauration
restoration() {
  #su - oracle -c impdp directory=dmp schemas=aub dumpfile=expdppcAUBV4.dmp logfile=import-expdppcAUBV13062024.dmp.log
  su - oracle -c impdp directory=dmp schemas=aub dumpfile=expdppcAUBV4.dmp logfile=imp-aub_20240616.dmp.log
  #su - oracle -c "impdp directory=dmp schemas=aub dumpfile=expdppcAUBV4.dmp logfile=imp-aub_202401367.dmp.log"
    echo "Restauration est terminée." >> /home/scripts/debug.log
}

# Fonction pour redémarrer le service admin
restart_service_admin() {
        echo "Connexion au serveur distant pour arrêter le serveur..."  >> /home/scripts/debug.log
    ssh -o StrictHostKeyChecking=no -t oramw@172.16.3.66 '
        cd /home/scripts/
        ./cbsCtl.sh 12 start cbdom 6556 AdminServer'

    if [[ $? -eq 0 ]]; then
        echo "Le traitement a été terminé." >> /home/scripts/debug.log
    else
        echo "Le traitement a échoué. Code d'erreur: $?" >> /home/scripts/debug.log
        if [[ $? -eq 255 ]]; then
            echo "La connexion au serveur distant a échoué." >> /home/scripts/debug.log
        fi
    fi
}


# Fonction pour redémarrer le service admin
restart_service_admin() {
        echo "Connexion au serveur distant pour arrêter le serveur..."  >> /home/scripts/debug.log
    ssh -o StrictHostKeyChecking=no -t oramw@172.16.3.66 '
        cd /home/scripts/
        ./cbsCtl.sh 12 start cbdom 6556 AdminServer'

    if [[ $? -eq 0 ]]; then
        echo "Le traitement a été terminé." >> /home/scripts/debug.log
    else
        echo "Le traitement a échoué. Code d'erreur: $?" >> /home/scripts/debug.log
        if [[ $? -eq 255 ]]; then
            echo "La connexion au serveur distant a échoué." >> /home/scripts/debug.log
        fi
    fi
}


# Fonction pour redémarrer le service manager
restart_service_manager() {
        echo "Connexion au serveur distant pour arrêter le serveur..."  >> /home/scripts/debug.log
    ssh -o StrictHostKeyChecking=no -t oramw@172.16.3.66 '
        cd /home/scripts/
        ./cbsCtl.sh 12 start cbdom 6556 cb_ManagedServer_1'

    if [[ $? -eq 0 ]]; then
        echo "Le traitement a été terminé." >> /home/scripts/debug.log
    else
        echo "Le traitement a échoué. Code d'erreur: $?" >> /home/scripts/debug.log
        if [[ $? -eq 255 ]]; then
            echo "La connexion au serveur distant a échoué." >> /home/scripts/debug.log
        fi
    fi
}




####-------------------------------#######

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
    sftp aub@172<<EOF
    cp /export/home2/aub/demp/test.dmp /export/home2/aub/demp/
EOF

    if [[ $? -eq 0 ]]; then
        echo "Le fichier a été copié avec succès."
    else
        echo "Erreur lors de la copie du fichier. Code d'erreur: $?"
    fi
}

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
# echo -n "Nom d'utilisateur : "
# read username
# echo -n "Mot de passe : "
# read -s password
# echo

# Validation des informations d'identification
# Ici vous pouvez ajouter votre propre logique d'authentification
# if [[ "$username" == "mbare" && "$password" == "1234" ]]; then
#     echo "Authentification réussie."
# else
#     echo "Nom d'utilisateur ou mot de passe incorrect."
#     exit 1
# fi

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
