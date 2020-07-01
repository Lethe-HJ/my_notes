# go学习笔记

## 介绍

### Go语言的主要特性

    - 开放源代码
    - 虽然是静态类型,编译型的语言,语法却非常简洁
    - 跨平台支持
    - 全自动的垃圾回收机制
    - 原生的先进并发编程模型和机制
    - 拥有函数式编程范式的特性
    - 无继承层次的轻量级面向对象编程范式
    - 程序编译和运行速度都非常快
    - 标准库丰富

任何新技术的产生都是归功与部分人对老旧技术的强烈不满
c的依赖管理,c++的垃圾回收,java笨重的类型系统和厚重的Java EE规范,以及脚本语言的性能

## 安装go

官方安装包下载地址
    https://golang.google.cn/dl/

### linux

    wget http://golang.org/dl/go1.3.linux-386.tar.gz //下载安装包
    tar -zxf go1.3.linux-386.tar.gz // 解压成一个存档文件
    sudo mv ./go /usr/local // 移动到官方建议的位置
    sudo vim /etc/profile // 编辑环境变量文件
    在最后追加
        export GOROOT=/usr/local/go
        export PATH=$PATH:$GOROOT/bin
    source /etc/profile // 使profile文件生效 

## hello world

    ```go
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello, World!")
    }
    ```


在Terminal中切换到该文件的目录 然后执行go run hello.go
