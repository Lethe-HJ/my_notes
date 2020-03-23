
## 节点规划

192.168.80.246 control1
192.168.80.247 compute1

## 网络配置
`[root@controller01 /]# cat /etc/sysconfig/network-scripts/ifcfg-ens3`

    TYPE="Ethernet"
    PROXY_METHOD="none"
    BROWSER_ONLY="no"
    BOOTPROTO=static
    DEFROUTE="yes"
    IPV4_FAILURE_FATAL="yes"
    IPV6INIT="yes"
    IPV6_AUTOCONF="yes"
    IPV6_DEFROUTE="yes"
    IPV6_FAILURE_FATAL="no"
    IPV6_ADDR_GEN_MODE="stable-privacy"
    NAME="ens3"
    UUID="e9b5f9c7-3a0a-49b6-a4cc-709ca88f414c"
    DEVICE="ens3"
    ONBOOT="yes"
    IPADDR="192.168.80.246"
    PREFIX="16"
    GATEWAY="192.168.1.254"
    IPV6_PRIVACY="no"
    DNS1="223.5.5.5"

`[root@controller01 /]# cat /etc/sysconfig/network-scripts/ifcfg-ens8`

```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens8
DEVICE=ens8
ONBOOT=yes
IPADDR=0.0.0.0
```

compute1进行类似配置(但 ifcfg-ens3中IPADDR="192.168.80.246")

## hosts配置

`[root@controller01 ~]# cat /etc/hosts`

    127.0.0.1 localhost
    192.168.80.246 control1
    192.168.80.247 compute1

拷贝到compute01节点

`scp /etc/hosts root@compute01:/etc/hosts`

## 配置免密登录


## 启用OpenStack存储库

`$ yum install centos-release-openstack-queens`

`$ yum upgrade`

`$ yum install python-openstackclient`

`$ yum install openstack-selinux`

## 安装mysql

在control1中 安装mysql

`yum install mariadb mariadb-server python2-PyMySQL`

`$ vi /etc/my.cnf.d/openstack.cnf`

    [mysqld]
    bind-address = 192.168.1.30

    default-storage-engine = innodb
    innodb_file_per_table = on
    max_connections = 4096
    collation-server = utf8_general_ci
    character-set-server = utf8

`$ systemctl enable mariadb.service`
`$ systemctl start mariadb.service`

`$ mysql_secure_installation`

## 安装rabbitmq-server

`yum install rabbitmq-server`

`systemctl enable rabbitmq-server.service`
`systemctl start rabbitmq-server.service`
`rabbitmqctl add_user openstack RABBIT_PASS`

`rabbitmqctl set_permissions openstack ".*" ".*" ".*"`

## 安装memcached

`yum install memcached python-memcached`

vi /etc/sysconfig/memcached

    OPTIONS="-l 127.0.0.1,::1,control1"

`systemctl enable memcached.service`
`systemctl start memcached.service`

## Etcd

`yum install etcd`
`vi /etc/etcd/etcd.conf`

```
#[Member]
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="http://192.168.80.246:2380"
ETCD_LISTEN_CLIENT_URLS="http://192.168.80.246:2379"
ETCD_NAME="controller"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.80.246:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.80.246:2379"
ETCD_INITIAL_CLUSTER="controller=http://192.168.80.246:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER_STATE="new"
```

`systemctl enable etcd`
`systemctl start etcd`



## 安装keystone

`mysql -u root -p`
`CREATE DATABASE keystone;`
`GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'hujin666';`

`yum install openstack-keystone httpd mod_wsgi`

`vi  /etc/keystone/keystone.conf`

    [database]
    # ...
    connection = mysql+pymysql://keystone:hujin666@control1/keystone

    #...

    [token]
    # ...
    provider = fernet

`su -s /bin/sh -c "keystone-manage db_sync" keystone`

`keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone`

`keystone-manage credential_setup --keystone-user keystone --keystone-group keystone`

    keystone-manage bootstrap --bootstrap-password hujin666 \
    --bootstrap-admin-url http://control1:5000/v3/ \
    --bootstrap-internal-url http://control1:5000/v3/ \
    --bootstrap-public-url http://control1:5000/v3/ \
    --bootstrap-region-id RegionOne

