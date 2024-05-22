#!/usr/bin/env python
# coding: utf-8

# #### 常數

# In[1]:


MODEL = "./models/BlazePose/pose_landmarker_full.task"
STREAM_ID = 0
VIDEO = "../../resources/video/side/20240401/A1-A5_3.mp4"


# #### 套件

# In[2]:


# view result
import cv2
import matplotlib.pyplot as plt
from matplotlib.backends.backend_agg import FigureCanvasAgg

# data process
from mediapipe.tasks.python.core.base_options import BaseOptions
from mediapipe.tasks.python.vision.core.vision_task_running_mode import (
    VisionTaskRunningMode,
)
from mediapipe.tasks.python.vision.pose_landmarker import (
    PoseLandmarker,
    PoseLandmarkerOptions,
)
import mediapipe as mp
import numpy as np
import time

# datatype
from mpl_toolkits.mplot3d.axes3d import Axes3D
from mediapipe.tasks.python.vision.pose_landmarker import PoseLandmarkerResult

# custom
from src.calculate import (
    draw_circles_by_landmarks,
    draw_bones_in_plot_by_pose_lanmark_result,
)
from src.utils.plot_painter import set_data_range
from src.mediapipe_lib.base import PoseLandmarkerLiveStream, PoseResult, ResultAnalyzer


# #### 忽略警告

# In[3]:


import warnings

warnings.filterwarnings("ignore")


# #### 變數

# In[4]:


is_3d = True

range_x = [-1, 1]
range_y = [-1, 1]
range_z = [0, 2]

c_kpts = "#000"
c_left = "#f00"
c_center = "#0f0"
c_right = "#00f"

# 圖表中視角
default_view = (30, -60, 0)  # 預設視角
top_view = (90, 0, 0)  # 頭頂視角
front_view = (30, 0, 0)  # 正面視角


# #### 函式

# ##### 取得一個 3D 姿勢圖表的圖片

# In[5]:


def get_a_3d_pose_plot_image(
    result: PoseLandmarkerResult,
    figsize: tuple[float, float] = (6.4, 4.8),
    view: tuple[float, float, float] = (30, -60, 0),
    range: tuple[list, list, list] = ([1, -1], [1, -1], [2, 0]),
    dot_size: int = 5,
    colors: tuple[str, str, str, str] = ("#000", "#000", "#000", "#000"),
) -> cv2.typing.MatLike:
    """取得一個 3D 姿勢圖表的圖片

    Args:
        result (PoseLandmarkerResult): 姿勢座標結果
        figsize (tuple[float, float], optional): 圖表大小. Defaults to (6.4, 4.8).
        view (tuple[float, float, float], optional): 圖表視角. Defaults to (30, -60, 0).
        range (tuple[list, list, list], optional): 圖表資料範圍. Defaults to ([1, -1], [1, -1], [2, 0]).
        dot_size (int, optional): 關鍵點大小. Defaults to 5.
        colors (tuple[str, str, str, str], optional): 顏色(關鍵點, 左邊線條, 中間線條, 右邊線條). Defaults to ("#000", "#000", "#000", "#000").

    Returns:
        cv2.typing.MatLike: 3D 姿勢圖表圖片
    """

    is3d = True  # 3D 姿勢

    # 設定分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    # 初始化
    fig = plt.figure(figsize=figsize)
    ax: Axes3D = fig.add_subplot(projection="3d")

    # 圖表設定
    set_data_range(range[0], range[1], range[2], ax)
    ax.view_init(view[0], view[1], view[2])
    ax.set_xlabel("x")
    ax.set_ylabel("z")
    ax.set_zlabel("y")

    # 如果可以取得世界座標資訊
    if len(pose_result.result.pose_world_landmarks) > 0:
        # 設定標題
        ax.set_title(
            f"label: {analyzer.get_lhc_label(is3d)}\n"
            + f"staggered angle: {analyzer.get_pose_shoulder_hip_staggered_angle(is3d):.2f}"
        )
        # 進行繪圖
        draw_bones_in_plot_by_pose_lanmark_result(
            result, dot_size, colors[0], colors[1], colors[2], colors[3], ax
        )
        ax.legend()

    # 固定圖表內容
    canvas = FigureCanvasAgg(fig)
    canvas.draw()
    plt.close(fig)  # 關閉圖表

    # 轉換圖表為圖片
    rgba = np.asarray(canvas.buffer_rgba())
    rgb = cv2.cvtColor(rgba, cv2.COLOR_RGBA2RGB)

    return rgb


