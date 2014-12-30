SuperMap GIS 系列产品的Docker镜像构建脚本

运行方式
=======
== iExpress镜像

1, 将iExpress文件夹放到Linux系统，例如~/iExpress位置
2, 将iExpress的包也放在~/iExpress位置，修改Dockerfile文件中的iExpress包名，使一致
3, 运行如下命令
$ sudo docker --tag supermap/iexpress build ~/iexpress