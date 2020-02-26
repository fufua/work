### Agent计算节点添加

##### 准备工作

​			设置主机名：	

​					echo "node1"  >  /etc/hostname

​			关闭seLinux

​					setenforce  0

​					sed   -i   '/^SELINUX=/cSELINUX=disabled'   /etc/selinux/config

​			调整硬件时钟，避免容器uptime less than a second问题

​					timedatectl    set-local-rtc   1

​			关闭防火墙

​					systemctl  stop   firewalld

​					systemctl   disable   firewalld

​			关闭NetworkManager

​					systemctl   stop   NetworkManager

​					systemctl   disable   NetworkManager

##### 安装依赖包和4.14 lts内核

​			删除libvirtd和dnsmasq，如果有的话

​					yum  remove  -y  libvirt-daemon  dnsmasq

​			安装csphere  yum   repo

​					curl -Ss https://download.csphere.cn/public/yum/centos/7/x86_64/csphere.repo > /etc/yum.repos.d/csphere.repo

​					yum repolist csphere

​			安装依赖的软件包

​					yum -y --disablerepo='csphere' install bridge-utils net-tools psmisc subversion git fuse ntp rng-tools bash-completion linux-firmware

​			安装4.14内核

​					yum -y --disablerepo='*' --enablerepo=csphere install kernel-lts iproute

​			使用新内核启动

​					grub2-set-default 0

​					reboot

​			重启完成后，通过`uname -r` 查看内核版本是不是4.14

##### Docker数据分区LVM卷管理

​			假设分区设备名为/dev/sdc,大小为300G,创建LVM操作如下：	

​					初始化磁盘

​							dd  if=/dev/vdc  of=/dev/vdc  bs=512  count=1

​					创建物理卷（PV）

​							pvcreate /dev/vdc

​					创建并加入卷组（VG）

​							vgcreate vg_docker /dev/vdc

​					分配卷组中300G创建逻辑卷（LV）

​							lvcreate   -L   1G  -n   lv_docker   vg_docker

​					使用所有空间扩容逻辑卷（LV）

​							lvextend -l +100%FREE /dev/vg_docker/lv_docker								

​					格式化LV

​							mkfs.xfs -n ftype=1 /dev/vg_docker/lv_docker

​							mkdir  /data

​					挂载磁盘到/data目录下（说明：尽量使用UUID来挂载磁盘，防止重启后设备名变化导致系统无法启动,可以通过目录/dev/disk/by-uuid或tune2fs命令查看对应设备的UUID.）

```
			UUID=`blkid /dev/vg_docker/lv_docker  |awk '{print $2}' |cut -d'"' -f2`
			echo   "UUID=$UUID  /data  xfs  defaults,prjquota  0  0"   >> /etc/fstab
			mount /data
            mkdir -p /data/docker /data/etcd2
			ln -sv /data/docker /var/lib/docker
			ln -sv /data/etcd2 /var/lib/etcd2
		后续扩展LVM逻辑卷（假设新添加磁盘名字为vdd:如果需要对磁盘分区,请更改磁盘类行为8e(LVM)）
			初始化一下磁盘，保证磁盘中无数据影响。
				dd if=/dev/vdd of=/dev/sdd bs=512 count=1
			创建pv
				pvcreate /dev/vdd
			加入vg
				vgextend vg_docker /dev/vdd
			扩容lv
				lvextend -l +100%FREE /dev/vg_docker/lv_docker
			重新读区磁盘信息
				xfs_growfs /dev/vg_docker/lv_docker
			查看扩容是否成功
				df -hT
```

##### 添加Agent						

​		先将agent的rpm包拷贝到要添加为agent节点的机器上

​			rpm   -ivh   csphere-agent-***-rhel7.x86_64.rpm

##### 初始化Agent参数

​		Role=agent ControllerAddr=10.1.1.2:80 InstCode=6906 NetMode=ipvlan InetDev=eth0 csphere_init

​			参数说明：

​				ControllerAddr：主控中心的地址:端口.

​				InstCode：安装码, 到主控中心页面上生成

​				NetMode：Docker容器网络模式, ipvlan或bridge

​				InetDev：物理网卡名，比如eth0

##### 启动Agent

​		cspherectl   start 

​			过一会儿就可以在主控页面上看到节点上线

##### 设置容器使用的IP地址范围

​		根据实际IP范围设定容器的IP地址池分配

​				net-plugin ip-range  --ip-start=192.168.51.2/24 --ip-end=192.168.51.10/24

​		验证结果（里面的2-100的地址）

​				etcdctl ls  /csphere/network/192.168.51.0/pool