# ##### 取得一個 3D 肩臀線條的圖片

# In[6]:


def get_shoulder_and_hip_plot_image(
    result: PoseLandmarkerResult,
    figsize: tuple[float, float] = (6.4, 4.8),
    view: tuple[float, float, float] = (90, 0, 0),
    range: tuple[list, list, list] = ([1, -1], [1, -1], [2, 0]),
) -> cv2.typing.MatLike:
    """取得一個 3D 肩臀線條的圖片

    Args:
        result (PoseLandmarkerResult): 姿勢座標結果
        figsize (tuple[float, float], optional): 圖表大小. Defaults to (6.4, 4.8).
        view (tuple[float, float, float], optional): 圖表視角. Defaults to (90, 0, 0).
        range (tuple[list, list, list], optional): 圖表資料範圍. Defaults to ([1, -1], [1, -1], [2, 0]).

    Returns:
        cv2.typing.MatLike: 3D 肩臀線條的圖片
    """

    is3d = True  # 3D 姿勢

    # 設定分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    # 初始化
    fig = plt.figure(figsize=figsize)
    ax: Axes3D = fig.add_subplot(projection="3d")

    # 圖表設定
    ax.view_init(view[0], view[1], view[2])
    set_data_range(range[0], range[1], range[2], ax)
    ax.set_xlabel("x")
    ax.set_ylabel("z")
    ax.set_zlabel("y")
    
    # 如果可以取得世界座標資訊
    if len(pose_result.result.pose_world_landmarks) > 0:
        # 設定標題
        ax.set_title(
            f"label: {analyzer.get_lhc_label(is3d)}\n"
            + f"staggered angle: {analyzer.get_pose_shoulder_hip_staggered_angle(is3d):.2f}"
        )
        # 取得資料
        shoulder = np.array(
            [
                pose_result.get_kpt_pos_by_name("left_shoulder", is3d),
                pose_result.get_kpt_pos_by_name("right_shoulder", is3d),
            ]
        )
        hip = np.array(
            [
                pose_result.get_kpt_pos_by_name("left_hip", is3d),
                pose_result.get_kpt_pos_by_name("right_hip", is3d),
            ]
        )
        # 進行繪圖
        ax.plot(shoulder[:, 0], shoulder[:, 2], shoulder[:, 1], label="shoulder")
        ax.plot(hip[:, 0], hip[:, 2], hip[:, 1], label="hip")
        ax.legend()

    # 固定圖表內容
    canvas = FigureCanvasAgg(fig)
    canvas.draw()
    plt.close(fig)  # 關閉圖表

    # 轉換圖表為圖片
    rgba = np.asarray(canvas.buffer_rgba())
    rgb = cv2.cvtColor(rgba, cv2.COLOR_RGBA2RGB)

    return rgb


# ##### 在原始圖片上繪製資料

# In[7]:


def draw_result_in_image(img: cv2.typing.MatLike, result: PoseLandmarkerResult):
    IS_3D = True  # 使用 3D 姿勢

    # 建立分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    result_img = img.copy()
    if len(result.pose_landmarks) > 0:
        ### 繪製關鍵點
        result_img = draw_circles_by_landmarks(result_img, result.pose_landmarks)

        ### 繪製額外加分項目的測試
        # 軀幹是否扭轉
        if analyzer.check_if_trunk_is_twisted(IS_3D):
            cv2.circle(result_img, (30, 30), 20, (0, 0, 0), -1)
            cv2.circle(result_img, (30, 30), 18, (255, 255, 255), -1)
            cv2.putText(
                result_img, "A", (30, 30), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 0), 2
            )
        # 手是否遠離身體
        if analyzer.check_if_hands_at_a_distance(IS_3D):
            cv2.circle(result_img, (30, 80), 20, (0, 0, 0), -1)
            cv2.circle(result_img, (30, 80), 18, (255, 255, 255), -1)
            cv2.putText(
                result_img, "B", (30, 80), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 0), 2
            )
        # 手臂是否抬起，水平位置且位於肩膀和手肘間
        if analyzer.check_if_arms_raised(IS_3D):
            cv2.circle(result_img, (30, 130), 20, (0, 0, 0), -1)
            cv2.circle(result_img, (30, 130), 18, (255, 255, 255), -1)
            cv2.putText(
                result_img, "C", (30, 130), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 0), 2
            )
        # 手是否高過肩膀
        if analyzer.check_if_hands_above_shoulder(IS_3D):
            cv2.circle(result_img, (30, 180), 20, (0, 0, 0), -1)
            cv2.circle(result_img, (30, 180), 18, (255, 255, 255), -1)
            cv2.putText(
                result_img, "D", (30, 180), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 0), 2
            )

    return result_img


