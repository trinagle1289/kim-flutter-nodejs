#!/usr/bin/env python
# coding: utf-8

# ### 常數

# In[ ]:


# HOST = "127.0.0.1"
HOST = "0.0.0.0"
PORT = 8022
SAVED_VIDEO_PATH = "video_in.mp4"


# ### 套件

# In[ ]:


from flask import Flask, jsonify, request
from flask_cors import cross_origin

from pathlib import Path
import shutil


# ##### Custom

# In[ ]:


from src.server_api import get_video_json_result


# ##### Datatype Reference

# In[ ]:


from werkzeug.datastructures.file_storage import FileStorage


# ### 主程式

# In[ ]:


app = Flask(__name__)
video_name = Path(SAVED_VIDEO_PATH)


# In[ ]:


@app.route("/", methods=["GET"])
def index_page():
    print("Someone connect to index page.")
    help_msg = """
<code>
/analyze/video_id 為上傳影片的路徑<br>
video_id: 客戶端上傳影片的字串值<br>
回傳結果: Json 格式檔案<br>
<br>
範例回傳資料:<br>
{<br>
    "video id": video_id,<br>
    "start": "A1",<br>
    "end": "A2",<br>
    "extra 1": "RARELY",<br>
    "extra 2": "FREQUENTLY_OR_CONSTANTLY",<br>
    "extra 3": "OCCASIONALLY",<br>
    "extra 4": "RARELY",<br>
    "pose score": "5",<br>
    "extra score": "2",<br>
    "total score": "7",<br>
}<br>
<br>
video id:       客戶端上傳影片的字串值<br>
start:          起始姿勢(A1~A5)<br>
end:            結束姿勢(A1~A5)<br>
extra 1:        軀幹扭轉/側傾的頻率(FREQUENTLY_OR_CONSTANTLY, OCCASIONALLY, RARELY)<br>
extra 2:        手或重心遠離身體的頻率(FREQUENTLY_OR_CONSTANTLY, OCCASIONALLY, RARELY)<br>
extra 3:        手臂抬舉，手的水平位於手肘與肩膀之間的頻率(FREQUENTLY_OR_CONSTANTLY, OCCASIONALLY, RARELY)<br>
extra 4:        手高過肩膀的頻率(FREQUENTLY_OR_CONSTANTLY, OCCASIONALLY, RARELY)<br>
pose score:     姿勢評級分數<br>
extra score:    額外加分項分數<br>
total score:    身體姿勢總分數<br>
</code>

"""
    return help_msg


# In[ ]:


@app.route("/analyze/<video_id>", methods=["POST"])
@cross_origin()
def server_api(video_id: str):
    # 取得資料
    file: FileStorage = request.files["file"]

    # 建立資料夾
    saved_path = Path(video_id) / video_name
    if not saved_path.parent.exists():
        saved_path.parent.mkdir(parents=True)

    # 儲存檔案
    file.save(str(saved_path))
    print(f"Save client file to: {saved_path}")

    # 回應資料
    response_data = {
        "video id": video_id,
        "start": "null",
        "end": "null",
        "extra 1": "null",
        "extra 2": "null",
        "extra 3": "null",
        "extra 4": "null",
        "pose score": "0",
        "extra score": "0",
        "total score": "0",
    }

    # 取得回應資料結果
    try:
        result = get_video_json_result(str(saved_path))
        response_data.update(result)
        print(f"Response Json Data: {response_data}")
    except Exception as e:
        print(f"Exception: {str(e)}")

    # 設定回應資訊
    response = jsonify(response_data)

    # # 清除暫存資料
    # shutil.rmtree(str(saved_path.parent))

    return response


# In[ ]:


if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=True)

