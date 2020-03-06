## Advanced Configuration 高级设置

### Endpoint Network Configuration 端点网络设置

When an OpenStack cloud is deployed, the REST API of each service is presented as a series of endpoints. These endpoints are the admin URL, the internal URL, and the external URL.

当部署OpenStack云时，每个服务的REST API作为一系列端点表示。这些端点是管理URL、内部URL和外部URL。

Kolla offers two options for assigning these endpoints to network addresses: 
- Combined - Where all three endpoints share the same IP address 
- Separate - Where the external URL is assigned to an IP address that is different than the IP address shared by the internal and admin URLs

kolla提供两个分配这些端点到网络地址的选项：
+ Combined 三种端点都共享相同的ip
+ Separate 外部URL分配与内部URL和管理URL不同的ip

The configuration parameters related to these options are: 
- kolla_internal_vip_address 
- network_interface 
- kolla_external_vip_address 
- kolla_external_vip_interface

[The configuration parameters related to these options are](与这些选项相关的配置参数有)：
- kolla_internal_vip_address 
- network_interface
- kolla_external_vip_address
- kolla_external_vip_interface


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

获得由著名的信任CA签署的证书并不总是现实的,(例如开发或内部测试kolla部署),在这些情况下，使用自签名证书可能很有用

为了方便，kolla-ansible命令将根据globals.yml配置文件中的信息生成必要的证书文件。

    kolla-ansible certificates

证书文件haproxy.pem 和 haproxy-ca.pem会被生成并存储在/etc/kolla/certificates/， CA证书在/etc/kolla/certificates/ca 目录
The files haproxy.pem and haproxy-ca.pem will be generated and stored in the /etc/kolla/certificates/ directory.

## 向服务容器添加证书

复制CA证书文件到服务容器

    kolla_copy_ca_into_containers: "yes"

当kolla_copy_ca_into_containers被设置成yes，/etc/kolla/certificates/ca目录下的CA证书文件会被复制到服务容器中，以启用对这些证书的信任。对于任何自签名的证书或由私有CA签名的证书，以及服务镜像信任存储区中还没有的证书，都需要这样做。

拷贝到容器中时，所有的证书文件名字都会加上kolla-customca-前缀。例如，如果一个证书叫做internal.crt，他在容器中被命名为kolla-customca-internal.crt

对于Debian和ubuntu容器，证书文件会被拷贝到/usr/local/share/ca-certificates/目录下

对于Centos和Red Hat Linux容器，证书文件会被拷贝到/etc/pki/ca-trust/source/anchors/目录下


OpenStack Service Configuration in Kolla
## kolla中的openstack设置

操操作员可以通过编辑/etc/kolla/globals.来更改读取自定义配置文件的位置并添加以下行。

    # The directory to merge custom config files the kolla's config files
    node_custom_config: "/etc/kolla/config"

Kolla允许操作员覆盖服务的配置， kolla会自动查找 /etc/kolla/config/<< config file >>, /etc/kolla/config/<< service name >>/<< config file >> 或者 /etc/kolla/config/<< service name >>/<< hostname >>/<< config file >>里面的文件。但是这些位置有时会发生变化，您应该检查在适当的Ansible角色中的配置任务，以获得受支持位置的完整列表
例如，对于nova.,conf，支持下面路径，假定您有使用nova.conf的服务在名为controller-0001、controller-0002和controller-0003的主机上运行:

    /etc/kolla/config/nova.conf

    /etc/kolla/config/nova/nova.conf

    /etc/kolla/config/nova/controller-0001/nova.conf

    /etc/kolla/config/nova/controller-0002/nova.conf

    /etc/kolla/config/nova/controller-0003/nova.conf

    /etc/kolla/config/nova/nova-scheduler.conf

使用此机制，可以对每个项目、每个项目服务或特定主机上的每个项目服务配置覆盖。