# ##### 取得分析結果

# In[8]:


def get_analyze_result_image(
    result: PoseLandmarkerResult, figsize: tuple[float, float] = (6.4, 4.8)
) -> cv2.typing.MatLike:
    """取得分析結果圖片
    包含 3D 姿勢圖表以及 3D 肩臀線條

    Args:
        result (PoseLandmarkerResult): 姿勢座標結果
        figsize (tuple[float, float], optional): 圖表大小. Defaults to (6.4, 4.8).

    Returns:
        cv2.typing.MatLike: 分析結果圖片
    """
    DATA_VIEW_RANGE = ([-1, 1], [-1, 1], [0, 2])  # 顯示資料區間
    AX0_VIEW_INIT = (30, -60, 0)  # 座標 0 初始視角
    AX1_VIEW_INIT = (90, 0, 0)  # 座標 1 初始視角

    IS_3D = True  # 使用 3D 姿勢

    # 建立分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    # 建立圖表和 3D 視圖
    fig = plt.figure(figsize=figsize)
    ax_0: Axes3D = fig.add_subplot(121, projection="3d")
    ax_1: Axes3D = fig.add_subplot(122, projection="3d")

    # 設定圖表資訊
    set_data_range(DATA_VIEW_RANGE[0], DATA_VIEW_RANGE[1], DATA_VIEW_RANGE[2], ax_0)
    ax_0.view_init(AX0_VIEW_INIT[0], AX0_VIEW_INIT[1], AX0_VIEW_INIT[2])
    ax_0.set_xlabel("x")
    ax_0.set_ylabel("z")
    ax_0.set_zlabel("y")
    set_data_range(DATA_VIEW_RANGE[0], DATA_VIEW_RANGE[1], DATA_VIEW_RANGE[2], ax_1)
    ax_1.view_init(AX1_VIEW_INIT[0], AX1_VIEW_INIT[1], AX1_VIEW_INIT[2])
    ax_1.set_xlabel("x")
    ax_1.set_ylabel("z")
    ax_1.set_zlabel("y")

    # 如果能抓到骨架
    if len(result.pose_world_landmarks) > 0:
        # 繪製座標 0
        ax_0.set_title(f"Pose Label: {analyzer.get_lhc_label(IS_3D)}")
        draw_bones_in_plot_by_pose_lanmark_result(result, ax=ax_0)
        ax_0.legend()

        # 繪製座標 1
        ax_1.set_title(
            f"Staggered Angle: {analyzer.get_pose_shoulder_hip_staggered_angle(IS_3D):.2f}"
        )
        # 取得肩膀臀部座標
        shoulder = np.array(
            [
                pose_result.get_kpt_pos_by_name("left_shoulder", IS_3D),
                pose_result.get_kpt_pos_by_name("right_shoulder", IS_3D),
            ]
        )
        hip = np.array(
            [
                pose_result.get_kpt_pos_by_name("left_hip", IS_3D),
                pose_result.get_kpt_pos_by_name("right_hip", IS_3D),
            ]
        )
        ax_1.plot(shoulder[:, 0], shoulder[:, 2], shoulder[:, 1], label="shoulder")
        ax_1.plot(hip[:, 0], hip[:, 2], hip[:, 1], label="hip")
        ax_1.legend()

    else:
        ax_0.set_title("NO DATA")
        ax_1.set_title("NO DATA")

    # 固定圖表內容
    canvas = FigureCanvasAgg(fig)
    canvas.draw()
    plt.close(fig)

    # 將圖表 buffer 轉換成 numpy 格式
    rgba = np.asarray(canvas.buffer_rgba())
    rgb = cv2.cvtColor(rgba, cv2.COLOR_RGBA2BGR)

    return rgb


# #### 主程式

# ##### 直播版

# In[9]:


cap = cv2.VideoCapture(STREAM_ID)

# 相機資訊
cam_width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
cam_heigh = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)

