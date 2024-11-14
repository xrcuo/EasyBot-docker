
FROM xrcuor/easybot:base

COPY ./EasyBot-Linux.zip /app/EasyBot/EasyBot-Linux.zip
WORKDIR /app/EasyBot
RUN unzip -q EasyBot-Linux.zip \
       && rm EasyBot-Linux.zip \
       && chmod +x /app/EasyBot/EasyBot 

COPY ./NapCat.Shell.zip /app/napcat/NapCat.Shell.zip
WORKDIR /app/napcat
RUN unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip



# 安装Linux QQ
ENV QQNT=3.2.13-29456
RUN wget -O linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/e379390a/linuxqq_${QQNT}_amd64.deb \
       && dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb \
       rm -rf /opt/QQ/resources/app/package.json && \
       echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js && \
       sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' /opt/QQ/resources/app/package.json


COPY ntqq.sh /opt/ntqq.sh
COPY start.sh /opt/start.sh
RUN chmod +x /opt/ntqq.sh \
       && chmod +x /opt/start.sh


WORKDIR /data

ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh





