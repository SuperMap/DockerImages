## 运行方式
docker run -d -p 8190:8090 -v \`pwd\`/myOPTs:/opt/iportalOPTs supermap/iportal:912

支持 myOPTs 为空目录，iportal的配置会在启动时加过来，并在重启时不变

## 支持的env参数
* LICENSE_SERVER：许可服务器地址
