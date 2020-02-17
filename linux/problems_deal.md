## 1. no digital signature

### problem describe 
when i execute `sudo apt-get update` in command for ubuntu1604.I got the following mistakes.

```text
W: GPG 错误：http://ppa.launchpad.net/ubuntu-desktop/ubuntu-make/ubuntu xenial InRelease: 由于没有公钥，无法验证下列签名： NO_PUBKEY 2CC98497A1231595
W: 仓库 “http://ppa.launchpad.net/ubuntu-desktop/ubuntu-make/ubuntu xenial InRelease” 没有数字签名。
N: 无法认证来自该源的数据，所以使用它会带来潜在风险。
N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
```

## Solution

`sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2CC98497A1231595`

> tip: you should replace argument which is behind position of '--recv-keys' with the string behind 'NO_PUBKEY' before typing this command
