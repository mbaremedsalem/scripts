import cv2

def display_remote_camera_stream():
    # Utilisez l'adresse IP de la machine serveur
    rtsp_url = "rtsp://192.168.0.162:554/live"
    cap = cv2.VideoCapture(rtsp_url)

    if not cap.isOpened():
        print("Erreur : Impossible de se connecter au flux vidéo distant")
        return

    while True:
        # Lire une image du flux vidéo
        ret, frame = cap.read()

        if not ret:
            print("Erreur : Impossible de lire l'image du flux vidéo distant")
            break

        # Afficher l'image du flux vidéo
        cv2.imshow('Remote Camera', frame)

        # Sortir de la boucle en appuyant sur la touche 'q'
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Libérer la ressource de capture
    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    display_remote_camera_stream()
