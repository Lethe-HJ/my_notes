#!/bin/bash
:<<EOF
执行脚本的本机为 192.168.1.30 controller01
在本地文件夹下新建下按照/etc/hostname的格式新建hosts文件，如：

192.168.1.31 controller02
192.168.1.32 controller03
192.168.1.33 compute01
192.168.1.34 compute02
192.168.1.35 kolla

注意 最好不要包括主机(192.168.1.30和127.0.0.1)
即使想包含本机 也要 放在最后一行 否则 因为会重启导致后面的脚本不执行
如果需要的话 建议最好手动修改本机的hostname 
你也可以直接拷贝 配置好的 /etc/hosts 文件为 ./hosts 然后进行修改
EOF

hostnamepath="./hosts"
i=1
for line in `cat $hostnamepath`;
do
    if [ `expr $i % 2` -eq 1 ];
    then
        ip=$line
    else
        echo "操作$ip"
        echo "修改/etc/hostname: ssh root@$ip 'echo $line > /etc/hostname'"
        ssh root@$ip "echo $line > /etc/hostname"
        echo "重启目标机器 ssh root@$ip 'reboot'"
        ssh root@$ip "reboot"
    fi
    let "i++"
done
