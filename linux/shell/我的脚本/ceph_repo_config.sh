#!/bin/bash
ips=(
10.10.16.55
10.10.16.56
10.10.16.58
10.10.16.59
10.10.16.94
)

function success_msg(){
    if test $1 -eq 0
    then
            echo "[消息]：命令执行成功。"
    else
            echo "[消息]：命令执行失败。"
    fi
}

for i in ${ips[@]};
do
    ip="$i"
    # 添加公钥
    echo "--------------------------------------------------------------------"
    echo "[消息]：正在配置{$ip}的ceph源"
    echo "[消息]：正在执行命令：ssh root@$ip 'yum clean all;mkdir /mnt/bak;mv /etc/yum.repos.d/* /mnt/bak/'"
    ssh root@$ip "yum clean all;mkdir -p /mnt/bak;mv /etc/yum.repos.d/* /mnt/bak/"
    success_msg $?

    echo "[消息]：正在执行命令： ssh root@{$ips} wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo"
    ssh root@$ip "wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo"
    success_msg $?

    echo "[消息]：正在执行命令： wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo"
    ssh root@$ip "wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo"
    success_msg $?

    echo "[消息]：正在执行命令： scp ./ceph.repo root@$ip:/etc/yum.repos.d/ceph.repo"
    scp ./ceph.repo root@$ip:/etc/yum.repos.d/ceph.repo
    success_msg $?

    echo "[消息]：正在给{$ip}创建cephuser用户"

    echo "[消息]：正在执行命令： useradd -d /home/cephuser -m cephuser"
    ssh root@$ip "useradd -d /home/cephuser -m cephuser"
    success_msg $?

    echo "[消息]：正在执行命令： echo 'cephuser'|passwd --stdin cephuser"
    ssh root@$ip "echo 'cephuser'|passwd --stdin cephuser"
    success_msg $?
    
    echo "[消息]：正在执行命令： echo 'cephuser ALL = (root) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/cephuser"
    ssh root@$ip "echo 'cephuser ALL = (root) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/cephuser"
    success_msg $?
    
    echo "[消息]：正在执行命令： chmod 0440 /etc/sudoers.d/cephuser"
    ssh root@$ip "chmod 0440 /etc/sudoers.d/cephuser"
    success_msg $?
    
    echo "[消息]：正在执行命令： sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers"
    ssh root@$ip "sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers"
    success_msg $?
done


