# Django基础API

## render

`render(request, "login.html")` 渲染指定的页面到浏览器

`render(request, "login.html", {"error_msg": error_msg})` 渲染指定的页面到浏览器并传入参数到页面

## request参数

`request.method`   获取请求的方式 返回值如"GET","POST"等等

`request.POST.get("email", None)`	 获取POST参数,如果不存在则返回None,存在则返回参数对应的值

## redirect

`redirect("http://www.baidu.com")`重定向URL 即让浏览器跳转到指定页面 相当于在地址栏输入http://www.baidu.com

`redirect("/login")`重定向URL 即让浏览器跳转到指定url

简单的登录实例

```python
from django.shortcuts import HttpResponse, render, redirect


def login(request):
    if request.method == "GET":
        return render(request, "login.html")
    elif request.method == "POST":
        email = request.POST.get("email", None)
        password = request.POST.get("password", None)
        if email != "123@163.com":
            error_msg = "email is not exist!"
        elif password != "321":
            error_msg = "password is wrong!"
        else:
            return redirect("http://www.baidu.com")  # 重定向 跳转到指定的URL
        return render(request, "login.html", {"error_msg": error_msg})
    else:
        return 0

```

## 新建app

`python manage.py startapp app_first`

在settings.py中的INSTALLED_APPS中加入`'app_first.apps.app_firstConfig',`或者写`app_first`两者皆可

## URL

URL是Uniform Resource Locator的简写，统一资源定位符。

一个URL由以下几部分组成：
scheme://host:port/path/?query-string=xxx#anchor
scheme：代表的是访问的协议，一般为http或者https以及ftp等。
host：主机名，域名，比如www.baidu.com。
port：端口号。当你访问一个网站的时候，浏览器默认使用80端口。
path：查找路径。比如：www.jianshu.com/trending/now，后面的trending/now就是path。
query-string：查询字符串，比如：www.baidu.com/s?wd=python，后面的wd=python就是查询字符串。
anchor：锚点，后台一般不用管，前端用来做页面定位的。
注意：URL中的所有字符都是ASCII字符集，如果出现非ASCII字符，比如中文，浏览器会进行编码再进行传输。

URL中包含另外一个urls模块：
在我们的项目中，不可能只有一个app，如果把所有的app的views中的视图都放在urls.py中进行映射，肯定会让代码显得非常乱。因此django给我们提供了一个方法，可以在app内部包含自己的url匹配规则，而在项目的urls.py中再统一包含这个app的urls。使用这个技术需要借助include函数。示例代码如下：

## first_project/urls.py文件

```python
from django.contrib import admin
from django.urls import path,include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('book/',include("book.urls"))
]
```

在urls.py文件中把所有的和book这个app相关的url都移动到app/urls.py中了，然后在first_project/urls.py中，通过include函数包含book.urls，以后在请求book相关的url的时候都需要加一个book的前缀。
