# x = "awesome"

# def myfunc():
#   x = "fantastic"
#   print("Python is " + x)

# myfunc()

# print("Python is " + x)



# def myfunc1():
#   global x
#   x = "fantastic"

# myfunc1()

# print("Python is " + x)

x = "awesome"

def myfunc():
  global x
  x = "fantastic"

myfunc()

print("Python is " + x)