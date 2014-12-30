SuperMap GIS 系列产品的Docker镜像构建脚本

简介
=======
## iExpress镜像

### 构建过程

1, 将iExpress文件夹放到Linux系统，例如~/iExpress位置

2, 将iExpress的包也放在~/iExpress位置，修改Dockerfile文件中的iExpress包名，使一致

3, 运行如下命令

```bash
$ sudo docker --tag supermap/iexpress build ~/iExpress
```

### 如何运行iExpress？

运行如下命令：

```bash
$ sudo docker run --name iexpress1 -d -p 8090:8090 supermap/iexpress
```

其中：

* --name ：表示启动的Container名称，这里为iexpress1
* -d：表示启动后，在后台运行
* -p 8080:8090：将启动的Container中端口8090映射到了宿主机的8090端口
	
如此，访问 http://<宿主机IP>:8090，初始化后，即可看到iExpress首页
