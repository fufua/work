二、应用模板快速部署

没有分配ip地址,如下图
![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/%E6%B2%A1%E6%9C%89%E5%88%86%E9%85%8DIP.png)

分配ip：net-plugin ip-range

测试已分配的ip：etcdctl ls /csphere/network/192.168.网段.0/pool
