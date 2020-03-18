#!/bin/bash

for var in {1..32};
do
    if [ $var -lt 4 ];
    then
        name=controller
    else
        name=node
    fi
    ssh root@25.8.1.$var "echo $name$var > /etc/hostname;reboot"
    if [ $? = 0 ];
        then
            echo "[success] hostname of 25.8.1.$var modified success"
        else
            echo "[failure] hostname of 25.8.1.$var modified failure"
    fi
done