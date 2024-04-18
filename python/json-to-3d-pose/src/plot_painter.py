#!/usr/bin/env python
# coding: utf-8

# In[1]:


import matplotlib.pyplot as plt
import numpy as np


# In[ ]:


def set_data_range(data_range: list[float, float], ax: plt.Axes) -> plt.Axes:
    """設定圖表資料範圍

    Args:
        data_range (list[float, float]): 資料範圍
        ax (plt.Axes): 座標資料

    Returns:
        plt.Axes: 座標資料
    """
    ax.set_xlim(data_range)
    ax.set_ylim(data_range)
    if ax.name == "3d":
        ax.set_zlim(data_range)

    return ax


# In[2]:


def draw_pose_result_line_chart(
    labels: list[str], data_type: str = None, ax: plt.Axes = None
) -> plt.Axes:
    """
    取得姿勢結果折線圖
    labels: 姿勢標籤列表
    data_type: 所代表的模型
    ax: Matplotlib 座標資料
    """
    POSE_LABEL = ["A1", "A2", "A3", "A4", "A5"]
    data = []

    # 將標籤以數值的形式存入到 data 中
    for lab in labels:
        if lab == "A1":
            data.append(0)
        if lab == "A2":
            data.append(1)
        if lab == "A3":
            data.append(2)
        if lab == "A4":
            data.append(3)
        if lab == "A5":
            data.append(4)

    if ax is None:
        ax = plt.gca()

    ax.set_xlabel("time frame")
    ax.set_ylabel("pose label")
    ax.set_yticks(list(range(5)), POSE_LABEL)
    ax.plot(range(len(data)), data, label=data_type)
    return ax


# In[3]:


def draw_dots(
    positions: list[list[float, float]] | list[list[float, float, float]],
    is_3d: bool = False,
    dot_size: int = 5,
    color: str = "#f00",
    ax: plt.Axes = None,
) -> plt.Axes:
    """繪製多個點

    Args:
        positions (list[list[list[float, float]]] | list[list[list[float, float, float]]]): 點座標陣列
        is_3d (bool, optional): 是否為 3D 座標. Defaults to False.
        dot_size (int, optional): 點大小. Defaults to 5.
        color (str, optional): 顏色(16位元rgb). Defaults to "#f00".
        ax (plt.Axes, optional): 圖表坐標. Defaults to None.

    Returns:
        plt.Axes: 圖表坐標
    """

    if ax is None:
        ax = plt.gca()

    # 轉換座標點格式
    pos = np.array(positions)

    # 設定標籤
    if not is_3d:
        ax.set_xlabel("x")
        ax.set_ylabel("y")
    else:
        ax.set_xlabel("x")
        ax.set_ylabel("z")
        ax.set_zlabel("y")

    # 繪製多個點
    x, y = pos[:, 0], pos[:, 1] # 點的 x, y 座標
    if not is_3d:  # 2D 格式
        ax.scatter(x, y, color=color, s=dot_size)
    else:  # 3D 格式
        z = pos[:, 2]  # z 座標點
        ax.scatter(x, z, -y, color=color, s=dot_size)

    return ax


# In[4]:


def draw_lines(
    positions: list[list[list[float, float]]] | list[list[list[float, float, float]]],
    is_3d: bool = False,
    color: str = "#000",
    ax: plt.Axes = None,
) -> plt.Axes:
    """繪製多組線條

    Args:
        positions (list[list[list[float, float]]] | list[list[list[float, float, float]]]): 座標點列表，存放多組的兩個點(用於連線)
        data_range (list[float, float]): 資料顯示區間
        is_3d (bool, optional): 是否為 3D 座標. Defaults to False.
        color (str, optional): 顏色(16位元rgb). Defaults to "#00f".
        ax (plt.Axes, optional): 圖表座標. Defaults to None.

    Returns:
        plt.Axes: 圖表座標
    """

    if ax is None:
        ax = plt.gca()

    # 取得座標點位置
    pos = np.array(positions)

    # 設定標籤
    if not is_3d:
        ax.set_xlabel("x")
        ax.set_ylabel("y")
    else:
        ax.set_xlabel("x")
        ax.set_ylabel("z")
        ax.set_zlabel("y")

    # 繪製多組線條
    for line in pos:
        x, y = line[:, 0], line[:, 1]  # x, y 座標點
        if not is_3d:  # 2D 格式
            ax.plot(x, y, color=color)
        else:  # 3D 格式
            z = line[:, 2]  # z 座標點
            ax.plot(x, z, -y, color=color)

    return ax

