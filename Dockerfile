
FROM xrcuor/easybot:base

COPY ./EasyBot.tgz /app/EasyBot/EasyBot.tgz
WORKDIR /app/EasyBot
RUN tar -vxf EasyBot.tgz \
       && rm EasyBot.tgz \
       && chmod +x /app/EasyBot/EasyBot 

COPY ./NapCat.Shell.zip /app/napcat/NapCat.Shell.zip
WORKDIR /app/napcat
RUN unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip

COPY ./qqnt.json /app/qqnt.json


# 安装Linux QQ
ENV QQNT=3.2.12-28327
RUN wget -O linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/f60e8252/linuxqq_${QQNT}_amd64.deb \
       && dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb \
       rm -rf /opt/QQ/resources/app/package.json && \
       echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/loadNapCat.js \
       && mv /app/qqnt.json /opt/QQ/resources/app/package.json


COPY ntqq.sh /opt/ntqq.sh
COPY start.sh /opt/start.sh
RUN chmod +x /opt/ntqq.sh \
       && chmod +x /opt/start.sh


WORKDIR /data

ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh





