# 镜像制作以 Ubuntu 14.04 操作系统为基础
FROM ubuntu:14.04
MAINTAINER iportal@supermap.com
ENV IPORTAL_VERSION 8.0.2
ENV iPortal true

# 国内的 Ubuntu 镜像源
ADD sources.list_aliyun /etc/apt/sources.list

# 安装 iPortal 产品包
ADD supermap_iportal_8.0.2_linux64_deploy.tar.gz /opt/

# 准备依赖检查&安装脚本
ADD dependencies_check_and_install.sh /opt/SuperMapiPortal8C/support
RUN chmod 777 /opt/SuperMapiPortal8C/support/dependencies_check_and_install.sh

# 安装依赖
RUN cd /opt/SuperMapiPortal8C/support && \
	./dependencies_check_and_install.sh install -yu && \
	echo
RUN apt-get update && apt-get -f install -y libc6-i386
RUN apt-get -f install -y language-pack-zh-hans

# 解压许可驱动
RUN cd /opt/SuperMapiPortal8C/support/SuperMap_License/Support && \
	tar xvf aksusbd_2.4.1-i386.tar && \
	echo

# 准备启动脚本
ADD run.sh /opt/
RUN chmod 777 /opt/run.sh

# Container 启动时立即运行 iPortal
CMD /opt/run.sh