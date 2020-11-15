### 安装

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
```

```
nvm --version
```

### 使用

 1、查看本地安装的所有版本；有可选参数available，显示所有可下载的版本。

```
nvm list [available]
```

  2、安装，命令中的版本号可自定义，具体参考命令1查询出来的列表

```
nvm install 11.13.0
```

  3、使用特定版本

```
nvm use 11.13.0
```

  4、卸载

```
nvm uninstall 11.13.0
```

  5、设置npm镜像

```
nvm npm_mirror [url]
```

如果不写url，则使用默认url。设置后可至安装目录settings.txt文件查看，也可直接在该文件操作。