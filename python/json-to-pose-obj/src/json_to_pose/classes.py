#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np


# In[ ]:


class LineConnections:
    """線條連接點"""

    left_kpt: list[list[str]] = []  # 左邊關鍵點連接列表
    right_kpt: list[list[str]] = []  # 右邊關鍵點連接列表
    center_kpt: list[list[str]] = []  # 中間關鍵點連接列表
    full_kpt: list[list[str]] = []  # 全關鍵點連接列表

    def __init__(
        self, left: list[list[str]], right: list[list[str]], center: list[list[str]]
    ) -> None:
        """初始化物件
        Args:
            left (list[list[str]]): 左邊連接列表
            right (list[list[str]]): 右邊連接列表
            center (list[list[str]]): 中間連接列表
        """
        self.left_kpt = left
        self.right_kpt = right
        self.center_kpt = center
        lr_kpt = np.append(left, right, axis=0)
        full_kpt = np.append(lr_kpt, center, axis=0)
        self.full_kpt = full_kpt.tolist()

