from flask import Flask, request

app = Flask(__name__)


@app.route("/success", methods=["POST"])
def success():
    if request.method == "POST":
        f = request.files["file"]
        f.save(f.filename)


if __name__ == "__main__":
    app.run(debug=True)
