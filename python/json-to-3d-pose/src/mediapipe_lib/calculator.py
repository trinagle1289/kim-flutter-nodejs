#!/usr/bin/env python
# coding: utf-8

# #### 使用套件

# In[ ]:


import numpy as np
import math


# ##### 從三個座標點之間取得角度

# In[ ]:


def get_angle_by_3_points(pos1: list, pos2: list, center_pos: list) -> float:
    """
    從三個座標點之間取得角度
    中心點為 center_pos
    (使用餘弦定理)

    Args:
        pos1 (list): 座標 1
        pos2 (list): 座標 2
        center_pos (list): 中心關鍵點(連接關鍵點 1和關鍵點 2)

    Returns:
        float: 角度(度數)
    """
    # 求角 A (對面為邊 a)
    # a: pt1 pt2 距離
    # b: pt1 cenPt 距離
    # c: pt2 cenPt 距離

    p1 = np.array(pos1)
    p2 = np.array(pos2)
    center_pt = np.array(center_pos)

    a = np.linalg.norm(p1 - p2)
    b = np.linalg.norm(p1 - center_pt)
    c = np.linalg.norm(p2 - center_pt)

    angleA = math.degrees(math.acos((b * b + c * c - a * a) / (2 * b * c)))
    return angleA


# ##### 將角度轉換成 LHC 姿勢標籤

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

    if angles is None:
        label = ""
    return label


# ##### 取得兩條線座標之間的角度

# In[ ]:


def get_angle_between_two_lines_position(
    line1: list[list[float, float], list[float, float]],
    line2: list[list[float, float], list[float, float]],
) -> float:
    """取得兩條線座標之間的角度

    Args:
        line1 (list[list[float, float], list[float, float]]): 線條 1的兩點座標
        line2 (list[list[float, float], list[float, float]]): 線條 2的兩點座標

    Returns:
        float: 角度(度數)
    """
    pos1a = np.array(line1[0])
    pos1b = np.array(line1[1])
    pos2a = np.array(line2[0])
    pos2b = np.array(line2[1])

    vec1 = pos1a - pos1b
    vec2 = pos2a - pos2b

    norm1 = np.linalg.norm(vec1)
    norm2 = np.linalg.norm(vec2)

    return np.rad2deg(np.arccos(np.dot(vec1, vec2) / (norm1 * norm2)))