# 輸出圖表資訊
fig_width = int(cam_width * 0.7) / 100  # 寬度
fig_heigh = int(cam_heigh) / 100  # 長度

live = PoseLandmarkerLiveStream(MODEL)
while cap.isOpened():
    # 抓取影像
    ret, frame = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")

    # 偵測模型以及監聽其結果
    live.detect_async(frame, int(time.time() * 1000))
    mp_img = live.current_image
    result = live.result

    # 姿勢分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    if mp_img is None:  # 抓不到圖片
        continue

    # 轉換 mp 圖形為 numpy
    np_img = np.array(mp_img.numpy_view())

    # # 繪製影像中的關鍵點
    # img_2d = draw_circles_by_landmarks(
    #     np_img, result.pose_landmarks, 3, (0, 255, 0), -1
    # )

    # # 有扭轉的狀況下，左上角繪製綠紅點
    # if len(result.pose_world_landmarks) > 0:
    #     if analyzer.get_pose_shoulder_hip_staggered_angle(is_3d) > 15:
    #         cv2.circle(img_2d, (30, 30), 15, (0, 255, 0), -1)
    #         cv2.circle(img_2d, (30, 30), 10, (0, 0, 255), -1)
    #         pass

    # 取得圖表圖片
    img_2d = draw_result_in_image(np_img, result)
    img_analyze = get_analyze_result_image(result)

    # 組合圖片
    img_all = np.concatenate((img_2d, img_analyze), axis=1)

    cv2.imshow("result", img_all)

    # 按 Q 離開
    if cv2.waitKey(1) == ord("q"):
        break

# 關閉物件
live.close()
cap.release()
cv2.destroyAllWindows()


# ##### 影片版

# In[ ]:


# cap = cv2.VideoCapture(VIDEO)

# # 影片資訊
# cam_width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
# cam_heigh = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
# fps = int(cap.get(cv2.CAP_PROP_FPS))

# # 輸出圖表資訊
# fig_width = int(cam_width * 0.7) / 100  # 寬度
# fig_heigh = int(cam_heigh) / 100  # 長度

# # 建立模型
# options = PoseLandmarkerOptions(
#     base_options=BaseOptions(MODEL), running_mode=VisionTaskRunningMode.VIDEO
# )
# landmarker = PoseLandmarker.create_from_options(options)

# # 開啟相機
# while cap.isOpened():
#     # 抓取影像
#     ret, frame = cap.read()
#     if not ret:
#         print("Can't receive frame (stream end?). Exiting ...")

#     # 偵測模型以及監聽其結果
#     mp_img = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
#     result = landmarker.detect_for_video(mp_img, int(time.time() * 1000))

#     # 姿勢分析器
#     pose_result = PoseResult(result)
#     analyzer = ResultAnalyzer(pose_result)

#     # 繪製影像中的關鍵點
#     img_2d = draw_circles_by_landmarks(frame, result.pose_landmarks, 3, (0, 255, 0), -1)

#     # 有扭轉的狀況下，左上角繪製綠紅點
#     if len(result.pose_world_landmarks) > 0:
#         if analyzer.get_pose_shoulder_hip_staggered_angle(is_3d) > 15:
#             cv2.circle(img_2d, (30, 30), 15, (0, 255, 0), -1)
#             cv2.circle(img_2d, (30, 30), 10, (0, 0, 255), -1)
#             pass

#     # 取得圖表圖片
#     img_default = get_a_3d_pose_plot_image(
#         result=result,
#         figsize=(fig_width, fig_heigh),
#         view=default_view,
#         range=(range_x, range_y, range_z),
#         dot_size=5,
#         colors=(c_kpts, c_left, c_center, c_right),
#     )
#     img_shoulder_hip = get_shoulder_and_hip_plot_image(
#         result=result,
#         figsize=(fig_width, fig_heigh),
#         view=top_view,
#         range=(range_x, range_y, range_z),
#     )

#     # 組合圖片
#     img_all = np.concatenate((img_2d, img_default, img_shoulder_hip), axis=1)

#     cv2.imshow("result", img_all)

#     # 按 Q 離開
#     if cv2.waitKey(1) == ord("q"):
#         break

# # 關閉物件
# cap.release()
# cv2.destroyAllWindows()


# In[ ]:


# # 關閉物件
# cap.release()
# cv2.destroyAllWindows()
# # live.close()

