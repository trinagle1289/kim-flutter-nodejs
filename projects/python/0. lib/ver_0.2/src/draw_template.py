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

# ##### 根據姿勢座標結果在圖表中繪製骨架

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


# ##### 取得肩臀交錯角度圖表座標

# In[ ]:


def get_staggered_angle_axes(
    result: PoseLandmarkerResult, is_3d: bool = False, ax: Axes3D = None
) -> Axes3D:
    """取得肩臀交錯角度圖表座標

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.
        ax (Axes3D, optional): 3D 圖表座標. Defaults to None.

    Returns:
        Axes3D: 圖表座標
    """
    # 取得當前圖表座標
    if ax is None:
        ax = plt.gca()

    # 沒有資料則回傳原始表格座標
    if len(result.pose_landmarks) <= 0:
        return ax

    # 建立分析器
    pose_result = PoseResult(result)

    # 設定肩臀線條座標
    shoulder = np.array(
        [
            pose_result.get_kpt_pos_by_name("left_shoulder", is_3d),
            pose_result.get_kpt_pos_by_name("right_shoulder", is_3d),
        ]
    )
    hip = np.array(
        [
            pose_result.get_kpt_pos_by_name("left_hip", is_3d),
            pose_result.get_kpt_pos_by_name("right_hip", is_3d),
        ]
    )

    # 繪製圖表資訊
    if not is_3d:
        ax.plot(shoulder[:, 0], shoulder[:, 2], shoulder[:, 1], label="shoulder")
        ax.plot(hip[:, 0], hip[:, 2], hip[:, 1], label="hip")
    else:
        ax.plot(shoulder[:, 0], shoulder[:, 1], label="shoulder")
        ax.plot(hip[:, 0], hip[:, 1], label="hip")

    return ax


# ##### 取得手到身體重心資訊的圖表座標

# In[ ]:


def get_a_hand_to_gravity_axes(
    result: PoseLandmarkerResult, is_left: bool, is_3d: bool = False, ax: Axes3D = None
) -> Axes3D:
    """取得手到身體重心資訊的圖表座標

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        is_left (bool): 是否為左手
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.
        ax (Axes3D, optional): 3D 圖表座標. Defaults to None.

    Returns:
        Axes3D: 圖表座標
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

    hand_kpt_name = "left_wrist" if is_left else "right_wrist"  # 手腕關鍵點名稱
    hand_type = "left" if is_left else "right"  # 手的種類(左或右)

    # 取得 手部到重心距離 的座標
    dist = np.array(
        [
            pose_result.get_kpt_pos_by_name(hand_kpt_name, is_3d),
            analyzer.get_body_gravity_position(is_3d),
        ]
    )

    # 繪製圖表
    if not is_3d:
        ax.plot(dist[:, 0], dist[:, 1], label=f"{hand_type} hand to gravity line")
        ax.scatter(dist[0, 0], dist[0, 1], label=f"{hand_type} hand")
        ax.scatter(dist[1, 0], dist[1, 1], label="body gravity")
    else:
        ax.plot(
            dist[:, 0],
            dist[:, 2],
            dist[:, 1],
            label=f"{hand_type} hand to gravity line",
        )
        ax.scatter(dist[0, 0], dist[0, 2], dist[0, 1], label=f"{hand_type} hand")
        ax.scatter(dist[1, 0], dist[1, 2], dist[1, 1], label="body gravity")

    return ax


# ##### 取得雙手中心到身體重心資訊的圖表座標

# In[ ]:


def get_hand_center_to_gravity_axes(
    result: PoseLandmarkerResult, is_3d: bool = False, ax: Axes3D = None
) -> Axes3D:
    """取得雙手中心和身體重心資訊的圖表座標

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.
        ax (Axes3D, optional): 3D 圖表座標. Defaults to None.

    Returns:
        Axes3D: 圖表座標
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

    # 取得 手部到重心距離 的座標
    dist = np.array(
        [
            analyzer.get_center_position_by_2_hand(is_3d),
            analyzer.get_body_gravity_position(is_3d),
        ]
    )

    # 繪製圖表
    if not is_3d:
        ax.plot(dist[:, 0], dist[:, 1], label="hand to gravity line")
        ax.scatter(dist[0, 0], dist[0, 1], label="hand center")
        ax.scatter(dist[1, 0], dist[1, 1], label="body gravity")
    else:
        ax.plot(dist[:, 0], dist[:, 2], dist[:, 1], label="hand to gravity line")
        ax.scatter(dist[0, 0], dist[0, 2], dist[0, 1], label="hand center")
        ax.scatter(dist[1, 0], dist[1, 2], dist[1, 1], label="body gravity")

    return ax


# ##### 取得手或重心是否遠離身體資料的圖表座標

# In[ ]:


def get_hand_to_gravity_info_axes(
    result: PoseLandmarkerResult, is_3d: bool = False, ax: Axes3D = None
) -> Axes3D:
    """取得手或重心是否遠離身體資料的圖表座標

    Args:
        result (PoseLandmarkerResult): 姿勢分析結果
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.
        ax (Axes3D, optional): 3D 圖表座標. Defaults to None.

    Returns:
        Axes3D: 圖表座標
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

    # 關鍵點座標
    left_wrist = np.array(pose_result.get_kpt_pos_by_name("left_wrist", is_3d))
    left_elbow = np.array(pose_result.get_kpt_pos_by_name("left_elbow", is_3d))
    right_wrist = np.array(pose_result.get_kpt_pos_by_name("right_wrist", is_3d))
    right_elbow = np.array(pose_result.get_kpt_pos_by_name("right_elbow", is_3d))
    body_gravity = np.array(analyzer.get_body_gravity_position(is_3d))

    # 上臂線條座標
    left_upper_arm = np.array([left_wrist, left_elbow])
    right_upper_arm = np.array([right_wrist, right_elbow])
    # 手腕到重心線條座標
    left_hand_to_gravity = np.array([left_wrist, body_gravity])
    right_hand_to_gravity = np.array([right_wrist, body_gravity])

    # 繪製圖表
    if not is_3d:
        ax.plot(left_upper_arm[:, 0], left_upper_arm[:, 1], label="left upper arm")
        ax.plot(right_upper_arm[:, 0], right_upper_arm[:, 1], label="right upper arm")
        ax.plot(
            left_hand_to_gravity[:, 0],
            left_hand_to_gravity[:, 1],
            label="left hand to gravity",
        )
        ax.plot(
            right_hand_to_gravity[:, 0],
            right_hand_to_gravity[:, 1],
            label="right hand to gravity",
        )
        ax.scatter(left_wrist[:, 0], left_wrist[:, 1], label="left wrist")
        ax.scatter(left_elbow[:, 0], left_elbow[:, 1], label="left elbow")
        ax.scatter(right_wrist[:, 0], right_wrist[:, 1], label="right wrist")
        ax.scatter(right_elbow[:, 0], right_elbow[:, 1], label="right elbow")
        ax.scatter(body_gravity[:, 0], body_gravity[:, 1], label="body gravity")
    else:
        ax.plot(
            left_upper_arm[:, 0],
            left_upper_arm[:, 2],
            left_upper_arm[:, 1],
            label="left upper arm",
        )
        ax.plot(
            right_upper_arm[:, 0],
            right_upper_arm[:, 2],
            right_upper_arm[:, 1],
            label="right upper arm",
        )
        ax.plot(
            left_hand_to_gravity[:, 0],
            left_hand_to_gravity[:, 2],
            left_hand_to_gravity[:, 1],
            label="left hand to gravity",
        )
        ax.plot(
            right_hand_to_gravity[:, 0],
            right_hand_to_gravity[:, 2],
            right_hand_to_gravity[:, 1],
            label="right hand to gravity",
        )
        ax.scatter(
            left_wrist[0],
            left_wrist[2],
            left_wrist[1],
            label="left wrist",
        )
        ax.scatter(
            left_elbow[0],
            left_elbow[2],
            left_elbow[1],
            label="left elbow",
        )
        ax.scatter(
            right_wrist[0],
            right_wrist[2],
            right_wrist[1],
            label="right wrist",
        )
        ax.scatter(
            right_elbow[0],
            right_elbow[2],
            right_elbow[1],
            label="right elbow",
        )
        ax.scatter(
            body_gravity[0],
            body_gravity[2],
            body_gravity[1],
            label="body gravity",
        )

    return ax

