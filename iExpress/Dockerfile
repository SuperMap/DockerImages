# 镜像制作以国内仓库的ubuntu 14.04操作系统为基础
FROM docker.cn/docker/ubuntu:14.04
MAINTAINER sulele@supermap.com
ENV IEXPRESS_VERSION 7.1
ENV iExpress true
# 国内的Ubuntu镜像源
ADD sources.list_aliyun /etc/apt/sources.list
# 安装依赖库
RUN apt-get update && apt-get install -y lsb-core
# 安装iExpress产品包
ADD supermap_iexpress_710_11919_20_linux64.tar.gz /opt/
# 初始化许可驱动
RUN cd /opt/SuperMapiExpress7C/support/SuperMap_License/Support && \
	./rpms_check_and_install_for_64bit.sh install && \
	tar xvf aksusbd_2.4.1-i386.tar && \
	cd aksusbd-2.4.1-i386 && \
	./dinst && \
	echo
ADD run.sh /opt/
# Container启动时立即运行iServer
CMD /opt/run.sh