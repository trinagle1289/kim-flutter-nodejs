from flask import Flask, jsonify, request
from flask_cors import cross_origin
from pathlib import Path
import numpy as np
import cv2

# custom
from server_api import get_video_json_result

# Datatype Reference
from werkzeug.datastructures.file_storage import FileStorage

HOST = "127.0.0.1"
PORT = 8022
SAVED_VIDEO_PATH = "video_in.mp4"

app = Flask(__name__)
saved_path = Path(SAVED_VIDEO_PATH)


@app.route("/analyze/<video_id>", methods=["POST", "GET"])
@cross_origin()
def analyze_video(video_id: str):

    file: FileStorage = request.files["file"]
    file.save("test.mp4")

    response_data = {
        "video id": video_id,
        "start": "null",
        "end": "null",
        "extra 1": "null",
        "extra 2": "null",
        "extra 3": "null",
        "extra 4": "null",
    }

    response = jsonify(response_data)

    return response


if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=True)
