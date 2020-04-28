# go基础

Go是一门并发支持,垃圾回收的编译型系统编程语言,旨在创造一门具有在静态编译语言的高性能和动态语言的高效开发之间拥有良好平衡点的一门编程语言

Go的主要特点
    类型安全和内存安全
    直观和低代价的方案实现高并发
    高效的垃圾回收机制
    快速编译
    为多核计算机提供性能提升的方案
    UTF-编码支持

实际应用
    Youtube(谷歌)
    七牛云

Go 2009年发布

GOPATH下的目录
bin(存放编译后生成的可执行文件)
pkg(存放编译后生成的包文件)
src(存放项目源码)

go常用命令

    go get 获取远程包
    go run 直接运行程序
    go build 测试编译
    go fmt 格式化源码
    go install 编译包文件并编译整个程序
    go test 运行测试文件
    go doc 查看文档

建立本地文档网站
godoc -http-:8080

## hello world

hello.go

    ```go
    package main
    import (
        "fmt"
    )

    func main(){
        fmt.PrintIn("Hello world")
    }
    ```
使用 go run hello.go 直接在控制台运行go文件
使用 go build hello.go 生产可执行文件

mian.go

```go
//当前程序的包名
package main

//导入其他的包
import "fmt"
//别名
import std "fmt"

//常量的定义
const PI = 3.14
const (
    PI = 3.14
    const1 = "1"
)

//全局变量的声明与赋值
var name = "gopher"
var (
    name1 = 1
    name2 = 2
)

//一般类型的声明
type newType int
type (
    newType int
    type1 string
)

//结构的声明
type gopher struct{}

//接口的声明
type golang interface{}

//main函数作为程序入口
func mian(){
    PrintIn("Hello world")
}
```

    go语言中约定 首字母小写 即为private 大写为public

布尔型 bool
    长度 1字节
    取值范围 true, false
    注意事项 不可以用数字代表true或false

整形
    int/uint
        根据运行平台可能为32或64位
    int8/uint8
        长度 1字节
    字节型 uint8
    int16/uint16
        长度 2字节
    int32(rune)/uint32
        长度 4字节
    int64/uint64
        长度 8字节

浮点型
    float32/float64
    4/8字节
    精确到小数点后7/15位

复数
    complex64/complex128
    长度 8/16字节

指针类型
    uintptr
    根据运行平台可能为32或64位

其它类型
    array

    struct

    string

引用类型
    slice

    map

    chan

接口类型interface

函数类型func

类型零值
    当变量被声明某种类型后的默认值,通常情况下值类型的默认值为0, boll为false, string为空字符串, array为空数组

变量的声明与赋值
先声明再赋值
    var a int
    a=1
或者直接赋值自动推断类型
    a := 1

多个变量的声明
    var a, b, c int
    a, b, c = 1, 2, 3
    或者
    var a, b, c int = 1, 2, 3
    或者
    a, b, c := 1, 2, 3

空白符
    a, _, c := 1, 3, 4

类型转换
    go不存在隐式转换,所有类型转换必须显示声明
    var a int
    var b float = 1.1
    a = int(b)

编译命令
    `go build -o bin/goroute_text.exe go_dev/day1/goroute_example/main`

init函数会在main函数调用之前调用

study_go/src/test1/add.go

    ```go
    package test1

    var Name string

    func init(){
        Name = "hujin"
    }
    ```

study_go/src/test2/main.go
    ```go
    package main

    import (
        "fmt"
        "test1"
    )

    func main(){
        fmt.Println("hahhaa" + test1.Name)
    }
    ```
环境变量 GoPath设置为`D:\workspace\go\study_go`
在terminal中输入以下命令
`D:\workspace\go\study_go> go build -o bin/test2.exe src/test2/main.go`
`D:\workspace\go\study_go> .\bin\test2.exe`
显示结果:hahhaahujin

函数声明

    ```go
        func add1(){
            //函数内容
        }
        func add2(a int) int{
            //函数内容 
        }
        func add3(a int, b int)(int, int){
            //函数内容
        }
    ```

常量使用const修饰,只读,不可修改
const只能修饰boolean, number和string类型
常量定义语法:
    const identifier [type] = value, 其中type可以省略
    例: const b string = "hello world"
        const a = "hello world"
        const a, b, c = 1, "2", "c"
        const c = 3/4 在编译阶段会计算表达式的值 满足boolean, number和string即可
        value不能是函数,函数只能在运行时才能计算值

    优雅的写法
        const(
            a = 0
            b = 1
            c = 2
        )
        const(
            d, e, f = 1, 2, 3
        )
    专业的写法
        const(
            a = "A" // "A"
            b //"A"
            c = iota // 2
            d // 3
            e // 4
        )
    常量中未赋值的默认为上一个,iota为当前这个const里该变量的位置序号,在上述的专业写法中b默认与a一致,d,e默认与c一致都为iota,iota取值为当前const中该变量的位置序号即2,3,4

    ```go
    second := time.Now().Unix()//获取当前unix时间
    time.Sleep(1000 * time.Millisecond)// 暂停1秒
    os.Getenv("GOOS")//获取当前操作系统名称
    os.Getenv("PATH")//获取当前PATH环境变量的值
    ```

值类型与引用类型
    值类型: 变量直接存储值,内存通常在栈中分配
        包括int, float, bool, string以及数组和struct
    引用类型: 变量存储的是地址值, 该地址值其对应地址上
    存储的是最终的值,内存通常在堆上分配,通过GC回收
        包括指针, slice, map, chan等
  
    ```go
    package main

    import "fmt"

    func fun1(a int){
        a = 5
    }

    func fun2(a *int){
        *a = 5 // *取值
    }

    func main(){
        a := 1
        fmt.Println("a=", a) // 1
        fun1(a)//传值
        fmt.Println("a=", a) // 1
        fun2(&a)//传址 &取址
        fmt.Println("a=", a) // 5
    }

    ```

栈分配内存比堆高效

交换两个数的值

```go
func swap(a *int, b *int){
    temp := *a
    *a = *b
    *b = temp
    return
}

func swap1(a int, b int){
    return b, a
}

first, second = second, first
```

## 控制语句

### if语句

```go
if a := 1; a > 1 {

}

if a>1 {
}
```

### for语句

```go
for{
    //无限循环
}

for a<3{
    //a<3时循环
}

for i :=0: i < 3; i++ {
    //经典for循环
}
```

### switch语句

```go
    //经典用法
    a := 1
    switch a {
        case 0:
            fmt.Println("a=0")
        case 1:
            fmt.Println("a=1")
        default:
            fmt.Println("None")
    }

    //特殊用法
    a := 1
    switch {//也可以将前面的a := 1紧跟在switch后 如 switch a := 1;{
        //switch后不跟变量, 依据case后面的表达式True或False来决定是否执行case语句块
        //若全部case表达式都为False则执行default
        case a >= 0:
            fmt.Println("a=0")
        case a >= 1:
            fmt.Println("a=1")
        default:
            fmt.Println("None")
    }
```

### goto

goto LABEL1 将程序跳转到LABEL1位置

### break

一般情况下 之跳出当前这层循环
break LABLE1 可以跳出到LABLE1标签所在层级的循环

### continue

一般情况下 结束当前循环剩余的循环次数 继续外层循环的下一次循环
continue LABLE1 结束当前循环剩余的循环次数 直接继续执行LABLE1标签所在层级的下一次循环

## 字符串

"XXX" 双引号 会转义字符
\`XXX\` 反引号 不会转义字符,且还能换行
如: "hello\tworld" 输出hello    world
    \`hahaha\nhahah\` 输出 hahaha\nhahah

## 数组

```go
    var a [2]int
    a := [2]int{}
    a := [2]int{1,2}
    a := [20]int{19:1} //最后一个元素为1
    a := [...]int{19:1} //自动计算满足索引为十九的元素为1的最小长度即20

    a := [2][3]int{{1,1,1},{2,2,2}} //多维数组
    a := [...][3]int{{1,1,1},{2,2,2}}
```

## 切片

```go
var s1 []int //定义切片

a := [10]int{1,2,3,4,5,6,7,8,9}
s1 := a[5:10] // start=5 end=10 [5,6,7,8,9]
s2 := a[5:] // start=5 end=10 [5,6,7,8,9]
s3 := a[:5] // start=0 end=5 [1,2,3,4,5] cap(s3)==cap(a)-start==10
s4 := make([]int, 3, 10) //包含3个元素 初始容量为10 以后每次扩容都是倍增
//容量是可选的 默认与初始元素个数一致
fmt.Println(len(s4), cap(s4))//cap函数可以获得切片的容量
s5 :=s3[4:6] //[5,6] 虽然切片s3中不包含元素6,但reslice是基于a[s3_start1:]

s1 = append(s1, 1, 2, 3) // [5,6,7,8,9,1,2,3]
//当append引发切片的扩容时 切片会指向新的扩容后的底层数组

copy(s1, s5)//将切片s5的元素拷贝到s1相应索引的元素上 并且不会改变切片s1的长度
```

## map

```go
var m map[int]string
m = map[int]string{} //m = make(map[int]string) 也一样

//上面两行还可以这样写
var m map[int]string = make(map[int]string)
//还可以省略定义
m := make(map[int]string)

m[1] = "OK" // map键值对的赋值

a := m[1] // map键值对的取值
delete(m, 1) // 删除map m 中键为1的键值对

a, ok := m[2][1] // 第二个返回值是个boolean值 指示该键值对是否存在
if !ok {//不存在时的处理
    m[2] = make(map[int]string)
}
m[2][1] = "Good"
a = m[2][1]

sm := make([]map[int]string, 5)
for i,v := range sm {//range迭代函数返回的两个值 分别是迭代的元素的 索引 和值的拷贝 其中v可以省略
    sm[i] = make(map[int]string, 1)
    sm[i][1] = "OK"
}

//对map进行间接排序
m := map[int]string{1: "a", 3: "c", 2: "b"}
s := make([]int, len(m))
i := 0
for k := range m {
    s[i] = k
    i++
}
sort.Ints(s)
fmt.Println(s)
```

##　函数

```go
// func 函数名(参数列表)(返回值列表){
//    函数内容
//}
func test1(){
    //没有参数时 参数列表为空
    //没有返回值时 返回值列表为空 且括号可以省略
}

func test2(a int, b string)(a int, b string){
    //返回值列表里面的返回值可以不命名 如
    //func test2(a int, b string)(int, string)
}

func test3(a int, b string) int{
    //只有一个返回值 不需要写()
}

func test4(a, b, c int)(a, b, c int){
    //参数列表里的参数类型一致,可以简略写. 返回值列表也可以简略写
}

func test5()(a, b, c int){
    a, b, c = 1, 2, 3//这里不用写 a, b, c := 1, 2, 3
    //因为返回值列表中已经声明过了 这里赋值即可

    return //这里不写return a, b, c 会自动返回a, b, c
}

//不定长变参
func test5(a ...int){
    //注意 不定长变参 必须要放在参数列表最后的位置
    //参数a 是个 slice
    fmt.Println(a)//[1, 2, 3, 4, 5]
}
// test5(1, 2, 3, 4, 5)

```

### 闭包

```go
func closure(x int) func(int) int {
    return func(y int) int {
        return x + y
    }
}
//f := closure(10)
//fmt.Println(f(1))
```

### defer

```go
//执行顺序与普通调用顺序相反
func main(){
    for i := 0; i < 3; i++ {
        defer fmt.Println(i)//2 1 0
    }

    for i := 0; i < 3; i++ {
        defer func(){//defer与匿名函数一起用时 i是对外部i的引用
            fmt.Println(i)//3 3 3
        }()
    }
}
```

### panic与recover

```go
func main(){
    A()
    B()
    C()
}

func A(){
    fmt.Println("Func A")
}

func B(){
    defer func {
        if err := recover(); err != nil {
            fmt.Println("Recover in B")
        }
    }()
    panic("Panic in B")
    //先执行 panic 进入panic状态 然后在执行 上面的匿名函数 将程序recover
}

func C(){
    fmt.Println("Func C")
}

//Func A
//Recover in B
//Func C
```