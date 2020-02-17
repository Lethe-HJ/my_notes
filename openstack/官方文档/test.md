本文介绍在ubuntu 16.04下单点安装Mitaka Nova的过程

步骤1：root身份进入mysql，创建两个数据库

CREATE DATABASE nova_api;

CREATE DATABASE nova;

       步骤2：依然在数据库中，创建nova用户并赋予权限，下面命令中自行设置一致的NOVA_DBPASS值，之后退出mysql

 GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost'  IDENTIFIED BY 'NOVA_DBPASS';

 GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';

 GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';

 GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';

步骤3：运行脚本. admin-openrc以保证接下来以admin身份运行命令

步骤4：创建nova用户：openstack user create --domain default --password-prompt nova

步骤5：nova用户赋予对service project的admin权限：openstack role add --project service --user nova admin

步骤6：创建nova服务：openstack service create --name nova --description "OpenStack Compute" compute

步骤7：国际惯例，为nova服务创建三个API URL，这三个URL仅类型不同

openstack endpoint create --region RegionOne \compute public http://controller:8774/v2.1/%tenantidtenantids

openstack endpoint create --region RegionOne \compute internal http://controller:8774/v2.1/%tenantidtenantids

openstack endpoint create --region RegionOne \compute admin http://controller:8774/v2.1/%tenantidtenantids

步骤8：安装nova服务所有安装包

apt-get install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler

步骤9：编辑或创建文件 /etc/nova/nova.conf，在我机器上是没有这个文件的，得自行创建，添加或修改内容如下

[DEFAULT]
 enabled_apis = osapi_compute,metadata
 rpc_backend = rabbit
 auth_strategy = keystone
 my_ip = 192.168.1.110 #enp3s0的IP地址
 use_neutron = True
 firewall_driver = nova.virt.firewall.NoopFirewallDriver

#logdir=/var/log/nova 一定要将这个注释掉



[api_database]
connection = mysql+pymysql://nova:YOURPASSWORD@controller/nova_api

[database]
connection = mysql+pymysql://nova:YOURPASSWORD@controller/nova

[oslo_messaging_rabbit]
rabbit_host = controller
rabbit_userid = openstack
rabbit_password = YOURPASSWORD #环境配置时安装rabbitmq时创建的openstack用户名密码

      

[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = YOURPASSWORD



[vnc]
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip



[oslo_concurrency]
lock_path = /var/lib/nova/tmp

   

步骤10：同步数据库

chown :nova /etc/nova/nova.conf # 给nova这个文件的权限
重启nova

su -s /bin/sh -c "nova-manage api_db sync" nova

su -s /bin/sh -c "nova-manage db sync" nova

步骤11：重启服务

service nova-api restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

步骤12：如果是分布式安装，安装官网文档，对另一台作为compute节点的机器再进行一系列配置。但是单节点安装中，直接在controller所在机器继续进行compute节点配置。

安装：apt-get install nova-compute

步骤13：再次打开/etc/nova/nova.conf进行修改

官网安装文档中，compute节点nova.conf文件中的[vnc]段落内容如下

[vnc]

enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html

而在刚才步骤9中，我们将[vnc]写成这样

        [vnc]
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip

可以看到，两个配置中vncserver_listen值不一样，于是我最终将[vnc]写成了这样：

[vnc]
#vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html



继续，添加glance段落

[glance]
api_servers = http://controller:9292

步骤14：测试机器能否支持虚拟机硬件加速，运行命令egrep -c '(vmx|svm)' /proc/cpuinfo，返回值大于0则什么也不做，反之，在/etc/nova/nova-compute.conf文件的[libvirt]中设置virt_type = qemu；

步骤15：重启服务 service nova-compute restart

步骤16：验证一下，admin用户身份运行 openstack compute service list，显示如下信息。注意，zopen是我controller所在主机的hostname。因为是单点安装，下面四个服务都显示运行在zopen Host上。
