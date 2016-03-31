# 镜像制作以ubuntu 14.04操作系统为基础
FROM ubuntu:14.04
MAINTAINER iserver@supermap.com
ENV ISERVER_VERSION 8.0.1
ENV iServer true

# 国内的Ubuntu镜像源
ADD sources.list_aliyun /etc/apt/sources.list

# 安装依赖库
RUN apt-get update && apt-get install -y lsb-core
RUN apt-get install -y libx11-dev
RUN apt-get install -y xinit
RUN apt-get install -y language-pack-zh-hans

# 安装iServer产品包
ADD supermap_iserver_8.0.1_linux64_deploy.tar.gz /opt/
RUN cp /opt/SuperMapiServer8C/support/objectsjava/bin/libmawt.so /opt/SuperMapiServer8C/support/jre/lib/amd64/headless
ADD run.sh /opt/
RUN chmod 777 /opt/run.sh

# Container启动时立即运行iServer
CMD /opt/run.sh