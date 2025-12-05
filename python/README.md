# 资源链接

https://python.study/
https://www.w3schools.com/python/
https://www.studytonight.com/python/

## 多行文本

```py
a = """Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt
ut labore et dolore magna aliqua."""
print(a)
```

```py
a = '''Lorem ipsum dolor sit amet,
consectetur adipiscing elit,
sed do eiusmod tempor incididunt
ut labore et dolore magna aliqua.'''
print(a)
```

## 截取文本

```py
b = "Hello, World!"
print(b[2:5])


b = "Hello, World!"
print(b[:5])
```

## 字母大小写

```py
a = "Hello, World!"
print(a.upper())


a = "Hello, World!"
print(a.lower())
```

## 移除两端空格或某些字符

```py
a = " Hello, World! "
print(a.strip()) # returns "Hello, World!"


txt = ",,,,,rrttgg.....banana....rrr"

x = txt.strip(",.grt")

print(x)# banana
```

## 文本模板

```py
age = 36
txt = f"My name is John, I am {age}"
print(txt)


price = 59
txt = f"The price is {price} dollars"
print(txt)
```

数值取小数点后两位数

```py
price = 59
txt = f"The price is {price:.2f} dollars"
print(txt)
```

计算

```py
txt = f"The price is {20 * 59} dollars"
print(txt)
```

## 转义符

```py
txt = "We are the so-called \"Vikings\" from the north."
```

| Code   | Result          |
| ------ | --------------- |
| `\'`   | Single Quote    |
| `\\`   | Backslash       |
| `\n`   | New Line        |
| `\r`   | Carriage Return |
| `\t`   | Tab             |
| `\b`   | Backspace       |
| `\f`   | Form Feed       |
| `\ooo` | Octal value     |
| `\xhh` | Hex value       |

## 字符串方法

https://www.w3schools.com/python/python_strings_methods.asp

文本出现次数

```py
txt = "I love apples, apple are my favorite fruit"

x = txt.count("apple")

print(x)
```

编码方式

```py

txt = "My name is Ståle"
# utf-8
x = txt.encode()

print(x)

txt = "My name is Ståle"

print(txt.encode(encoding="ascii",errors="backslashreplace"))
print(txt.encode(encoding="ascii",errors="ignore"))
print(txt.encode(encoding="ascii",errors="namereplace"))
print(txt.encode(encoding="ascii",errors="replace"))
print(txt.encode(encoding="ascii",errors="xmlcharrefreplace"))
```

是否有某结束字符

```py
txt = "Hello, welcome to my world."

x = txt.endswith(".")

print(x)

# 以A或B字符串结束
txt = "Hello, welcome to my castle."

x = txt.endswith(("world.", "castle."))

print(x)
# 检查某位置内的字符串是否以x结束
txt = "Hello, welcome to my world."

x = txt.endswith("my world.", 5, 11)

print(x)
```

以某字符串开始

```py
txt = "Hello, welcome to my world."

x = txt.startswith("Hello")

print(x)


txt = "Hello, welcome to my world."

x = txt.startswith("wel", 7, 20)

print(x)

txt = "Hi, welcome to my world."

x = txt.startswith(("Hello", "Hi"))

print(x)
```

文本格式化模板

```py
txt = "For only {price:.2f} dollars!"
print(txt.format(price = 49))


txt1 = "My name is {fname}, I'm {age}".format(fname = "John", age = 36)
txt2 = "My name is {0}, I'm {1}".format("John",36)
txt3 = "My name is {}, I'm {}".format("John",36)
```

https://www.w3schools.com/python/ref_string_format.asp

格式化可以对数值和字符串处理，比如小数点位数，字母小写等

查找子字符串位置

```py
txt = "Hello, welcome to my world."

x = txt.find("e")

print(x)
# 某范围内子字符串位置
txt = "Hello, welcome to my world."

x = txt.find("e", 5, 10)

print(x)


txt = "Hello, welcome to my world."

x = txt.index("welcome")

print(x)


txt = "Hello, welcome to my world."

x = txt.index("e", 5, 10)

print(x)


txt = "Hello, welcome to my world."

print(txt.find("q"))# -1
print(txt.index("q")) # 报错
```

字符串合并

```py
myTuple = ("John", "Peter", "Vicky")

x = "#".join(myTuple)

print(x)


myDict = {"name": "John", "country": "Norway"}
mySeparator = "TEST"

x = mySeparator.join(myDict)

print(x)
```

小写

```py
txt = "Hello my FRIENDS"

x = txt.lower()

print(x)
```