设置apache中的ServerName

`vi /etc/httpd/conf/httpd.conf`

    ServerName control1

创建链接
`ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/`

设置apache开机自启，并开启apache

`systemctl enable httpd.service`
`systemctl start httpd.service`

`$ export OS_USERNAME=admin`
`$ export OS_PASSWORD=hujin666`
`$ export OS_PROJECT_NAME=admin`
`$ export OS_USER_DOMAIN_NAME=Default`
`$ export OS_PROJECT_DOMAIN_NAME=Default`
`$ export OS_AUTH_URL=http://control1:5000/v3`
`$ export OS_IDENTITY_API_VERSION=3`


`openstack domain create --description "An Example Domain" example`

`openstack project create --domain default --description "Service Project" service`

`openstack project create --domain default --description "Demo Project" demo`

`openstack user create --domain default --password-prompt demo`

`openstack role create user`

`openstack role add --project demo --user demo user`


`unset OS_AUTH_URL OS_PASSWORD`

`openstack --os-auth-url http://control1:35357/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name admin --os-username admin token issue`


`openstack --os-auth-url http://control1:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name demo --os-username demo token issue`

`vi admin-openrc`

    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD=ADMIN_PASS
    export OS_AUTH_URL=http://control1:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

`vi demo-openrc`

    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=demo
    export OS_USERNAME=demo
    export OS_PASSWORD=hujin666
    export OS_AUTH_URL=http://control1:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

`. admin-openrc`

`openstack token issue`

## 安装glance

mysql -u root -p

CREATE DATABASE glance;

`GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'hujin666';`

`openstack user create --domain default --password-prompt glance`

`openstack role add --project service --user glance admin`

`openstack service create --name glance --description "OpenStack Image" image`


`openstack endpoint create --region RegionOne image public http://control1:9292`


`openstack endpoint create --region RegionOne image internal http://control1:9292`


`openstack endpoint create --region RegionOne image admin http://control1:9292`

`yum install openstack-glance`

`vi /etc/glance/glance-api.conf`

    [database]
    # ...
    connection = mysql+pymysql://glance:hujin666@control1/glance

    # ...
    [keystone_authtoken]
    # ...
    auth_uri = http://control1:5000
    auth_url = http://control1:5000
    memcached_servers = control1:11211
    auth_type = password
    project_domain_name = Default
    user_domain_name = Default
    project_name = service
    username = glance
    password = hujin666

    [paste_deploy]
    # ...
    flavor = keystone

    #...
    [glance_store]
    # ...
    stores = file,http
    default_store = file
    filesystem_store_datadir = /var/lib/glance/images/

`vi /etc/glance/glance-registry.conf`

    [database]
    # ...
    connection = mysql+pymysql://glance:hujin666@control1/glance

    #...

    [keystone_authtoken]
    # ...
    auth_uri = http://control1:5000
    auth_url = http://control1:5000
    memcached_servers = control1:11211
    auth_type = password
    project_domain_name = Default
    user_domain_name = Default
    project_name = service
    username = glance
    password = hujin666

    [paste_deploy]
    # ...
    flavor = keystone

`su -s /bin/sh -c "glance-manage db_sync" glance`


`systemctl enable openstack-glance-api.service openstack-glance-registry.service`

`systemctl start openstack-glance-api.service openstack-glance-registry.service`


## 安装nova

### 在control1节点上安装

`mysql -u root -p`

`CREATE DATABASE nova_api;`
`CREATE DATABASE nova;`
`CREATE DATABASE nova_cell0;`

`GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'hujin666';`


`GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'hujin666';`

`. admin-openrc`

`openstack user create --domain default --password-prompt nova`

`openstack role add --project service --user nova admin`

`openstack service create --name nova --description "OpenStack Compute" compute`

`openstack endpoint create --region RegionOne compute public http://control1:8774/v2.1`

`openstack endpoint create --region RegionOne compute internal http://control1:8774/v2.1`

