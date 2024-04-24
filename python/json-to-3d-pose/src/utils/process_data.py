#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import numpy as np


# In[ ]:


def scaleYAxis(data: list, val: float) -> list:
    """縮放 Y 軸座標(只作用於二三維陣列)

    Args:
        data (list): 被縮放的目標
        val (float): 縮放數值

    Returns:
        list: 縮放結果
    """

    np_data = np.array(data)
    layer_size = len(np_data.shape)

    if layer_size == 2:  # 二維陣列
        np_data[:, 1] *= val
    elif layer_size == 3:  # 三維陣列
        np_data[:, :, 1] *= val

    return np_data.tolist()


# In[ ]:


def transYAxis(data: list, val: float) -> list:
    """平移 Y 軸座標(只作用於二三維陣列)

    Args:
        data (list): 被平移的目標
        val (float): 平移數值

    Returns:
        list: 平移結果
    """

    np_data = np.array(data)
    layer_size = len(np_data.shape)

    if layer_size == 2:  # 二維陣列
        np_data[:, 1] += val
    elif layer_size == 3:  # 三維陣列
        np_data[:, :, 1] += val

    return np_data.tolist()

