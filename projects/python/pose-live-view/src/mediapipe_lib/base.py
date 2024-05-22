#!/usr/bin/env python
# coding: utf-8

# #### 套件

# In[ ]:


from enum import Enum
import numpy as np
import cv2

# 使用 MediaPipe 套件
import mediapipe as mp
from mediapipe.tasks.python.core.base_options import BaseOptions
from mediapipe.tasks.python.vision.core.vision_task_running_mode import (
    VisionTaskRunningMode,
)
from mediapipe.tasks.python.vision.pose_landmarker import (
    PoseLandmarker,
    PoseLandmarkerOptions,
    PoseLandmarkerResult,
)
from mediapipe.tasks.python.components.containers.landmark import (
    Landmark,
    NormalizedLandmark,
)

# 使用到子函式庫
if __name__ == "__main__":
    from calculator import (
        angles_to_lhc_label,
        get_angle_between_two_lines_position,
        get_angle_by_3_points,
    )
    from value import (
        KPT_IDX_DICT,
        KPT_LIST,
        JOINT_NAME_DICT,
        JOINT_IDX_DICT,
        LineConnections,
        blazepose_line,
    )
else:
    from src.mediapipe_lib.calculator import (
        angles_to_lhc_label,
        get_angle_between_two_lines_position,
        get_angle_by_3_points,
    )
    from src.mediapipe_lib.value import (
        KPT_IDX_DICT,
        KPT_LIST,
        JOINT_NAME_DICT,
        JOINT_IDX_DICT,
        LineConnections,
        blazepose_line,
    )


# #### 類別

# ##### 姿勢地標直播類別

# In[ ]:


class PoseLandmarkerLiveStream:
    """姿勢地標直播類別"""

    landmarker: PoseLandmarker = None  # 姿勢地標模型
    "姿勢地標模型"
    result = PoseLandmarkerResult([], [])  # 姿勢地標結果(實時更新)
    "姿勢地標結果(實時更新)"
    current_image: mp.Image = None
    "影像畫面(實時更新)"
    current_timestamp_ms: int = -1
    "時間戳(實時更新)"

    def __init__(self, model_path: str):
        """初始化姿勢模型物件

        Args:
            model_path (str): 模型路徑
        """

        def update_result(
            result: PoseLandmarkerResult,
            output_image: mp.Image,
            timestamp_ms: int,
        ) -> None:
            """更新偵測結果

            Args:
                result (PoseLandmarkerResult): 偵測結果
                output_image (mp.Image): 輸出圖片
                timestamp_ms (int): 時間戳
            """
            self.result = result
            self.current_image = output_image
            self.current_timestamp_ms = timestamp_ms

        options = PoseLandmarkerOptions(
            base_options=BaseOptions(model_asset_path=model_path),
            running_mode=VisionTaskRunningMode.LIVE_STREAM,
            result_callback=update_result,
        )
        self.landmarker = PoseLandmarker.create_from_options(options)

    def detect_async(self, frame: cv2.typing.MatLike, timestamp_ms: int):
        """實時偵測

        Args:
            frame (cv2.typing.MatLike): 影像幀
            timestamp_ms (int): 時間戳
        """
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
        self.landmarker.detect_async(mp_image, timestamp_ms)

    def close(self):
        """關閉模型"""
        self.landmarker.close()


# ##### MediaPipe 姿勢物件結果

# In[ ]:


