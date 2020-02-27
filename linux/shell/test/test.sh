#!/bin/bash

package_li=(
gnocchi
ironic
ironic-ui
kcmp-xstatic
kcmp
keystonekeys
liclib
masakari-monitors
masakari
monasca-ui
neutron
python-cinderclient
python-keystonemiddleware
python-neutron-lib
python-neutronclient
python-novaclient
python-oslo.config
python-oslo.log
searchlight
)

package_li_len=${#package_li[@]}
echo $package_li_len
int=0
while( test $int -lt $package_li_len )
do
    package_name=${package_li[$int]}
    # 如果存在这个文件夹就删除它
    if test -e ./$package_name
    then
        rm -rf ./$package_name
    fi

    times=1
    # 克隆对应包的代码
    echo "[test.sh]:start to install $package_name" >> log
    git clone http://zhongshengping:lSUlxYQQYZgti+JAmVYlm05BBYl0gvlGn1PS0Qffnw@dev.kylincloud.me/gerrit/kylincloud/${package_name} >> log
    while( test $times -le 20) # 允许询问20次
    do
        if [ $? -eq 0 ] # 如果上一条执行完成
        then
            echo "[test.sh]:success install $package_name" >> log
            break
        else
            sleep 60 # 延时60秒
            echo "[test.sh]:it costs ${60\*$time}" >> log
        fi
        let "times++"
    done
    if [ $times -ge 20 ]
    then
        echo "[test.sh]:fail to install $package_name" >> log
    fi
    let "int++"
done