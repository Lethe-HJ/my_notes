#!/bin/bash
# ping一整个网段
#
# $1 表示网段 $2表示测试组数
function testip(){
    for var in {1..10};
    do
        num=`expr $var + $2 \* 10`
        if [ "$num" -lt 255 ];
        then
            ip=$1.$num
            ping -c 2 $ip >/dev/null 2>&1
            # echo -ne '\b\b'
            # echo "$num"
            if [ $? = 0 ];
            then
                echo "$num" >> used
            else
                echo "$num" >> unused
            fi
        fi
    done
}

# $1  # 网段

for (( i=0; i<=25; i++ ))
do
    {
        testip $1 $i
    } &  #将上述程序块放到后台执行
done
wait

echo "[used]" > testip.log
sort -n used >> testip.log
rm used
echo "[unused]" >> testip.log
sort -n unused >> testip.log
rm unused


# ping 192.168.1.1 | tee -a 22.log 同时输出到屏幕和22.log文件