class PoseResult:
    """MediaPipe 姿勢物件結果"""

    result = PoseLandmarkerResult([], [])

    def __init__(self, result: PoseLandmarkerResult):
        self.result = result

    # 基礎函式

    def get_kpt_pos_by_index(
        self, idx: int, get_3d: bool = False
    ) -> list[float, float] | list[float, float, float]:
        """使用關鍵點索引值來取得關鍵點座標

        Args:
            idx (int): 索引值
            get_3d (bool, optional): 是否需要取得 3D 關鍵點. Defaults to False.

        Returns:
            list[float, float] | list[float, float, float]: 關鍵點座標
        """
        position = None
        # 取得座標
        if not get_3d:
            kpt: Landmark = self.result.pose_landmarks[0][idx]
            position = [kpt.x, kpt.y]
        else:
            kpt: NormalizedLandmark = self.result.pose_world_landmarks[0][idx]
            position = [kpt.x, kpt.y, kpt.z]

        return position

    def get_kpt_pos_by_name(
        self, kpt_name: str, get_3d: bool = False
    ) -> list[float, float] | list[float, float, float]:
        """使用關鍵點名稱來取得關鍵點座標

        Args:
            kpt_name (str): 關鍵點名稱
            get_3d (bool, optional): 是否需要取得 3D 關鍵點. Defaults to False.

        Returns:
            list[float, float] | list[float, float, float]: 關鍵點座標
        """
        position = None

        # 取得索引值
        if KPT_LIST.count(kpt_name) > 0:
            idx = KPT_LIST.index(kpt_name)
        else:
            return None

        # 取得座標
        if not get_3d:
            kpt: Landmark = self.result.pose_landmarks[0][idx]
            position = [kpt.x, kpt.y]
        else:
            kpt: NormalizedLandmark = self.result.pose_world_landmarks[0][idx]
            position = [kpt.x, kpt.y, kpt.z]

        return position

    # 資料列表函式

    def get_all_kpt_positions(self, get_3d: bool = False) -> list[list[float, float]]:
        """取得全部關鍵點

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[list[float, float]]: 全部關鍵點列表
        """
        positions = []

        if not get_3d:
            for kpt in self.result.pose_landmarks[0]:
                kpt: Landmark
                positions.append([kpt.x, kpt.y])
        else:
            for kpt in self.result.pose_world_landmarks[0]:
                kpt: NormalizedLandmark
                positions.append([kpt.x, kpt.y, kpt.z])

        return positions


# ##### 姿勢結果分析器

# In[ ]:


