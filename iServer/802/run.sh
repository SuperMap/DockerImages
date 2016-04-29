# 初始化许可驱动
cd /opt/SuperMapiServer8C/support/SuperMap_License/Support
tar xvf aksusbd_2.4.1-i386.tar
cd aksusbd-2.4.1-i386
./dunst
./dinst
echo

# 运行iServer
cd /opt/SuperMapiServer8C/bin
./catalina.sh run