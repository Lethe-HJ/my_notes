使用ansible分发脚本
`ansible openstack -m copy -a "src=/home/hujin/prepare.sh dest=/home/prepare.sh"`

使用ansible执行分发的脚本
`ansible openstack -m shell  -a "sh /home/prepare.sh chdir=/home"`


ens224.10(vlan10)
192.168.10.20/24