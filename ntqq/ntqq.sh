#!/bin/bash

# 检查引号
chech_quotes(){
    local input="$1"
    if [ "${input:0:1}" != '"' ] ; then
        if [ "${input:0:1}" != '[' ] ; then
            input="[\"$input\"]"
        fi
    else
        input="[$input]"
    fi
    echo $input
}

# 配置文件路径
CONFIG_PATH=/app/napcat/config/onebot11_$ACCOUNT.json
# 容器首次启动时执行
if [ ! -f "$CONFIG_PATH" ]; then
    # 如果WEBUI_TOKEN存在，则创建webui.json文件
    if [ "$WEBUI_TOKEN" ]; then
        echo "{\"port\": 6099,\"token\": \"$WEBUI_TOKEN\",\"loginRate\": 3}" > /app/napcat/config/webui.json
    fi
    : ${WEBUI_TOKEN:=''}
    : ${HTTP_PORT:=3000}
    : ${HTTP_URLS:='[]'}
    : ${WS_PORT:=3001}
    : ${HTTP_ENABLE:='false'}
    : ${HTTP_POST_ENABLE:='false'}
    : ${WS_ENABLE:='false'}
    : ${WSR_ENABLE:='false'}
    : ${WS_URLS:='[]'}
    : ${HEART_INTERVAL:=30000}
    : ${TOKEN:=''}
    : ${F2U_ENABLE:='false'}
    : ${DEBUG_ENABLE:='false'}
    : ${LOG_ENABLE:='false'}
    : ${RSM_ENABLE:='false'}
    : ${MESSAGE_POST_FORMAT:='array'}
    : ${HTTP_HOST:=''}
    : ${WS_HOST:=''}
    : ${HTTP_HEART_ENABLE:='false'}
    : ${MUSIC_SIGN_URL:=''}
    : ${HTTP_SECRET:=''}
    # 检查HTTP_URLS和WS_URLS是否包含引号
    HTTP_URLS=$(chech_quotes $HTTP_URLS)
    WS_URLS=$(chech_quotes $WS_URLS)
    # 创建配置文件
cat <<EOF > $CONFIG_PATH
{
    "http": {
      "enable": ${HTTP_ENABLE},
      "host": "$HTTP_HOST",
      "port": ${HTTP_PORT},
      "secret": "$HTTP_SECRET",
      "enableHeart": ${HTTP_HEART_ENABLE},
      "enablePost": ${HTTP_POST_ENABLE},
      "postUrls": $HTTP_URLS
    },
    "ws": {
      "enable": ${WS_ENABLE},
      "host": "${WS_HOST}",
      "port": ${WS_PORT}
    },
    "reverseWs": {
      "enable": ${WSR_ENABLE},
      "urls": $WS_URLS
    },
    "debug": ${DEBUG_ENABLE},
    "heartInterval": ${HEART_INTERVAL},
    "messagePostFormat": "$MESSAGE_POST_FORMAT",
    "enableLocalFile2Url": ${F2U_ENABLE},
    "musicSignUrl": "$MUSIC_SIGN_URL",
    "reportSelfMessage": ${RSM_ENABLE},
    "token": "$TOKEN"
}
EOF
fi

# 检查文件是否存在
FILE="/tmp/.X1-lock"
if [ -e "$FILE" ]; then
    # 如果存在，则删除
    rm -rf "$FILE"
    echo "$FILE has been deleted."
else
    echo "$FILE does not exist."
fi

# 修改权限
chmod 777 /tmp &
# 删除dbus的pid文件
rm -rf /run/dbus/pid &
# 创建dbus的目录
mkdir -p /var/run/dbus &
# 启动dbus
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address &
# 启动Xvfb
Xvfb :1 -screen 0 1080x760x16 +extension GLX +render &
# 设置FFMPEG路径
export FFMPEG_PATH=/usr/bin/ffmpeg
# 设置DISPLAY环境变量
export DISPLAY=:1
# 进入目录
cd /app/napcat
# 启动qq
qq --no-sandbox -q $ACCOUNT