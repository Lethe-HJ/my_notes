#!/bin/bash

# network="192.168.1"
# begin=30
# end=35

# ips=$(seq $begin $end)
ips=(10.10.16.55
10.10.16.56
10.10.16.58
10.10.16.59
10.10.16.94)

for i in ${ips[@]};
do
    ip="$i"
    # 添加公钥
    echo "操作$ip"
    echo "添加公钥到: ssh-copy-id -i ~/.ssh/id_rsa.pub $ip"
    ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
    # 设置权限
    #echo "设置~/.ssh权限： ssh $ip "cd /root/.ssh ; chown -R root:root ..""
    #ssh $ip "cd /root/.ssh ; chown -R root:root .."
    # 配置
    # echo "拷贝并覆盖/etc/ssh/ssh_config"
    # scp /etc/ssh/ssh_config root@$ip:/etc/ssh/ssh_config
    # echo "重启sshd"
    # ssh root@$ip "service sshd restart"
done

for i in ${ips[@]};
do
    ip="$i"
    # 添加公钥
    echo "操作$ip"
    # 拷贝整个.ssh文件夹
    echo "拷贝.ssh文件夹到: scp -r ~/.ssh $ip:~/"
    scp -r ~/.ssh $ip:~/
done