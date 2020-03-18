#!/bin/bash

for var in {1..32};
do
    #scp /etc/ssh/ssh_config root@25.8.1.$var:/etc/ssh/ssh_config
    #ssh root@25.8.1.$var "service sshd restart"
    echo 25.8.1.$var
done
