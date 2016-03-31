# 镜像制作以ubuntu 14.04操作系统为基础
FROM ubuntu:14.04
MAINTAINER iserver@supermap.com
ENV ISERVER_VERSION 8.0.1
ENV iServer true

# 国内的Ubuntu镜像源
ADD sources.list_aliyun /etc/apt/sources.list

# 安装iServer产品包
ADD supermap_iserver_801_13525_2282_linux64_deploy.tar.gz /opt/

# 安装依赖库
RUN cd /opt/SuperMapiServer8C/support && \
	./dependencies_check_and_install.sh install -yu && \
	echo 
	
RUN apt-get update && apt-get -f install -y libc6-i386
RUN apt-get -f install -y language-pack-zh-hans

ADD run.sh /opt/
RUN chmod 777 /opt/run.sh

# Container启动时立即运行iServer
CMD /opt/run.sh