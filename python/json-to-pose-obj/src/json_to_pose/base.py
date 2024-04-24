#!/usr/bin/env python
# coding: utf-8

# In[1]:


import json
import numpy as np
import math

if __name__ == "__main__":
    from values import joint_dict, LineConnections, blazepose_lines
else:
    from src.json_to_pose.values import joint_dict, LineConnections, blazepose_lines


# # 函式

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


# # 類別

# In[2]:


class Pose:
    """Json 檔案轉換成儲存姿勢資訊的基底類別"""

    json_data: list = []  # JSON 資料
    kpt_name_lst: list = []  # 關鍵點名稱列表

    ### 預設函式

    def __init__(self, json_file_path: str = "", json_data: list = []) -> None:
        """將 json 檔案資料載入到此物件中

        Args:
            json_file_path (str): Json 檔案路徑
        """
        if json_file_path != "":
            with open(json_file_path) as f:
                self.json_data = json.load(f)
        elif json_data != []:
            self.json_data = json_data
        else:
            return ValueError("沒有在參數中設定 Json 資料來源")
        # 取得 json_data 中所有關鍵點的名稱
        for img in self.json_data:
            if len(img) > 0:  # 如果姿勢數量大於 0
                for kpt in img[0]["keypoints"]:
                    self.kpt_name_lst.append(kpt["name"])
                break
        pass

    def __len__(self) -> int:
        """取得圖片數量

        Returns:
            int: 圖片數量
        """
        return len(self.json_data)

    def __str__(self) -> str:
        """取得 JSON 字串

        Returns:
            str: JSON 字串
        """
        return json.dumps(self.json_data)

    ### 基礎函式

    def get_image_count(self) -> int:
        """取得圖片數量

        Returns:
            int: 圖片數量
        """
        return len(self.json_data)

    def get_pose_count(self, idx_img: int) -> int:
        """取得姿勢數量

        Args:
            idx_img (int): 圖片索引值

        Returns:
            int: 姿勢數量
        """
        return len(self.json_data[idx_img])

    def get_pose_score(self, idx_img: int, idx_pose: int) -> int:
        """取得姿勢置性度

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值

        Returns:
            int: 姿勢置性度分數
        """
        return self.json_data[idx_img][idx_pose]["score"]

    def get_pose_kpts(
        self, idx_img: int, idx_pose: int, get_3d: bool = False
    ) -> list[dict]:
        """取得姿勢關鍵點

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            get_3d (bool, optional): 是否需要取得關鍵點 3D. Defaults to False.

        Returns:
            list[dict]: 姿勢關鍵點
        """
        if not get_3d:
            kpt = self.json_data[idx_img][idx_pose]["keypoints"]
        else:
            kpt = self.json_data[idx_img][idx_pose]["keypoints3D"]
        return kpt

    def get_kpt_pos_by_index(
        self, idx_img: int, idx_pose: int, idx_kpt: int, get_3d: bool = False
    ) -> list[float, float] | list[float, float, float]:
        """使用關鍵點索引值來取得關鍵點座標

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            idx_kpt (int): 關鍵點索引值
            get_3d (bool, optional): 是否需要取得關鍵點 3D. Defaults to False.

        Returns:
            list[float, float] | list[float, float, float]: 關鍵點座標
        """
        position = None

        # 取得關鍵點座標
        if not get_3d:
            kpt = self.json_data[idx_img][idx_pose]["keypoints"]
            position = [kpt[idx_kpt]["x"], kpt[idx_kpt]["y"]]
        else:
            kpt = self.json_data[idx_img][idx_pose]["keypoints3D"]
            position = [kpt[idx_kpt]["x"], kpt[idx_kpt]["y"], kpt[idx_kpt]["z"]]

        return position

    def get_kpt_pos_by_name(
        self, idx_img: int, idx_pose: int, kpt_name: str, get_3d: bool = False
    ) -> list[float, float] | list[float, float, float]:
        """使用關鍵點名稱來取得關鍵點座標

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            kpt_name (str): 關鍵點名稱
            get_3d (bool, optional): 是否需要取得關鍵點 3D. Defaults to False.

        Returns:
            list[float, float] | list[float, float, float]: 關鍵點座標
        """
        position = None

        # 取得關鍵點名稱的索引值
        if self.kpt_name_lst.count(kpt_name) > 0:
            idx = self.kpt_name_lst.index(kpt_name)
        else:
            return None

        # 取得關鍵點座標
        if not get_3d:
            kpt = self.json_data[idx_img][idx_pose]["keypoints"]
            position = [kpt[idx]["x"], kpt[idx]["y"]]
        else:
            kpt = self.json_data[idx_img][idx_pose]["keypoints3D"]
            position = [kpt[idx]["x"], kpt[idx]["y"], kpt[idx]["z"]]

        return position

    def get_pose_kpt_positions(
        self, idx_img: int, idx_pose: int, get_3d: bool = False
    ) -> list[float, float, float] | list[float, float]:
        """取得圖片中姿勢的所有關鍵點座標

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list: 關鍵點座標列表
        """
        positions = []

        key_value = "keypoints" if not get_3d else "keypoints3D"
        for kpt in self.json_data[idx_img][idx_pose][key_value]:
            if not get_3d:
                positions.append([kpt["x"], kpt["y"]])
            else:
                positions.append([kpt["x"], kpt["y"], kpt["z"]])
        return positions

    # 將資料整理成列表

    def get_all_pose_kpt_positions(
        self, get_3d: bool = False
    ) -> list[list[float, float, float]] | list[list[float, float]]:
        """取得所有圖片中姿勢的關鍵點座標

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[list[float, float, float]] | list[list[float, float]]: 取得所有圖片中姿勢的關鍵點座標
        """
        pose_kpt_positions = []

        for i in range(self.get_image_count()):
            if self.get_pose_count(i) > 0:
                pose_kpt_positions.append(self.get_pose_kpt_positions(i, 0, get_3d))
            else:
                pose_kpt_positions.append([])
        return pose_kpt_positions


