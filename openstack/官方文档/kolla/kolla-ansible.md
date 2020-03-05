## 高级设置

### 端点网络设置

kolla提供两个分配这些端点到网络地址的选项：
+ Combined 三种端点都共享相同的ip
+ Separate 外部URL分配与内部URL和管理URL不同的ip

这两个选项相关的参数：
+ kolla_internal_vip_address
+ network_interface
+ kolla_external_vip_address
+ kolla_external_vip_interface

对于`Combined`选项 设置如下两个变量，同时会允许其它两个接受他们的默认值。在这个设置中所有的TEST API请求，内部和外部的都流经相同的网络

```shell
kolla_internal_vip_address: "10.10.10.254"
network_interface: "eth0"
```
对于`Separate`选项，设置如下四个变量。在这个设置中内部和外部的REST API请求会流经不同的网络

```shell
kolla_internal_vip_address: "10.10.10.254"
network_interface: "eth0"
kolla_external_vip_address: "10.10.20.254"
kolla_external_vip_interface: "eth1"
```

### 全限定域名配置

如果你想使用域名在kolla部署中去寻址端点，使用以下变量

+ kolla_internal_fqdn
+ kolla_external_fqdn

例如:

```shell
kolla_internal_fqdn: inside.mykolla.example.net
kolla_external_fqdn: mykolla.example.net
```
规定，这些域名与被设置的ip地址之间的映射必须放在kolla之外
可以通过DNS或者`/etc/hosts`文件的方式创建域名映射

### RabbitMQ的Hostname解决方案

RabbitMQ不能使用IP地址，因此api接口的IP地址应该可以通过主机名来解析，以确保所有RabbitMQ集群主机可以预先解析彼此的主机名。

### TLS设置

一个附加的端点设置是为外部VIP开启或禁止TLS保护。              TLS允许客户端对OpenStack服务端点进行身份验证，并允许对请求和响应进行加密。
为了在外部网络上启用TLS, kolla内部vip地址和kolla外部vip地址必须不同。

控制TLS网络的设置变量如下

    kolla_enable_tls_external: "yes"
    kolla_external_fqdn_cert: "{{ node_config_directory }}/certificates/mycert.pem"

> TLS身份验证基于由受信任的证书颁发机构签署的证书.
> Letsencrypt.org是一个免费提供可信证书的CA
> 如果在您的情况下无法使用受信任的CA，您可以使用OpenSSL创建自己的证书，或者参阅下面关于kolla生成的自签名证书的部分。

需要两个验证文件才能安全地使用带有验证功能的TLS，这两个证书文件将由你的证书颁发机构提供，这两个文件是带有私钥的服务器证书和带有任何中间证书的CA证书，服务器证书需要与kolla部署一起安装，并使用kolla_external_fqdn_cert 参数进行配置， 如果客户端尚未信任所提供的服务器证书，则需要将CA证书文件分发给客户端

当使用TLS连接到公共端点时，OpenStack客户端如下设置:

    export OS_PROJECT_DOMAIN_ID=default
    export OS_USER_DOMAIN_ID=default
    export OS_PROJECT_NAME=demo
    export OS_USERNAME=demo
    export OS_PASSWORD=demo-password
    export OS_AUTH_URL=https://mykolla.example.net:5000
    # os_cacert is optional for trusted certificates
    export OS_CACERT=/etc/pki/mykolla-cacert.crt
    export OS_IDENTITY_API_VERSION=3


## 自签证书

> 自签证书不应该被用在生产环境中

获得由著名的信任CA签署的证书并不总是实际的,(例如开发或内部测试kolla部署),在这些情况下，使用自签名证书可能很有用
It is not always practical to get a certificate signed by a well-known trust CA, for example a development or internal test kolla deployment. In these cases it can be useful to have a self-signed certificate to use.


For convenience, the kolla-ansible command will generate the necessary certificate files based on the information in the globals.yml configuration file:

    kolla-ansible certificates

The files haproxy.pem and haproxy-ca.pem will be generated and stored in the /etc/kolla/certificates/ directory.
OpenStack Service Configuration in Kolla¶

 
Note

As of now kolla only supports config overrides for ini based configs.

An operator can change the location where custom config files are read from by editing /etc/kolla/globals.yml and adding the following line.

# The directory to merge custom config files the kolla's config files
node_custom_config: "/etc/kolla/config"

Kolla allows the operator to override configuration of services. Kolla will look for a file in /etc/kolla/config/<< service name >>/<< config file >>. This can be done per-project, per-service or per-service-on-specified-host. For example to override scheduler_max_attempts in nova scheduler, the operator needs to create /etc/kolla/config/nova/nova-scheduler.conf with content:

[DEFAULT]
scheduler_max_attempts = 100

If the operator wants to configure compute node cpu and ram allocation ratio on host myhost, the operator needs to create file /etc/kolla/config/nova/myhost/nova.conf with content:

[DEFAULT]
cpu_allocation_ratio = 16.0
ram_allocation_ratio = 5.0

Kolla allows the operator to override configuration globally for all services. It will look for a file called /etc/kolla/config/global.conf.

For example to modify database pool size connection for all services, the operator needs to create /etc/kolla/config/global.conf with content:

[database]
max_pool_size = 100

In case the operators want to customize policy.json file, they should create a full policy file for specific project in the same directory like above and Kolla will overwrite default policy file with it. Be aware, with some projects are keeping full policy file in source code, operators just need to copy it but with some others are defining default rules in codebase, they have to generate it.

For example to overwrite policy.json file of Neutron project, the operator needs to grab policy.json from Neutron project source code, update rules and then put it to /etc/kolla/config/neutron/policy.json.

 
Note

Currently kolla-ansible only support JSON format for policy file.

The operator can make these changes after services were already deployed by using following command:

kolla-ansible reconfigure

IP Address Constrained Environments¶

If a development environment doesn’t have a free IP address available for VIP configuration, the host’s IP address may be used here by disabling HAProxy by adding:

enable_haproxy: "no"

Note this method is not recommended and generally not tested by the Kolla community, but included since sometimes a free IP is not available in a testing environment.
External Elasticsearch/Kibana environment¶

It is possible to use an external Elasticsearch/Kibana environment. To do this first disable the deployment of the central logging.

enable_central_logging: "no"

Now you can use the parameter elasticsearch_address to configure the address of the external Elasticsearch environment.
Non-default <service> port¶

It is sometimes required to use a different than default port for service(s) in Kolla. It is possible with setting <service>_port in globals.yml file. For example:

database_port: 3307

As <service>_port value is saved in different services’ configuration so it’s advised to make above change before deploying.
Use an external Syslog server¶

By default, Fluentd is used as a syslog server to collect Swift and HAProxy logs. When Fluentd is disabled or you want to use an external syslog server, You can set syslog parameters in globals.yml file. For example:

syslog_server: "172.29.9.145"
syslog_udp_port: "514"

You can also set syslog facility names for Swift and HAProxy logs. By default, Swift and HAProxy use local0 and local1, respectively.

syslog_swift_facility: "local0"
syslog_haproxy_facility: "local1"

