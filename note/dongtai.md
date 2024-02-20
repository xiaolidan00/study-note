# 动态规划

参考：https://leetcode.cn/circle/discuss/krb5lH/
https://xiaochen1024.com/courseware/60b4f11ab1aa91002eb53b18/61963bcdc1553b002e57bf13

## 动态规划特点

「分治」是算法中的一种基本思想，其通过将原问题分解为子问题，不断递归地将子问题分解为更小的子问题，并通过组合子问题的解来得到原问题的解。

类似于分治算法，「动态规划」也通过组合子问题的解得到原问题的解。不同的是，适合用动态规划解决的问题具有「重叠子问题」和「最优子结构」两大特性。

### 重叠子问题

动态规划的子问题是有重叠的，即各个子问题中包含重复的更小子问题。若使用暴力法穷举，求解这些相同子问题会产生大量的重复计算，效率低下。

动态规划在第一次求解某子问题时，会将子问题的解保存至矩阵中；后续遇到重叠子问题时，则直接通过查表获取解，保证每个独立子问题只被计算一次，从而降低算法的时间复杂度。

### 最优子结构

如果一个问题的最优解可以由其子问题的最优解组合构成，那么称此问题具有最优子结构。

动态规划从基础问题的解开始，不断迭代组合、选择子问题的最优解，最终得到原问题最优解。

### 动态规划和其他算法的区别

动态规划和分治的区别：动态规划和分治都有最优子结构 ，但是分治的子问题不重叠
动态规划和贪心的区别：动态规划中每一个状态一定是由上一个状态推导出来的，这一点就区分于贪心，贪心没有状态推导，而是从局部直接选最优解，所以它永远是局部最优，但是全局的解不一定是最优的。
动态规划和递归的区别：递归和回溯可能存在非常多的重复计算，动态规划可以用递归加记忆化的方式减少不必要的重复计算

### 解动态规划题目的步骤

1. 根据重叠子问题定义状态
2. 寻找最优子结构推导状态转移方程
3. 确定 dp 初始状态
4. 确定输出值

**动态规划解题框架**
若确定给定问题具有重叠子问题和最优子结构，那么就可以使用动态规划求解。总体上看，求解可分为四步：

1. 状态定义： 构建问题最优解模型，包括问题最优解的定义、有哪些计算解的自变量；
2. 初始状态： 确定基础子问题的解（即已知解），原问题和子问题的解都是以基础子问题的解为起始点，在迭代计算中得到的；
3. 转移方程： 确定原问题的解与子问题的解之间的关系是什么，以及使用何种选择规则从子问题最优解组合中选出原问题最优解；
4. 返回值： 确定应返回的问题的解是什么，即动态规划在何处停止迭代；

**动态规划的解题方法**

- 递归+记忆化(自顶向下)
- 动态规划（自底向上）

## 重叠子问题示例：斐波那契数列

https://leetcode.cn/problems/fibonacci-number/submissions/494780155/?envType=study-plan-v2&envId=dynamic-programming

f(n)=f(n-1)+f(n-2)
f(0)=0,f(1)=1
**暴力递归法**

```js
// 求第 n 个斐波那契数
function fibonacci(n) {
  if (n == 0) return 0; // 返回 f(0)
  if (n == 1) return 1; // 返回 f(1)
  return fibonacci(n - 1) + fibonacci(n - 2); // 分解为两个子问题求解
}
```

**记忆化递归**
重叠子问题产生了大量的递归树节点，其不应被重复计算.可以在递归中第一次求解子问题时，就将它们保存；后续递归中再次遇到相同子问题时，直接访问内存赋值即可

