#!/usr/bin/env python
# coding: utf-8

# ### 常數

# In[ ]:


MODEL_PTH = "model/pose_landmarker_full.task"
TEST_VIDEO = "../../../../resources/video/other/20240506/walk-and-turn.mp4"


# ### 套件

# In[ ]:


import mediapipe as mp
import numpy as np
import cv2


# #### MediaPipe

# In[ ]:


from mediapipe.tasks.python.core.base_options import BaseOptions
from mediapipe.tasks.python.vision.core.vision_task_running_mode import (
    VisionTaskRunningMode,
)
from mediapipe.tasks.python.vision.pose_landmarker import (
    PoseLandmarker,
    PoseLandmarkerOptions,
)


# #### 自定義函式

# In[ ]:


from src.mediapipe_lib.base import (
    PoseResult,
    ResultAnalyzer,
    LhcPoseListAnalyzer,
)


# ### 初始設定

# In[ ]:


# 模型設定
options = PoseLandmarkerOptions(
    base_options=BaseOptions(MODEL_PTH),
    running_mode=VisionTaskRunningMode.VIDEO,
)
# 模型物件
landmarker = PoseLandmarker.create_from_options(options)


# ### 函式

# In[ ]:


def get_video_json_result(img_path: str) -> dict[str:str]:

    is_3d = True  # 表示 3D 姿勢

    # 資料結果陣列
    lhc_analyzer = LhcPoseListAnalyzer([])

    # 初始化分析結果
    result = {
        "start": "",
        "end": "",
        "extra 1": "",
        "extra 2": "",
        "extra 3": "",
        "extra 4": "",
    }

    cap = cv2.VideoCapture(img_path)  # 影片抓取物件
    while cap.isOpened():
        # 抓取影像
        ret, frame = cap.read()
        if not ret:
            print("Can't receive frame (stream end?). Exiting ...")
            break
        # 取得模型結果，並存入到變數中
        mp_img = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
        result = landmarker.detect_for_video(
            mp_img, int(cap.get(cv2.CAP_PROP_POS_MSEC))
        )
        lhc_analyzer += [result]

    ### 取得起始和結束的姿勢標籤
    start_label, end_label = lhc_analyzer.get_start_and_finish_poses(is_3d)
    ### 額外加分結果
    # 身體扭轉的頻率
    extra_1 = lhc_analyzer.get_frequency_of_trunk_is_twisted(is_3d).name
    # 手遠離身體的頻率
    extra_2 = lhc_analyzer.get_frequency_of_hands_at_a_distance(is_3d).name
    # 手臂抬舉，手的水平位於手肘與肩膀之間的頻率
    extra_3 = lhc_analyzer.get_frequency_of_hands_above_shoulder(is_3d).name
    # 手高過肩膀的頻率
    extra_4 = lhc_analyzer.get_frequency_of_arms_raised(is_3d).name

    # 更新分析結果
    result.update(
        {
            "start": start_label,
            "end": end_label,
            "extra 1": extra_1,
            "extra 2": extra_2,
            "extra 3": extra_3,
            "extra 4": extra_4,
        }
    )

    return result

