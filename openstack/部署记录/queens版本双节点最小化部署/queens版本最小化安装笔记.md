
## 启用OpenStack存储库

`$ yum install centos-release-openstack-queens`

`$ yum upgrade`

`$ yum install python-openstackclient`

`$ yum install openstack-selinux`

## 安装mysql

在control1中 安装mysql

`yum install mariadb mariadb-server python2-PyMySQL`

`$ vim /etc/my.cnf.d/openstack.cnf`

    [mysqld]
    bind-address = 192.168.80.248

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

vim /etc/sysconfig/memcached

    OPTIONS="-l 127.0.0.1,::1,control1"

`systemctl enable memcached.service`
`systemctl start memcached.service`

## Etcd

`yum install etcd`
`vim /etc/etcd/etcd.conf`

```
#[Member]
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="http://192.168.80.248:2380"
ETCD_LISTEN_CLIENT_URLS="http://192.168.80.248:2379"
ETCD_NAME="control1"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.80.248:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.80.248:2379"
ETCD_INITIAL_CLUSTER="controller=http://192.168.80.248:2380"
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

`vim  /etc/keystone/keystone.conf`

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

`vim /etc/httpd/conf/httpd.conf`

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

`vim admin-openrc`

    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD=ADMIN_PASS
    export OS_AUTH_URL=http://control1:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2

`vim demo-openrc`

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

### 验证

`unset OS_AUTH_URL OS_PASSWORD`

`openstack --os-auth-url http://control1:35357/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name admin --os-username admin token issue`

+------------+-----------------------------------------------------------------+
| Field      | Value                                                           |
+------------+-----------------------------------------------------------------+
| expires    | 2016-02-12T20:14:07.056119Z                                     |
| id         | gAAAAABWvi7_B8kKQD9wdXac8MoZiQldmjEO643d-e_j-XXq9AmIegIbA7UHGPv |
|            | atnN21qtOMjCFWX7BReJEQnVOAj3nclRQgAYRsfSU_MrsuWb4EDtnjU7HEpoBb4 |
|            | o6ozsA_NmFWEpLeKy0uNn_WeKbAhYygrsmQGA49dclHVnz-OMVLiyM9ws       |
| project_id | 343d245e850143a096806dfaefa9afdc                                |
| user_id    | ac3377633149401296f6c0d92d79dc16                                |
+------------+-----------------------------------------------------------------+

`openstack --os-auth-url http://control1:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name demo --os-username demo token issue`

+------------+-----------------------------------------------------------------+
| Field      | Value                                                           |
+------------+-----------------------------------------------------------------+
| expires    | 2016-02-12T20:15:39.014479Z                                     |
| id         | gAAAAABWvi9bsh7vkiby5BpCCnc-JkbGhm9wH3fabS_cY7uabOubesi-Me6IGWW |
|            | yQqNegDDZ5jw7grI26vvgy1J5nCVwZ_zFRqPiz_qhbq29mgbQLglbkq6FQvzBRQ |
|            | JcOzq3uwhzNxszJWmzGC7rJE_H0A_a3UFhqv8M4zMRYSbS2YF0MyFmp_U       |
| project_id | ed0b60bf607743088218b0a533d5943f                                |
| user_id    | 58126687cbcc4888bfa9ab73a2256f27                                |
+------------+-----------------------------------------------------------------+

## 安装glance

`mysql -u root -p`

`CREATE DATABASE glance;`

`GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'hujin666';`

`openstack user create --domain default --password-prompt glance`

`openstack role add --project service --user glance admin`

`openstack service create --name glance --description "OpenStack Image" image`


`openstack endpoint create --region RegionOne image public http://control1:9292`


`openstack endpoint create --region RegionOne image internal http://control1:9292`


`openstack endpoint create --region RegionOne image admin http://control1:9292`

`yum install openstack-glance`

`vim /etc/glance/glance-api.conf`

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

`vim /etc/glance/glance-registry.conf`

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

### 验证

`. admin-openrc`

`wget https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img`

`openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public`


+------------------+------------------------------------------------------+
| Field            | Value                                                |
+------------------+------------------------------------------------------+
| checksum         | 133eae9fb1c98f45894a4e60d8736619                     |
| container_format | bare                                                 |
| created_at       | 2015-03-26T16:52:10Z                                 |
| disk_format      | qcow2                                                |
| file             | /v2/images/cc5c6982-4910-471e-b864-1098015901b5/file |
| id               | cc5c6982-4910-471e-b864-1098015901b5                 |
| min_disk         | 0                                                    |
| min_ram          | 0                                                    |
| name             | cirros                                               |
| owner            | ae7a98326b9c455588edd2656d723b9d                     |
| protected        | False                                                |
| schema           | /v2/schemas/image                                    |
| size             | 13200896                                             |
| status           | active                                               |
| tags             |                                                      |
| updated_at       | 2015-03-26T16:52:10Z                                 |
| virtual_size     | None                                                 |
| visibility       | public                                               |
+------------------+------------------------------------------------------+