大写

```py
txt = "Hello my friends"

x = txt.upper()

print(x)
```

字符串分割

```py
txt = "hello, my name is Peter, I am 26 years old"

x = txt.split(", ")

print(x)

txt = "apple#banana#cherry#orange"

# 多少个出现的地方分割
x = txt.split("#", 1)

print(x)
```

## bool

布尔转换

```py
print(bool("abc"),
bool(123),
bool(["apple", "cherry", "banana"]),
bool(False),
bool(None),
bool(0),
bool(""),
bool(()),
bool([]),
bool({}))
# True True True False False False False False False False


class myclass():
  def __len__(self):
    return 0

myobj = myclass()
print(bool(myobj)) # False


def myFunction() :
  return True

print(myFunction())# True

x = 200
print(isinstance(x, int)) # True
```

## 运算

```py
x = 15
y = 4

print(x + y)
print(x - y)
print(x * y)
print(x / y)
print(x % y)
print(x ** y) # 幂运算
print(x // y) # 向下取整除法

# 19
# 11
# 60
# 3.75
# 3
# 50625
# 3
```

| Operator | Example       | Same As        |
| -------- | ------------- | -------------- |
| =        | x = 5         | x = 5          |
| +=       | x += 3        | x = x + 3      |
| -=       | x -= 3        | x = x - 3      |
| \*=      | x \*= 3       | x = x \* 3     |
| /=       | x /= 3        | x = x / 3      |
| %=       | x %= 3        | x = x % 3      |
| //=      | x //= 3       | x = x // 3     |
| \*\*=    | x \*\*= 3     | x = x \*\* 3   |
| &=       | x &= 3        | x = x & 3      |
| \|=      | x \|= 3       | x = x \| 3     |
| ^=       | x ^= 3        | x = x ^ 3      |
| >>=      | x >>= 3       | x = x >> 3     |
| <<=      | x <<= 3       | x = x << 3     |
| :=       | print(x := 3) | x = 3 print(x) |

或

```py
x = 5

print(x < 5 or x > 10) # False
```

且

```py
x = 5

print(x > 0 and x < 10) # True
```

```py
x = 5

print(not(x > 3 and x < 10)) # False
```

是否

```py
x = ["apple", "banana"]
y = ["apple", "banana"]
z = x

print(x is z)
print(x is y)
print(x == y)
# True
# False
# True

x = ["apple", "banana"]
y = ["apple", "banana"]

print(x is not y) # True


x = [1, 2, 3]
y = [1, 2, 3]

print(x == y)
print(x is y)

# True
# False
```

包含

```py
fruits = ["apple", "banana", "cherry"]

print("banana" in fruits) # True

fruits = ["apple", "banana", "cherry"]

print("pineapple" not in fruits)# True

text = "Hello World"

print("H" in text) # True
print("hello" in text) # False
print("z" not in text)# True
```

二进制运算

```py
print(6 & 3)
print(6 | 3)
print(6 ^ 3)
print(~4)
print(8 << 3)
print(8 >> 3)

# 2
# 7
# 5
# -5
# 64
# 1
```

## List 列表

```py
thislist = ["apple", "banana", "cherry"]
print(thislist[1])# banana
print(thislist[-1])# cherry


thislist = ["apple", "banana", "cherry", "orange", "kiwi", "melon", "mango"]
print(thislist[2:5])# ['cherry', 'orange', 'kiwi']


thislist = ["apple", "banana", "cherry", "orange", "kiwi", "melon", "mango"]
print(thislist[:4]) # ['apple', 'banana', 'cherry', 'orange']


thislist = ["apple", "banana", "cherry", "orange", "kiwi", "melon", "mango"]
print(thislist[2:])# ['cherry', 'orange', 'kiwi', 'melon', 'mango']
```

赋值

```py
thislist = ["apple", "banana", "cherry"]
thislist[1] = "blackcurrant"
print(thislist)


thislist = ["apple", "banana", "cherry", "orange", "kiwi", "mango"]
thislist[1:3] = ["blackcurrant", "watermelon"]
print(thislist)

thislist = ["apple", "banana", "cherry"]
thislist[1:2] = ["blackcurrant", "watermelon"]
print(thislist)

thislist = ["apple", "banana", "cherry"]
thislist[1:3] = ["watermelon"]
print(thislist)

# ['apple', 'blackcurrant', 'watermelon', 'orange', 'kiwi', 'mango']
# ['apple', 'blackcurrant', 'watermelon', 'cherry']
# ['apple', 'watermelon']
```

