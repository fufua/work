# csphere平台更换IP地址

## 一、更改相关配置文件

一、控制节点

1、查看控制节点的网络配置文件，获取相关网络信息

​				cat  /etc/sysconfig/network-scripts/ifcfg-ens33

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/1.png)

2、停止csphere相关服务

​			cspherectl	 stop 

2、更改控制节点csphere平台的相关配置文件

​			vi 	/etc/csphere/csphere-agent.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/2.png)

​			vi 	csphere-etcd2-controller.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/3.png)

​			vi 	csphere-public.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/4.png)

​			vi 	inst-opts.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/5.png)

3、启动csphere服务

​			cspherectl 	start

4、登录csphere平台，查看主机中的控制节点主机是否出现，并且删除原来IP地址的主机

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/6.png)

二、计算节点

1、查看计算节点的网络配置文件，获取相关网络信息

​				cat   /etc/sysconfig/network-scripts/ifcfg-br0

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/7.png)

2、停止csphere相关服务

​				cspherectl     stop

3、登录cpshere平台，获取COS验证码

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/8.png)

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/9.png)

3、更改计算节点csphere平台的相关配置文件

​			vi   /etc/csphere/csphere-agent.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/10.png)

​			vi   /etc/csphere/csphere-etcd2-agent.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/11.png)

​			vi csphere-public.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/12.png)

​			vi 	inst-opts.env

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/13.png)

4、启动服务

​			cspherectl    start 

5、拓展

​			ifconfig   br0  down			关闭br0网络

​			brctl   delbr  br0				  删除br0网络

## 二、遇到的问题

### 1、x86环境

问题描述：重启服务器，br0网络出现自动变为原来未更改的IP地址，重启network服务，IP地址变为新的IP地址

出现原因：docker记录的是以前的网卡信息，导致重启服务器后IP自动变更为原来的IP地址

解决办法：需要删除docker里面记录的信息

步骤如下：			

​			docker network ls			   查看docker网络信息

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/14.png)

​			docker   network  inspect  br0				查看br0的信息

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/15.png)

如果不一致，需要删除docker网络，然后重启docker

​			systemctl   stop   csphere-docker-agent				停止docker服务

​			rm -rf /data/docker/network					删除docker网络

​			systemctl   start  csphere-docker-agent				启动docker服务

### 2、申威环境

1、问题描述：添加docker  br0网络失败，显示报错如图

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/17.png)

创建容器时报错如图

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/19.png)

出现原因：net-plugin服务不能连接etcd数据库，导致添加docker  br0失败

拓展：net-plugin服务未启动，报错如下图

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/18.png)

修改/etc/systemd/system/multi-user.target.wants/csphere-dockeripam.service

#####  注意：etcd服务所在主机的IP地址为192.168.1.10，配置文件要注意（解决net-plugin连接etcd数据库）

	主机：192.168.1.10
	[Unit]
	Description=Csphere Docker IPAM Service
	After=csphere-etcd2-agent.service
	Before=csphere-docker-agent.service
	Before=csphere-agent.service
	
	[Service]
	User=root
	EnvironmentFile=/etc/csphere/csphere-public.env
	EnvironmentFile=/etc/csphere/csphere-dockeripam.env
	ExecStartPre=/bin/sleep 3s
	ExecStartPre=/bin/rm -f /run/docker/plugins/csphere.sock
	ExecStart=/bin/net-plugin server
	Restart=always
	RestartSec=10s
	
	[Install]
	WantedBy=multi-user.target
	
	主机：192.168.1.11
	[Unit]
	Description=Csphere Docker IPAM Service
	After=csphere-etcd2-agent.service
	Before=csphere-docker-agent.service
	Before=csphere-agent.service
	
	[Service]
	User=root
	EnvironmentFile=/etc/csphere/csphere-public.env
	EnvironmentFile=/etc/csphere/csphere-dockeripam.env
	ExecStartPre=/bin/sleep 3s
	ExecStartPre=/bin/rm -f /run/docker/plugins/csphere.sock
	ExecStart=/bin/net-plugin --cluster-store "etcd://192.168.1.10:2379" server
	Restart=always
	RestartSec=10s
	
	[Install]
	WantedBy=multi-user.target
​			systemctl    daemon-reload    				更新配置文件内容

​			systemctl    restart    csphere-dockeripam					重启服务

2、删除docker历史网络记录

​			rm   -rf   /var/lib/docker/network						删除docker原来的网络配置

​			systemctl    restart     csphere-docker-agent     重启docker网络

3、添加docker   br0网络

	docker network create -d bridge --ipam-driver=csphere --gateway 192.168.1.1 \
	          -o com.docker.network.bridge.name=br0 \
	          -o com.docker.network.bridge.enable_ip_masquerade=false \
	          --aux-address=DefaultGatewayIPv4=192.168.1.1 \
	          --subnet 192.168.1.11/24 br0
	注释：
	192.168.1.1：服务器的网关
	192.168.1.11/24：服务器的IP地址和子网掩码
4、查看docker   br0网络

​			docker    network    ls					查看容器网络

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/15.png)

​			docker    network    inspect    br0 				查看br0网络详细信息

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/cSphere%E6%9B%B4%E6%94%B9IP%E5%9C%B0%E5%9D%80/16.png)
