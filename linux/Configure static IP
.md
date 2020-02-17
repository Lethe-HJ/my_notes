# 静态IP配置步骤：

以管理员身份登陆
输入`vi /etc/network/interfaces`，将iface eht0 inet dhcp改为iface eht0 inet static
在后面添加

```text
address 192.168.137.111
netmask 255.255.255.0
gateway 192.168.137.1
dns-nameserver X.X.X.X
dns-nameserver X.X.X.X
```

其中X.X.X.X为DNS地址。
重启网络服务
`service networking restart`
`ifconfig`查看IP地址是否改过来，如若发现Ip地址重启网络不生效，在命令行执行
`ip addr flush dev eth0`
`ifdown eth0`
`ifup eth0`
执行ifconfig发现IP已更改。
