FROM ubuntu:22.04
#   安装依赖
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
       curl \
       jq \
       gosu \
       wget \
       dotnet-runtime-8.0 \
       aspnetcore-runtime-8.0 

# 设置时区
ENV TZ=Asia/Shanghai 
RUN echo "${TZ}" > /etc/timezone \ 
       && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \ 
       && apt update \ 
       && apt install -y tzdata \ 
       && rm -rf /var/lib/apt/lists/* \
       && apt autoremove -y \
       && apt clean \
       && rm -rf \
       /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/*