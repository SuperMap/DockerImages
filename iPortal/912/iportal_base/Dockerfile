FROM ubuntu:14.04
MAINTAINER zhangtianyi@supermap.com

ENV LICENSE_DIR=/opt/SuperMap/License

RUN apt-get update && \
	apt-get install -y make gcc binutils perl libx11-dev xinit libgomp1 libxtst6 libxi6 language-pack-zh-hans lsb-core && \
	apt-get install -y libc6-i386 libglu1-mesa libxcursor1 && \
	apt-get install -y curl unzip libaio1 && \
	apt-get clean && apt-get autoclean

# get and install aksusbd
ADD hasplm.ini /etc/hasplm/hasplm.ini
ADD init.sh /opt/init.sh 

RUN curl http://imanager-tool.oss-cn-beijing.aliyuncs.com/aksusbd-2.4.1-i386.tar -o /tmp/aksusbd.tar && \
	tar -xvf /tmp/aksusbd.tar -C /opt && \
	ln -s /opt/aksusbd* /opt/aksusbd &&\
	chmod +x /opt/init.sh 

RUN mkdir -p $LICENSE_DIR

CMD /opt/init.sh 