添加元素

```py
thislist = ["apple", "banana", "cherry"]
thislist.append("orange")
print(thislist) # ['apple', 'banana', 'cherry', 'orange']

thislist = ["apple", "banana", "cherry"]
thislist.insert(1, "orange")
print(thislist) # ['apple', 'orange', 'banana', 'cherry']
```

删除元素

```py
thislist = ["apple", "banana", "cherry"]
thislist.remove("banana")
print(thislist)# ['apple', 'cherry']

thislist = ["apple", "banana", "cherry", "banana", "kiwi"]
thislist.remove("banana")
print(thislist) # ['apple', 'cherry', 'banana', 'kiwi']

thislist = ["apple", "banana", "cherry"]
thislist.pop(1)
print(thislist)# ['apple', 'cherry']

thislist = ["apple", "banana", "cherry"]
thislist.pop()
print(thislist)# ['apple', 'banana']

thislist = ["apple", "banana", "cherry"]
del thislist[0]
print(thislist)# ['banana', 'cherry']

# 删除列表
thislist = ["apple", "banana", "cherry"]
del thislist

# 清空列表
thislist = ["apple", "banana", "cherry"]
thislist.clear()
print(thislist)# []
```

遍历列表

```py
thislist = ["apple", "banana", "cherry"]
for x in thislist:
  print(x)

thislist = ["apple", "banana", "cherry"]
for i in range(len(thislist)):
  print(thislist[i])
```

过滤

```py
fruits = ["apple", "banana", "cherry", "kiwi", "mango"]
newlist = []

for x in fruits:
  if "a" in x:
    newlist.append(x)

print(newlist)# ['apple', 'banana', 'mango']


fruits = ["apple", "banana", "cherry", "kiwi", "mango"]

newlist = [x for x in fruits if "a" in x]

print(newlist)# ['apple', 'banana', 'mango']
```

排序

```py
# 升序
thislist = ["orange", "mango", "kiwi", "pineapple", "banana"]
thislist.sort()
print(thislist)# ['banana', 'kiwi', 'mango', 'orange', 'pineapple']

thislist = [100, 50, 65, 82, 23]
thislist.sort()
print(thislist)# [23, 50, 65, 82, 100]

# 降序
thislist = ["orange", "mango", "kiwi", "pineapple", "banana"]
thislist.sort(reverse = True)
print(thislist)# ['pineapple', 'orange', 'mango', 'kiwi', 'banana']

thislist = [100, 50, 65, 82, 23]
thislist.sort(reverse = True)
print(thislist) # [100, 82, 65, 50, 23]
```

复制列表

```py
thislist = ["apple", "banana", "cherry"]
mylist = thislist.copy()
print(mylist)

thislist = ["apple", "banana", "cherry"]
mylist = list(thislist)
print(mylist)

thislist = ["apple", "banana", "cherry"]
mylist = thislist[:]
print(mylist)
```

连接列表

```py
list1 = ["a", "b", "c"]
list2 = [1, 2, 3]

list3 = list1 + list2
print(list3)# ['a', 'b', 'c', 1, 2, 3]


list1 = ["a", "b" , "c"]
list2 = [1, 2, 3]

for x in list2:
  list1.append(x)

print(list1)


list1 = ["a", "b" , "c"]
list2 = [1, 2, 3]

list1.extend(list2)
print(list1)
```

反转列表

```py
fruits = ['apple', 'banana', 'cherry']

fruits.reverse()
```

列表方法
https://www.w3schools.com/python/python_lists_methods.asp

## 元组

```py
mytuple = ("apple", "banana", "cherry")

print(mytuple[1]) # banana
print(mytuple[-1]) # cherry

thistuple = ("apple", "banana", "cherry", "orange", "kiwi", "melon", "mango")
print(thistuple[2:5])# ('cherry', 'orange', 'kiwi')


thistuple = ("apple", "banana", "cherry", "orange", "kiwi", "melon", "mango")
print(thistuple[:4])# ('apple', 'banana', 'cherry', 'orange')

thistuple = ("apple", "banana", "cherry", "orange", "kiwi", "melon", "mango")
print(thistuple[2:]) # ('cherry', 'orange', 'kiwi', 'melon', 'mango')
```

更新元组