`openstack endpoint create --region RegionOne compute admin http://control1:8774/v2.1`

`openstack user create --domain default --password-prompt placement`

`openstack role add --project service --user placement admin`


`openstack service create --name placement --description "Placement API" placement`


`openstack endpoint create --region RegionOne placement public http://control1:8778`


`openstack endpoint create --region RegionOne placement internal http://control1:8778`

`openstack endpoint create --region RegionOne placement admin http://control1:8778`


`yum install openstack-nova-api openstack-nova-conductor  openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler openstack-nova-placement-api`

`vi /etc/nova/nova.conf`

```
[DEFAULT]
# ...
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:hujin666@control1
my_ip = 192.168.80.246
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver



[api_database]
# ...
connection = mysql+pymysql://nova:hujin666@control1/nova_api

[database]
# ...
connection = mysql+pymysql://nova:hujin666@control1/nova


[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_url = http://control1:5000/v3
memcached_servers = control1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = hujin666

[vnc]
enabled = true
# ...
server_listen = $my_ip
server_proxyclient_address = $my_ip

[glance]
# ...
api_servers = http://control1:9292

[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp

[placement]
# ...
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://control1:5000/v3
username = placement
password = hujin666
```

`vi /etc/httpd/conf.d/00-nova-placement-api.conf`

    <Directory /usr/bin>
    <IfVersion >= 2.4>
        Require all granted
    </IfVersion>
    <IfVersion < 2.4>
        Order allow,deny
        Allow from all
    </IfVersion>
    </Directory>

`systemctl restart httpd`

`su -s /bin/sh -c "nova-manage api_db sync" nova`

`su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova`

`su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova`

`su -s /bin/sh -c "nova-manage db sync" nova`

`nova-manage cell_v2 list_cells`

```
systemctl enable openstack-nova-api.service \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \
openstack-nova-conductor.service openstack-nova-novncproxy.service
```

```
systemctl start openstack-nova-api.service \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \
openstack-nova-conductor.service openstack-nova-novncproxy.service
```
### 在compute1节点上安装

`yum install openstack-nova-compute`

`vi /etc/nova/nova.conf`

```
[DEFAULT]
# ...
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:hujin666@control1
my_ip = 192.168.80.247
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_url = http://control1:5000/v3
memcached_servers = control1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = hujin666

[vnc]
# ...
enabled = True
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://control1:6080/vnc_auto.html

[glance]
# ...
api_servers = http://control1:9292

[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp

[placement]
# ...
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://control1:5000/v3
username = placement
password = hujin666
```

`egrep -c '(vmx|svm)' /proc/cpuinfo`

`vi /etc/nova/nova.conf`

```
[libvirt]
# ...
virt_type = qemu
```

`systemctl enable libvirtd.service openstack-nova-compute.service`
`systemctl start libvirtd.service openstack-nova-compute.service`

`. admin-openrc`

`openstack compute service list --service nova-compute`

`su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova`



## neutron

`mysql -u root -p`

`CREATE DATABASE neutron;`

`GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'hujin666';`

`. admin-openrc`

`openstack user create --domain default --password-prompt neutron`

`openstack role add --project service --user neutron admin`

`openstack service create --name neutron --description "OpenStack Networking" network`

`openstack endpoint create --region RegionOne network public http://control1:9696`

`openstack endpoint create --region RegionOne network internal http://control1:9696`

`openstack endpoint create --region RegionOne network admin http://control1:9696`

`vi /etc/neutron/metadata_agent.ini`

```
[DEFAULT]
# ...
nova_metadata_host = controller
metadata_proxy_shared_secret = hujin666

```

`vi /etc/nova/nova.conf file`
```
[neutron]
# ...
url = http://control1:9696
auth_url = http://control1:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = hujin666
service_metadata_proxy = true
metadata_proxy_shared_secret = hujin666
```


`ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini`

`su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron`

`systemctl restart openstack-nova-api.service`

`systemctl enable neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service`

`systemctl start neutron-server.service neutron-linuxbridge-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service`

`systemctl enable neutron-l3-agent.service`

`systemctl start neutron-l3-agent.service`