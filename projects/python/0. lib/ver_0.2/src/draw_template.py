#!/usr/bin/env python
# coding: utf-8

# ### 套件

# In[ ]:


import matplotlib.pyplot as plt
import numpy as np
import cv2


# In[ ]:


from mpl_toolkits.mplot3d.axes3d import Axes, Axes3D
from mediapipe.tasks.python.components.containers.landmark import Landmark
from mediapipe.tasks.python.vision.pose_landmarker import PoseLandmarkerResult


# In[ ]:


if __name__ == "__main__":
    from calculate import line_3d_result_to_plot_pos
    from utils.cv_lib import draw_letter_badge
    from utils.plot_painter import draw_dots, draw_lines
    from mp_lib.base import PoseResult, ResultAnalyzer
else:
    from src.calculate import line_3d_result_to_plot_pos
    from src.utils.cv_lib import draw_letter_badge
    from src.utils.plot_painter import draw_dots, draw_lines
    from src.mp_lib.base import PoseResult, ResultAnalyzer


# ### 函式

# #### OpenCV

# ##### 在圖片上繪製關鍵點位置

# In[ ]:


def draw_kpt_position_in_img(
    result: PoseLandmarkerResult,
    origin_img: cv2.typing.MatLike,
    dot_size: int = 3,
    color: tuple[int, int, int] = (0, 0, 255),
    thickness: int = -1,
) -> cv2.typing.MatLike:
    """在圖片上繪製關鍵點位置

    Args:
        result (PoseLandmarkerResult): 姿勢座標列表
        origin_img (cv2.typing.MatLike): 原始圖片
        dot_size (int, optional): 點大小. Defaults to 3.
        color (tuple[int, int, int], optional): 顏色(BGR). Defaults to (0, 0, 255).
        thickness (int, optional): 圓形線條長度. Defaults to -1.

    Returns:
        cv2.typing.MatLike: 繪製完成的圖片
    """
    # 沒有資料則傳回原始圖片
    if len(result.pose_landmarks) <= 0:
        return origin_img

    # 繪製關鍵點
    drawed_img = origin_img.copy()
    h, w, _ = drawed_img.shape
    for kpt in result.pose_landmarks[0]:
        kpt: Landmark
        pos = (int(kpt.x * w), int(kpt.y * h))
        cv2.circle(drawed_img, pos, dot_size, color, thickness)

    return drawed_img


# ##### 在圖片上繪製偵錯資訊

# In[ ]:


def draw_debug_in_img(
    result: PoseLandmarkerResult, origin_img: cv2.typing.MatLike, is_3d: bool = False
) -> cv2.typing.MatLike:
    """在圖片上繪製偵錯資訊

    Args:
        result (PoseLandmarkerResult): 姿勢結果
        origin_img (cv2.typing.MatLike): 原始圖片
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

    Returns:
        cv2.typing.MatLike: 繪製過姿勢結果的圖片
    """
    # 複製原始圖片
    result_img = origin_img.copy()

    ### 未取得任何運算結果
    if len(result.pose_landmarks) <= 0:
        result_img = draw_letter_badge(result_img, "F", (30, 230))
        return result_img

    # 建立分析器
    analyzer = ResultAnalyzer(PoseResult(result))

    ### 繪製驗證標誌
    # 軀幹是否扭轉
    if analyzer.check_if_trunk_is_twisted(is_3d):
        result_img = draw_letter_badge(result_img, "A", (30, 30))
    # 手是否遠離身體
    if analyzer.check_if_hands_at_a_distance(is_3d):
        result_img = draw_letter_badge(result_img, "B", (30, 80))
    # 手臂是否抬起，水平位置且位於肩膀和手肘間
    if analyzer.check_if_arms_raised(is_3d):
        result_img = draw_letter_badge(result_img, "C", (30, 130))
    # 手是否高過肩膀
    if analyzer.check_if_hands_above_shoulder(is_3d):
        result_img = draw_letter_badge(result_img, "D", (30, 180))

    return result_img


# #### Matplotlib

# ##### 在圖表座標中繪製骨架

# In[ ]:


def get_bones_plot_axes(
    result: PoseLandmarkerResult,
    dot_size: int = 5,
    colors: list[str, str, str, str] = ["#f00", "#0f0", "#00f", "#000"],
    is_3d: bool = False,
    ax: Axes | Axes3D = None,
) -> Axes | Axes3D:
    """在圖表座標中繪製骨架

    Args:
        result (PoseLandmarkerResult): 姿勢座標結果
        dot_size (int, optional): 關鍵點大小. Defaults to 5.
        colors (list[str, str, str, str], optional): 顏色資料[左邊身體, 中間身體, 右邊身體, 全部關鍵點]. Defaults to ["#f00", "#0f0", "#00f", "#000"].
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.
        ax (Axes | Axes3D, optional): 表格座標. Defaults to None.

    Returns:
        Axes | Axes3D: 表格座標
    """
    # 取得當前表格座標
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result.pose_world_landmarks) <= 0:
        return ax

    # 初始化所需參數
    kpts, left, center, right = None, None, None, None
    # 是否為 3D 姿勢
    if not is_3d:
        # 建立分析器
        pose_result = PoseResult(result)
        analyzer = ResultAnalyzer(pose_result)
        # 取得所需資料
        kpts = pose_result.get_all_kpt_positions(is_3d)
        left, center, right = analyzer.get_line_positions(get_3d=is_3d)
    else:
        # 轉換成表格座標
        kpts, left, center, right = line_3d_result_to_plot_pos(result)

    # 繪製表格
    draw_lines(left, is_3d, colors[0], "left", ax)
    draw_lines(center, is_3d, colors[1], "center", ax)
    draw_lines(right, is_3d, colors[2], "right", ax)
    draw_dots(kpts, is_3d, dot_size, colors[3], "kpts", ax)

    return ax


# ##### 取得肩臀交錯線條的軸

# In[ ]:


def get_axes_with_staggered_lines(
    result: PoseLandmarkerResult, is_3d: bool = False, ax: Axes = None
) -> Axes | Axes3D:
    """取得肩臀交錯線條的軸

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        is_3d (bool, optional): 是否顯示 3D 座標結果(不是的話會顯示 xz 軸畫面). Defaults to False.
        ax (Axes, optional): 圖表座標. Defaults to None.

    Returns:
        Axes | Axes3D: 圖表座標
    """

    # 取得當前圖表座標
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result.pose_landmarks) <= 0:
        return ax

    # 建立分析器
    pose_result = PoseResult(result)

    # 取得關鍵點座標
    shoulder_l = pose_result.get_kpt_pos_by_name("left_shoulder", True)
    shoulder_r = pose_result.get_kpt_pos_by_name("right_shoulder", True)
    hip_l = pose_result.get_kpt_pos_by_name("left_hip", True)
    hip_r = pose_result.get_kpt_pos_by_name("right_hip", True)

    # 繪製圖表資訊
    if not is_3d:
        ax.plot(
            [shoulder_l[0], shoulder_r[0]],
            [shoulder_l[2], shoulder_r[2]],
            label="shoulder",
        )
        ax.plot([hip_l[0], hip_r[0]], [hip_l[2], hip_r[2]], label="waist")
    else:
        ax.scatter(
            [shoulder_l[0], hip_l[0]],
            [shoulder_l[2], hip_l[2]],
            [shoulder_l[1], hip_l[1]],
            c="#f00",
            label="left",
        )
        ax.scatter(
            [shoulder_r[0], hip_r[0]],
            [shoulder_r[2], hip_r[2]],
            [shoulder_r[1], hip_r[1]],
            c="#0f0",
            label="right",
        )
        ax.plot(
            [shoulder_l[0], shoulder_r[0]],
            [shoulder_l[2], shoulder_r[2]],
            [shoulder_l[1], shoulder_r[1]],
            label="shoulder",
        )
        ax.plot(
            [hip_l[0], hip_r[0]],
            [hip_l[2], hip_r[2]],
            [hip_l[1], hip_r[1]],
            label="waist",
        )

    return ax


# ##### 取得肩臀交錯向量的軸

# In[ ]:


def get_axes_with_staggered_vector(
    result: PoseLandmarkerResult, is_3d: bool = False, ax: Axes = None
) -> Axes | Axes3D:
    """取得肩臀交錯向量的軸

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        is_3d (bool, optional): 是否顯示 3D 座標結果(不是的話會顯示 xz 軸畫面). Defaults to False.
        ax (Axes, optional): 圖表座標. Defaults to None.

    Returns:
        Axes | Axes3D: 圖表座標
    """

    # 取得當前圖表座標
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result.pose_landmarks) <= 0:
        return ax

    # 建立分析器
    pose_result = PoseResult(result)

    # 取得關鍵點座標
    shoulder_l = pose_result.get_kpt_pos_by_name("left_shoulder", True)
    shoulder_r = pose_result.get_kpt_pos_by_name("right_shoulder", True)
    hip_l = pose_result.get_kpt_pos_by_name("left_hip", True)
    hip_r = pose_result.get_kpt_pos_by_name("right_hip", True)

    shoulder_vec = np.array(shoulder_r) - np.array(shoulder_l)
    hip_vec = np.array(hip_r) - np.array(hip_l)

    # 繪製圖表資訊
    if not is_3d:
        ax.plot([0, shoulder_vec[0]], [0, shoulder_vec[2]], label="shoulder vector")
        ax.plot([0, hip_vec[0]], [0, hip_vec[2]], label="waist vector")
    else:
        ax.plot(
            [0, shoulder_vec[0]],
            [0, shoulder_vec[2]],
            [0, shoulder_vec[1]],
            label="shoulder vector",
        )
        ax.plot([0, hip_vec[0]], [0, hip_vec[2]], [0, hip_vec[1]], label="waist vector")

    return ax


