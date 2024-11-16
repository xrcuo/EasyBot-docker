#!/bin/bash

# 定义EasyBot配置文件路径
EASYBOT_PATH=/data/appsettings.json
# 初始化EasyBot配置文件
INIT() {
  cat <<EOF > $EASYBOT_PATH
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "AllowedHosts": "*",
  "ServerOptions": {
    "Host": "$SERVER_HOST",
    "Port": $SERVER_PORT,
    "HeartbeatInterval": "$HEARTBEAT_INTERVAL"
  },
  "Kestrel": {
    "Endpoints": {
      "web_app": {
        "Url": "$WEB_HOST",
        "Protocols": "Http1"
      }
    }
  },
  "ProSettings": {
    "NavTheme": "light",
    "HeaderHeight": 48,
    "Layout": "side",
    "ContentWidth": "Fluid",
    "FixedHeader": true,
    "FixSiderbar": true,
    "Title": "EasyBot",
    "PrimaryColor": "daybreak",
    "ColorWeak": false,
    "SplitMenus": false,
    "HeaderRender": true,
    "FooterRender": true,
    "MenuRender": true,
    "MenuHeaderRender": true
  }
}
EOF
}

appsettings() {
  if [ ! -f "$EASYBOT_PATH" ]; then
    : ${WEB_HOST:='http://0.0.0.0:5000'}

    : ${HEARTBEAT_INTERVAL:='0.00:02:00'}

    : ${SERVER_HOST:='0.0.0.0'}

    : ${SERVER_PORT:='26990'}
    INIT


  fi
}
 
BACKUP_PATH=/data/backup
backup_source(){
  if [ ! -f "$BACKUP_PATH/appsettings.json.bak" ]; then
     mkdir -p $BACKUP_PATH
     cp -rp $EASYBOT_PATH $BACKUP_PATH/appsettings.json.bak
     cp -rp /data/EasyBot.db $BACKUP_PATH/EasyBot.db.bak
     cp -a /data/options/* $BACKUP_PATH/options
     cp -a /app/EasyBot/dp/* $BACKUP_PATH/dp
     rm  /data/appsettings.json
     echo -e "(配置文件已备份)"
  else   
     echo -e "(配置文件已备份，使用默认配置文件)"
  fi

}

main(){
 # backup_source
  appsettings
  rm -rf /data/wwwroot  # 删除/data/wwwroot目录
  # 将/app/EasyBot/wwwroot*目录复制到/data/wwwroot目录
  cp -a /app/EasyBot/wwwroot* /data/wwwroot

  
}

main
# 运行EasyBot
/app/EasyBot/EasyBot.WebUI