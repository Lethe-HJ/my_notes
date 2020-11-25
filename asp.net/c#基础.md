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

输出参数与引用参数类似，不同之处在于，不要求向调用方提供的自变量显式赋值

```C#
static void Divide(int x, int y, out int result, out int remainder)
{
    result = x / y;
    remainder = x % y;
}

public static void OutUsage()
{
    Divide(10, 3, out int res, out int rem);
    Console.WriteLine($"{res} {rem}"); // "3 1"
}
```

参数数组允许向方法传递数量不定的自变量。 参数数组使用 params 修饰符进行声明。
参数数组只能是方法的最后一个参数，且参数数组的类型必须是一维数组类型

### 抽象方法

```c#
public class Console
{
    public static void Write(string fmt, params object[] args) { }
    public static void WriteLine(string fmt, params object[] args) { }
    // ...
}
```

```C#
public abstract class Expression
{
    public abstract double Evaluate(Dictionary<string, object> vars);
}

public class Constant : Expression
{
    double _value;

    public Constant(double value)
    {
        _value = value;
    }

    public override double Evaluate(Dictionary<string, object> vars)
    {
        return _value;
    }
}

public class VariableReference : Expression
{
    string _name;

    public VariableReference(string name)
    {
        _name = name;
    }

    public override double Evaluate(Dictionary<string, object> vars)
    {
        object value = vars[_name] ?? throw new Exception($"Unknown variable: {_name}");
        return Convert.ToDouble(value);
    }
}

public class Operation : Expression
{
    Expression _left;
    char _op;
    Expression _right;

    public Operation(Expression left, char op, Expression right)
    {
        _left = left;
        _op = op;
        _right = right;
    }

    public override double Evaluate(Dictionary<string, object> vars)
    {
        double x = _left.Evaluate(vars);
        double y = _right.Evaluate(vars);
        switch (_op)
        {
            case '+': return x + y;
            case '-': return x - y;
            case '*': return x * y;
            case '/': return x / y;

            default: throw new Exception("Unknown operator");
        }
    }
}
```

### 方法重载

```C#
class OverloadingExample
{
    static void F() => Console.WriteLine("F()");
    static void F(object x) => Console.WriteLine("F(object)");
    static void F(int x) => Console.WriteLine("F(int)");
    static void F(double x) => Console.WriteLine("F(double)");
    static void F<T>(T x) => Console.WriteLine("F<T>(T)");
    static void F(double x, double y) => Console.WriteLine("F(double, double)");
    public static void UsageExample()
    {
        F();            // Invokes F()
        F(1);           // Invokes F(int)
        F(1.0);         // Invokes F(double)
        F("abc");       // Invokes F<string>(string)
        F((double)1);   // Invokes F(double)
        F((object)1);   // Invokes F(object)
        F<int>(1);      // Invokes F<int>(int)
        F(1, 1);        // Invokes F(double, double)
    }
}
```

### 属性

```C#
public class MyList<T>
{
    const int DefaultCapacity = 4;

    T[] _items;
    int _count;

    public MyList(int capacity = DefaultCapacity)
    {
        _items = new T[capacity];
    }

    public int Count => _count;

    // 属性get set
    public int Capacity
    {
        get =>  _items.Length;
        set
        {
            if (value < _count) value = _count;
            if (value != _items.Length)
            {
                T[] newItems = new T[value];
                Array.Copy(_items, 0, newItems, 0, _count);
                _items = newItems;
            }
        }
    }

    public T this[int index]
    {
        get => _items[index];
        set
        {
            _items[index] = value;
            OnChanged();
        }
    }

    public void Add(T item)
    {
        if (_count == Capacity) Capacity = _count * 2;
        _items[_count] = item;
        _count++;
        OnChanged();
    }
    protected virtual void OnChanged() =>
        Changed?.Invoke(this, EventArgs.Empty);

    public override bool Equals(object other) =>
        Equals(this, other as MyList<T>);

    static bool Equals(MyList<T> a, MyList<T> b)
    {
        if (Object.ReferenceEquals(a, null)) return Object.ReferenceEquals(b, null);
        if (Object.ReferenceEquals(b, null) || a._count != b._count)
            return false;
        for (int i = 0; i < a._count; i++)
        {
            if (!object.Equals(a._items[i], b._items[i]))
            {
                return false;
            }
        }
        return true;
    }

    public event EventHandler Changed;

    public static bool operator ==(MyList<T> a, MyList<T> b) =>
        Equals(a, b);

    public static bool operator !=(MyList<T> a, MyList<T> b) =>
        !Equals(a, b);
}
```

### 构造函数

C# 支持实例和静态构造函数。 实例构造函数是实现初始化类实例所需执行的操作的成员。 静态构造函数是实现在首次加载类时初始化类本身所需执行的操作的成员。
构造函数的声明方式与方法一样，都没有返回类型，且与所含类同名。 如果构造函数声明包含 static 修饰符，则声明的是静态构造函数。 否则，声明的是实例构造函数。

### 虚方法

如果实例方法声明中有 virtual 修饰符，可以将实例方法称为“虚方法”。 如果没有 virtual 修饰符，可以将实例方法称为“非虚方法”。
调用虚方法时，为其调用方法的实例的运行时类型决定了要调用的实际方法实现代码。 调用非虚方法时，实例的编译时类型是决定性因素。
可以在派生类中重写虚方法。 如果实例方法声明中有 override 修饰符，那么实例方法可以重写签名相同的继承虚方法。 虚方法声明引入了新方法。 重写方法声明通过提供现有继承的虚方法的新实现，专门针对该方法。

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