覆盖一个选项与在相关部分中设置该选项一样简单。例如，要在nova scheduler中设置覆盖scheduler_max_attempts，操作者可以创建/etc/kolla/config/nova/nova-scheduler.conf，内容如下:
Overriding an option is as simple as setting the option under the relevant section. For example, to set override scheduler_max_attempts in nova scheduler, the operator could create /etc/kolla/config/nova/nova-scheduler.conf with content:

    [DEFAULT]
    scheduler_max_attempts = 100

如果操作员想要在主机myhost上配置计算节点cpu和ram分配比率，那么操作员需要创建文件/etc/kolla/config/nova/myhost/nova.conf，其中包含以下内容:
If the operator wants to configure compute node cpu and ram allocation ratio on host myhost, the operator needs to create file /etc/kolla/config/nova/myhost/nova.conf with content:

    [DEFAULT]
    cpu_allocation_ratio = 16.0
    ram_allocation_ratio = 5.0

This method of merging configuration sections is supported for all services using Oslo Config, which includes the vast majority of OpenStack services, and in some cases for services using YAML configuration. Since the INI format is an informal standard, not all INI files can be merged in this way. In these cases Kolla supports overriding the entire config file.

用Oslo Config支持所有服务 合并配置部分的方法，包括绝大部分Openstack服务，在某些情况下，用于使用YAML配置的服务。由于INI格式是一种非正式的标准，所以并不是所有的INI文件都可以以这种方式合并。在这些情况下，Kolla支持覆盖整个配置文件

Additional flexibility can be introduced by using Jinja conditionals in the config files. For example, you may create Nova cells which are homogeneous with respect to the hypervisor model. In each cell, you may wish to configure the hypervisors differently, for example the following override shows one way of setting the bandwidth_poll_interval variable as a function of the cell:

可以通过在配置文件中使用Jinja条件来引入额外的灵活性，例如，您可以创建与管理程序模型类似的Nova单元。在每个计算单元中，您可能希望以不同的方式配置管理程序，例如，下面的覆盖显示了将bandwidth_poll_interval 变量设置为计算单元的函数的一种方法

    [DEFAULT]
    {% if 'cell0001' in group_names %}
    bandwidth_poll_interval = 100
    {% elif 'cell0002' in group_names %}
    bandwidth_poll_interval = -1
    {% else %}
    bandwidth_poll_interval = 300
    {% endif %}

An alternative to Jinja conditionals would be to define a variable for the bandwidth_poll_interval and set it in according to your requirements in the inventory group or host vars:

Jinja条件的另一种选择是为bandwidth_poll_interval定义一个变量，并根据您在库存组或主机vars中的需求来设置它:

    [DEFAULT]
    bandwidth_poll_interval = {{ bandwidth_poll_interval }}

Kolla allows the operator to override configuration globally for all services. It will look for a file called /etc/kolla/config/global.conf.

Kolla允许操作员全局覆盖所有服务的配置。它将查找一个名为/etc/kolla/config/global.conf的文件。

For example to modify database pool size connection for all services, the operator needs to create /etc/kolla/config/global.conf with content:

    [database]
    max_pool_size = 100

In case the operators want to customize policy.json file, they should create a full policy file for specific project in the same directory like above and Kolla will overwrite default policy file with it. Be aware, with some projects are keeping full policy file in source code, operators just need to copy it but with some others are defining default rules in codebase, they have to generate it.

如果操作人员需要自定义policy.json文件，他们应该在相同的目录下为特定的项目创建一个完整的策略文件，就像上面一样，Kolla会用它覆盖默认的策略文件。注意，有些项目在源代码中保存完整的策略文件，操作人员只需要复制它，而有些项目在代码库中定义默认规则，他们必须生成它。

For example to overwrite policy.json file of Neutron project, the operator needs to grab policy.json from Neutron project source code, update rules and then put it to /etc/kolla/config/neutron/policy.json.

例如覆盖Neutron项目的policy.json文件。操作员需要从Neutron项目源码中抓取policy.json，更新规则，然后把它放在/etc/kolla/config/neutron/policy.json。

> Note： Currently kolla-ansible only support JSON and YAML format for policy file.

> 注意： 现在的kolla-ansible只支持JSON和YAML格式的policy文件

