问题：平台更改IP时，遇到bridge网络重启出现br0，etcd服务启动不起来

​	1、先更改服务器的IP地址主控制节点服务器照常更改，但是计算节点服务器先删除br0，然后运行br0.sh脚本       重新生成br1，在br1中改成想要的IP

​	2、etcd服务不能启动

​			目录/var/lib/etcd2/这里面放的是etcd的标识，标识具有唯一性，你要是重置etcd的话 就得把这个删除

​			需要把主控节点和etcd不能启动的计算节点的这个标识删除 

​					rm  -rf  /var/lib/etcd2/*

​					rm  -rf  /data/etcd2/member/*

​			还有UUID也需要删除

​					rm  -rf  /etc/.csphere-*
