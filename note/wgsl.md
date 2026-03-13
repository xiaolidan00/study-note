# function

```c++
// Function with no arguments and no return value
fn do_nothing() {

}

// Function with a single 'i32' parameter, no return value
fn eat_an_i32(my_param : i32) {

}

// Function with no arguments, which returns a 'i32' value
fn give_me_a_number() -> i32 {
    return 42;
}

// Function with two parameters, which returns a 'f32' value
fn average(a : f32, b : f32) -> f32 {
    return (a + b) / 2;
}
```

不能递归嵌套，不能死循环互相调用，按照前后顺序，先声明后调用

```c++
@compute @workgroup_size(32)
fn my_awesome_compute_shader() {
}
//顶点着色器
@vertex
fn vertex_entry_point(@builtin(vertex_index) idx : u32) -> @builtin(position) vec4f {
    return vec4f(f32(idx%2-1), f32(idx/2-1), 1, 1);
}
//片元着色器
@fragment
fn fragment_main(@builtin(position) pos : vec4f) -> @location(0) vec4f {
    return vec4(0, 1, 0, 1);
}

@compute @workgroup_size(16)
fn another_compute_entry_point() {
}

```

## @must_use

返回值必须使用

```c++
@must_use
fn a() -> i32 {
  return 10;
}

fn b() -> i32 {
  return 10;
}

fn c() {
  let d = a();  // Ok, result is used
  b();          // Ok, not marked @must_use

  if a() < 5 {  // Ok, used to manage control flow.

  }

  // a();       // Error, result not used
}
```

# 变量

i32 - a signed, two’s complement, 32-bit integer.
u32 - an unsigned 32-bit integer.
f32 - an IEEE-754 binary32, floating point.
bool - a true or false value, with no specified storage representation.

```c++

```
