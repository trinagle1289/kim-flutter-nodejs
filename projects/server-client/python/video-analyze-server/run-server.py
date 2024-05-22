from flask import Flask, request
from flask_cors import cross_origin

HOST = "127.0.0.1"
PORT = 8022

app = Flask(__name__)


@app.route("/analyze/<video_id>", methods=["POST", "GET"])
@cross_origin()
def analyze_video(video_id: str):
    data = f"Video id is: {video_id}"
    response = app.response_class(response=data, status=200, content_type="text/plain")
    return response


if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=True)
