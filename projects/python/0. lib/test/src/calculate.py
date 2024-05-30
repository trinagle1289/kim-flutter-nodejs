#!/usr/bin/env python
# coding: utf-8

# #### 套件

# In[ ]:


from mediapipe.tasks.python.vision.pose_landmarker import PoseLandmarkerResult


# In[ ]:


if __name__ == "__main__":
    from mediapipe_lib.base import PoseResult, ResultAnalyzer
    from utils.positon_trans import translate_multi_kpt_to_plot_pos
else:
    from src.mediapipe_lib.base import PoseResult, ResultAnalyzer
    from src.utils.positon_trans import translate_multi_kpt_to_plot_pos


# #### 函式

# ##### 將姿勢座標結果轉換成表格座標

# In[ ]:


def line_3d_result_to_plot_pos(
    result: PoseLandmarkerResult,
) -> list[list, list, list, list]:
    """將 3D 姿勢座標的線條結果轉換成表格座標

    Args:
        poselandmarker_result (PoseLandmarkerResult): 姿勢座標結果

    Returns:
        list[list, list, list, list]: [關鍵點, 左邊線條, 中間線條, 右邊線條]
    """

    is_3d = True  # 確定使用 3D 姿勢座標

    # 建立分析器
    pose_result = PoseResult(result)
    analyzer = ResultAnalyzer(pose_result)

    # 取得關鍵點和線條資料
    kpts = pose_result.get_all_kpt_positions(is_3d)
    left, center, right = analyzer.get_line_positions(get_3d=is_3d)

    # 轉換關鍵點和線條資料
    kpts, left, center, right = translate_multi_kpt_to_plot_pos(
        kpts, kpts, left, center, right
    )

    return [kpts, left, center, right]


# ##### 取得在 bool 陣列中的 True 比率

# In[ ]:


def get_true_rate_in_bool_list(bool_lst: list[bool]) -> float:
    """取得在 bool 陣列中的 True 比率

    Args:
        bool_lst (list[bool]): bool 陣列

    Returns:
        float: 在 bool 陣列中的 True 比率
    """
    return bool_lst.count(True) / len(bool_lst)

