# 引入函数库
import math
import cmath
import random
import time
import calendar
# 查看 math 查看包中的内容:
# print(dir(math))
 
print('sqrt(9)=',math.sqrt(9))

print('abs(-10)',abs(-10))

print('PI',math.pi)

print('random=',random.random())

print("cos(PI)=",math.cos(math.pi))

print("currentTime=",time.time())

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) )

print('2016-01月份日期',calendar.month(2016, 1))