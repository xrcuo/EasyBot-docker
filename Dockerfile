FROM ubuntu:22.04

RUN  sed -i "s,//.*.ubuntu.com,//mirrors.aliyun.com,g" /etc/apt/sources.list \
       && apt-get update -y \
       && apt-get install -y \
       unzip \
       wget \
       ntpdate \
       net-tools \
       iputils-ping \
       iproute2 \
       dotnet-runtime-8.0 \
       aspnetcore-runtime-8.0 \
       && rm -rf /var/lib/apt/lists/*

# 设置时区
ENV TZ=Asia/Shanghai 
RUN echo "${TZ}" > /etc/timezone \ 
       && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \ 
       && apt update \ 
       && apt install -y tzdata \ 
       && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/EasyBot

RUN wget https://github.com/xrcuo/EasyBot-docker/releases/download/EasyBot-Linux-1.1.0/EasyBot-Linux-1.1.0.tar.gz \
       && tar -zxvf EasyBot-Linux-1.1.0.tar.gz \
       && rm EasyBot-Linux-1.1.0.tar.gz \
       && chmod +x /opt/EasyBot/EasyBot \
       && ln -s /opt/EasyBot/EasyBot /usr/bin/EasyBot  


COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
WORKDIR /data
ENTRYPOINT ["/opt/start.sh"]
#CMD ["/usr/bin/EasyBot"]





