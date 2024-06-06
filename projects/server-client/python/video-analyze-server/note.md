
* [使用 OpenCV 不存檔直接讀入 Flask 所傳進的圖片 | 辛西亞的技能樹](https://cynthiachuang.github.io/Reading-Image-File-Without-Saving-It-Using-CV2-in-Flask/)


### Flask 回傳 response 物件的備份
```python
response = app.response_class(
    response=data,
    status=200,
    content_type="text/plain",
)
```