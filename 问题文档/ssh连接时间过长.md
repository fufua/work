##  问题：通过ssh连接虚拟机，大概需要10~20秒出现输入密码的对话框，但是可以连接



---
解决办法:关闭DNS反向解析
在linux中，默认就是开启了SSH的反向DNS解析,这个会消耗大量时间，因此需要关闭。
vi /etc/ssh/sshd_config
UseDNS no(默认为:UseDNS yes)
---
