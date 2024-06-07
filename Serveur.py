import cv2

def start_camera_stream():
    # Ouvrir la caméra
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Erreur : Impossible d'ouvrir la caméra")
        return

    # Configuration du serveur de streaming RTSP
    rtsp_url = "rtsp://localhost:8554/live"
    stream = cv2.VideoWriter(rtsp_url, cv2.VideoWriter_fourcc(*'MJPG'), 20, (640, 480))

    while True:
        # Lire une image de la caméra
        ret, frame = cap.read()

        if not ret:
            print("Erreur : Impossible de lire l'image de la caméra")
            break

        # Diffuser le flux vidéo
        stream.write(frame)

        # Afficher le flux vidéo localement
        cv2.imshow('Camera', frame)

        # Sortir de la boucle en appuyant sur la touche 'q'
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Libérer la caméra et fermer la fenêtre
    cap.release()
    stream.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    start_camera_stream()
