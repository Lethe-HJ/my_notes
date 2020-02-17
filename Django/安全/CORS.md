# CORS 跨源资源共享

## 概念

一般在前后端分离开发阶段或是项目前后端分别部署在不同服务器时 都容易遇到跨域的问题
CORS是一个w3c标准,全称是"跨域资源共享"(`Cross-origin resource sharing`).
它允许浏览器跨源向服务器发送`XMLHttpRequest`请求,从而克服AJAX只能同源使用的限制.
*PS: 一个请求url的协议,域名,端口三者之间任意与当前页面地址不同即为跨域*

浏览器默认的安全限制为同源策略，即JavaScript只能访问同源（相同协议，相同
域名，相同端口）下的内容。但由于跨域访问资源需要，出现了CORS机制，这种机制让web服
务器能跨站访问控制，使跨站数据传输更安全。CORS需要阅览器和服务器同时支持，目前，
主流的阅览器都支持cors。

## 简单请求

### 简单请求的标准

1. 请求方法是`HEAD`,`GET`,`POST`方法之一
2. HTTP的头信息不超出`Accept`,`Accept-Language`,`Content-Language`,`Last-Event-ID`字段
*PS: Content-Type：只限于三个值application/x-www-form-urlencoded、multipart/form-data、text/plain*

满足以上两个条件即为简单请求,否则为非简单请求

### 简单请求跨域过程

浏览器在header信息中增加一个Origin字段(例如`Origin:http://localhost`, 表明这是一个跨域的请求),
然后发送CORS跨域请求,服务器根据这个值，决定是否同意这次请求。

如果Origin指定的源，不在服务器许可范围内，服务器会返回一个正常的HTTP回应，浏览器发现响应中的头
信息没有包含Access-Control-Allow-Origin字段,就会抛出一个可被XMLHttpRequest的onerror回调函数捕获的错误.

如果Origin指定的域名在许可范围内，服务器返回的响应的header中会多出以下几个字段:
`Access-Control-Allow-Origin`：该字段是必须的，其值可能是请求时Origin字段的值，也可能是一个*
`Access-Control-Allow-Credentials`:该字段可选，其值类型是布尔型，表示是否允许发送Cookie。
*ps:默认情况下Cookie不包括在CORS请求中。当设为true时表示服务器明确许可，Cookie可以包含在请求中一起发送给服务器。*
`Access-Control-Allow-Headers`:该字段必须，它是一个逗号分割的字符串，表明服务器支持的所有头信息字段

另外:

默认情况下，CORS请求默认不发送Cookie和Http认证信息，如果要把Cookie发送到服务器，首先要指定
`Access-Control-Alloe-Credentials`字段，另一方面，需要在AJAX请求中打开`withCredentials`属性,
且服务器中Access-Control-Allow-Origin要明确设置成与请求一致的域名,不能是*,同时，Cookie依然遵循同源策略。

```js
var xml = new XMLHttpRequest();
xml.withCredentials = true;
```

### 非简单跨域请求过程

当不同时满足简单跨域请求条件的，就是非简单请求。

####　预检请求

非简单请求的CORS请求，会在正式通信前进行一次Http查询请求，又称预检请求。

浏览器先请求服务器，当前网页所在域名是否在服务器许可名单中以及可以使用那些HTTP动词和头信息字段，当客户端得到肯定答复时，浏览器才会正式发出XMLHttpRequest请求。

预检请求用的请求方法是OPTIONS,表示这个请求是用来询问的。

`Access-Control-Request-Method`:该字段是必须的，用来列出浏览器的CORS请求会用到哪些HTTP方法。
`Access-Control-Request-Headers`:该字段是一个逗号分割的字符串，指定浏览器CORS请求会额外发送的头信息字段。

#### 预检请求的回应

当服务其收到预检请求后，检查了`Origin,Access-Control-Request-Method`等信息字段后，如果没有问题，则确认允许跨源请求，就可以做出了回应。

回应中应该包含的字段

`Access-Control-Allow-Methods`:该字段必须，其值是逗号分隔的一个字符串，表明服务器支持的所有跨域请求的方法。这是为了避免多次预检请求。
`Access-Control-Max-Age`:该字段是可选的，用来指定本次预检请求的有效期，单位是秒。`Access-Control-Max-Age:20`,即允许缓存该条回应20秒，再此期间不用发出另一条预检请求

如果服务器否定了预检请求，会返回一个正常的HTTP回应，但是没有任何CORS相关的头信息字段。浏览器此时会认定服务器不同意预检请求，触发一个错误，被XMLHttpRequest的onerror回调函数捕获。

#### 服务器端处理机制

服务器对于跨域请求的处理流程如下：

首先查看http头部有无origin字段；
如果没有，或者不允许，当成普通请求；
如果有且是允许的，再看是否是preflight(method=OPTIONS);
如果不是preflight(简单请求)，返回Allow-Origin,Allow-Credential等字段，并返回正常内容；
如果是preflight(非简单请求)，返回Allow-Headers,Allow-Methods等；
