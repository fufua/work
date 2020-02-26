# 问题：分配容器IP地址池时，IP地址池的IP与平台的IP地址在不同网段

## 1、在工作节点上添加另一块网卡

## 2、编辑/bin/csphere_init文件

```
将/bin/csphere_init文件进行备份，然后将'hellocsphere'替换为'prod-192-168-51'
   cp /bin/csphere_init /mnt
   sed -i 's/hellocsphere/prod-192-168-51/g' /bin/csphere_init
```

![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/csphere_init.png)

## 3、编辑/etc/csphere/csphere-prepare.bash文件

```
将/etc/csphere/csphere-prepare.bash进行备份，然后添加一行'/storage-driver/a dockerCommonOpts="$dockerCommonOpts --bip=192.168.51.1/24"'
   cp /etc/csphere/csphere-prepare.bash /mnt//etc/csphere/csphere-prepare.bash
   sed -i '/storage-driver/a dockerCommonOpts="$dockerCommonOpts --bip=192.168.51.1/24"' /etc/csphere/csphere-prepare.bash
```

![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/csphere-prepare.png)

## 4、修改网络

```
初始化ens37网络
   cat > /etc/sysconfig/network-scripts/ifcfg-ens37 <<EOF
   TYPE=Ethernet
   IPV6INIT=no
   NAME=ens37
   DEVICE=ens37
   ONBOOT=yes
   NM_CONTROLLED=no
   EOF
   ifup ens37
```

## 5、修改ipvlan配置

```
将/etc/csphere/csphere-docker-agent-after.bash文件备份，修改ipvlan那一部分配置
   cp /etc/csphere/csphere-docker-agent-after.bash /mnt/csphere-docker-agent-after.bash
   if [ "${COS_NETMODE}" == "ipvlan" ]; then
        docker network inspect ipvlan >/dev/null 2>&1 && exit 0
        netdev=ens37
        subnet=192.168.51.0/24
        defaultgw=192.168.51.254
        if [[ "${docker_version}" =~ "1.9." ]]; then
                docker network create -d ipvlan \
                --ipam-driver=csphere \
                --subnet=$subnet \
                --gateway=$defaultgw \
                -o master_interface=$COS_INETDEV ipvlan
        else
                docker network create -d ipvlan \
                --ipam-driver=csphere \
                --subnet=$subnet \
                --gateway=$defaultgw \
                -o parent=$netdev \
                -o ipvlan_mode=l2 ipvlan
        fi
        exit 0
   fi
```

![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/csphere-docker-agent-after.png)

## 6、重启csphere平台

```
   cspherectl restart
```
