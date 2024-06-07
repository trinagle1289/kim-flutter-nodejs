#!/usr/bin/env python
# coding: utf-8

# ### 常數

# In[9]:


HOST = "127.0.0.1"
PORT = 8022
SAVED_VIDEO_PATH = "video_in.mp4"


# ### 套件

# In[7]:


from flask import Flask, jsonify, request
from flask_cors import cross_origin

from pathlib import Path
import shutil


# ##### Custom

# In[11]:


from src.server_api import get_video_json_result


# ##### Datatype Reference

# In[12]:


from werkzeug.datastructures.file_storage import FileStorage


# ### 主程式

# In[ ]:


app = Flask(__name__)
video_name = Path(SAVED_VIDEO_PATH)


# In[ ]:


@app.route("/analyze/<video_id>", methods=["POST", "GET"])
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

    # 回應資料
    response_data = {
        "video id": video_id,
        "start": "null",
        "end": "null",
        "extra 1": "null",
        "extra 2": "null",
        "extra 3": "null",
        "extra 4": "null",
    }

    # 取得回應資料結果
    response_data.update(get_video_json_result(str(saved_path)))
    response = jsonify(response_data)

    # 清除暫存資料
    shutil.rmtree(str(saved_path.parent))

    return response


# In[ ]:


if __name__ == "__main__":
    app.run(host=HOST, port=PORT, debug=True)

