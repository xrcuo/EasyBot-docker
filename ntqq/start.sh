#!/bin/bash

# 定义EasyBot配置文件路径
EASYBOT_PATH=/data/appsettings.json
# 判断配置文件是否存在
if [ ! -f "$EASYBOT_PATH" ]; then
  # 如果不存在，则设置默认的WEB_HOST
  : ${WEB_HOST:='http://0.0.0.0:5000'}
  # 创建配置文件
  cat <<EOF > $EASYBOT_PATH
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information",
      "Grpc": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ProSettings": {
    "NavTheme": "realDark",
    "HeaderHeight": 48,
    "Layout": "side",
    "ContentWidth": "Fixed",
    "FixedHeader": true,
    "FixSiderbar": true,
    "Title": "EasyBot",
    "IconfontUrl": null,
    "PrimaryColor": "purple",
    "ColorWeak": false,
    "SplitMenus": false,
    "HeaderRender": true,
    "FooterRender": true,
    "MenuRender": true,
    "MenuHeaderRender": true
  },
  "Kestrel": {
    "Endpoints": {
      "web_app": {
        "Url": "$WEB_HOST",
        "Protocols": "Http1"
      },
      "grpc": {
        "Url": "http://0.0.0.0:5001",
        "Protocols": "Http2"
      }
    }
  }
}
EOF
fi


# 定义要删除的目录路径
FILE="/data/wwwroot"
# 判断目录是否存在
if [ -e "$FILE" ]; then
    # 如果存在，则删除
    rm -rf "$FILE"
    echo "$FILE has been deleted."
else
    echo "$FILE does not exist."
fi

# 将/app/EasyBot/wwwroot*目录复制到/data/wwwroot目录
cp -a /app/EasyBot/wwwroot* /data/wwwroot

# 运行EasyBot
/app/EasyBot/EasyBot