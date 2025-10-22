
count = 0
while (count < 9):
   print("count=",count)
   count = count + 1



i = 1
while i < 10:   
    i += 1
    if i%2 > 0:     # 非双数时跳过输出
        continue
    print("i=",i)         # 输出双数2、4、6、8、10
 
i = 1
while 1:            # 循环条件为1必定成立
    print("i=",i)        # 输出1~10
    i += 1
    if i > 10:     # 当i大于10时跳出循环
        break


count = 0
while count < 5:
   print(count, " is  less than 5")
   count = count + 1
else:
   print(count, " is not less than 5")

for letter in 'Python':     # 第一个实例
   print("当前字母: %s" % letter)


fruits = ['banana', 'apple',  'mango']
for fruit in fruits:        # 第二个实例
   print ('当前水果: %s'% fruit)


fruits = ['banana', 'apple',  'mango']
for index in range(len(fruits)):
   print ('当前水果 : %s' % fruits[index])


for num in range(10,20):  # 迭代 10 到 20 (不包含) 之间的数字
   for i in range(2,num): # 根据因子迭代
      if num%i == 0:      # 确定第一个因子
         j=num/i          # 计算第二个因子
         print ('%d 等于 %d * %d' % (num,i,j))
         break            # 跳出当前循环
   else:                  # 循环的 else 部分
      print ('%d 是一个质数' % num)



i = 2
while(i < 100):
   j = 2
   while(j <= (i/j)):
      if not(i%j): break
      j = j + 1
   if (j > i/j) : print(i, " 是素数")
   i = i + 1


for letter in 'Python':     # 第一个实例
   if letter == 'h':
      continue
   print('当前字母 :', letter)


while var > 0:              
   print('当前变量值 :', var)
   var = var -1
   if var == 5:   # 当变量 var 等于 5 时退出循环
      break
   


for letter in 'Python':
   if letter == 'h':
      pass
      print('pass 不做任何事情，一般用做占位语句')
   print('当前字母 :', letter)