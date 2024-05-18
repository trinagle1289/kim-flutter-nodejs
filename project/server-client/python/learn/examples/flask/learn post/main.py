import json
from flask import Flask, jsonify, request
from flask_cors import cross_origin

app = Flask(__name__)


@app.route("/success", methods=["GET", "POST"])
@cross_origin()
def success():
    data = {"method": request.method}

    res = app.response_class(response=data, status=200, content_type="application/json")
    res1 = app.response_class(
        response=json.dumps(data), status=200, content_type="text/plain"
    )

    data2 = "Success!!!"
    res2 = app.response_class(response=data2, status=200, content_type="text/plain")

    if request.method == "POST":
        print("POST")

    print(request.method)

    return res


if __name__ == "__main__":
    app.run(debug=True)