# ##### 取得兩肩膀的軸

# In[ ]:


def get_axes_with_both_shoulders(result: PoseLandmarkerResult, ax: Axes = None) -> Axes:
    """取得兩肩膀的軸

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        ax (Axes, optional): 圖表軸. Defaults to None.

    Returns:
        Axes: 圖表軸
    """
    # 取得當前圖表軸
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result.pose_world_landmarks) <= 0:
        return ax

    pose_result = PoseResult(result)

    shoulder_l = pose_result.get_kpt_pos_by_name("left_shoulder", True)
    shoulder_r = pose_result.get_kpt_pos_by_name("right_shoulder", True)

    ax.scatter(
        shoulder_l[0],
        shoulder_l[1],
        c="#f00",
        label="left shoulder",
    )
    ax.scatter(
        shoulder_r[0],
        shoulder_r[1],
        c="#0f0",
        label="right shoulder",
    )
    ax.plot(
        [shoulder_l[0], shoulder_r[0]],
        [shoulder_l[1], shoulder_r[1]],
        c="#00f",
        label="shoulder width",
    )

    return ax


# ##### 取得雙手腕到身體重心的軸

# In[ ]:


def get_axes_with_both_wrists_to_gravity(
    result: PoseLandmarkerResult, ax: Axes = None
) -> Axes:
    """取得雙手腕到身體重心的軸

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        ax (Axes, optional): 圖表座標. Defaults to None.

    Returns:
        Axes: 圖表座標
    """
    # 取得當前圖表座標
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result.pose_landmarks) <= 0:
        return ax

    # 設定分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    # 取得關鍵點座標
    hip_l = analyzer.pose_result.get_kpt_pos_by_name("left_hip", True)  # 左腰
    hip_r = analyzer.pose_result.get_kpt_pos_by_name("right_hip", True)  # 右腰
    wrist_l = analyzer.pose_result.get_kpt_pos_by_name("left_wrist", True)  # 左手腕
    wrist_r = analyzer.pose_result.get_kpt_pos_by_name("right_wrist", True)  # 右手腕
    gravity = np.mean([hip_l, hip_r], axis=0)

    ### 繪製圖表
    # 腰部
    ax.plot([hip_l[0], hip_r[0]], [hip_l[2], hip_r[2]], label="Waist")
    # 左手到腰部中心
    ax.plot(
        [wrist_l[0], gravity[0]],
        [wrist_l[2], gravity[2]],
        label="Wrist to gravity line(left)",
    )
    # 右手到腰部中心
    ax.plot(
        [wrist_r[0], gravity[0]],
        [wrist_r[2], gravity[2]],
        label="Wrist to gravity line(right)",
    )
    ax.scatter(gravity[0], gravity[2], label="Gravity Point")
    ax.scatter(wrist_l[0], wrist_l[2], label="Left wrist")
    ax.scatter(wrist_r[0], wrist_r[2], label="Right wrist")

    return ax


# ##### 取得分析肩膀高度差的軸

# In[ ]:


def get_axes_with_shoulder_hight_diff(
    result_lst: list[PoseLandmarkerResult], ax: Axes = None
) -> Axes:
    """取得分析肩膀高度差的軸

    Args:
        result_lst (list[PoseLandmarkerResult]): 姿勢分析結果列表
        ax (Axes, optional): 圖表軸. Defaults to None.

    Returns:
        Axes: 圖表軸
    """
    # 取得當前圖表軸
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result_lst) <= 0:
        return ax

    shoulder_diff_lst = []
    for result in result_lst:
        pose_result = PoseResult(result)
        shoulder_l = pose_result.get_kpt_pos_by_name("left_shoulder", True)
        shoulder_r = pose_result.get_kpt_pos_by_name("right_shoulder", True)
        shoulder_diff = np.linalg.norm(shoulder_l[1] - shoulder_r[1])
        shoulder_diff_lst.append(shoulder_diff)

    ax.plot(range(len(shoulder_diff_lst)), shoulder_diff_lst)

    pass