class ResultAnalyzer:
    """姿勢結果分析器"""

    pose_result: PoseResult

    def __init__(self, pose_result: PoseResult):
        self.pose_result = pose_result

    # 基礎函式

    def get_joint_angle_by_name(
        self, center_joint_name: str, get_3d: bool = False
    ) -> float:
        """使用名稱取得關節角度

        Args:
            center_joint_name (str): 關節名稱
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            float: 關節角度
        """
        # 取得關節連接關鍵點名稱
        j1, j2 = JOINT_NAME_DICT[center_joint_name]

        pos1 = self.pose_result.get_kpt_pos_by_name(j1, get_3d)
        pos2 = self.pose_result.get_kpt_pos_by_name(j2, get_3d)
        center_pos = self.pose_result.get_kpt_pos_by_name(center_joint_name, get_3d)

        return get_angle_by_3_points(pos1, pos2, center_pos)

    def get_joint_angle_by_index(
        self, center_joint_idx: int, get_3d: bool = False
    ) -> float:
        """使用索引值取得關節角度

        Args:
            center_joint_idx (int): 關節索引值
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            float: 關節角度
        """
        # 取得關節連接關鍵點索引值
        j1, j2 = JOINT_IDX_DICT[center_joint_idx]

        pos1 = self.pose_result.get_kpt_pos_by_index(j1, get_3d)
        pos2 = self.pose_result.get_kpt_pos_by_index(j2, get_3d)
        center_pos = self.pose_result.get_kpt_pos_by_index(center_joint_idx, get_3d)

        return get_angle_by_3_points(pos1, pos2, center_pos)

    def get_pose_shoulder_hip_staggered_angle(self, get_3d: bool = False) -> float:
        """取得身體姿勢的肩臀交錯角度

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            float: 肩臀交錯角度
        """
        shoulder = [
            self.pose_result.get_kpt_pos_by_name("left_shoulder", get_3d),
            self.pose_result.get_kpt_pos_by_name("right_shoulder", get_3d),
        ]
        hip = [
            self.pose_result.get_kpt_pos_by_name("left_hip", get_3d),
            self.pose_result.get_kpt_pos_by_name("right_hip", get_3d),
        ]

        return get_angle_between_two_lines_position(shoulder, hip)

    def get_pose_shoulder_hip_staggered_angle_xz(self) -> float:
        """取得身體姿勢的肩臀交錯角度(xz軸)

        Returns:
            float: 肩臀交錯角度
        """
        shoulder = [
            self.pose_result.get_kpt_pos_by_name("left_shoulder", True)[0::2],
            self.pose_result.get_kpt_pos_by_name("right_shoulder", True)[0::2],
        ]
        hip = [
            self.pose_result.get_kpt_pos_by_name("left_hip", True)[0::2],
            self.pose_result.get_kpt_pos_by_name("right_hip", True)[0::2],
        ]

        return get_angle_between_two_lines_position(shoulder, hip)

    # 複合函式(有使用到基礎函式)

    def get_all_joint_angles_by_name(self, get_3d: bool = False) -> dict:
        """使用名稱取得姿勢的所有關節角度

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            dict: 所有關節角度字典
        """
        all_angles = {}
        for center in JOINT_NAME_DICT.keys():
            angle = self.get_joint_angle_by_name(center, get_3d)
            all_angles.update({center: angle})
        return all_angles

    def get_all_joint_angles_by_index(self, get_3d: bool = False) -> dict:
        """使用索引值取得姿勢的所有關節角度

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            dict: 所有關節角度字典
        """
        all_angles = {}
        for center in JOINT_IDX_DICT.keys():
            angle = self.get_joint_angle_by_index(center, get_3d)
            all_angles.update({center: angle})
        return all_angles

    def get_lhc_label(self, get_3d: bool = False) -> str:
        """取得 LHC 身體姿勢標籤

        標籤描述:
        A1: 站立
        A2: 搬運高處物品
        A3: 微彎腰
        A4: 彎腰
        A5: 蹲姿、跪姿、跪坐姿勢

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            str: LHC 身體姿勢標籤
        """
        angle_name_dict = self.get_all_joint_angles_by_name(get_3d)
        return angles_to_lhc_label(angle_name_dict)

    def get_line_positions(
        self, line_type: LineConnections = blazepose_line, get_3d: bool = False
    ) -> list[list, list, list]:
        """取得組合線條的多組兩點座標

        Args:
            line_type (LineConnections, optional): 線條連接種類. Defaults to blazepose_line.
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[list, list, list]: 線條座標列表(分別存放左、中、右邊的線條座標資訊)
        """
        # 線條列表
        left, center, right = [], [], []

        for pt1, pt2 in line_type.left_kpt:
            pos = [
                self.pose_result.get_kpt_pos_by_name(pt1, get_3d),
                self.pose_result.get_kpt_pos_by_name(pt2, get_3d),
            ]
            left.append(pos)

        for pt1, pt2 in line_type.center_kpt:
            pos = [
                self.pose_result.get_kpt_pos_by_name(pt1, get_3d),
                self.pose_result.get_kpt_pos_by_name(pt2, get_3d),
            ]
            center.append(pos)

        for pt1, pt2 in line_type.right_kpt:
            pos = [
                self.pose_result.get_kpt_pos_by_name(pt1, get_3d),
                self.pose_result.get_kpt_pos_by_name(pt2, get_3d),
            ]
            right.append(pos)

        return [left, center, right]

    # 身體姿勢額外加分項目的判斷

    def check_if_trunk_is_twisted(self, get_3d: bool = False) -> bool:
        """檢查軀幹是否扭轉/側傾

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            bool: 軀幹是否扭轉/側傾
        """
        TWISTED_ANGLE = 15
        return self.get_pose_shoulder_hip_staggered_angle(get_3d) > TWISTED_ANGLE

    def check_if_hands_at_a_distance(self, get_3d: bool = False) -> bool:
        """檢查手或重心是否遠離身體

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            bool: 手或重心是否遠離身體
        """
        # 左肩膀的位置
        left_shoulder = self.pose_result.get_kpt_pos_by_name("left_shoulder", get_3d)
        # 左手肘的位置
        left_elbow = self.pose_result.get_kpt_pos_by_name("left_elbow", get_3d)
        # 左手腕的位置
        left_wrist = self.pose_result.get_kpt_pos_by_name("left_wrist", get_3d)

        # 右肩膀的位置
        right_shoulder = self.pose_result.get_kpt_pos_by_name("right_shoulder", get_3d)
        # 右手肘的位置
        right_elbow = self.pose_result.get_kpt_pos_by_name("right_elbow", get_3d)
        # 右手腕的位置
        right_wrist = self.pose_result.get_kpt_pos_by_name("right_wrist", get_3d)

        result = False
        return NotImplementedError

    def check_if_arms_raised(self, get_3d: bool = False) -> bool:
        """檢查手臂是否需抬舉，手的水平位於手肘與肩膀之間

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            bool: 手臂是否需抬舉，手的水平位於手肘與肩膀之間
        """
        RAISED_ANGLE = 30  # 判斷抬舉的角度

        result = False  # 判斷結果

        # 左肩膀角度
        left_shoulder_angle = self.get_joint_angle_by_name("left_shoulder", get_3d)
        # 右肩膀角度
        right_shoulder_angle = self.get_joint_angle_by_name("right_shoulder", get_3d)

        # 左肩膀的 y 軸位置
        left_shoulder_y = (
            self.pose_result.get_kpt_pos_by_name("left_shoulder", get_3d)[1] * -1
        )
        # 左手肘的 y 軸位置
        left_elbow_y = (
            self.pose_result.get_kpt_pos_by_name("left_elbow", get_3d)[1] * -1
        )
        # 左手腕的 y 軸位置
        left_wrist_y = (
            self.pose_result.get_kpt_pos_by_name("left_wrist", get_3d)[1] * -1
        )
        left_result = False  # 表示左側是否達標

        # 右肩膀的 y 軸位置
        right_shoulder_y = (
            self.pose_result.get_kpt_pos_by_name("right_shoulder", get_3d)[1] * -1
        )
        # 右手肘的 y 軸位置
        right_elbow_y = (
            self.pose_result.get_kpt_pos_by_name("right_elbow", get_3d)[1] * -1
        )
        # 右手腕的 y 軸位置
        right_wrist_y = (
            self.pose_result.get_kpt_pos_by_name("right_wrist", get_3d)[1] * -1
        )
        right_result = False  # 表示左側是否達標

        ### 在 y 軸中，當手在手肘和肩膀之間時，肩膀到手肘的長度 會大於 手肘到手腕的長度

        # 判斷左手抬舉行為，再判斷手的水平是否位於手肘和肩膀中間
        if left_shoulder_angle > RAISED_ANGLE:
            if abs(left_shoulder_y - left_elbow_y) > abs(left_elbow_y - left_wrist_y):
                left_result = True

        # 判斷右手抬舉行為，再判斷手的水平是否位於手肘和肩膀中間
        if right_shoulder_angle > RAISED_ANGLE:
            if abs(right_shoulder_y - right_elbow_y) > abs(
                right_elbow_y - right_wrist_y
            ):
                right_result = True

        # 只要出現其中一種狀況，就表示為真
        result = left_result or right_result

        return result

    def check_if_hands_above_shoulder(self, get_3d: bool = False) -> bool:
        """檢查手是否會高過肩膀

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            bool: 手是否會高過肩膀
        """
        # 左手腕的 y 軸位置
        left_wrist_y = (
            self.pose_result.get_kpt_pos_by_name("left_wrist", get_3d)[1] * -1
        )
        # 左肩膀的 y 軸位置
        left_shoulder_y = (
            self.pose_result.get_kpt_pos_by_name("left_shoulder", get_3d)[1] * -1
        )

        # 右手腕的 y 軸位置
        right_wrist_y = (
            self.pose_result.get_kpt_pos_by_name("right_wrist", get_3d)[1] * -1
        )
        # 右肩膀的 y 軸位置
        right_shoulder_y = (
            self.pose_result.get_kpt_pos_by_name("right_shoulder", get_3d)[1] * -1
        )

        # 只要出現其中一種狀況(左手腕比左肩膀高 或 右手腕比右肩膀高)，就表示為真
        result = left_wrist_y > left_shoulder_y or right_wrist_y > right_shoulder_y

        return result

    pass


