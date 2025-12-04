# Python

## 输入输出

```py
x = float(input("Enter the first number:"))

y=float(input("Enter the second number:"))

print(x,'+',y,'=',x+y)
```

## 类型和查看类型

```py
X = str(3)    # x will be '3'
Y = int(3)    # y will be 3
Z = float(3)  # z will be 3.0
A=bool(True)
print(type(X))
print(type(Y))
print(type(Z))
print(type(A))

# <class 'str'>
# <class 'int'>
# <class 'float'>
# <class 'bool'>
```

| 数据类型        | 方法                               |
| --------------- | ---------------------------------- |
| 字符串          | `str`                              |
| 数值            | `int`, `float`, `complex`          |
| Sequence Types: | `list`, `tuple`, `range`           |
| Mapping Type:   | `dict`                             |
| Set Types:      | `set`, `frozenset`                 |
| Boolean Type:   | `bool`                             |
| Binary Types:   | `bytes`, `bytearray`, `memoryview` |
| None Type:      | `NoneType`                         |

**类型代码**

| 代码                                         | 数据类型   |
| -------------------------------------------- | ---------- |
| x = "Hello World"                            | str        |
| x = 20                                       | int        |
| x = 20.5                                     | float      |
| x = 1j                                       | complex    |
| x = ["apple", "banana", "cherry"]            | list       |
| x = ("apple", "banana", "cherry")            | tuple      |
| x = range(6)                                 | range      |
| x = {"name" : "John", "age" : 36}            | dict       |
| x = {"apple", "banana", "cherry"}            | set        |
| x = frozenset({"apple", "banana", "cherry"}) | frozenset  |
| x = True                                     | bool       |
| x = b"Hello"                                 | bytes      |
| x = bytearray(5)                             | bytearray  |
| x = memoryview(bytes(5))                     | memoryview |
| x = None                                     | NoneType   |

| Example                                      | 类型       |
| -------------------------------------------- | ---------- |
| x = str("Hello World")                       | str        |
| x = int(20)                                  | int        |
| x = float(20.5)                              | float      |
| x = complex(1j)                              | complex    |
| x = list(("apple", "banana", "cherry"))      | list       |
| x = tuple(("apple", "banana", "cherry"))     | tuple      |
| x = range(6)                                 | range      |
| x = dict(name="John", age=36)                | dict       |
| x = set(("apple", "banana", "cherry"))       | set        |
| x = frozenset(("apple", "banana", "cherry")) | frozenset  |
| x = bool(5)                                  | bool       |
| x = bytes(5)                                 | bytes      |
| x = bytearray(5)                             | bytearray  |
| x = memoryview(bytes(5))                     | memoryview |

## 类型转换

```py
x = float(1)     # x will be 1.0
y = float(2.8)   # y will be 2.8
z = float("3")   # z will be 3.0
w = float("4.2") # w will be 4.2


x = str("s1") # x will be 's1'
y = str(2)    # y will be '2'
z = str(3.0)  # z will be '3.0'
```

## 多个赋值

```py
a, b, c = "Orange", "Banana", "Cherry"
print(a,b,c)
a = b = c = "Orange"
print(a,b,c)
fruits = ["apple", "banana", "cherry"]
a, b, c = fruits
print(a,b,c)
```

## 全局变量

```py
x = "awesome"

def myfunc():
  x = "fantastic"
  print("Python is " + x)

myfunc()

print("Python is " + x)
# Python is fantastic
# Python is awesome
```

```py
def myfunc1():
  global x
  x = "fantastic"

myfunc1()

print("Python is " + x)
# Python is fantastic
```

```py
x = "awesome"

def myfunc():
  global x
  x = "fantastic"

myfunc()

print("Python is " + x)
# Python is fantastic
```

## 随机数

```py
import random

print(random.randrange(99, 999))
```
