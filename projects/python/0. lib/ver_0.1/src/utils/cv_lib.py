#!/usr/bin/env python
# coding: utf-8

# #### 套件

# In[1]:


import cv2
import numpy as np


# #### 函式

# ##### 繪製字母徽章

# In[11]:


def draw_letter_badge(
    img: cv2.typing.MatLike,
    letter: str = "A",
    position: cv2.typing.Point = (30, 30),
    graphic_color: cv2.typing.Scalar = (255, 255, 255),
    outline_color: cv2.typing.Scalar = (0, 0, 0),
) -> cv2.typing.MatLike:
    """繪製字母徽章

    Args:
        img (cv2.typing.MatLike): 輸入影像
        letter (str, optional): 單個字母. Defaults to "A".
        position (cv2.typing.Point, optional): 圓圈中心座標. Defaults to (30, 30).
        graphic_color (cv2.typing.Scalar, optional): 圖案顏色. Defaults to (255, 255, 255).
        outline_color (cv2.typing.Scalar, optional): 輪廓顏色. Defaults to (0, 0, 0).

    Returns:
        cv2.typing.MatLike: 繪製過後的影像
    """
    result = img.copy()

    # 繪製倫繪製倫
    cv2.circle(result, position, 20, outline_color, -1)
    cv2.circle(result, position, 18, graphic_color, -1)
    cv2.putText(
        img=result,
        text=letter[0],
        org=np.array(position) + [-10, 10],
        fontFace=cv2.FONT_HERSHEY_DUPLEX,
        fontScale=1,
        color=(0, 0, 0),
        thickness=2,
    )

    return result

