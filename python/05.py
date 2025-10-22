
str="ABCDEF GH"
print("str[0]=",str[0])

print("str[:6]=",str[:6])

print("str[1:5]=",str[1:5])

a='A'
if(a in str):
    print("a in str")

b='Z'
if(b not in str):
    print("b not in str")

list=[]

list.append("AAA")
print("list length",len(list))

print("list min",min([32,16]))

list.insert(0,'BBB')
list.insert(0,'BBB')
list.insert(0,'BBB')
print('list=',list)

print("list count",list.count('BBB'))

list.extend('CCC')

list.extend(['DDD'])
print('list=',list)

list.remove('C')
print('list=',list)