# Contents

- Prerequisite先决条件
- Create the service entity and API endpoints创建服务实体和API实例

The Identity service provides a catalog of services and their locations. Each service that you add to your OpenStack environment requires a service entity and several API endpoints in the catalog.
身份服务提供了服务及其位置的目录.任何你添加到你openstack环境的服务需要一个服务实体和目录中的几个API端点.

## Prerequisites先决条件

By default, the Identity service database contains no information to support conventional authentication and catalog services. You must use a temporary authentication token that you created in the section called Install and configure to initialize the service entity and API endpoint for the Identity service.
默认情况下,身份服务数据库不包含支持常见的验证和目录服务的信息.你必须使用一个你在Install and configure章节创建的临时验证token为身份服务去初始化服务实体和API端点.

You must pass the value of the authentication token to the openstack command with the `--os-token` parameter or set the `OS_TOKEN` environment variable. Similarly, you must also pass the value of the Identity service URL to the openstack command with the `--os-url` parameter or set the `OS_URL` environment variable. This guide uses environment variables to reduce command length.
你必须使用`--os-token`参数将传递验证token的值传递给openstack命令,或者设置`OS_TOKEN`环境变量.同样你也必须使用`--os-url`参数传递身份服务URL给openstack命令,或者设置`OS_URL`环境变量.本指南使用环境变量去减少命令长度.

Warning

For security reasons, do not use the temporary authentication token for longer than necessary to initialize the Identity service.
警告
处于安全原因,不要将使用临时验证token的时间超过初始化身份服务的时间.

1.Configure the authentication token:
1.设置身份验证令牌

```shell
export OS_TOKEN=ADMIN_TOKEN
```
  
Replace ADMIN_TOKEN with the authentication token that you generated in the section called Install and configure. For example:
用你在Install and configure章节生成的验证token来替换`ADMIN_TOKEN`

```shell
export OS_TOKEN=294a4c8a8a475f9b9836
```

2.Configure the endpoint URL:
2.设置端点URL

```shell
export OS_URL=http://controller:35357/v3
```

Configure the Identity API version:
设置身份API版本

```shell
export OS_IDENTITY_API_VERSION=3
```

## Create the service entity and API endpoints创建服务实体和API端点

The Identity service manages a catalog of services in your OpenStack environment. Services use this catalog to determine the other services available in your environment.
身份服务管理你的openstack环境中的服务目录.服务使用这个目录去确定环境中可用的其他的服务.

Create the service entity for the Identity service:
创建身份服务的服务实体

$ openstack service create \
  --name keystone --description "OpenStack Identity" identity
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Identity               |
| enabled     | True                             |
| id          | 4ddaae90388b4ebc9d252ec2252d8d10 |
| name        | keystone                         |
| type        | identity                         |
+-------------+----------------------------------+
 Note

OpenStack generates IDs dynamically, so you will see different values in the example command output.

The Identity service manages a catalog of API endpoints associated with the services in your OpenStack environment. Services use this catalog to determine how to communicate with other services in your environment.

OpenStack uses three API endpoint variants for each service: admin, internal, and public. The admin API endpoint allows modifying users and tenants by default, while the public and internal APIs do not allow these operations. In a production environment, the variants might reside on separate networks that service different types of users for security reasons. For instance, the public API network might be visible from the Internet so customers can manage their clouds. The admin API network might be restricted to operators within the organization that manages cloud infrastructure. The internal API network might be restricted to the hosts that contain OpenStack services. Also, OpenStack supports multiple regions for scalability. For simplicity, this guide uses the management network for all endpoint variations and the default RegionOne region.

Create the Identity service API endpoints:

$ openstack endpoint create --region RegionOne \
  identity public http://controller:5000/v3
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 30fff543e7dc4b7d9a0fb13791b78bf4 |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 8c8c0927262a45ad9066cfe70d46892c |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://controller:5000/v3        |
+--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  identity internal http://controller:5000/v3
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 57cfa543e7dc4b712c0ab137911bc4fe |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 6f8de927262ac12f6066cfe70d99ac51 |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://controller:5000/v3        |
+--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  identity admin http://controller:35357/v3
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 78c3dfa3e7dc44c98ab1b1379122ecb1 |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 34ab3d27262ac449cba6cfe704dbc11f |
| service_name | keystone                         |
| service_type | identity                         |
| url          | http://controller:35357/v3       |
+--------------+----------------------------------+
 Note

Each service that you add to your OpenStack environment requires one or more service entities and three API endpoint variants in the Identity service.