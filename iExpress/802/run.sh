# 初始化许可驱动
cd /opt/SuperMapiExpress8C/support/SuperMap_License/Support
./rpms_check_and_install_for_64bit.sh install
tar xvf aksusbd_2.4.1-i386.tar
cd aksusbd-2.4.1-i386
./dunst
./dinst
echo

# 运行iExpress
cd /opt/SuperMapiExpress8C/bin
./catalina.sh run
