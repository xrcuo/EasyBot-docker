FROM ubuntu:22.04



RUN  sed -i "s,//.*.ubuntu.com,//mirrors.aliyun.com,g" /etc/apt/sources.list \
       && apt-get update -y \
       && apt-get install -y \
       unzip \
       wget \
       curl \
       ntpdate \
       net-tools \
       iputils-ping \
       iproute2 \
       dotnet-runtime-8.0 \
       aspnetcore-runtime-8.0 \
       && rm -rf /var/lib/apt/lists/*


WORKDIR /app/EasyBot
RUN TH=$(curl "https://api.github.com/repos/xrcuo/EasyBot-docker/releases/latest" | jq -r '.tag_name') \
       && arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
       && wget https://github.com/xrcuo/EasyBot-docker/releases/download/${TH}/EasyBot-Linux-${arch}.zip \
       && unzip -q EasyBot-Linux-${arch}.zip \
          && rm EasyBot-Linux-arm64.zip \
          && rm EasyBot-Linux-amd64.zip \
          && chmod +x /app/EasyBot/EasyBot 





COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
WORKDIR /data
ENTRYPOINT ["/opt/start.sh"]
