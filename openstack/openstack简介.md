

OpenStack核心组件

Keystone（身份认证）
Nova（计算）
Neutron（网络）
Glance（镜像存储）
Cinder（块存储）
Swift（对象存储）
Horizon（web UI 界面）
Ceilometer（计量）
Heat（部署编排）
Trove（数据库）

**身份认证（Keystone）**：统一的授权、认证管理。所有组件都依赖亍 Keystone 提供 3A(Account,Authentication, Authorization)服务
1）认证(Authentication)，验证用户的身份不可使用的网络服务；
2）授权(Authorization)：依据认证结果开放网络服务给用户；
3）计帐(Accounting)：记录用户对各种网络服务的用量，并提供给计费系统。整个系统在网络管理不安全问题中十分有效


**计算管理（Nova）**：Nova 是 OpenStack 于中的计算组织控制器。Nova 自身并没有提供任何虚拟化能力，相反它使用 libvirt API 来与不被支持的虚拟技术 Hypervisors 交互。如：kvm、Xen、VMware等虚拟化技术

**Neutron（网络）**：实现虚拟机的网络资源管理如网络连接、ip 管理、公网映射
**镜像管理（Glance）**： 主要存储和管理系统镜像。 centos 镜像
**块存储（Cinder）**：为虚拟机提供存储空间。 比如硬盘，分区，目前支持LVM、ip-san、fc-san等。
**对象存储（Swift）**：OpenStack Swift 开源项目提供了弹性可伸缩、高可用的分布式对象存储服务，适合存储大规模非结构化数据。通过key/value的斱式实现对文件的存储，现在的云盘就是这样的，和MFS，HDFS类似
注：如果客户需要一个1000T的存储空间，使用Cinder就不行，效率太低。这时就用Swift。
**界面（Horizon）**：安装好后，openstack 的 web 界面控制台 DashBoard
**Ceilometer（计量）**：Ceilometer 是 OpenStack 中的一个子项目，它像一个漏斗一样，能把
OpenStack 内部发生的几乎所有的事件都收集起来，然后为计费和监控以及其它服务提供数据支撑。
**Heat（部署编排）**：是一个编排引擎，它可以基于文本文件形式的模板启动多个复合于应用程序（这些文件可以被视为代码）。简单来说，Heat 为 OpenStack 用户提供了一种自动创建于组件（如网络、实例、存储设备等）的方法。
**Trove（数据库）**：为关系型数据库和非关系型数据库引擎提供可扩展的和可靠的于数据库服务，并继续改进其功能齐全、可扩展的开源框架。

Openstack的网络模式有5种
**Local模式**：一般测试时使用，只需一台物理机即可。
**GRE模式**：隧道模式， VLAN数量没有限制，性能有点问题。
**Vlan模式**：vlan数量有4096的限制
**VXlan模式**：vlan数量没有限制，性能比GRE好。
**Flat模式**：管理员创建租户直接到外网，不需要NAT。

kolla 是 openstack 下面用亍自动化部署的一个项目，它基于 docker 和 ansible 来实现，docker主要负责镜像制作，容器管理。而 ansible 主要负责环境的部署和管理。
Kolla 实际上是分为两大块的，一部分，Kolla 提供了生产环境级别的镜像，涵盖了 Openstack 用到的各个服务，另一部分是自动化的部署，也就是上面说的 ansible 部分。最开始两个部分是在一个项目中的（也就是 Kolla），从 O 版本开始将两个部分独立开来，Kolla 项目用来构建所有服务的镜像，Kolla-ansible 用来执行自劢化部署。
