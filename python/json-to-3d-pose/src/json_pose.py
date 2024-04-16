#!/usr/bin/env python
# coding: utf-8

# In[2]:


import json
import math
from abc import ABCMeta, abstractmethod
import numpy as np


# In[3]:


# 左邊關鍵點連接列表
LEFT_KPT_CONNECTION_LIST = [
    # 頭部
    ["nose", "left_eye"],  # 0, 2
    ["left_eye", "left_ear"],  # 2, 7
    # 手部
    ["left_shoulder", "left_elbow"],  # 11, 13
    ["left_elbow", "left_wrist"],  # 13, 15
    ["left_wrist", "left_pinky"],  # 15, 17
    ["left_wrist", "left_index"],  # 15, 19
    ["left_wrist", "left_thumb"],  # 15, 21
    ["left_pinky", "left_index"],  # 17, 19
    # 腰部、腳
    ["left_shoulder", "left_hip"],  # 11, 23
    ["left_hip", "left_knee"],  # 23, 25
    ["left_knee", "left_ankle"],  # 25, 27
    ["left_ankle", "left_heel"],  # 27, 29
    ["left_ankle", "left_foot_index"],  # 27, 31
    ["left_heel", "left_foot_index"],  # 29, 31
]

# 右邊關鍵點連接列表
RIGHT_KPT_CONNECTION_LIST = [
    # 頭部
    ["nose", "right_eye"],  # 0, 5
    ["right_eye", "right_ear"],  # 5, 8
    # 手部
    ["right_shoulder", "right_elbow"],  # 12, 14
    ["right_elbow", "right_wrist"],  # 14, 16
    ["right_wrist", "right_pinky"],  # 16, 18
    ["right_wrist", "right_index"],  # 16, 20
    ["right_wrist", "right_thumb"],  # 16, 22
    ["right_pinky", "right_index"],  # 18, 20
    # 腰部、腳
    ["right_shoulder", "right_hip"],  # 12, 24
    ["right_hip", "right_knee"],  # 24, 26
    ["right_knee", "right_ankle"],  # 26, 28
    ["right_ankle", "right_heel"],  # 28, 30
    ["right_ankle", "right_foot_index"],  # 28, 32
    ["right_heel", "right_foot_index"],  # 30, 32
]

# 中間關鍵點連接列表
CENTER_KPT_CONNECTION_LIST = [
    ["mouth_left", "mouth_right"],  # 9, 10
    ["left_shoulder", "right_shoulder"],  # 11, 12
    ["left_hip", "right_hip"],  # 23, 24
]

_left_and_right_np_lst = np.append(
    LEFT_KPT_CONNECTION_LIST, RIGHT_KPT_CONNECTION_LIST, axis=0
)
_full_np_lst = np.append(_left_and_right_np_lst, CENTER_KPT_CONNECTION_LIST, axis=0)

# 全關鍵點連接列表
FULL_KPT_CONNECTION_LIST = _full_np_lst.tolist()


# In[ ]:


def angles_to_lhc_label(angles: dict) -> str:
    """將角度轉換成 LHC 姿勢標籤

    標籤描述:
    A1: 站立
    A2: 搬運高處物品
    A3: 微彎腰
    A4: 彎腰
    A5: 蹲姿、跪姿、跪坐姿勢

    Args:
        angles (dict): 角度字典

    Returns:
        str: LHC 姿勢標籤
    """
    label = ""
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


# In[ ]:


def get_angle_in_points(
    self, pt1: np.ndarray, pt2: np.ndarray, cenPt: np.ndarray
) -> float:
    """從三個點之間取得角度
    中心點為 cenPt
    (使用餘弦定理)

    Args:
        pt1 (np.ndarray): 點 1
        pt2 (np.ndarray): 點 2
        cenPt (np.ndarray): 中心點(連接點 1和點 2)

    Returns:
        float: 角度(度數)
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


# In[ ]:


class PoseDataBase(metaclass=ABCMeta):
    """儲存影片中姿勢資料的類別"""

    # 是否擁有 3D 關鍵點
    hasKpt3D: bool = False
    # json 資料
    json_data: list = []
    # 關鍵點名稱
    kpt_name: list = []
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
        """設定 JSON 資料
        資料由外而內分別是: 擷取圖片數量、圖片中的姿勢數量(多姿勢模型)
        和姿勢分析結果(置信度、關鍵點2D、關鍵點3D(3D姿勢模型))

        Args:
            json_file_path (str): Json 檔案路徑
        """
        # 讀取並載入 json 資料
        with open(json_file_path) as f:
            self.json_data = json.load(f)
        # 檢查是否擁有 3D 關鍵點
        if list(self.json_data[0][0].keys()).count("keypoints3D") > 0:
            self.hasKpt3D = True
        # 寫入關鍵點名稱
        for kpt in self.get_kpts(0, 0, False):
            self.kpt_name.append(kpt["name"])
        pass

    def __len__(self) -> int:
        """影像幀數量

        Returns:
            int: 影像數量
        """
        return len(self.json_data)

    def __str__(self) -> str:
        """取得 JSON 字串

        Returns:
            str: JSON 字串
        """
        return json.dumps(self.json_data)

    ### 分隔區: 下面函式為基底函式

    def get_number_of_frames(self) -> int:
        """取得影像幀數量

        Returns:
            int: 影像數量
        """
        return len(self.json_data)

    def get_number_of_poses(self, idx_frame: int) -> int:
        """取得影像幀中的姿勢數量

        Args:
            idx_frame (int): 第 n 個影像幀

        Returns:
            int: 姿勢數量
        """
        return len(self.json_data[idx_frame])

    def get_kpts(self, idx_frame: int, idx_pose: int, is_3d: bool = False) -> list:
        """取得影像幀中的關鍵點資訊

        Args:
            idx_frame (int): 第 n 個影像幀
            idx_pose (int): 第 n 個姿勢
            is_3d (bool, optional): 是否為 3D 關鍵點(keypoints3D 標籤). Defaults to False.

        Returns:
            list: 關鍵點資訊列表
        """
        kpts = []

        if not is_3d:
            kpts = self.json_data[idx_frame][idx_pose]["keypoints"]
        else:
            kpts = self.json_data[idx_frame][idx_pose]["keypoints3D"]

        return kpts

    def get_kpt_idx(self, kpt_name: str) -> int:
        """取得關鍵點名稱的索引值(用於查詢特定關鍵點資訊)

        Args:
            kpt_name (str): 關鍵點名稱

        Returns:
            int: 索引值
        """
        # 回傳結果
        idx = -1
        # 直接擷取第一幀影像第一個姿勢的資料來參考
        kpts = self.json_data[0][0]["keypoints"]
        # 尋找索引值
        for i in range(len(kpts)):
            if kpts[i]["name"] == kpt_name:
                idx = i
                break
        return idx

    ### 分隔區: 下面函式會使用基底函式

    def get_kpts_dict(self, idx_frame: int, idx_pose: int, is_3d: bool = False) -> dict:
        """取得影像幀中的關鍵點資訊(dict格式)

        Args:
            idx_frame (int): 第 n 個影像幀
            idx_pose (int): 第 n 個姿勢
            is_3d (bool, optional): 是否為 3D 關鍵點(keypoints3D 標籤). Defaults to False.

        Returns:
            dict: 關鍵點資訊字典
        """
        kpt_dict = {}

        kpt_list = self.get_kpts(idx_frame, idx_pose, is_3d)
        if not is_3d:
            for kpt in kpt_list:
                kpt_dict.update(
                    {kpt["name"]: {"x": kpt["x"], "y": kpt["y"], "score": kpt["score"]}}
                )
        else:
            for kpt in kpt_list:
                kpt_dict.update(
                    {
                        kpt["name"]: {
                            "x": kpt["x"],
                            "y": kpt["y"],
                            "z": kpt["z"],
                            "score": kpt["score"],
                        }
                    }
                )

        return kpt_dict

    def get_connection_list(self, idx_frame: int, idx_pose: int, is_3d: bool = False):
        left_list = []
        center_list = []
        right_list = []

        kpts = self.get_kpts_dict(idx_frame, idx_pose, is_3d)
        for pt1, pt2 in LEFT_KPT_CONNECTION_LIST:
            left_list.append([kpts[pt1], kpts[pt2]])
        for pt1, pt2 in CENTER_KPT_CONNECTION_LIST:
            center_list.append([kpts[pt1], kpts[pt2]])
        for pt1, pt2 in RIGHT_KPT_CONNECTION_LIST:
            right_list.append([kpts[pt1], kpts[pt2]])

        return (left_list, center_list, right_list)

    ### 分隔區: 以下為抽象函式

    @abstractmethod
    def get_kpt_pos(self, idx_frame: int, idx_pose: int, kpt_name: str) -> np.ndarray:
        """取得關鍵點座標資訊

        Args:
            idx_frame (int): 影像幀索引值
            idx_pose (int): 姿勢索引值
            kpt_name (str): 關鍵點名稱

        Returns:
            np.ndarray: 關鍵點座標
        """
        return NotImplementedError

    @abstractmethod
    def get_angles(self, idx_frame: int, idx_pose: int) -> dict:
        """取得姿勢角度

        Args:
            idx_frame (int): 第 n 個影像幀
            idx_pose (int): 第 n 個姿勢

        Returns:
            dict: 姿勢角度
        """
        return NotImplementedError

    @abstractmethod
    def get_lhc_label(self, idx_frame: int, idx_pose: int) -> str:
        """取得 LHC 身體姿勢標籤

        標籤描述:
        A1: 站立
        A2: 搬運高處物品
        A3: 微彎腰
        A4: 彎腰
        A5: 蹲姿、跪姿、跪坐姿勢

        Args:
            idx_frame (int): 影像幀索引值
            idx_pose (int): 姿勢索引值

        Returns:
            np.ndarray: 姿勢標籤
        """
        return NotImplementedError

    @abstractmethod
    def to_label_list(self) -> list[str]:
        """將姿勢標籤轉換成一組列表格式

        Returns:
            list[str]: 姿勢標籤陣列
        """
        return NotImplementedError

    @abstractmethod
    def get_lhc_score(self, idx_pose: int) -> int:
        """取得 LHC 身體姿勢評分

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

        Args:
            idx_pose (int): 姿勢索引值

        Returns:
            int: LHC 姿勢評級
        """
        return NotImplementedError


# In[ ]:


class PoseData3D(PoseDataBase):
    def get_kpt_pos(self, idx_frame: int, idx_pose: int, kpt_name: str) -> np.ndarray:
        kpt = self.get_kpts_3d(idx_frame, idx_pose)[self.get_kpt_idx(kpt_name)]
        pos = np.array([kpt["x"], kpt["y"], kpt["z"]])
        return pos

    def get_angles(self, idx_frame: int, idx_pose: int) -> dict:
        angles: dict = {}
        for center, side in self.joints_dict.items():
            pt1 = self.get_kpt_pos(idx_frame, idx_pose, side[0])
            pt2 = self.get_kpt_pos(idx_frame, idx_pose, side[1])
            cenPt = self.get_kpt_pos(idx_frame, idx_pose, center)
            angles.update({center: get_angle_in_points(pt1, pt2, cenPt)})
        return angles

    def get_lhc_label(self, idx_frame: int, idx_pose: int) -> str:
        angles = self.get_angles(idx_frame, idx_pose)
        label = angles_to_lhc_label(angles)
        return label

    def to_label_list(self) -> list[str]:
        # 使用 PoseData 類別
        labels = []
        for i in range(self.get_number_of_frames()):
            labels.append(self.get_lhc_label(i, 0))
        return labels
    
    def get_lhc_score(self, idx_pose: int) -> int:
        score = 0
        return score


# In[4]:


class PoseData(PoseDataBase):
    def get_kpt_pos(self, idx_frame: int, idx_pose: int, kpt_name: str) -> np.ndarray:
        kpt = self.get_kpts(idx_frame, idx_pose, False)[self.get_kpt_idx(kpt_name)]
        pos = np.array([kpt["x"], kpt["y"]])
        return pos

    def get_angles(self, idx_frame: int, idx_pose: int) -> dict:
        angles: dict = {}
        for center, side in self.joints_dict.items():
            pt1 = self.get_kpt_pos(idx_frame, idx_pose, side[0])
            pt2 = self.get_kpt_pos(idx_frame, idx_pose, side[1])
            cenPt = self.get_kpt_pos(idx_frame, idx_pose, center)
            angles.update({center: get_angle_in_points(pt1, pt2, cenPt)})
        return angles

    def get_lhc_label(self, idx_frame: int, idx_pose: int) -> str:
        angles = self.get_angles(idx_frame, idx_pose)
        label = angles_to_lhc_label(angles)
        return label

    def to_label_list(self) -> list[str]:
        # 使用 PoseData 類別
        labels = []
        for i in range(self.get_number_of_frames()):
            labels.append(self.get_lhc_label(i, 0))
        return labels

    def get_lhc_score(self, idx_pose: int) -> int:
        score = 0
        return score