```py
x = ("apple", "banana", "cherry")
y = list(x)
y[1] = "kiwi"
x = tuple(y)

print(x) #('apple', 'kiwi', 'cherry')


thistuple = ("apple", "banana", "cherry")
y = list(thistuple)
y.append("orange")
thistuple = tuple(y)
print(thistuple) # ('apple', 'banana', 'cherry', 'orange')


thistuple = ("apple", "banana", "cherry")
y = ("orange",)
thistuple += y

print(thistuple) # ('apple', 'banana', 'cherry', 'orange')


```

解构

```py
fruits = ("apple", "banana", "cherry")

(green, yellow, red) = fruits

print(green)
print(yellow)
print(red)
```

遍历

```py
thistuple = ("apple", "banana", "cherry")
for x in thistuple:
  print(x)

thistuple = ("apple", "banana", "cherry")
for i in range(len(thistuple)):
  print(thistuple[i])
```

合并元组

```py
tuple1 = ("a", "b" , "c")
tuple2 = (1, 2, 3)

tuple3 = tuple1 + tuple2
print(tuple3)# ('a', 'b', 'c', 1, 2, 3)


fruits = ("apple", "banana", "cherry")
mytuple = fruits * 2

print(mytuple)# ('apple', 'banana', 'cherry', 'apple', 'banana', 'cherry')
```

元素出现次数

```py
thistuple = (1, 3, 7, 8, 7, 5, 4, 6, 8, 5)

x = thistuple.count(5)

print(x) # 2
```

元素在元组的位置

```py
thistuple = (1, 3, 7, 8, 7, 5, 4, 6, 8, 5)

x = thistuple.index(8)

print(x)# 3
```

## Set 集合

```py
thisset = {"apple", "banana", "cherry", "apple"}

print(thisset)# {'apple', 'cherry', 'banana'}


thisset = {"apple", "banana", "cherry", True, 1, 2}
# True和1会视为一个值
print(thisset)# {True, 2, 'banana', 'apple', 'cherry'}

thisset = {"apple", "banana", "cherry", False, True, 0}
# False和0会视为一个值
print(thisset)# {False, True, 'cherry', 'apple', 'banana'}
```

遍历

```py
thisset = {"apple", "banana", "cherry"}

for x in thisset:
  print(x)
```

包含

```py
thisset = {"apple", "banana", "cherry"}

print("banana" in thisset)


thisset = {"apple", "banana", "cherry"}

print("banana" not in thisset)
```

添加元素

```py
thisset = {"apple", "banana", "cherry"}

thisset.add("orange")

print(thisset)# {'cherry', 'orange', 'banana', 'apple'}

thisset = {"apple", "banana", "cherry"}
tropical = {"pineapple", "mango", "papaya"}

thisset.update(tropical)

print(thisset)# {'pineapple', 'papaya', 'cherry', 'apple', 'banana', 'mango'}

thisset = {"apple", "banana", "cherry"}
mylist = ["kiwi", "orange"]

thisset.update(mylist)

print(thisset)# {'kiwi', 'orange', 'banana', 'cherry', 'apple'}
```

移除元素

```py
thisset = {"apple", "banana", "cherry"}

thisset.remove("banana")

print(thisset)# {'apple', 'cherry'}


thisset = {"apple", "banana", "cherry"}

thisset.discard("banana")

print(thisset)# {'apple', 'cherry'}


thisset = {"apple", "banana", "cherry"}

x = thisset.pop()

print(x)# banana

print(thisset)# {'cherry', 'apple'}


thisset = {"apple", "banana", "cherry"}

thisset.clear()

print(thisset)# set()

# 删除set集合
thisset = {"apple", "banana", "cherry"}

del thisset

print(thisset)
```

合并

```py
set1 = {"a", "b", "c"}
set2 = {1, 2, 3}

set3 = set1.union(set2)
print(set3)# {1, 2, 3, 'b', 'c', 'a'}

set1 = {"a", "b", "c"}
set2 = {1, 2, 3}

set3 = set1 | set2
print(set3)# {1, 'b', 2, 3, 'c', 'a'}


set1 = {"a", "b", "c"}
set2 = {1, 2, 3}
set3 = {"John", "Elena"}
set4 = {"apple", "bananas", "cherry"}

myset = set1.union(set2, set3, set4)
print(myset)# {1, 2, 'a', 3, 'John', 'apple', 'b', 'cherry', 'bananas', 'c', 'Elena'}


set1 = {"a", "b", "c"}
set2 = {1, 2, 3}
set3 = {"John", "Elena"}
set4 = {"apple", "bananas", "cherry"}

myset = set1 | set2 | set3 |set4
print(myset)# {'c', 1, 2, 3, 'bananas', 'John', 'b', 'a', 'apple', 'Elena', 'cherry'}


set1 = {"a", "b" , "c"}
set2 = {1, 2, 3}

set1.update(set2)
print(set1)# {'c', 1, 2, 3, 'a', 'b'}
```