`openstack image list`

+--------------------------------------+--------+--------+
| ID                                   | Name   | Status |
+--------------------------------------+--------+--------+
| 38047887-61a7-41ea-9b49-27987d5e8bb9 | cirros | active |
+--------------------------------------+--------+--------+


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

`vim /etc/nova/nova.conf`

```
[DEFAULT]
# ...
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:hujin666@control1
my_ip = 192.168.80.248
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

`vim /etc/httpd/conf.d/00-nova-placement-api.conf`

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
systemctl restart openstack-nova-api.service \
openstack-nova-consoleauth.service openstack-nova-scheduler.service \
openstack-nova-conductor.service openstack-nova-novncproxy.service
```
### 在compute1节点上安装

`yum install openstack-nova-compute`

`vim /etc/nova/nova.conf`

```
[DEFAULT]
# ...
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:hujin666@control1
my_ip = 192.168.80.248
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

`vim /etc/nova/nova.conf`

```
[libvirt]
# ...
virt_type = qemu
```

`systemctl enable libvirtd.service`
`systemctl enable openstack-nova-compute.service`
`systemctl start libvirtd.service openstack-nova-compute.service`

如果一直在等待状态的话，可能是control1的5672端口没有开放
`cat /var/log/nova/nova-compute.log`
在control1上执行

`firewall-cmd --zone=public --add-port=5672/tcp --permanent`
<!-- `firewall-cmd --zone=public --add-port=5672/udp --permanent` -->
`firewall-cmd --reload`

在control1上运行以下命令

`. admin-openrc`

`nova-manage cell_v2 discover_hosts`  注册这个新的计算节点

`openstack compute service list --service nova-compute`

`su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova`



## neutron

### 在control1中

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

`yum install -y openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables`

`vim /etc/neutron/neutron.conf`

```
[database]
# ...
connection = mysql+pymysql://neutron:hujin666@control1/neutron

[DEFAULT]
# ...
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
transport_url = rabbit://openstack:hujin666@control1
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[keystone_authtoken]
# ...
auth_uri = http://control1:5000
auth_url = http://control1:35357
memcached_servers = control1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = hujin666



[nova]
# ...
auth_url = http://control1:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = hujin666

[oslo_concurrency]
# ...
lock_path = /var/lib/neutron/tmp

```

`vim /etc/neutron/plugins/ml2/ml2_conf.ini`

```
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security

[ml2_type_flat]
# ...
flat_networks = ens9

[securitygroup]
# ...
enable_ipset = true

```

`vim /etc/neutron/plugins/ml2/linuxbridge_agent.ini`

```
[linux_bridge]
physical_interface_mappings = provider:ens9

[vxlan]
enable_vxlan = true
local_ip = 192.168.80.248
l2_population = true

[securitygroup]
# ...
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver


```

`vim /etc/neutron/l3_agent.ini`

```
[DEFAULT]
# ...
interface_driver = linuxbridge
```

`vim /etc/neutron/dhcp_agent.ini`

```
[DEFAULT]
# ...
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
```

`vim /etc/neutron/metadata_agent.ini`

```
[DEFAULT]
# ...
nova_metadata_host = control1
metadata_proxy_shared_secret = hujin666

```

`vim /etc/nova/nova.conf`
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


### 在compute1中

`yum install openstack-neutron-linuxbridge ebtables ipset`

`vim /etc/neutron/neutron.conf`

```
[DEFAULT]
# ...
transport_url = rabbit://openstack:hujin666@control1
auth_strategy = keystone


[keystone_authtoken]
# ...
auth_uri = http://control1:5000
auth_url = http://control1:35357
memcached_servers = control1:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = hujin666

[oslo_concurrency]
# ...
lock_path = /var/lib/neutron/tmp
```

`vim /etc/neutron/plugins/ml2/linuxbridge_agent.ini`

```
[linux_bridge]
physical_interface_mappings = provider:ens9

[vxlan]
enable_vxlan = true
local_ip = 192.168.80.247
l2_population = true

[securitygroup]
# ...
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

```

`vim /etc/nova/nova.conf`

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

```

