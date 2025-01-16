FROM xrcuor/easybot:base

COPY ./NapCat.Shell.zip /app/napcat/NapCat.Shell.zip

WORKDIR /app/napcat
RUN unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip

COPY EasyBot-Linux-amd64.zip /app/EasyBot/
WORKDIR /app/EasyBot
RUN unzip -q EasyBot-Linux-amd64.zip \
    && rm EasyBot-Linux-amd64.zip \
    && chmod +x /app/EasyBot/EasyBot 


RUN useradd --no-log-init -d /app napcat
# 安装Linux QQ
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    curl -o linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/63c751e8/linuxqq_3.2.15-30899_${arch}.deb && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js && \
    sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json


COPY ntqq.sh /opt/ntqq.sh
COPY start.sh /opt/start.sh
RUN chmod +x /opt/ntqq.sh \
    && chmod +x /opt/start.sh
    
    
WORKDIR /data
    
ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh
