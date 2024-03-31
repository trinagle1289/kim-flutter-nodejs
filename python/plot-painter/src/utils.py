#!/usr/bin/env python
# coding: utf-8

# In[2]:


import json
import math

import numpy as np


# In[3]:


def get_angle_in_points(pt1: np.ndarray, pt2: np.ndarray, cenPt: np.ndarray) -> float:
    """
    從三個點之間取得角度
    中心點為 cenPt
    (使用餘弦定理)
    """
    # 求角 A (對面為邊 a)
    # a: pt1 pt2 距離
    # b: pt1 cenPt 距離
    # c: pt2 cenPt 距離

    a = np.linalg.norm(pt1 - pt2)
    b = np.linalg.norm(pt1 - cenPt)
    c = np.linalg.norm(pt2 - cenPt)

    angleA = math.degrees(math.acos((b * b + c * c - a * a) / (2 * b * c)))
    return angleA


# In[92]:


class PoseData:
    """儲存影片中姿勢資料的類別"""

    # 是否擁有 3D 關鍵點
    hasKpt3D: bool = False
    # json 資料
    json_data: list = []
    # 關節對照字典
    joints_dict: dict = {
        "left_shoulder": ["left_elbow", "left_hip"],
        "right_shoulder": ["right_elbow", "right_hip"],
        "left_hip": ["left_shoulder", "left_knee"],
        "right_hip": ["right_shoulder", "right_knee"],
        "left_knee": ["left_hip", "left_ankle"],
        "right_knee": ["right_hip", "right_ankle"],
    }

    def __init__(self, json_file_path: str):
        """
        設定 JSON 資料
        資料由外而內分別是: 擷取圖片數量、圖片中的姿勢數量(多姿勢模型)
        和姿勢分析結果(置信度、關鍵點2D、關鍵點3D(3D姿勢模型))
        """
        # 讀取並載入 json 資料
        with open(json_file_path) as f:
            self.json_data = json.load(f)

        # 檢查是否擁有 3D 關鍵點
        if list(self.json_data[0][0].keys()).count("keypoints3D") > 0:
            self.hasKpt3D = True

    def __str__(self):
        """取得 JSON 字串"""
        return json.dumps(self.json_data)

    ### 分隔區: 下面函式會使用到此類別其他函式

    def get_angles(self, idx_frame: int, idx_pose: int) -> dict:
        """
        取得姿勢角度
        idx_frame: 第 n 個影像幀
        idx_pose: 第 n 個姿勢
        """
        angles: dict = {}
        for center, side in self.joints_dict.items():
            pt1 = self.get_kpt_pos(idx_frame, idx_pose, side[0])
            pt2 = self.get_kpt_pos(idx_frame, idx_pose, side[1])
            cenPt = self.get_kpt_pos(idx_frame, idx_pose, center)
            angles.update({center: get_angle_in_points(pt1, pt2, cenPt)})

        return angles

    def get_kpt_pos(self, idx_frame: int, idx_pose: int, kpt_name: str) -> np.ndarray:
        """
        取得關鍵點座標資訊
        idx_frame: 影像幀索引值
        idx_pose: 姿勢索引值
        kpt_name: 關鍵點名稱
        """
        kpt = self.get_kpts(idx_frame, idx_pose)[self.get_kpt_index(kpt_name)]
        pos = (
            np.array([kpt["x"], kpt["y"]])
            if not self.hasKpt3D
            else np.array([kpt["x"], kpt["y"], kpt["z"]])
        )

        return pos

    def get_lhc_label(self, idx_frame: int, idx_pose: int) -> str:
        """
        取得 LHC 身體姿勢標籤
        idx_frame: 影像幀索引值
        idx_pose: 姿勢索引值

        標籤描述:
        A1: 站立
        A2: 搬運高處物品
        A3: 微彎腰
        A4: 彎腰
        A5: 蹲姿、跪姿、跪坐姿勢
        """
        label = ""
        angles = self.get_angles(idx_frame, idx_pose)
        if angles["right_knee"] < 90:
            label = "A5"
        elif angles["right_hip"] < 120:
            label = "A4"
        elif angles["right_hip"] < 160:
            label = "A3"
        elif angles["right_shoulder"] > 90:
            label = "A2"
        else:
            label = "A1"

        return label

    def get_lhc_score(self, idx_pose: int) -> int:
        """
        取得 LHC 身體姿勢評分
        idx_pose: 姿勢索引值

        評分規則(A2 跟 A3 評分方式相同因此不顯示 A3 範例):
        A1 - A1: 0
        A1 - A2: 3
        A2 - A2: 5
        A1 - A4: 7
        A1 - A5: 9
        A2 - A4: 10
        A2 - A5: 13
        A4 - A4: 15
        A4 - A5: 18
        A5 - A5: 20
        """
        score = 0

        return score

    def get_kpt_index(self, kpt_name: str) -> int:
        """
        取得關鍵點名稱的索引值(用於查詢特定關鍵點資訊)
        kpt_name: 關鍵點名稱
        """
        # 回傳結果
        idx = -1
        # 直接擷取第一幀影像第一個姿勢的資料來參考
        kpts = self.get_kpts(0, 0)
        # 尋找索引值
        for i in range(len(kpts)):
            if kpts[i]["name"] == kpt_name:
                idx = i
                break

        return idx

    ### 分隔區: 下面函式並未使用到此類別其他函式

    def get_number_of_frames(self) -> int:
        """取得影像幀數量"""
        return len(self.json_data)

    def get_number_of_poses(self, idx_frame: int) -> int:
        """
        取得影像幀中的姿勢數量
        idx: 第 n 個影像幀
        """
        return len(self.json_data[idx_frame])

    def get_kpts(self, idx_frame: int, idx_pose: int) -> dict:
        """
        取得影像幀中的關鍵點資訊
        idx_frame: 第 n 個影像幀
        idx_pose: 第 n 個姿勢
        """
        return self.json_data[idx_frame][idx_pose]["keypoints"]

    def get_kpts3D(self, idx_frame: int, idx_pose: int) -> dict:
        """
        取得影像幀中的 3D 關鍵點資訊，如果沒有資料則回傳 0
        idx_frame: 第 n 個影像幀
        idx_pose: 第 n 個姿勢
        """
        result = (
            None
            if not self.hasKpt3D
            else self.json_data[idx_frame][idx_pose]["keypoints3D"]
        )
        return result

