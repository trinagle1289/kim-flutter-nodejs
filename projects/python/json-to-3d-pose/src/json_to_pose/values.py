#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np


# In[ ]:


class LineConnections:
    """線條連接點"""

    left_kpt: list[list[str]] = []  # 左邊關鍵點連接列表
    right_kpt: list[list[str]] = []  # 右邊關鍵點連接列表
    center_kpt: list[list[str]] = []  # 中間關鍵點連接列表
    full_kpt: list[list[str]] = []  # 全關鍵點連接列表

    def __init__(
        self, left: list[list[str]], right: list[list[str]], center: list[list[str]]
    ) -> None:
        """初始化物件
        Args:
            left (list[list[str]]): 左邊連接列表
            right (list[list[str]]): 右邊連接列表
            center (list[list[str]]): 中間連接列表
        """
        self.left_kpt = left
        self.right_kpt = right
        self.center_kpt = center
        lr_kpt = np.append(left, right, axis=0)
        full_kpt = np.append(lr_kpt, center, axis=0)
        self.full_kpt = full_kpt.tolist()


# In[ ]:


blazepose_lines = LineConnections(
    left=[
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
    ],
    right=[
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
    ],
    center=[
        ["mouth_left", "mouth_right"],  # 9, 10
        ["left_shoulder", "right_shoulder"],  # 11, 12
        ["left_hip", "right_hip"],  # 23, 24
    ],
)


# In[ ]:


# 關節角度對照關鍵點(通用)
joint_dict: dict = {
    "left_shoulder": ["left_elbow", "left_hip"],
    "right_shoulder": ["right_elbow", "right_hip"],
    "left_hip": ["left_shoulder", "left_knee"],
    "right_hip": ["right_shoulder", "right_knee"],
    "left_knee": ["left_hip", "left_ankle"],
    "right_knee": ["right_hip", "right_ankle"],
}

