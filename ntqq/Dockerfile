FROM ubuntu:22.04

RUN sed -i "s,//.*.ubuntu.com,//mirrors.tuna.tsinghua.edu.cn,g" /etc/apt/sources.list \
       && apt-get update \
       && apt upgrade -y \
       && apt-get install -y \
       zip \
       unzip \
       jq \
       xvfb \
       libnss3 \
       libgbm1 \
       libasound2 \
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


# 安装Linux QQ
ENV QQNT=3.2.12_240819
RUN wget -O linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_${QQNT}_amd64_01.deb \
       && apt update \
       && apt install -f -y ./linuxqq.deb && rm linuxqq.deb \
       && echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/app_launcher/index.js


WORKDIR /app/napcat
ENV napcat=v2.2.4
RUN  wget https://github.com/NapNeko/NapCatQQ/releases/download/${napcat}/NapCat.Shell.zip \
       && unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip

WORKDIR /app/EasyBot
RUN wget https://github.com/xrcuo/EasyBot-docker/releases/download/EasyBot-Linux-1.0.7/EasyBot_linux_1_1_0_fix2.tar \
       && tar -vxf EasyBot_linux_1_1_0_fix2.tar \
       && rm EasyBot_linux_1_1_0_fix2.tar \
       && chmod +x /app/EasyBot/EasyBot     

COPY start.sh /opt/start.sh
COPY ./config /opt/config
COPY ntqq.sh /opt/ntqq.sh
RUN    chmod +x /opt/start.sh \
       && chmod +x /opt/ntqq.sh

WORKDIR /data
#ENTRYPOINT /opt/entrypoint.sh & /opt/start.sh
ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh