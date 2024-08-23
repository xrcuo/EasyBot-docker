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

RUN wget https://github.com/xrcuo/EasyBot-docker/releases/download/EasyBot-Linux-1.0.7/EasyBot_linux_1_1_0_fix2.tar \
       && tar -vxf EasyBot_linux_1_1_0_fix2.tar \
       && rm EasyBot_linux_1_1_0_fix2.tar 


COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
WORKDIR /data
ENTRYPOINT ["/opt/start.sh"]
#CMD ["/usr/bin/EasyBot"]





