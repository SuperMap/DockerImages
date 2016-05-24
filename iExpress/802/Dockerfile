# 镜像制作以国内仓库的ubuntu 14.04操作系统为基础
FROM ubuntu:14.04
MAINTAINER sulele@supermap.com
ENV IEXPRESS_VERSION 8.0.2
ENV iExpress true

# 国内的Ubuntu镜像源
ADD sources.list_aliyun /etc/apt/sources.list

# 安装依赖库
RUN apt-get update && apt-get install -y libx11-dev xinit gcc libc6-i386 language-pack-zh-hans 

# 安装iExpress产品包
ADD supermap_iexpress_8.0.2_linux64.tar.gz /opt/

ADD run.sh /opt/
RUN chmod 777 /opt/run.sh
# Container启动时立即运行iExpress
CMD /opt/run.sh