`systemctl restart openstack-nova-compute.service`

`systemctl enable neutron-linuxbridge-agent.service`

`systemctl start neutron-linuxbridge-agent.service`

### 验证

在contorl1中
`openstack network agent list`

确保以下服务都是UP状态

control1 | neutron-linuxbridge-agent
compute1 | neutron-linuxbridge-agent
control1 | neutron-l3-agent
control1 | neutron-dhcp-agent
control1 | neutron-metadata-agent

## dashboard

在contorl1中

`yum install openstack-dashboard`

`vim /etc/openstack-dashboard/local_settings`

```
OPENSTACK_HOST = "control1"
ALLOWED_HOSTS = ['*']


SESSION_ENGINE = 'django.contrib.sessions.backends.cache'

CACHES = {
    'default': {
         'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
         'LOCATION': 'control1:11211',
    }
}

OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST

OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True

OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 2,
}

OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"

OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"


TIME_ZONE = "Asia/Shanghai"

```


`vim /etc/httpd/conf.d/openstack-dashboard.conf`

```
WSGIApplicationGroup %{GLOBAL}
```

`systemctl restart httpd.service memcached.service`


### 验证

 http://control1/dashboard

domain: default
user: demo
password: hujin666


 ## cinder

### 在存储节点上

`yum install lvm2 device-mapper-persistent-data`

`systemctl enable lvm2-lvmetad.service`

`systemctl start lvm2-lvmetad.service`


`vim /etc/lvm/lvm.conf`


```
devices {
...
filter = [ "a/sdb/", "r/.*/"]

```


`yum install openstack-cinder targetcli python-keystone`

`vim /etc/cinder/cinder.conf`

```
[database]
# ...
connection = mysql+pymysql://cinder:hujin666@control1/cinder

[DEFAULT]
# ...
transport_url = rabbit://openstack:hujin666@control1
auth_strategy = keystone
my_ip = 192.168.80.247
# my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
enabled_backends = lvm
glance_api_servers = http://control1:9292

[keystone_authtoken]
# ...
auth_uri = http://control1:5000
auth_url = http://control1:5000
memcached_servers = control1:11211
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = cinder
password = hujin666



[lvm]
volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
volume_group = cinder-volumes
iscsi_protocol = iscsi
iscsi_helper = lioadm

[oslo_concurrency]
# ...
lock_path = /var/lib/cinder/tmp
```

`systemctl enable openstack-cinder-volume.service target.service`
`systemctl start openstack-cinder-volume.service target.service`

### 验证

`. admin-openrc`

`openstack volume service list`


## 在control1中

`mysql -u root -p`

`CREATE DATABASE cinder;`

`GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY 'hujin666';`

`GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY 'hujin666';`

`. admin-openrc`

`openstack user create --domain default --password-prompt cinder`

`openstack role add --project service --user cinder admin`

`openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2`

`openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3`

`openstack endpoint create --region RegionOne volumev2 public http://control1:8776/v2/%\(project_id\)s`


`openstack endpoint create --region RegionOne volumev2 internal http://control1:8776/v2/%\(project_id\)s`

`openstack endpoint create --region RegionOne volumev2 admin http://control1:8776/v2/%\(project_id\)s`


`openstack endpoint create --region RegionOne volumev3 public http://control1:8776/v3/%\(project_id\)s`

`openstack endpoint create --region RegionOne volumev3 internal http://control1:8776/v3/%\(project_id\)s`


`openstack endpoint create --region RegionOne volumev3 admin http://control1:8776/v3/%\(project_id\)s`


`yum install openstack-cinder`

`vim /etc/cinder/cinder.conf`

```
[database]
# ...
connection = mysql+pymysql://cinder:hujin666@control1/cinder

[DEFAULT]
# ...
transport_url = rabbit://openstack:hujin666@control1
auth_strategy = keystone
my_ip = 192.168.80.248

[keystone_authtoken]
# ...
auth_uri = http://control1:5000
auth_url = http://control1:5000
memcached_servers = control1:11211
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = cinder
password = hujin666

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp
```

`su -s /bin/sh -c "cinder-manage db sync" cinder`

`vim /etc/nova/nova.conf`

```
[cinder]
os_region_name = RegionOne
```

`systemctl restart openstack-nova-api.service`

`systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service`

`systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service`

验证

`. admin-openrc`

`openstack volume service list`

cinder-scheduler | controller | nova | enabled | up
cinder-volume    | block@lvm  | nova | enabled | up 


















相关命令
删除卷
cinder-manage service remove <Binary> <host>