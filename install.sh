#!/bin/bash

# 函数：检查并返回可用的包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        echo "none"
    fi
}


echo "正在更新依赖..."
package_manager=$(detect_package_manager)
if [ "$package_manager" = "apt" ]; then
    apt update -y
    apt install -y zip unzip wget jq curl dotnet-runtime-8.0 aspnetcore-runtime-8.0
elif [ "$package_manager" = "yum" ]; then
    yum install -y dotnet-runtime-8.0
    yum install -y zip unzip jq curl screen
else
    echo "包管理器检查失败，目前仅支持apt/yum。"
    exit 1
fi



GH_PROXY='https://mirror.ghproxy.com/'
RED_COLOR='\e[1;31m'
GREEN_COLOR='\e[1;32m'
RES='\e[0m'



INSTALL() {
  echo -e "\r\n${GREEN_COLOR}下载 EasyBot ...${RES}"  
  mkdir -p /app/EasyBot
  cd /app/EasyBot
  wget ${GH_PROXY}https://github.com/xrcuo/EasyBot-docker/releases/download/${easybot_version}/EasyBot.tgz

  if [ -f "/app/EasyBot/EasyBot" ]; then
    rm EasyBot.tgz
    echo -e "${RED_COLOR}下载 EasyBot.tgz 失败！${RES}"
    exit 1
  else
    tar -vxf EasyBot.tgz
    rm EasyBot.tgz
    chmod +x /app/EasyBot/EasyBot
    echo -e "${GREEN_COLOR} 下载成功 ${RES}"
  fi 

}

INIT() {
  mkdir -p /app/data

  if [ ! -f "/etc/systemd/system/easybot.service" ]; then
  cat >/etc/systemd/system/easybot.service <<EOF
[Unit]
Description=Alist service
Wants=network.target
After=network.target network.service

[Service]
Type=simple
WorkingDirectory=/app/data
ExecStart=/app/EasyBot/EasyBot
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
fi 

  systemctl daemon-reload
  systemctl enable easybot >/dev/null 2>&1
}



SUCCESS() {
  cp -a /app/EasyBot/wwwroot* /app/data
  clear
  echo "easybot 安装成功！"
  echo -e "\r\n访问地址：${GREEN_COLOR}http://YOUR_IP:5000/${RES}\r\n"
  echo -e "配置文件路径：${GREEN_COLOR}/app/data/appsettings.json${RES}"

  
  echo -e "启动服务中"
  systemctl restart easybot
  sleep 10
  sed -i 's/localhost/0.0.0.0/g' /app/data/appsettings.json
   
  echo
  echo -e "查看状态：${GREEN_COLOR}systemctl status easybot${RES}"
  echo -e "启动服务：${GREEN_COLOR}systemctl start easybot${RES}"
  echo -e "重启服务：${GREEN_COLOR}systemctl restart easybot${RES}"
  echo -e "停止服务：${GREEN_COLOR}systemctl stop easybot${RES}"
  echo -e "\r\n温馨提示：如果端口无法正常访问，请检查 \033[36m服务器安全组、本机防火墙、easybot状态\033[0m"
  echo
}


UPDATE() {
  echo
  echo -e "${GREEN_COLOR}停止 easybot 进程${RES}\r\n"
  systemctl stop easybot
  cp -a /app/EasyBot/dp* /app/data/dp
  rm -rf /app/data/wwwroot
  rm -rf /app/EasyBot
  mkdir -p /app/EasyBot
  cd /app/EasyBot
  echo -e "${GREEN_COLOR}下载 ${easybot_version} $VERSION ...${RES}"
  wget ${GH_PROXY}https://github.com/xrcuo/EasyBot-docker/releases/download/${easybot_version}/EasyBot.tgz
  if [ -f "/app/EasyBot/EasyBot" ]; then
      rm EasyBot.tgz
      echo -e "${RED_COLOR}下载 EasyBot.tgz 失败！${RES}"
      exit 1
    else
      tar -vxf EasyBot.tgz
      rm EasyBot.tgz
      chmod +x /app/EasyBot/EasyBot
      echo -e "${GREEN_COLOR} 下载成功 ${RES}"
  fi
  clear
  echo
  echo -e "查看状态：${GREEN_COLOR}systemctl status easybot${RES}"
  echo -e "启动服务：${GREEN_COLOR}systemctl start easybot${RES}"
  echo -e "重启服务：${GREEN_COLOR}systemctl restart easybot${RES}"
  echo -e "停止服务：${GREEN_COLOR}systemctl stop easybot${RES}"
  echo -e "\r\n温馨提示：如果端口无法正常访问，请检查 \033[36m服务器安全组、本机防火墙、easybot状态\033[0m"
  echo
  cp -a /app/data/dp* /app/EasyBot/dp
  cp -a /app/EasyBot/wwwroot* /app/data/wwwroot
    

  echo -e "\r\n${GREEN_COLOR}启动 easybot 进程${RES}"
  systemctl start easybot
  echo -e "\r\n${GREEN_COLOR}easybot 已更新到最新稳定版！${RES}\r\n"
}


easybot_version=$(curl "https://api.github.com/repos/xrcuo/EasyBot-docker/releases/latest" | jq -r '.tag_name')
if [ -z $easybot_version ]; then
    echo "无法获取EasyBot版本，请检查错误。"
    exit 1
fi

if [ "$1" = "update" ]; then
  UPDATE  
elif [ "$1" = "install" ]; then
  INSTALL
  INIT
  SUCCESS
else
  echo -e "${RED_COLOR} 错误的命令${RES}"
fi

