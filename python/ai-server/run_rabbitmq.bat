:: 取得 rabbitmq IMAGE
docker pull rabbitmq:latest

:: 建立 rabbitmq 容器
docker run -itd --rm --name rabbitmq -p 5672:5672 rabbitmq:latest