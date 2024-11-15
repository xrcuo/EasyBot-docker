FROM xrcuor/easybot:base

COPY ./EasyBot-Linux.zip /app/EasyBot/EasyBot-Linux.zip


COPY ./NapCat.Shell.zip /app/napcat/NapCat.Shell.zip
WORKDIR /app/napcat
RUN unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip



WORKDIR /app/EasyBot
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
      TH=$(curl "https://api.github.com/repos/xrcuo/EasyBot-docker/releases/latest" | jq -r '.tag_name')
RUN curl -o EasyBot-Linux.zip https://github.com/xrcuo/EasyBot-docker/releases/download/${TH}/EasyBot-Linux_${arch}.zip
RUN unzip -q EasyBot-Linux.zip \
       && rm EasyBot-Linux.zip \
       && chmod +x /app/EasyBot/EasyBot 


# 安装Linux QQ
RUN curl -o linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/e379390a/linuxqq_3.2.13-29456_${arch}.deb && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js
RUN  sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json


COPY ntqq.sh /opt/ntqq.sh
COPY start.sh /opt/start.sh
RUN chmod +x /opt/ntqq.sh \
       && chmod +x /opt/start.sh


WORKDIR /data

ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh
