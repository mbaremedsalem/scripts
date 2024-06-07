import cv2

def open_camera():
    # Ouvrir la caméra
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Erreur : Impossible d'ouvrir la caméra")
        return

    while True:
        # Lire une image de la caméra
        ret, frame = cap.read()

        if not ret:
            print("Erreur : Impossible de lire l'image de la caméra")
            break

        # Afficher l'image
        cv2.imshow('Camera', frame)

        # Sortir de la boucle en appuyant sur la touche 'q'
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Libérer la caméra et fermer la fenêtre
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    open_camera()
