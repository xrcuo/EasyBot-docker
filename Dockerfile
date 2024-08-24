
FROM xrcuor/easybot:base

COPY NapCat.Shell.zip /app/napcat
WORKDIR /app/EasyBot
RUN RUN wget https://github.com/xrcuo/EasyBot-docker/releases/download/EasyBot-Linux-1.0.7/EasyBot_linux_1_1_0_fix2.tar \
       && tar -vxf EasyBot_linux_1_1_0_fix2.tar \
       && rm EasyBot_linux_1_1_0_fix2.tar \
       && chmod +x /app/EasyBot/EasyBot 


WORKDIR /app/napcat
RUN   unzip -q NapCat.Shell.zip \
       && rm NapCat.Shell.zip

# 安装Linux QQ
ENV QQNT=3.2.12_240819
RUN wget -O linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_${QQNT}_amd64_01.deb \
       && dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb \
       && echo "(async () => {await import('file:///app/napcat/napcat.mjs');})();" > /opt/QQ/resources/app/app_launcher/index.js

COPY ntqq.sh /opt/ntqq.sh
COPY start.sh /opt/start.sh
RUN chmod +x /opt/ntqq.sh \
       && chmod +x /opt/start.sh

ENTRYPOINT  /opt/ntqq.sh & /opt/start.sh





