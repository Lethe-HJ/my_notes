#!/bin/bash
hostnamepath="./hosts"
network="192.168.1"
begin=30
end=35
host_str="cat $hostnamepath"

ips=$(seq $begin $end)

for i in $ips;
do
    ip="$network.$i"
    ssh root@$ip "echo $host_str >> /etc/hostsname"
    if [ $? = 0 ];
        then
            echo "[success] add hostsname of $ip success"
        else
            echo "[failure] add hostsname of $ip failure"
    fi
done