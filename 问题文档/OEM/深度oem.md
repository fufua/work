## 一、先查看前端和后端的版本号
#### 前端：https://控制器IP/build.txt(curl  https://控制器IP/build.txt)
#### 后端：csphere  version
## 二、更改logo和favicon图标
```
logo.png (注意,要根据实际情况查看图片名称，然后进行替换)
```
![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/logo.png)
```
注意：图片为450x200的svg矢量图,前景色需要浅色,方便在深色背景呈现.
```
favicon.png
```
![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/favicon.png)
```
注意：大小为：48x48或64x64
```
#### 在Controller控制节点上创建前端目录:mkdir /etc/csphere/frontend
```
将设置好的.png和.svg上传到前端目录下
```
## 三、深度oem
![image](https://github.com/lyz-970124/work/blob/master/%E5%9B%BE%E7%89%87/%E6%B7%B1%E5%BA%A6OEM.png)
```
cd /etc/csphere
vi oem.sh
chmod 777 oem.sh
./oem.sh brand product company
./oem.sh 易讯通 ECC 北京易讯通信息技术股份有限公司(要注意product是英文)
````
