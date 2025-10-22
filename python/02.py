a = 10
b = 20 
if  a and b :
   print("AAA")
else:
   print("BBB")


if  a or b :
   print("AAA")
else:
   print("BBB")


if  not(a and b) :
   print("AAA")
else:
   print("BBB")


a = 5
b = 20
list = [1, 2, 3, 4, 5 ];

if ( a in list ):
   print("IN LIST")
else:
   print("NOT IN LIST")

if ( b not in list ):
   print("NOT IN LIST")
else:
   print("IN LIST")


a = [1, 2, 3]
b = a

if ( a is b ):
   print("a is b")
else:
   print("a is not b")


b=a[1] 

if ( a is not b ):
   print("a is not b")
else:
   print("a is b")


if(a>0):
   print("a>0")
elif (a==0):
   print("a==0")
else :
   print("a<0")

