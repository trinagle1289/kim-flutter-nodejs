#!/usr/bin/env python
# coding: utf-8

# ### 套件

# In[ ]:


from matplotlib.backends.backend_agg import FigureCanvasAgg
import matplotlib.pyplot as plt
import numpy as np
import cv2


# In[ ]:


from matplotlib.figure import Figure
from matplotlib.pyplot import Axes
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.collections import LineCollection
from mpl_toolkits.mplot3d.art3d import Line3DCollection


# ### 函式

# #### 圖表設定

# ##### 設定圖表資料範圍(方形)

# In[ ]:


def set_square_data_range(
    data_range: list[float, float], ax: Axes | Axes3D = None
) -> Axes | Axes3D:
    """設定圖表資料範圍(方形)

    Args:
        data_range (list[float, float]): 資料範圍
        ax (Axes | Axes3D, optional): 座標資料. Defaults to None.

    Returns:
        Axes | Axes3D: 座標資料
    """

    if ax is None:
        ax = plt.gca()

    ax.set_xlim(data_range)
    ax.set_ylim(data_range)
    if ax.name == "3d":
        ax.set_zlim(data_range)

    return ax


# ##### 設定圖表資料範圍

# In[ ]:


def set_data_range(
    x: list[float, float],
    y: list[float, float],
    z: list[float, float] = [0, 0],
    ax: Axes | Axes3D = None,
) -> Axes | Axes3D:
    """設定圖表資料範圍

    Args:
        x (list[float, float]): x 軸範圍
        y (list[float, float]): y 軸範圍
        z (list[float, float], optional): z 軸範圍. Defaults to [0, 0].
        ax (Axes | Axes3D, optional): 座標資料. Defaults to None.

    Returns:
        Axes | Axes3D: 座標資料
    """
    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    ax.set_xlim(x)
    ax.set_ylim(y)
    if ax.name == "3d":
        ax.set_zlim(z)

    return ax


# ##### 設定圖表標籤

# In[ ]:


def set_plot_labels(
    x_label: str, y_label: str, z_label: str = "", ax: Axes | Axes3D = None
) -> Axes | Axes3D:
    """設定圖表標籤

    Args:
        x_label (str): x 軸標籤
        y_label (str): y 軸標籤
        z_label (str, optional): z 軸標籤. Defaults to "".
        ax (Axes | Axes3D, optional): 圖表座標. Defaults to None.

    Returns:
        Axes | Axes3D: 圖表座標
    """
    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    # 設定標籤
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    if ax.name == "3d":
        ax.set_zlabel(z_label)

    return ax


# #### 基礎繪製

# ##### 繪製多個點

# In[ ]:


def draw_dots(
    positions: list[list[float, float]] | list[list[float, float, float]],
    is_3d: bool = False,
    dot_size: int = 5,
    color: str = "#f00",
    label: str = "",
    ax: Axes | Axes3D = None,
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

    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    # 轉換座標點格式
    pos = np.array(positions)

    # 繪製多個點
    x, y = pos[:, 0], pos[:, 1]  # 點的 x, y 座標
    if not is_3d:  # 2D 格式
        ax.scatter(x, y, color=color, s=dot_size, label=label)
    else:  # 3D 格式
        z = pos[:, 2]  # z 座標點
        ax.scatter(x, z, y, color=color, s=dot_size, label=label)

    return ax


# ##### 繪製多組線條

# In[ ]:


def draw_lines(
    positions: list[list[list[float, float]]] | list[list[list[float, float, float]]],
    is_3d: bool = False,
    color: str = "#000",
    label: str = "",
    ax: Axes | Axes3D = None,
) -> Axes | Axes3D:
    """繪製多組線條

    Args:
        positions (list[list[list[float, float]]] | list[list[list[float, float, float]]]): 座標點列表，存放多組的兩個點(用於連線)
        is_3d (bool, optional): 是否為 3D 座標. Defaults to False.
        color (str, optional): 顏色(16位元rgb). Defaults to "#000".
        ax (Axes | Axes3D, optional): 圖表座標. Defaults to None.

    Returns:
        Axes | Axes3D: 圖表座標
    """
    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    pos = np.array(positions)  # 取得座標點位置
    colors = [color] * pos.shape[0]  # 設定顏色陣列

    # 設定標籤和設定線條集合
    if not is_3d:
        lines = LineCollection(pos, colors=colors, label=label)
        ax.add_collection(lines)
    else:
        # 取得三維座標點
        x = pos[:, :, 0]
        y = pos[:, :, 1]
        z = pos[:, :, 2]

        # 將舊的三維座標點映射在新的物件上
        new_pos = pos.copy()
        new_pos[:, :, 0] = x
        new_pos[:, :, 1] = z
        new_pos[:, :, 2] = y

        lines = Line3DCollection(new_pos, colors=colors, label=label)
        ax.add_collection(lines)

    return ax


# #### 繪製資料

# ##### 繪製姿勢結果折線圖

# In[ ]:


def draw_pose_result_line_chart(
    labels: list[str], data_type: str = None, ax: Axes = None
) -> Axes:
    """繪製姿勢結果折線圖

    Args:
        labels (list[str]): 姿勢標籤列表
        data_type (str, optional): 所代表的模型. Defaults to None.
        ax (Axes, optional): 座標資料. Defaults to None.

    Returns:
        plt.Axes: 座標資料
    """
    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    # 姿勢標籤字典
    POSE_LABEL_DICT = {"A1": 0, "A2": 1, "A3": 2, "A4": 3, "A5": 4}

    data = []
    # 將標籤以數值的形式存入到 data 中
    for lab in labels:
        if lab == "A1" or lab == "A2" or lab == "A3" or lab == "A4" or lab == "A5":
            data.append(POSE_LABEL_DICT[lab])

    # 設定標籤名稱
    ax.set_xlabel("time frame")
    ax.set_ylabel("pose label")

    # 設定 y 軸刻度
    ticks = list(POSE_LABEL_DICT.values())
    labels = list(POSE_LABEL_DICT.keys())
    ax.set_yticks(ticks, labels)
    ax.set_ylim(-0.1, 4.1)

    # 繪製折線圖
    x = range(len(data))
    y = data
    ax.plot(x, y, label=data_type)

    return ax


# ##### 繪製 bool 陣列折線圖

# In[ ]:


def draw_bool_list_line_chart(
    bool_lst: list[bool], data_type: str = None, ax: Axes = None
) -> Axes:
    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    data: list[int] = []
    # 將 True 或 False 以數值的形式存入到 data 中
    for element in bool_lst:
        # True 資料訂為 1，False 資料訂為 0
        if element:
            data.append(1)
        else:
            data.append(0)

    ax.set_xlabel("time frame")
    ax.set_yticks([1, 0], [True, False])  # 設定 y 軸刻度值
    ax.set_ylim(-0.1, 1.1)
    ax.plot(range(len(data)), data, label=data_type)

    return ax


# ##### 繪製頻率直方圖

# In[ ]:


def draw_frequency_list_bar_chart(
    frequency_dict: dict[str:str],
    ytick_label_dict: dict[str:int] = {
        "FREQUENTLY_OR_CONSTANTLY": 2,
        "OCCASIONALLY": 1,
        "RARELY": 0,
    },
    ax: Axes = None,
) -> Axes:
    """繪製頻率直方圖

    Args:
        frequency_dict (dict[str:str]): 動作頻率字典{動作名稱: 頻率名稱}
        ytick_label_dict (dict[str:int], optional): y 軸刻度值設定字典{頻率名稱: y 軸刻度值}. Defaults to { "FREQUENTLY_OR_CONSTANTLY": 2, "OCCASIONALLY": 1, "RARELY": 0, }.
        ax (Axes, optional): 表格座標. Defaults to None.

    Returns:
        Axes: 表格座標
    """

    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    # 表格資料
    plot_data: dict[str, int] = {}
    # 將頻率列表轉換成數值
    for key, value in frequency_dict.items():
        y_tick = ytick_label_dict[value]  # 設定 y 軸刻度值
        print(y_tick)
        plot_data.update({key: y_tick})  # 更新表格資料

    # 設定標籤
    ax.set_xlabel("Doing...")  # 做的事情
    ax.set_ylabel("Frequency")  # 頻率

    # 設定 y 軸刻度值
    ticks = list(ytick_label_dict.values())
    labels = list(ytick_label_dict.keys())
    ax.set_yticks(ticks, labels)

    # 繪製直方圖
    x = list(plot_data.keys())
    y = list(plot_data.values())
    ax.bar(x, y, label="Frequency Type")

    return ax


# ##### 繪製動作執行比率直方圖

# In[ ]:


def draw_execution_rate_bar_chart(
    execution_rate_dict: dict[str:int],
    ax: Axes = None,
) -> Axes:
    """繪製動作執行比率直方圖

    Args:
        execution_rate_dict (dict[str:int]): 動作執行比率字典{動作名稱: 執行比率}
        ax (Axes, optional): 圖表座標. Defaults to None.

    Returns:
        Axes: 圖表座標
    """

    # 取得當前使用的座標
    if ax is None:
        ax = plt.gca()

    # 設定標籤
    ax.set_xlabel("Doing...")  # 做的事情
    ax.set_ylabel("Execution Rate")  # 執行比率
    ax.set_ylim(0, 100)  # 顯示範圍為 0 ~ 100

    # 繪製直方圖
    x = list(execution_rate_dict.keys())
    y = list(execution_rate_dict.values())
    ax.bar(x, y, label="Execution Rate")

    return ax


# #### 資料轉換

# ##### 將圖表轉換成圖片格式

# In[ ]:


def plot_to_opencv_img(fig: Figure) -> cv2.typing.MatLike:
    """將圖表轉換成圖片格式

    Args:
        fig (Figure): 圖表物件

    Returns:
        cv2.typing.MatLike: opencv 圖片(RGBA 格式)
    """

    # 固定畫布內容
    canvas = FigureCanvasAgg(fig)
    canvas.draw()

    # 將圖表 buffer 轉換成 numpy
    rgba = np.asarray(canvas.buffer_rgba())
    return rgba

