#!/usr/bin/env python
# coding: utf-8

# 套件

# In[ ]:


import cv2
import numpy as np
import matplotlib.pyplot as plt

# datatype
from mpl_toolkits.mplot3d.axes3d import Axes3D
from mediapipe.tasks.python.vision.pose_landmarker import PoseLandmarkerResult
from mediapipe.tasks.python.components.containers.landmark import Landmark

# custom
if __name__ == "__main__":
    from mediapipe_lib.base import PoseResult, ResultAnalyzer
    from utils.process_data import translate_multi_kpt_to_plot_pos
    from utils.plot_painter import draw_dots, draw_lines
else:
    from src.mediapipe_lib.base import PoseResult, ResultAnalyzer
    from src.utils.process_data import translate_multi_kpt_to_plot_pos
    from src.utils.plot_painter import draw_dots, draw_lines


# ##### 將姿勢座標結果轉換成表格座標

# In[ ]:


def poselandmarker_result_to_plot_pos(
    poselandmarker_result: PoseLandmarkerResult,
    is_3d: bool = False,
) -> list[list, list, list, list]:
    """將姿勢座標結果轉換成表格座標

    Args:
        poselandmarker_result (PoseLandmarkerResult): 姿勢座標結果
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

    Returns:
        list[list, list, list, list]: [關鍵點, 左邊線條, 中間線條, 右邊線條]
    """
    # 建立分析器
    result = PoseResult(poselandmarker_result)
    analyzer = ResultAnalyzer(result)

    # 取得關鍵點和線條資料
    kpts = result.get_all_kpt_positions(is_3d)
    left, center, right = analyzer.get_line_positions(get_3d=is_3d)

    # 轉換關鍵點和線條資料
    kpts, left, center, right = translate_multi_kpt_to_plot_pos(
        kpts, kpts, left, center, right
    )

    return [kpts, left, center, right]


# ##### 根據姿勢座標結果繪製圓形

# In[ ]:


def draw_circles_by_landmarks(
    np_img: np.ndarray,
    landmarks: list[Landmark],
    dot_size: int = 3,
    color: tuple[int, int, int] = (0, 0, 255),
    thickness: int = -1,
) -> np.ndarray:
    """根據姿勢座標結果繪製圓形

    Args:
        np_img (np.ndarray): 原始圖片
        landmarks (list[Landmark]): 姿勢座標列表
        dot_size (int, optional): 點大小. Defaults to 3.
        color (tuple[int, int, int], optional): 顏色(BGR). Defaults to (0, 0, 255).
        thickness (int, optional): 圓形線條長度. Defaults to -1.

    Returns:
        np.ndarray: 繪製完成的圖片
    """
    drawed_img = np_img.copy()
    h, w, _ = drawed_img.shape
    for kpt in landmarks[0]:
        kpt: Landmark
        pos = (int(kpt.x * w), int(kpt.y * h))
        cv2.circle(drawed_img, pos, dot_size, color, thickness)

    return drawed_img


# ##### 根據姿勢座標結果在圖表中繪製骨架

# In[ ]:


def draw_bones_in_plot_by_pose_lanmark_result(
    pose_lanmark_result: PoseLandmarkerResult,
    dot_size: int = 5,
    kpt_color: str = "#000",
    left_color: str = "#f00",
    center_color: str = "#0f0",
    right_color: str = "#00f",
    ax: Axes3D = None,
) -> Axes3D:
    """根據姿勢座標結果在圖表中繪製骨架

    Args:
        pose_lanmark_result (PoseLandmarkerResult): 姿勢座標結果
        dot_size (int, optional): 關鍵點大小. Defaults to 5.
        kpt_color (str, optional): 關鍵點顏色. Defaults to "#000".
        left_color (str, optional): 左邊身體顏色. Defaults to "#f00".
        center_color (str, optional): 中間身體顏色. Defaults to "#0f0".
        right_color (str, optional): 右邊身體顏色. Defaults to "#00f".
        ax (Axes3D, optional): _description_. Defaults to None.

    Returns:
        Axes3D: 表格座標
    """

    if ax is None:  # 沒有表格座標
        ax = plt.gca()

    # 轉換成表格座標
    kpts, left, center, right = poselandmarker_result_to_plot_pos(
        pose_lanmark_result, True
    )

    # 繪製表格
    draw_lines(left, True, left_color, "left", ax)
    draw_lines(center, True, center_color, "center", ax)
    draw_lines(right, True, right_color, "right", ax)
    draw_dots(kpts, True, dot_size, kpt_color, "kpts", ax)

    return ax

