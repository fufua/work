# 添加Agent时，初始化失败

报错如下

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/Agent%E5%88%9D%E5%A7%8B%E5%8C%96%E5%A4%B1%E8%B4%A5/1.png)

原因：初始化失败，找不到网卡配置文件（注意：IP地址设置为静态获取）

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/Agent%E5%88%9D%E5%A7%8B%E5%8C%96%E5%A4%B1%E8%B4%A5/2.png)

解决办法：按照上图配置好网卡配置文件，重启network服务
