# docker的安装

## 卸载旧版本

Docker 的旧版本被称为 docker，docker.io 或 docker-engine 。如果已安装，请卸载它们：

`$ sudo apt-get remove docker docker-engine docker.io containerd runc`

当前称为 Docker Engine-Community 软件包 docker-ce 。

使用 Docker 仓库进行安装

在新主机上首次安装 Docker Engine-Community 之前，需要设置 Docker 仓库。之后，您可以从仓库安装和更新 Docker 。
设置仓库

更新 apt 包索引。

`$ sudo apt-get update`

安装 apt 依赖包，用于通过HTTPS来获取仓库:
`$ sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common`

添加 Docker 的官方 GPG 密钥：

`$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88 通过搜索指纹的后8个字符，验证您现在是否拥有带有指纹的密钥。
`$ sudo apt-key fingerprint 0EBFCD88`

使用以下指令设置稳定版仓库
`$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`
安装 Docker Engine-Community

更新 apt 包索引。

`$ sudo apt-get update`

安装最新版本的 Docker Engine-Community 和 containerd ，或者转到下一步安装特定版本：

`$ sudo apt-get install docker-ce docker-ce-cli containerd.io`

要安装特定版本的 Docker Engine-Community，请在仓库中列出可用版本，然后选择一种安装。列出您的仓库中可用的版本：
$ apt-cache madison docker-ce

  docker-ce | 5:18.09.1~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  docker-ce | 5:18.09.0~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  docker-ce | 18.06.1~ce~3-0~ubuntu       | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  docker-ce | 18.06.0~ce~3-0~ubuntu       | https://download.docker.com/linux/ubuntu  xenial/stable amd64 Packages
  ...

使用第二列中的版本字符串安装特定版本，例如 <VERSION_STRING> 指上面的 5:18.09.1~3-0~ubuntu-xenial。

`$ sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io`

测试 Docker 是否安装成功，输入以下指令，打印出以下信息则安装成功:

`$ sudo docker run hello-world`