```js
function fibonacci(n, dp) {
  if (n == 0) return 0; // 返回 f(0)
  if (n == 1) return 1; // 返回 f(1)
  if (dp[n] != 0) return dp[n]; // 若 f(n) 以前已经计算过，则直接返回记录的解
  dp[n] = fibonacci(n - 1, dp) + fibonacci(n - 2, dp); // 将 f(n) 则记录至 dp
  return dp[n];
}

// 求第 n 个斐波那契数
function fibonacciMemorized(n) {
  var dp = []; // 用于保存 f(0) 至 f(n) 问题的解
  return fibonacci(n, dp);
}
```

**动态规划**

```js
// 求第 n 个斐波那契数
function fibonacci(n) {
  if (n == 0) return 0; // 若求 f(0) 则直接返回 0
  var dp = []; // 初始化 dp 列表
  dp[1] = 1; // 初始化 f(0), f(1)
  for (let i = 2; i <= n; i++) {
    // 状态转移求取 f(2), f(3), ..., f(n)
    dp[i] = dp[i - 1] + dp[i - 2];
  }
  return dp[n]; // 返回 f(n)
}

// 求第 n 个斐波那契数
function fibonacci(n) {
  if (n == 0) return 0; // 若求 f(0) 则直接返回 0
  let a = 0,
    b = 1; // 初始化 f(0), f(1)
  for (let i = 2; i <= n; i++) {
    // 状态转移求取 f(2), f(3), ..., f(n)
    let tmp = a;
    a = b;
    b = tmp + b;
  }
  return b; // 返回 f(n)
}

// 时间复杂度O(n)，空间复杂度O(1)
var fib = function (N) {
  if (N <= 1) {
    return N;
  }
  let prev2 = 0;
  let prev1 = 1;
  let result = 0;
  for (let i = 2; i <= N; i++) {
    result = prev1 + prev2;
    prev2 = prev1;
    prev1 = result;
  }
  return result;
};
```

## 最优子结构示例：蛋糕最高售价

f(0)=0,f(1)=p(1)
f(n)=max(f(i)+p(n-i))

**暴力递归**

```js
// 输入蛋糕价格列表 priceList ，求重量为 n 蛋糕的最高售价
function maxCakePrice(n, priceList) {
  if (n <= 1) return priceList[n]; // 蛋糕重量 <= 1 时直接返回
  var f_n = 0;
  for (
    let i = 0;
    i < n;
    i++ // 从 n 种组合种选择最高售价的组合作为 f(n)
  )
    f_n = Math.max(f_n, maxCakePrice(i, priceList) + priceList[n - i]);
  return f_n; // 返回 f(n)
}
```

**记忆递归**

```js
// 输入蛋糕价格列表 priceList ，求重量为 n 蛋糕的最高售价
function maxCakePrice(n, priceList, dp) {
  if (n <= 1) return priceList[n]; // 蛋糕重量 <= 1 时直接返回
  var f_n = 0;
  for (var i = 0; i < n; i++) {
    // 从 n 种组合种选择最高售价的组合作为 f(n)
    var f_i = dp[i] != 0 ? dp[i] : maxCakePrice(i, priceList, dp);
    f_n = Math.max(f_n, f_i + priceList[n - i]);
  }
  dp[n] = f_n; // 记录 f(n) 至 dp 数组
  return f_n; // 返回 f(n)
}

function maxCakePriceMemorized(n, priceList) {
  var dp = [];
  return maxCakePrice(n, priceList, dp);
}
```

**动态规划**

```js
// 输入蛋糕价格列表 priceList ，求重量为 n 蛋糕的最高售价
function maxCakePrice(n, priceList) {
  if (n <= 1) return priceList[n]; // 蛋糕重量 <= 1 时直接返回
  let dp = []; // 初始化 dp 列表
  for (let j = 1; j <= n; j++) {
    // 按顺序计算 f(1), f(2), ..., f(n)
    for (
      let i = 0;
      i < j;
      i++ // 从 j 种组合种选择最高售价的组合作为 f(j)
    )
      dp[j] = Math.max(dp[j], dp[i] + priceList[j - i]);
  }
  return dp[n];
}
```
