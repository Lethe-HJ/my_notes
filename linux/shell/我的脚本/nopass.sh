#!/bin/bash

network="192.168.1"
begin=30
end=35

ips=$(seq $begin $end)
for i in $ips;
do
  ip="$network.$i"
  # 添加公钥
  echo "操作$ip"
  echo "添加公钥到: ssh-copy-id -i ~/.ssh/id_rsa.pub $ip"
  ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
  # 拷贝整个.ssh文件夹
  echo "拷贝.ssh文件夹到: scp -r ~/.ssh $ip:~/"
  scp -r ~/.ssh $ip:~/
  # 设置权限
  echo "设置~/.ssh权限： ssh $ip "cd /root/.ssh ; chown -R root:root ..""
  ssh $ip "cd /root/.ssh ; chown -R root:root .."
  # 配置
  echo "拷贝并覆盖/etc/ssh/ssh_config"
  scp /etc/ssh/ssh_config root@$ip:/etc/ssh/ssh_config
  echo "重启sshd"
  ssh root@$ip "service sshd restart"
done
