## `cookie`

cookie的内容主要包括：名字、值、过期时间、路径和域。路径与域一起构成cookie的作用范围。若不设置时间，则表示这个cookie的生命期为浏览器会话期间，关闭浏览器窗口，cookie就会消失。这种生命期为浏览器会话期的cookie被称为会话cookie。 

会话cookie一般不存储在硬盘而是保存在内存里，当然这个行为并不是规范规定的。若设置了过期时间，浏览器就会把cookie保存到硬盘上，关闭后再打开浏览器这些cookie仍然有效直到超过设定的过期时间。对于保存在内存里的cookie，不同的浏览器有不同的处理方式。

cookie保存在客户端，保存的是字符串 。

单个cookie保存的数据不能超过4K，很多浏览器都限制一个站点最多保存20个cookie 。

cookie支持父子域名之间的跨域名访问，cookie在所有同源窗口中都是共享的。

cookie数据始终在同源的http请求中携带（即使不需要），即cookie在浏览器和服务器间来回传递。

## `session`

当程序需要为某个客户端的请求创建一个session时，服务器首先检查这个客户端的请求里是否已包含了一个session标识（称为session  id），如果已包含则说明以前已经为此客户端创建过session，服务器就按照session  id把这个session检索出来使用（检索不到，会新建一个），如果客户端请求不包含session  id，则为客户端创建一个session并且生成一个与此session相关联的session id，session  id的值应该是一个既不会重复，又不容易被找到规律以仿造的字符串，这个session id将被在本次响应中返回给客户端保存。保存这个session id的方式可以采用cookie，这样在交互过程中浏览器可以自动的按照规则把这个标识发送给服务器。

session中保存的是对象。

session需要借助cookie才能正常工作。如果客户端完全禁止cookie，session将失效。



## `session storage`

sessionStorage是在同源的同窗口中，始终存在的数据，也就是说只要这个浏览器窗口没有关闭，即使刷新页面或进入同源另一个页面，数据仍然存在，关闭窗口后，sessionStorage就会被销毁，同时“独立”打开的不同窗口，即使是同一页面，sessionStorage对象也是不同的。

仅在当前浏览器窗口关闭之前有效。

不在不同的浏览器窗口中共享，即使是同一个页面。

## `localStorage`

始终有效，窗口或浏览器关闭也一直保存，因此用作持久数据。

在所有同源窗口中都是共享的。