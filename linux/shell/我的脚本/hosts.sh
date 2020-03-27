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
    echo "[消息]：正在拷贝"
    scp /etc/hosts root@$ip:/etc/hosts
    if test $? -eq 0
    then
            echo "[消息]：拷贝到"${ip}"完成。"
    else
            echo "[消息]：拷贝到"${ip}"失败。"
    fi
done