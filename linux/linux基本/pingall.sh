#!/bin/bash

#加载functions,action需要用到

. /etc/init.d/functions

#for循环网段1-254

for var in {1..254};

do

#定义变量IP

ip=172.21.0.$var

#ping的信息不要显示在屏幕

ping -c2 $ip >/dev/null 2>&1

if [ $? = 0 ];then

#如果ping成功显示OK

 action "$ip" /bin/true

else

#如果ping不成功显示FAILED 

 action "$ip" /bin/false

fi

done