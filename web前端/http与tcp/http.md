```js
axios.post('/admin/url/modify', JSON.stringfy({
    privilege_id: 133,
    test: 'abc\n33 3&3',
}));
```

抓包结果如下

POST /mock/154/kops/v1/admin/url/modify HTTP/1.1
x-forwarded-host: localhost:8080
x-forwarded-proto: http
x-forwarded-port: 8080
x-forwarded-for: 127.0.0.1
accept-language: zh-CN,zh;q=0.9
accept-encoding: gzip, deflate, br
referer: http://localhost:8080/
sec-fetch-dest: empty
sec-fetch-mode: cors
sec-fetch-site: same-origin
origin: http://localhost:8080
**content-type: application/x-www-form-urlencoded**
user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36
accept: application/json, text/plain, */*
content-length: 38
connection: close
host: api.kylincloud.me

**privilege_id=133&test=abc%0A33%203%263**



如果不使用JSON.stringfy序列化，抓包结果如下

POST /mock/154/kops/v1/admin/url/modify HTTP/1.1
x-forwarded-host: localhost:8080
x-forwarded-proto: http
x-forwarded-port: 8080
x-forwarded-for: 127.0.0.1
accept-language: zh-CN,zh;q=0.9
accept-encoding: gzip, deflate, br
referer: http://localhost:8080/
sec-fetch-dest: empty
sec-fetch-mode: cors
sec-fetch-site: same-origin
origin: http://localhost:8080
**content-type: application/json;charset=UTF-8**
user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36
accept: application/json, text/plain, */*
content-length: 41
connection: close
host: api.kylincloud.me

**{"privilege_id":133,"test":"abc\n33 3&3"}**