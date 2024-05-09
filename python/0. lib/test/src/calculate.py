#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from mediapipe.tasks.python.vision.pose_landmarker import PoseLandmarkerResult

if __name__ == "__main__":
    from mediapipe_lib.base import PoseResult, ResultAnalyzer
    from utils.process_data import translate_multi_kpt_to_plot_pos
else:
    from src.mediapipe_lib.base import PoseResult, ResultAnalyzer
    from src.utils.process_data import translate_multi_kpt_to_plot_pos


# 將姿勢座標結果轉換成表格座標

# In[ ]:


def poselandmarker_result_to_plot_pos(
    poselandmarker_result: PoseLandmarkerResult,
    is_3d: bool = False,
) -> list[list, list, list, list]:
    """將姿勢座標結果轉換成表格座標

    Args:
        poselandmarker_result (PoseLandmarkerResult): 姿勢座標結果
        is_3d (bool, optional): 是否為 3D 姿勢. Defaults to False.

    Returns:
        list[list, list, list, list]: [關鍵點, 左邊線條, 中間線條, 右邊線條]
    """
    # 建立分析器
    result = PoseResult(poselandmarker_result)
    analyzer = ResultAnalyzer(result)

    # 取得關鍵點和線條資料
    kpts = result.get_all_kpt_positions(is_3d)
    left, center, right = analyzer.get_line_positions(get_3d=is_3d)

    # 轉換關鍵點和線條資料
    kpts, left, center, right = translate_multi_kpt_to_plot_pos(
        kpts, kpts, left, center, right
    )

    return [kpts, left, center, right]