# In[5]:


class PoseAnalyzer:
    pose: Pose = None  # 被分析的姿勢

    def __init__(self, pose: Pose) -> None:
        self.pose = pose

    # 基礎函式

    def get_joint_angle(
        self,
        idx_img: int,
        idx_pose: int,
        center_joint: str,
        get_3d: bool = False,
    ) -> float:
        """取得關節角度

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            center_joint (str): 中心關節點
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            float: 關節角度
        """
        # 取得關節連接關鍵點名稱
        j1, j2 = joint_dict[center_joint]

        # 取得三個關鍵點座標
        pos1 = self.pose.get_kpt_pos_by_name(idx_img, idx_pose, j1, get_3d)
        pos2 = self.pose.get_kpt_pos_by_name(idx_img, idx_pose, j2, get_3d)
        center_pos = self.pose.get_kpt_pos_by_name(
            idx_img, idx_pose, center_joint, get_3d
        )

        return get_angle_by_3_points(pos1, pos2, center_pos)

    # 複合函式(有使用其他函式)

    def get_pose_joint_angles(
        self, idx_img: int, idx_pose: int, get_3d: bool = False
    ) -> dict:
        """取得姿勢的所有關節角度

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            dict: 全部關節角度
        """
        joint_angles = {}
        for center_joint in joint_dict.keys():
            angle = self.get_joint_angle(idx_img, idx_pose, center_joint, get_3d)
            joint_angles.update({center_joint: angle})
        return joint_angles

    def get_pose_lhc_label(
        self, idx_img: int, idx_pose: int, get_3d: bool = False
    ) -> str:
        """取得 LHC 身體姿勢標籤

        標籤描述:
        A1: 站立
        A2: 搬運高處物品
        A3: 微彎腰
        A4: 彎腰
        A5: 蹲姿、跪姿、跪坐姿勢

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            str: LHC 姿勢標籤

        """
        joint_angles = self.get_pose_joint_angles(idx_img, idx_pose, get_3d)
        return angles_to_lhc_label(joint_angles)

    def get_pose_line_postions(
        self,
        idx_img: int,
        idx_pose: int,
        line_type: LineConnections = blazepose_lines,
        get_3d: bool = False,
    ) -> list[list, list, list]:
        """取得組合線條的多組兩點座標

        Args:
            idx_img (int): 圖片索引值
            idx_pose (int): 姿勢索引值
            line_type (LineConnections, optional): 線條連接. Defaults to blazepose_lines.
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[list, list, list]: 列表(存放左、中、右邊線條)
        """

        # 線條列表
        left, center, right = [], [], []

        for pt1, pt2 in line_type.left_kpt:
            pos = [
                self.pose.get_kpt_pos_by_name(idx_img, idx_pose, pt1, get_3d),
                self.pose.get_kpt_pos_by_name(idx_img, idx_pose, pt2, get_3d),
            ]
            left.append(pos)

        for pt1, pt2 in line_type.center_kpt:
            pos = [
                self.pose.get_kpt_pos_by_name(idx_img, idx_pose, pt1, get_3d),
                self.pose.get_kpt_pos_by_name(idx_img, idx_pose, pt2, get_3d),
            ]
            center.append(pos)

        for pt1, pt2 in line_type.right_kpt:
            pos = [
                self.pose.get_kpt_pos_by_name(idx_img, idx_pose, pt1, get_3d),
                self.pose.get_kpt_pos_by_name(idx_img, idx_pose, pt2, get_3d),
            ]
            right.append(pos)

        return [left, center, right]

    # 將資料整理成列表

    def get_all_joint_angles(self, get_3d: bool = False) -> list[dict]:
        """取得關節角度列表

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[dict]: 關節角度列表
        """
        angles = []

        for i in range(self.pose.get_image_count()):
            if self.pose.get_pose_count(i) > 0:
                angles.append(self.get_pose_joint_angles(i, 0, get_3d))
            else:
                angles.append([])

        return angles

    def get_all_lhc_labels(self, get_3d: bool = False) -> list[str]:
        """取得 LHC 身體姿勢標籤列表

        Args:
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[str]: LHC 姿勢標籤列表
        """
        labels = []
        for i in range(self.pose.get_image_count()):
            if self.pose.get_pose_count(i) > 0:
                labels.append(self.get_pose_lhc_label(i, 0, get_3d))
            else:
                labels.append("")

        return labels

    def get_all_line_positions(
        self, line_type: LineConnections = blazepose_lines, get_3d: bool = False
    ) -> list[list[list, list, list]]:
        """取得全部的線條所需座標點列表

        Args:
            line_type (LineConnections, optional): 線條種類. Defaults to blazepose_lines.
            get_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

        Returns:
            list[list[list, list, list]]: 全部的線條所需座標點列表
        """
        line_positions = []
        for i in range(self.pose.get_image_count()):
            if self.pose.get_pose_count(i) > 0:
                line_positions.append(
                    self.get_pose_line_postions(i, 0, line_type, get_3d)
                )
            else:
                line_positions.append([])

        return line_positions

