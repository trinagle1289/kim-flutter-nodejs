### Flask 回傳 response 物件的輩分
```python
response = app.response_class(
    response=data,
    status=200,
    content_type="text/plain",
)
```