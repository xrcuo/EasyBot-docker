#!/bin/bash

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

NAPCAT_PATH=/app/napcat/config/napcat.json
if [ ! -f "$NAPCAT_PATH" ]; then
echo "$NAPCAT_PATH has been deleted."
  cat <<EOF > $NAPCAT_PATH
{
    "fileLog": true,
    "consoleLog": true,
    "fileLogLevel": "debug",
    "consoleLogLevel": "info"
}
EOF

  cat <<EOF > /app/napcat/config/onebot11.json
{
    "http": {
        "enable": false,
        "host": "",
        "port": 3000,
        "secret": "",
        "enableHeart": false,
        "enablePost": false,
        "postUrls": []
    },
    "ws": {
        "enable": false,
        "host": "",
        "port": 3001
    },
    "reverseWs": {
        "enable": false,
        "urls": []
    },
    "GroupLocalTime": {
        "Record": false,
        "RecordList": []
    },
    "debug": false,
    "heartInterval": 30000,
    "messagePostFormat": "array",
    "enableLocalFile2Url": true,
    "musicSignUrl": "",
    "reportSelfMessage": false,
    "token": ""
}
EOF

else
    echo "$NAPCAT_PATH does not exist."
fi

CONFIG_PATH=/app/napcat/config/onebot11_$ACCOUNT.json
# 容器首次启动时执行
if [ ! -f "$CONFIG_PATH" ]; then
    echo "$CONFIG_PATH has been deleted."
    if [ "$WEBUI_TOKEN" ]; then
        echo "{\"port\": 6099,\"token\": \"$WEBUI_TOKEN\",\"loginRate\": 3}" > /app/napcat/config/webui.json
    fi
    : ${WEBUI_TOKEN:=''}
    : ${HTTP_PORT:=3000}
    : ${HTTP_URLS:='[]'}
    : ${WS_PORT:=3001}
    : ${HTTP_ENABLE:='false'}
    : ${HTTP_POST_ENABLE:='false'}
    : ${WS_ENABLE:='true'}
    : ${WSR_ENABLE:='false'}
    : ${WS_URLS:='[]'}
    : ${HEART_INTERVAL:=60000}
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
    HTTP_URLS=$(chech_quotes $HTTP_URLS)
    WS_URLS=$(chech_quotes $WS_URLS)
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
    "GroupLocalTime":{
      "Record": false,
      "RecordList": []
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
else
    echo "$CONFIG_PATH does not exist."
fi

rm -rf "/tmp/.X1-lock"

xvfb-run -a qq --no-sandbox -q $ACCOUNT