The operator can make these changes after services were already deployed by using following command:

当服务已经部署完毕后，操作员可以使用以下命令进行更改:

    kolla-ansible reconfigure


## IP Address Constrained Environments IP地址约束环境

If a development environment doesn’t have a free IP address available for VIP configuration, the host’s IP address may be used here by disabling HAProxy by adding:

如果一个开发环境没有可供VIP配置的空闲IP地址，主机的IP地址可以通过添加以下参数禁用HAProxy来使用:

    enable_haproxy: "no"

Note this method is not recommended and generally not tested by the Kolla community, but included since sometimes a free IP is not available in a testing environment.

注意，这个方法不推荐，一般也没有经过Kolla社区的测试，但是由于有时在测试环境中没有可用的免费IP，所以包含了这个方法。

## External Elasticsearch/Kibana environment 外部Elasticsearch/Kibana环境

It is possible to use an external Elasticsearch/Kibana environment. To do this first disable the deployment of the central logging.

可以使用外部Elasticsearch/Kibana环境。为此，首先要禁用中央日志的部署

    enable_central_logging: "no"

Now you can use the parameter elasticsearch_address to configure the address of the external Elasticsearch environment.

现在您可以使用参数elasticsearch_address地址来配置外部elasticsearch环境的地址。

##　Non-default <service> port　　非默认服务端口

It is sometimes required to use a different than default port for service(s) in Kolla. It is possible with setting \<service\>_port in globals.yml file. For example:

在Kolla中，有时需要使用与默认端口不同的服务端口。可以在全局中设置<service>端口。yml文件。例如:

    database_port: 3307

As <service>_port value is saved in different services’ configuration so it’s advised to make above change before deploying.

由于<service> port值保存在不同服务的配置中，因此建议在部署之前进行上述更改。

## Use an external Syslog server 使用外部Syslog服务器

By default, Fluentd is used as a syslog server to collect Swift and HAProxy logs. When Fluentd is disabled or you want to use an external syslog server, You can set syslog parameters in globals.yml file. For example:

默认情况下，Fluentd用作syslog服务器来收集Swift和HAProxy日志, 当您禁用Fluentd或希望使用外部syslog服务器时，可以在globals.yml文件中设置syslog参数。例如：

    syslog_server: "172.29.9.145"
    syslog_udp_port: "514"

You can also set syslog facility names for Swift and HAProxy logs. By default, Swift and HAProxy use local0 and local1, respectively.

您还可以为Swift和HAProxy日志设置syslog设备名称。默认情况下，Swift和HAProxy分别使用local0和local1。

    syslog_swift_facility: "local0"
    syslog_haproxy_facility: "local1"

## Mount additional Docker volumes in containers 在容器中装入其他Docker卷

It is sometimes useful to be able to mount additional Docker volumes into one or more containers. This may be to integrate 3rd party components into OpenStack, or to provide access to site-specific data such as x.509 certificate bundles.

有时，能够将附加的Docker卷装入一个或多个容器中是很有用的。这可能是将第三方组件集成到OpenStack中，或者提供对站点特定数据的访问，比如x.509证书包。

Additional volumes may be specified at three levels:
可在三个级别指定额外的卷:

+ globally
+ per-service (e.g. nova)
+ per-container (e.g. nova-api)

To specify additional volumes globally for all containers, set default_extra_volumes in globals.yml. For example:

要为所有容器全局指定额外卷，请在global.yml中设置默认的额外卷。例如:

    default_extra_volumes:
    - "/etc/foo:/etc/foo"

To specify additional volumes for all containers in a service, set 、\<service_name\>_extra_volumes in globals.yml. For example:

要为服务中的所有容器指定额外的卷，请在global .yml中设置<服务名称>额外的卷。例如:

    nova_extra_volumes:
    - "/etc/foo:/etc/foo"

To specify additional volumes for a single container, set 、\<container_name\>_extra_volumes in globals.yml. For example:

    nova_libvirt_extra_volumes:
    - "/etc/foo:/etc/foo"