交集

```py
set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set3 = set1.intersection(set2)
print(set3)# {'apple'}


set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set3 = set1 & set2
print(set3)# {'apple'}

set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set1.intersection_update(set2)

print(set1)# {'apple'}
```

差集

```py
set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set3 = set1.difference(set2)

print(set3)# {'banana', 'cherry'}

set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set3 = set1 - set2
print(set3)# {'banana', 'cherry'}


set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set1.difference_update(set2)

print(set1)# {'cherry', 'banana'}
```

差并集

```py
set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set3 = set1.symmetric_difference(set2)

print(set3)# {'google', 'cherry', 'banana', 'microsoft'}


set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set3 = set1 ^ set2
print(set3)


set1 = {"apple", "banana", "cherry"}
set2 = {"google", "microsoft", "apple"}

set1.symmetric_difference_update(set2)

print(set1)
```

锁定集合

```
x = frozenset({"apple", "banana", "cherry"})
print(x)# frozenset({'apple', 'cherry', 'banana'})
print(type(x)) # <class 'frozenset'>
```

# Dict 字典

```py
thisdict = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
print(thisdict["brand"])# Ford

x = thisdict.get("model")
print(x)# Mustang

x = thisdict.keys()

print(x)# dict_keys(['brand', 'model', 'year'])

thisdict["year"] = 2018

thisdict.update({"year": 2020})

thisdict["color"] = "red"

thisdict.update({"color": "red"})
```

删除元素

```py
thisdict = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
thisdict.pop("model")
print(thisdict)# {'brand': 'Ford', 'year': 1964}

thisdict = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
thisdict.popitem()
print(thisdict)# {'brand': 'Ford', 'model': 'Mustang'}


del thisdict["model"]
# 删除字典
del thisdict
# 清空
thisdict.clear()
```

遍历

```py
thisdict = {
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
for x in thisdict:
  print(x,thisdict[x])

# brand Ford
# model Mustang
# year 1964
thisdict.keys()
thisdict.values()

for x, y in thisdict.items():
  print(x, y)
```

复制

```py
mydict = thisdict.copy()

mydict = dict(thisdict)
```

```py
myfamily = {
  "child1" : {
    "name" : "Emil",
    "year" : 2004
  },
  "child2" : {
    "name" : "Tobias",
    "year" : 2007
  },
  "child3" : {
    "name" : "Linus",
    "year" : 2011
  }
}
print(myfamily["child2"]["name"])

for x, obj in myfamily.items():
  print(x)

  for y in obj:
    print(y + ':', obj[y])
```

字典方法
https://www.w3schools.com/python/python_dictionaries_methods.asp

# if else

```py
age = 20
if age >= 18:
  print("You are an adult")
  print("You can vote")
  print("You have full legal rights")


score = 75

if score >= 90:
  print("Grade: A")
elif score >= 80:
  print("Grade: B")
elif score >= 70:
  print("Grade: C")
elif score >= 60:
  print("Grade: D")
else:
  print("Grade: E")
```

条件赋值

```py
a = 10
b = 20
bigger = a if a > b else b
print("Bigger is", bigger)# 20
```

条件打印

```py
a = 330
b = 330
print("A") if a > b else print("=") if a == b else print("B")# =
```

且条件

```py
a = 200
b = 33
c = 500
if a > b and c > a:
  print("Both conditions are True")
```

或条件

```py
a = 200
b = 33
c = 500
if a > b or a > c:
  print("At least one of the conditions is True")
```

非条件

```py
a = 33
b = 200
if not a > b:
  print("a is NOT greater than b")
```

多级条件

```py
score = 85
attendance = 90
submitted = True

if score >= 60:
  if attendance >= 80:
    if submitted:
      print("Pass with good standing")# Pass with good standing
    else:
      print("Pass but missing assignment")
  else:
    print("Pass but low attendance")
else:
  print("Fail")
```

## switch

```py
day = 4
match day:
  case 1:
    print("Monday")
  case 2:
    print("Tuesday")
  case 3:
    print("Wednesday")
  case 4:
    print("Thursday")
  case 5:
    print("Friday")
  case 6:
    print("Saturday")
  case 7:
    print("Sunday")
```

## while

```py
i = 1
while i < 6:
  print(i)
  if i == 3:
    break
  i += 1

# 1
# 2
# 3
```
