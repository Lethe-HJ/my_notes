## 消息队列
消息队列（Message Queue，简称MQ）
本质是个队列，FIFO先入先出
队列中存放的内容是message

主要用途：不同进程Process/线程Thread之间通信

为什么会产生消息队列？有几个原因：
+ 不同进程（process）之间传递消息时，两个进程之间耦合程度过高，改动一个进程，引发必须修改另一个进程，为了隔离这两个进程，在两进程间抽离出一层（一个模块），所有两进程之间传递的消息，都必须通过消息队列来传递，单独修改某一个进程，不会影响另一个；
+ 不同进程（process）之间传递消息时，为了实现标准化，将消息的格式规范化了，并且，某一个进程接受的消息太多，一下子无法处理完，并且也有先后顺序，必须对收到的消息进行排队，因此诞生了事实上的消息队列；



## AMQP

RabbitMQ是一个开源的,以AMQP为基础的完整的可复用的企业消息系统,用Erlang语言开发

AMQP，即Advanced Message Queuing Protocol，一个提供统一消息服务的应用层标准高级消息队列协议，是应用层协议的一个开放标准，为面向消息的中间件设计。基于此协议的客户端与消息中间件可传递消息，并不受客户端/中间件不同产品，不同的开发语言等条件的限制

RabbitMq 应用场景广泛：

    系统的高可用：日常生活当中各种商城秒杀，高流量，高并发的场景。当服务器接收到如此大量请求处理业务时，有宕机的风险。某些业务可能极其复杂，但这部分不是高时效性，不需要立即反馈给用户，我们可以将这部分处理请求抛给队列，让程序后置去处理，减轻服务器在高并发场景下的压力。
    分布式系统，集成系统，子系统之间的对接，以及架构设计中常常需要考虑消息队列的应用。

## 安装


`sudo apt-get install erlang`
`sudo apt-get install rabbitmq-server`
`systemctl start rabbitmq-server`

查看状态

`service rabbitmq-server status`

查看日志
`cat /var/log/rabbitmq/rabbit@hostname.log`

使能客户端插件
/sbin/rabbitmq-plugins enable rabbitmq_management
然后重启rabbitmq服务
到此,就可以通过http://ip:15672 使用guest,guest 进行登陆web页面了


添加帐号:name 密码:passwd
#rabbitmqctl add_user name passwd
赋予其administrator角色
#rabbitmqctl set_user_tags name administrator
设置权限
#rabbitmqctl set_permissions -p / name ".*" ".*" ".*"