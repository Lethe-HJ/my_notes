## npm 设置淘宝镜像

### 安装cnpm

`npm install -g cnpm --registry=https://registry.npm.taobao.org`

在linux下还需设置软连接

`sudo ln -s /usr/local/node/bin/cnpm /usr/local/bin/cnpm`

或者
`npm config set registry https://registry.npm.taobao.org`



查看当前镜像url

`npm config get registry`

