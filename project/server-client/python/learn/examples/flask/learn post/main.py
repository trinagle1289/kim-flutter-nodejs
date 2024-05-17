import json
from mimetypes import MimeTypes
import mimetypes
from flask import Flask, request

app = Flask(__name__)


@app.route("/success")
def success():
    # print(f"{str(request)}")

    data = {"method": request.method}

    if request.method == "POST":
        print("POST")

    print(request.method)

    response = app.response_class(
        response=json.dumps(data),
        status=200,
        mimetype="application/json",
    )

    return response


if __name__ == "__main__":
    app.run(debug=True)
