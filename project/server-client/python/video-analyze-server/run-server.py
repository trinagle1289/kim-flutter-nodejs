from flask import Flask, request
from flask_cors import cross_origin

HOST = "127.0.0.1"
PORT = 8022

app = Flask(__name__)


@app.route("/analyze/<int:video_id>", methods=["POST"])
@cross_origin()
def analyze_video(video_id: int):

    pass


if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=True)
