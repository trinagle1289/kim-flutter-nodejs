from flask import Flask, jsonify, request
from flask_cors import cross_origin

HOST = "127.0.0.1"
PORT = 8022

app = Flask(__name__)


@app.route("/analyze/<video_id>", methods=["POST", "GET"])
@cross_origin()
def analyze_video(video_id: str):
    content_type = "application/json"

    response_data = {
        "video id": video_id,
        "start label": "",
        "end label": "",
        "extra 1": "",
        "extra 2": "",
        "extra 3": "",
        "extra 4": "",
    }

    response = jsonify(response_data)

    return response


if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=True)
