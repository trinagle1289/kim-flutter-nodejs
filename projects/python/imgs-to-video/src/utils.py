#!/usr/bin/env python
# coding: utf-8

# In[1]:


from typing import Callable
from pathlib import Path
import cv2


# In[ ]:


def get_folders_in_folder(folder_path: str) -> list[Path]:
    """取得資料夾中的資料夾陣列

    Args:
        folder_path (str): 資料夾路徑

    Returns:
        list[Path]: 資料夾物件陣列
    """
    folders: list[Path] = []
    for child in Path(folder_path).iterdir():
        if child.is_dir():
            folders.append(child)

    return folders


# In[ ]:


def get_files_in_folder(folder_path: str) -> list[Path]:
    """取得資料夾中的檔案陣列

    Args:
        folder_path (str): 資料夾路徑

    Returns:
        list[Path]: 檔案物件陣列
    """
    files: list[Path] = []
    for child in Path(folder_path).iterdir():
        if child.is_file():
            files.append(child)

    return files


# In[3]:


def handle_files_in_folder(
    folder_path: str,
    folder_cb: Callable[[Path, int], None] = None,
    file_cb: Callable[[Path, int], None] = None,
) -> None:
    """在資料夾中處理資料夾或檔案

    Args:
        folder_path (str): 資料夾路徑
        folder_cb (Callable[[Path, int], None]): 資料夾處理函式[[檔案路徑物件, 索引值], None]
        file_cb (Callable[[Path, int], None]): 檔案處理函式[[檔案路徑物件, 索引值], None]
    """
    idx_folder = 0
    idx_file = 0

    p = Path(folder_path)
    for child in p.iterdir():
        if child.is_dir():
            if folder_cb is not None:
                folder_cb(child, idx_folder)
                idx_folder += 1
        elif child.is_file():
            if file_cb is not None:
                file_cb(child, idx_file)
                idx_file += 1


# In[13]:


def img_folder_to_video(
    img_folder_path: str,
    saved_path: str,
    video_size: tuple[int, int] = None,
    video_frame_rate: int = 30,
    video_fourcc: str = "h264",
):
    """圖片資料夾轉換成影片

    Args:
        img_folder_path (str): 圖片資料夾
        video_path (str): 影片輸出路徑
        video_size (tuple[int, int], optional): 影片形狀大小. Defaults to None.
        video_frame_rate (int, optional): 影片幀率. Defaults to 30.
        video_fourcc (str, optional): 影片的唯一標識數據格式. Defaults to "h264".
    """
    # 影像幀
    frames: list[cv2.typing.MatLike] = []

    # 將資料夾中的圖片寫入到 frames 中
    p = Path(img_folder_path)
    for child in p.iterdir():
        if child.is_file():
            frames.append(cv2.imread(str(child)))

    # 設定影片形狀
    if video_size is None:
        width, height, _channel = frames[0]
        video_size = (width, height)

    # 將圖片寫入至影片中
    fourcc = cv2.VideoWriter.fourcc(*video_fourcc)
    video_out = cv2.VideoWriter(saved_path, fourcc, video_frame_rate, video_size)
    for frame in frames:
        video_out.write(frame)

