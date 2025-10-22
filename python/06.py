tup1 = ('physics', 'chemistry', 1997, 2000)
tup2 = (1, 2, 3, 4, 5 )
tup3 = "a", "b", "c", "d"


tup4 = tup1 + tup2
print('tup4',tup4)


tinydict = {'a': 1, 'b': 2, 'c': '3'}

a=tinydict['a']

print('keys=',tinydict.keys())
print('values=',tinydict.values())

for key,values in  tinydict.items():
    print(key,values)