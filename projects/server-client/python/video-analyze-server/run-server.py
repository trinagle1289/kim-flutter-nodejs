from flask import Flask, jsonify, request
from flask_cors import cross_origin

from analyze_video import get_video_json_result

HOST = "127.0.0.1"
PORT = 8022

app = Flask(__name__)


@app.route("/analyze/<video_id>", methods=["POST", "GET"])
@cross_origin()
def analyze_video(video_id: str):

    file = request.files["file"]


    print(type(file))

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
