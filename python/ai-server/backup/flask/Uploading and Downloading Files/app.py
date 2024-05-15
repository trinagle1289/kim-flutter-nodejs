# 第 1 步: 導入所有庫
# import all libraires
from io import BytesIO
from flask import Flask, render_template, request, send_file
from flask_sqlalchemy import SQLAlchemy

# 第 2 步: 建立資料庫
# Initialize flask  and create sqlite database
app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)


# 第 3 步: 為資料庫建立表
# create datatable
class Upload(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(50))
    data = db.Column(db.LargeBinary)


# 第 4 步: 建立索引函數
# Create index function for upload and return files
@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        file = request.files["file"]
        upload = Upload(filename=file.filename, data=file.read())
        db.session.add(upload)
        db.session.commit()
        return f"Uploaded: {file.filename}"
    return render_template("index.html")


# 第 5 步: 建立一個下載函數，用於下載檔案。
# create download function for download files
@app.route("/download/<upload_id>")
def download(upload_id):
    upload = Upload.query.filter_by(id=upload_id).first()
    return send_file(
        BytesIO(upload.data), download_name=upload.filename, as_attachment=True
    )
