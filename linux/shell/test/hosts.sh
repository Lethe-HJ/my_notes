#!/bin/bash

for var in {1..32};
do
    scp /etc/hosts root@25.8.1.$var:/etc/hosts
    if [ $? = 0 ];
        then
            echo "[success] host of 25.8.1.$var copy success"
        else
            echo "[failure] host of 25.8.1.$var copy failure"
    fi
done