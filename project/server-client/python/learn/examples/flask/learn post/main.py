import json
import re
from flask import Flask, jsonify, request
from flask_cors import cross_origin

app = Flask(__name__)


@app.route("/success", methods=["POST", "GET"])
@cross_origin()
def success():
    data = {"method": request.method}
    data2 = "Success!!!"
    res = app.response_class(response=data, status=200, content_type="application/json")
    res1 = app.response_class(
        response=json.dumps(data), status=200, content_type="text/plain"
    )
    res2 = app.response_class(response=data2, status=200, content_type="text/plain")

    if request.method == "POST":
        return app.response_class(
            response="Success !!!", status=200, content_type="text/plain"
        )
    else:
        return app.response_class(
            response="OK?", status=200, content_type="text/plain"
        )

    return res


if __name__ == "__main__":
    app.run(debug=True)
