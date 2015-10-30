FROM tutum/ubuntu:latest
MAINTAINER Martin Bachl <martin@bachl.pro>

RUN sudo apt-get update
RUN sudo apt-get install -y wget curl unzip nodejs-legacy npm mysql-client tofrodos git && \
	rm -r /var/lib/apt/lists/*

COPY run.sh /run.sh
	
ENV ETHERPAD_VERSION 1.5.6

WORKDIR /usr/bin
RUN ln -s fromdos dos2unix
RUN ln -s todos unix2dos

COPY templates /tmp/templates

WORKDIR /opt/etherpad-lite

COPY etherpad-dev /opt/etherpad-lite
RUN find . -type f -exec dos2unix {} \;
RUN npm install is-property -g
RUN npm install is-property
RUN bin/installDeps.sh

COPY etherpad.sql /opt/etherpad-lite/etherpad.sql

EXPOSE 9001
WORKDIR ~/bin
COPY inner-run.sh /root/bin/inner-run.sh
COPY run.sh run.sh
CMD ["bash", "/run.sh"]