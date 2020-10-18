# C#基础

## hello world

```c#
using System;

class Hello
{
    static void Main()
    {
        Console.WriteLine("Hello, World");
    }
}
```

```c#
int i = 123;
object o = i;    // Boxing
int j = (int)o;  // Unboxing
```

## 类

### 成员

常量：与类相关联的常量值
字段：与类关联的变量
方法：类可执行的操作
属性：与读取和写入类的已命名属性相关联的操作
索引器：与将类实例编入索引（像处理数组一样）相关联的操作
事件：类可以生成的通知
运算符：类支持的转换和表达式运算符
构造函数：初始化类实例或类本身所需的操作
终结器：永久放弃类实例之前执行的操作
类型：类声明的嵌套类型

### 访问控制

public：访问不受限制。
private：访问仅限于此类。
protected：访问仅限于此类或派生自此类的类。
internal：仅可访问当前程序集（.exe 或 .dll）。
protected internal：仅可访问此类、从此类中派生的类，或者同一程序集中的类。
private protected：仅可访问此类或同一程序集中从此类中派生的类。

### 字段

```C#
public class Color
{
    public static readonly Color Black = new Color(0, 0, 0);
    public static readonly Color White = new Color(255, 255, 255);
    public static readonly Color Red = new Color(255, 0, 0);
    public static readonly Color Green = new Color(0, 255, 0);
    public static readonly Color Blue = new Color(0, 0, 255);

    public byte R;
    public byte G;
    public byte B;

    public Color(byte r, byte g, byte b)
    {
        R = r;
        G = g;
        B = b;
    }
}
```

### 方法

静态方法是通过类进行访问。 实例方法是通过类实例进行访问

```C#
public override ToString() => "This is an object";
```

### 参数

值参数、引用参数、输出参数和参数数组。

```C#
static void Swap(ref int x, ref int y)
{
    int temp = x;
    x = y;
    y = temp;
}

public static void SwapExample()
{
    int i = 1, j = 2;
    Swap(ref i, ref j);
    Console.WriteLine($"{i} {j}");    // "2 1"
}
```

### 基类

```C#
public class Point3D : Point
{
    public int Z { get; set; }

    public Point3D(int x, int y, int z) : base(x, y)
    {
        Z = z;
    }
}

Point a = new Point(10, 20);
Point b = new Point3D(10, 20, 30);
```

### 泛型类

```C#
public class Pair<TFirst, TSecond>
{
    public TFirst First { get; }
    public TSecond Second { get; }

    public Pair(TFirst first, TSecond second) => (First, Second) = (first, second);
}

var pair = new Pair<int, string>(1, "two");
int i = pair.First;     // TFirst int
string s = pair.Second; // TSecond string
```

## 结构

```C#
public struct Point
{
    public double X { get; }
    public double Y { get; }

    public Point(double x, double y) => (X, Y) = (x, y);
}
```

## 接口

```C#
interface IControl
{
    void Paint();
}

interface ITextBox : IControl
{
    void SetText(string text);
}

interface IListBox : IControl
{
    void SetItems(string[] items);
}

interface IComboBox : ITextBox, IListBox { }
```

类和结构可以实现多个接口

```C#
interface IDataBound
{
    void Bind(Binder b);
}

public class EditBox : IControl, IDataBound
{
    public void Paint() { }
    public void Bind(Binder b) { }
}
```

当类或结构实现特定接口时，此类或结构的实例可以隐式转换成相应的接口类型

```C#
EditBox editBox = new EditBox();
IControl control = editBox;
IDataBound dataBound = editBox;
```

## 枚举

枚举类型定义了一组常数值。

```C#
public enum Seasons
{
    None = 0,
    Summer = 1,
    Autumn = 2,
    Winter = 4,
    Spring = 8,
    All = Summer | Autumn | Winter | Spring
}
```

## 可为 null 的类型

```C#
int? optionalInt = default; 
optionalInt = 5;
string? optionalText = default;
optionalText = "Hello World.";
```

## 元组

C# 支持元组，后者提供了简洁的语法来将多个数据元素分组成一个轻型数据结构

```C#
(double Sum, int Count) t2 = (4.5, 3);
Console.WriteLine($"Sum of {t2.Count} elements is {t2.Sum}.");
// Output:
// Sum of 3 elements is 4.5.
```

```c#
using System;

namespace Acme.Collections
{
    public class Stack<T>
    {
        Entry _top;

        public void Push(T data)
        {
            _top = new Entry(_top, data);
        }

        public T Pop()
        {
            if (_top == null)
            {
                throw new InvalidOperationException();
            }
            T result = _top.Data;
            _top = _top.Next;

            return result;
        }

        class Entry
        {
            public Entry Next { get; set; }
            public T Data { get; set; }

            public Entry(Entry next, T data)
            {
                Next = next;
                Data = data;
            }
        }
    }
}
```

```c#
using System;
using Acme.Collections;

class Example
{
    public static void Main()
    {
        var s = new Stack<int>();
        s.Push(1); // stack contains 1
        s.Push(10); // stack contains 1, 10
        s.Push(100); // stack contains 1, 10, 100
        Console.WriteLine(s.Pop()); // stack contains 1, 10
        Console.WriteLine(s.Pop()); // stack contains 1
        Console.WriteLine(s.Pop()); // stack is empty
    }
}
```