#!/bin/bash
ips=(10.10.16.55
10.10.16.56
10.10.16.58
10.10.16.59
10.10.16.94
)

for i in ${ips[@]};
do
    ip="$i"
    # 添加公钥
    echo "--------------------------------------------------------------------"
    echo "[消息]：正在关闭{$ip}的selinux"
    ssh root@$ips "sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config;setenforce 0"
    if test $? -eq 0
    then
            echo "[消息]：关闭${ip}的selinux完成。"
    else
            echo "[消息]：关闭${ip}的selinux失败。"
    fi
done