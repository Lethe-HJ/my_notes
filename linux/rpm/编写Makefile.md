## 简单的例子

Makefile
```shell
hello: hello.o    
hello.o: hello.c
    gcc -c hello.c -o hello.o
```
在这个目录下执行`make`就可以自动编译
>    这当中生成可执行文件hello依赖于hello.o,hello.o 依赖于 hello.c; 最后找到了hello.c便可以gcc生成hello.o, 这里值得注意的是写gcc命令时需要添上 -c选项，用来保证得到的.o文件可重链接，不然基本会make报错, 还有注意一点就是在Makefile中的命令（如gcc ..），必须要以[Tab]键开始，不然很可能就会make出错

## 多个中间目标文件

```shell
main: main.o add.o sub.o
main.o: main.c  
    gcc -c main.c -o main.o
add.o: add.c
    gcc -c add.c -o add.o  #加-c 指定生成为可重链接.o文件
sub.o: sub.c
    gcc -c sub.c -o sub.o

.PHONY:clean
clean:
    -rm -rf *.o

```

> 最终目标文件依赖多个.o时，将依赖的多个.o  一起写到main: 后面。然后依次以  目标：依赖文件  gcc...   的格式，罗列所有依赖关系

> 由于在上面的过程中生成了多个中间.o文件(实际工程中肯定是比较多的），所以每次编译完成，后续基本还需要进行一定的清理工作，这时候就用上一个 "clean" (后面细说一下）来清理。

> PHONY意思表示clean是一个“伪目标”。也即是无论clean是否最新，一定执行它。rm命令前面加了一个小减号的意思就是，也许某些文件出现问题，但并不理睬。当然，clean的规则不要放在文件的开头，否则这就会变成make的默认目标，相信谁也不愿意这样。

> clean只是一个自定义的名词，故冒号后面为空就行


## make的执行

1. make会在当前目录下找名字叫“Makefile”或“makefile”的文件
2. 如果找到，它会找文件中的第一个目标文件（target），在上面的例子中，他会找到“main”这个文件，并把这个文件作为最终的目标文件。
3. 如果main文件不存在，或是main所依赖的后面的 .o 文件的文件修改时间要比main这个文件新，那么，它就会执行后面所定义的命令来生成main这个文件。
4. 如果main所依赖的.o文件也不存在，那么make会在当前文件中找目标为.o文件的依赖性，如果找到则再根据那一个规则生成.o文件

> 这就是整个make的依赖性，make会一层又一层地去找文件的依赖关系，直到最终编译出第一个目标文件。在找寻的过程中，如果出现错误，比如最后被依赖的文件找不到，那么make就会直接退出，并报错，而对于所定义的命令的错误，或是编译不成功，并不会报错


## makefile的简化

`$^`    代表所有的依赖文件
`$@`    代表所有的目标文件 
`$<`   代表第一个依赖文件 

可以将上面的makefile改写成
```shell


main: main.o add.o sub.o
main.o: main.c  
    gcc -c $< -o $@
add.o: add.c
    gcc -c $^ -o $@  
sub.o: sub.c
    gcc -c $^ -o $@

.PHONY:clean
clean:
    rm -rf *.o
```

还能定义一个变量将所有目标文件列出来

```shell
.PHONY:clean

OBJS = main.o\   //\转义字符
       add.o\
       sub.o

main: $(OBJS) 
%.o : %.c
    gcc -c $^ -o $@

clean:
    -rm -rf $(OBJS)

```

