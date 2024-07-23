FROM ubuntu:22.04

RUN sed -i "s,//.*.ubuntu.com,//mirrors.tuna.tsinghua.edu.cn,g" /etc/apt/sources.list \
       && apt-get update \
       && apt upgrade -y \
       && apt-get install -y \
       libnss3 \   
       libnotify4 \
       libsecret-1-0 \
       libgbm1 \
       xvfb \
       libasound2 \
       fonts-wqy-zenhei \
       gnutls-bin \ 
       libglib2.0-dev \
       libdbus-1-3 \
       libgtk-3-0 \
       libxss1 \
       libxtst6 \
       libatspi2.0-0 \
       libx11-xcb1 \
       ffmpeg \
       unzip \
       dbus-user-session \
       wget \
       ntpdate \
       net-tools \
       iputils-ping \
       iproute2 \
       dotnet-runtime-8.0 \
       aspnetcore-runtime-8.0 \
       && rm -rf \
       /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/*

# 设置时区
ENV TZ=Asia/Shanghai 
RUN echo "${TZ}" > /etc/timezone \ 
       && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \ 
       && apt update \ 
       && apt install -y tzdata \ 
       && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN  wget https://github.com/NapNeko/NapCatQQ/releases/download/v1.6.7/NapCat.linux.x64.zip \
       && unzip -q NapCat.linux.x64.zip \
       && mv NapCat.linux.x64 napcat \
       && rm NapCat.linux.x64.zip

# 安装Linux QQ
RUN wget -O linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.10_240715_amd64_01.deb \
       && dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb \
       && echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/app_launcher/index.js


WORKDIR /app/EasyBot
RUN wget https://github.com/xrcuo/EasyBot-docker/releases/download/EasyBot-Linux-1.1.0/EasyBot-Linux-1.1.0.tar.gz \
       && tar -zxvf EasyBot-Linux-1.1.0.tar.gz \
       && rm EasyBot-Linux-1.1.0.tar.gz \
       && chmod +x /app/EasyBot/EasyBot \
       && ln -s /app/EasyBot/EasyBot /usr/bin/EasyBot  


COPY start.sh /opt/start.sh
COPY ntqq.sh /opt/ntqq.sh
RUN    chmod +x /opt/start.sh \
       && chmod +x /opt/ntqq.sh

WORKDIR /data
#ENTRYPOINT /opt/entrypoint.sh & /opt/start.sh
ENTRYPOINT /opt/ntqq.sh & /opt/start.sh