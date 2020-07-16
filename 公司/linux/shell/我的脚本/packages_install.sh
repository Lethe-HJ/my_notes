#!/bin/bash
ips=(10.10.16.55
10.10.16.56
10.10.16.58
10.10.16.59
10.10.16.94)

packages=(
net-tools
vim
wget
)

for i in ${ips[@]};
do
    ip="$i"
    # 添加公钥
    echo "--------------------------------------------------------------------"
    echo "[消息]：操作{$ip}"
    echo "[消息]：安装openstack源"
    yum install centos-release-openstack-queens
    echo "[消息]：yum upgrade"
    yum upgrade
    for package in ${packages[@]};
    do
        echo "[消息]：${package}"
        yum install -y $package >> /dev/null
        if test $? -eq 0
        then
                echo "[消息]：安装"${package}"完成。"
        else
                echo "[消息]：安装"${package}"失败。"
        fi
    done
done