# 深度deepin系统iSCSI挂载

网卡重置**

问题：服务器重启以后，网卡配置文件被重置，但是时使用（systemctl  restart  network）会生效，但是重启系统之后就会被还原

​	vim  /etc/sysconfig/network-scripts/ifcfg-eth0

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/iSCSI/1.png)

解决办法：

1、禁止cloud-init服务接管网络

​	vim  /etc/cloud/cloud.cfg

在最后添加：

​	network:

​	config:disabled

2、清理检查cloud-init配置文件

 	cd /usr/lib/python2.7/site-packages/cloudinit/sources/

 	rm -rf init.pyc  	 

 	rm -rf init.pyo  	  

	rm -rf /var/lib/cloud/*  	  

	rm -rf /var/log/cloud-init* 

 	cloud-init init --local

 	cat  /etc/sysconfig/network-scripts/ifcfg-eth0

3、重启检验

​	reboot

**iSCSI挂载（操作系统为深度deepin）**

1、修改IP地址

存储在32网段，现在环境为1网段

修改IP地址：vim /etc/network/interfaces

 	auto eth0                  #设置自动启动eth0接口

   	 	iface eth0 inet static     #配置静态IP

   		address 192.168.11.88      #IP地址

            	netmask 255.255.255.0      #子网掩码

    		gateway 192.168.11.1       #默认网关（注意：网关只能有一个）

dns的存放路径：/etc/resolv.conf

重启网络配置：/etc/init.d/networking restart（最好重启服务器）

2、挂载镜像（因为没有外网，所以得从镜像中下载相关软件包）

​	mount   -o  loop  .iso  /media/cdimage（挂载镜像）

​	umount  /media/cdimage(卸载镜像)

​	apt-cache search iscsi		搜索包

​	apt-get  install -y  iscsi		安装相关软件包

​	netstat  -a  |  grep  iscsi 		查看相关状态

​	systemctl  status  iscsid		查看运行状态

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/iSCSI/2.png)

3、查找存储对外提供的逻辑卷（有多个IP就查找多次）

​	 iscsiadm -m discovery -t sendtargets -p 存储IP:3260

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/iSCSI/3.png)

映射逻辑卷到系统中

​     iscsiadm -m node -T iqn.2004-01.com.storbridge:block01-wt -p 192.16.10.188:3260 -l

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/iSCSI/4.png)

设置开机自动映射

​     iscsiadm -m node -T iqn.2004-01.com.storbridge:block02-wt  -p 192.16.10.188:3260 --op update -n node.startup -v automatic

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/iSCSI/5.png)

删除已经存在的iSCSI信息

​     iscsiadm --mode node -o delete –targetnameiqn.2004-01.com.storbridge:block02-wt 192.16.10.188:3260

4、查看是否映射成功

​	lsblk

对映射出来的磁盘进行分区

添加分区

​	parted /dev/sdb   进入新添加的磁盘

​	mklabel  设置新的标签  标签类型 gpt和msdos

​	mkpart   分区编号、分区类型（xfs、ext4）、起点、终点

​	print 查看分区        （把整个磁盘分成一个分区 起点是0，终点-1）

​	q  退出

​	mkfs.xfs  /dev/sdb1  格式化

​	mount /dev/sdb1 /mnt  设置挂载点

​	vi /etc/fstab   

​		/dev/sdb1 /media/C ntfs ___netdev__ 0 0(**注意：iSCSI的默认类型为'_netdev'，不为defaults**)

这里的sdb对应你的分区，media对应要挂载到的目录，ntfs是分区的文件类型 

5、删除分区（完全的逆向操作）

![image](https://github.com/Lyz-github/work/blob/master/%E5%9B%BE%E7%89%87/iSCSI/6.png)

​	umount /dev/sdb1（或者  umount /mnt）

​	vi /etc/fstab  	删除开机自动挂载

​	parted /dev/sdb1   	进入磁盘

​	rm  + 编号  	删除分区
