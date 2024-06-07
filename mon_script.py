def afficher_menu():
    print("Menu des choix :")
    print("1. Dire bonjour")
    print("2. Dire bonsoir")
    print("3. Autre")
    print("4. Quitter")

def traiter_choix(choix):
    if choix == '1':
        print("Bonjour!")
    elif choix == '2':
        print("Bonsoir!")
    elif choix == '3':
        print("Option autre sélectionnée.")
    elif choix == '4':
        print("Au revoir!")
        exit()
    else:
        print("Choix invalide. Veuillez réessayer.")

def main():
    username = input("Entrez votre nom d'utilisateur : ")
    password = input("Entrez votre mot de passe : ")

    print(f"Bienvenue, {username}!")

    while True:
        afficher_menu()
        choix = input("Entrez votre choix : ")
        traiter_choix(choix)

if __name__ == "__main__":
    main()

