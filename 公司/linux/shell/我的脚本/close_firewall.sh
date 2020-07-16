#!/bin/bash
ips=(10.10.16.55
10.10.16.56
10.10.16.58
10.10.16.59
10.10.16.94)

for i in ${ips[@]};
do
    ip="$i"
    # 添加公钥
    echo "--------------------------------------------------------------------"
    echo "[消息]：正在关闭{$ip}的防火墙"
    ssh root@$ips "systemctl stop firewalld;stemctl disable firewalld;systemctl status  firewalld"
done