#!/usr/bin/env python
# coding: utf-8

# In[2]:


import json


# In[3]:


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

