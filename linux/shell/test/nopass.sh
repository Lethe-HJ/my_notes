#!/bin/bash
for i in `seq 1 32`
do 
  scp -r .ssh 25.8.1.$i:~/
  ssh 25.8.1.$i " cd /root/.ssh ; chown -R root:root ..;ls "
done