# ##### LHC 額外加分分析

# In[ ]:


class Frequency(Enum):
    """頻率枚舉"""

    RARELY = 0
    """幾乎沒有"""
    OCCASIONALLY = 1
    """偶爾"""
    FREQUENTLY_OR_CONSTANTLY = 2
    """通常"""


# In[ ]:


class LhcPoseListAnalyzer:
    """LHC 身體姿勢列表分析器"""

    result_analyzer_list: list[ResultAnalyzer] = []
    """姿勢分析結果列表"""

    def __init__(self, result_analyzer_list: list[ResultAnalyzer] = None):
        self.result_analyzer_list = result_analyzer_list

    # LHC 姿勢評級項目

    def get_lhc_label_list(self, get_3d: bool = False) -> list[str]:
        return [i.get_lhc_label(get_3d) for i in self.result_analyzer_list]

    def get_lhc_body_posture_rating(self, parameter_list):
        pass

    def get_start_and_finish_poses(self, parameter_list) -> list[str, str]:
        pass

    # 身體姿勢額外加分項目

    def get_frequency_of_trunk_is_twisted(self, get_3d: bool = False) -> Frequency:
        # 取得檢查名單
        check_list = [
            result_analyzer.check_if_trunk_is_twisted(get_3d)
            for result_analyzer in self.result_analyzer_list
        ]

        # 有做這件事情的達標率
        rate = check_list.count(True) / len(check_list)

        if rate > 1 / 3:
            frequency = Frequency.FREQUENTLY_OR_CONSTANTLY
        elif rate > 1 / 9:
            frequency = Frequency.OCCASIONALLY
        else:
            frequency = Frequency.RARELY

        return frequency

    def get_frequency_of_hands_at_a_distance(self, get_3d: bool = False) -> Frequency:
        # 取得檢查名單
        check_list = [
            result_analyzer.check_if_hands_at_a_distance(get_3d)
            for result_analyzer in self.result_analyzer_list
        ]

        # 有做這件事情的達標率
        rate = check_list.count(True) / len(check_list)

        if rate > 1 / 3:
            frequency = Frequency.FREQUENTLY_OR_CONSTANTLY
        elif rate > 1 / 9:
            frequency = Frequency.OCCASIONALLY
        else:
            frequency = Frequency.RARELY

        return frequency

    def get_frequency_of_arms_raised(self, get_3d: bool = False) -> Frequency:
        # 取得檢查名單
        check_list = [
            result_analyzer.check_if_arms_raised(get_3d)
            for result_analyzer in self.result_analyzer_list
        ]

        # 有做這件事情的達標率
        rate = check_list.count(True) / len(check_list)

        if rate > 1 / 3:
            frequency = Frequency.FREQUENTLY_OR_CONSTANTLY
        elif rate > 1 / 9:
            frequency = Frequency.OCCASIONALLY
        else:
            frequency = Frequency.RARELY

        return frequency

    def get_frequency_of_hands_above_shoulder(self, get_3d: bool = False) -> Frequency:
        # 取得檢查名單
        check_list = [
            result_analyzer.check_if_hands_above_shoulder(get_3d)
            for result_analyzer in self.result_analyzer_list
        ]

        # 有做這件事情的達標率
        rate = check_list.count(True) / len(check_list)

        if rate > 1 / 3:
            frequency = Frequency.FREQUENTLY_OR_CONSTANTLY
        elif rate > 1 / 9:
            frequency = Frequency.OCCASIONALLY
        else:
            frequency = Frequency.RARELY

        return frequency

    pass

