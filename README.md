# EasyBot-docker

#

### 命令行运行

```shell
docker run -d \
-e ACCOUNT=<机器人qq> \
-e WS_ENABLE=true \
-e SERVER_HOST=0.0.0.0 \
-e SERVER_PORT=26990 \
-p 5000:5000 \
-p 6099:6099 \
-p 26990:26990 \
--name easybot \
--restart=always \
xrcuor/easybot


# docker-compose 运行

创建 `docker-compose.yml` 文件
```yaml
# docker-compose.yml
version: '3'
services:
  easybot:
    image: xrcuor/easybot
    container_name: easybot
    environment:
      - ACCOUNT=123456 # 机器人qq
      - WS_ENABLE=true # 正向 WS
      - TOKEN=1234 # access_token，可以为空
      - WEBUI_TOKEN=wscc # 登录密钥，默认是自动生成的随机登录密码
      - SERVER_HOST=0.0.0.0 # WebSocket服务器地址
      - SERVER_PORT=26990 # WebSocket服务器端口
    restart: always
    volumes:
      - ./napcat/config:/app/napcat/config
      - ./napcat/qq:/root/.config/QQ
      - ./EasyBot:/data
    ports:
      - "6099:6099"
      - "5000:5000"
      - "26990:26990"
```

docker-compose up -d` 运行到后台



# 登录

```shell
docker logs easybot
```
