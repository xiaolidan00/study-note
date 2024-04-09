## 1.求用十进制、二进制、八进制表示都是回文数的所有数字中，大于十进制数 10 的最小值。

示例：9（十进制数）＝ 1001（二进制数）=11（八进制数）

【思路】因为是二进制的回文数，所以如果最低位是 0，那么相应地最高位
也是 0。但是，以 0 开头肯定是不恰当的，由此可知最低位为 1。
如果用二进制表示时最低位为 1，那这个数一定是奇数，因此只考
虑奇数的情况就可以。接下来可以简单地编写程序，从 10 的下一个数
字 11 开始，按顺序搜索。

```js
/* 为字符串类型添加返回逆序字符串的方法 */
String.prototype.reverse = function () {
  return this.split('').reverse().join('');
};

/* 从11开始检索 */
var num = 11;
while (true) {
  if (
    num.toString() == num.toString().reverse() &&
    num.toString(8) == num.toString(8).reverse() &&
    num.toString(2) == num.toString(2).reverse()
  ) {
    console.log(num);
    break;
  }
  /* 只检索奇数，每次加2 */
  num += 2;
}
```

【答案】585=1001001001（二进制）=1111（八进制）

## 62. 不同路径

[62. 不同路径](https://leetcode.cn/problems/unique-paths/?envType=study-plan-v2&envId=leetcode-75)

![image](https://pic.leetcode.cn/1697422740-adxmsI-image.png)

```

一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish” ）。

问总共有多少条不同的路径？

示例 1：
输入：m = 3, n = 7
输出：28


示例 2：

输入：m = 3, n = 2
输出：3
解释：
从左上角开始，总共有 3 条路径可以到达右下角。
1. 向右 -> 向下 -> 向下
2. 向下 -> 向下 -> 向右
3. 向下 -> 向右 -> 向下

示例 3：

输入：m = 7, n = 3
输出：28
示例 4：

输入：m = 3, n = 3
输出：6

提示：

1 <= m, n <= 100
题目数据保证答案小于等于 2 * 109
```

思路:由于在每个位置只能向下或者向右， 所以每个坐标的路径和等于上一行相同位置和上一列相同位置不同路径的总和，状态转移方程：`f[i][j] = f[i - 1][j] + f[i][j - 1]`;

复杂度:时间复杂度 O(mn)。空间复杂度 O(mn)，优化后 O(n)

```js
//状态压缩
var uniquePaths = function (m, n) {
  let cur = new Array(n).fill(1);
  for (let i = 1; i < m; i++) {
    for (let j = 1; j < n; j++) {
      cur[j] += cur[j - 1];
    }
  }
  return cur[n - 1];
};
```

# 动态规划

## 斐波那函数

```js
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

## 1137. 第 N 个泰波那契数

[1137. 第 N 个泰波那契数](https://leetcode.cn/problems/n-th-tribonacci-number/?envType=study-plan-v2&envId=leetcode-75)

```
泰波那契序列 Tn 定义如下：

T0 = 0, T1 = 1, T2 = 1, 且在 n >= 0 的条件下 Tn+3 = Tn + Tn+1 + Tn+2

给你整数 n，请返回第 n 个泰波那契数 Tn 的值。



示例 1：

输入：n = 4
输出：4
解释：
T_3 = 0 + 1 + 1 = 2
T_4 = 1 + 1 + 2 = 4
示例 2：

输入：n = 25
输出：1389537


提示：

0 <= n <= 37
答案保证是一个 32 位整数，即 answer <= 2^31 - 1。
```

```js
var tribonacci = function (N) {
  if (N == 0) {
    return 0;
  }
  if (N <= 2) {
    return 1;
  }
  let prev2 = 1;
  let prev1 = 1;
  let prev0 = 0;
  let result = 0;
  for (let i = 3; i <= N; i++) {
    result = prev1 + prev2 + prev0;
    prev0 = prev1;
    prev1 = prev2;
    prev2 = result;
  }
  return result;
};
```

## 70. 爬楼梯

https://leetcode.cn/problems/climbing-stairs/description/?envType=study-plan-v2&envId=top-interview-150

```
假设你正在爬楼梯。需要 n 阶你才能到达楼顶。

每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？



示例 1：

输入：n = 2
输出：2
解释：有两种方法可以爬到楼顶。
1. 1 阶 + 1 阶
2. 2 阶
示例 2：

输入：n = 3
输出：3
解释：有三种方法可以爬到楼顶。
1. 1 阶 + 1 阶 + 1 阶
2. 1 阶 + 2 阶
3. 2 阶 + 1 阶


提示：

1 <= n <= 45
```

斐波那函数的变换

```js
var climbStairs = function (N) {
  if (N <= 2) {
    return N;
  }
  let prev2 = 1;
  let prev1 = 2;
  let result = 0;
  for (let i = 3; i <= N; i++) {
    result = prev1 + prev2;
    prev2 = prev1;
    prev1 = result;
  }
  return result;
};
```

## 198. 打家劫舍

```
你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。

给定一个代表每个房屋存放金额的非负整数数组，计算你 不触动警报装置的情况下 ，一夜之内能够偷窃到的最高金额。



示例 1：

输入：[1,2,3,1]
输出：4
解释：偷窃 1 号房屋 (金额 = 1) ，然后偷窃 3 号房屋 (金额 = 3)。
     偷窃到的最高金额 = 1 + 3 = 4 。
示例 2：

输入：[2,7,9,3,1]
输出：12
解释：偷窃 1 号房屋 (金额 = 2), 偷窃 3 号房屋 (金额 = 9)，接着偷窃 5 号房屋 (金额 = 1)。
     偷窃到的最高金额 = 2 + 9 + 1 = 12 。


提示：

1 <= nums.length <= 100
0 <= nums[i] <= 400
```

```js
/**
 * @param {number[]} nums
 * @return {number}
 */
var rob = function (nums) {
  let n = nums.length;
  if (n == 1) return nums[0];
  if (n == 2) return Math.max(nums[0], nums[1]);

  let dp = []; // 初始化 dp 列表
  dp[0] = nums[0];
  dp[1] = Math.max(nums[0], nums[1]);
  for (let i = 2; i < n; i++) {
    // 按顺序计算 f(1), f(2), ..., f(n)
    dp[i] = Math.max(dp[i - 2] + nums[i], dp[i - 1]);
  }
  return dp[n - 1];
};
```

## 746. 使用最小花费爬楼梯

[746. 使用最小花费爬楼梯](https://leetcode.cn/problems/min-cost-climbing-stairs/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个整数数组 cost ，其中 cost[i] 是从楼梯第 i 个台阶向上爬需要支付的费用。一旦你支付此费用，即可选择向上爬一个或者两个台阶。

你可以选择从下标为 0 或下标为 1 的台阶开始爬楼梯。

请你计算并返回达到楼梯顶部的最低花费。



示例 1：

输入：cost = [10,15,20]
输出：15
解释：你将从下标为 1 的台阶开始。
- 支付 15 ，向上爬两个台阶，到达楼梯顶部。
总花费为 15 。
示例 2：

输入：cost = [1,100,1,1,1,100,1,1,100,1]
输出：6
解释：你将从下标为 0 的台阶开始。
- 支付 1 ，向上爬两个台阶，到达下标为 2 的台阶。
- 支付 1 ，向上爬两个台阶，到达下标为 4 的台阶。
- 支付 1 ，向上爬两个台阶，到达下标为 6 的台阶。
- 支付 1 ，向上爬一个台阶，到达下标为 7 的台阶。
- 支付 1 ，向上爬两个台阶，到达下标为 9 的台阶。
- 支付 1 ，向上爬一个台阶，到达楼梯顶部。
总花费为 6 。


提示：

2 <= cost.length <= 1000
0 <= cost[i] <= 999
```

```js
var minCostClimbingStairs = function (nums) {
  let n = nums.length;
  if (n == 1) return nums[0];
  if (n == 2) return Math.min(nums[0], nums[1]);

  let dp = []; // 初始化 dp 列表
  dp[0] = nums[0];
  dp[1] = nums[1];
  for (let i = 2; i < n; i++) {
    // 按顺序计算 f(1), f(2), ..., f(n)

    dp[i] = Math.min(dp[i - 2] + nums[i], dp[i - 1] + nums[i]);
  }
  return Math.min(dp[n - 1], dp[n - 2]);
};
```

## 790. 多米诺和托米诺平铺

https://leetcode.cn/problems/domino-and-tromino-tiling/description/?envType=study-plan-v2&envId=leetcode-75

```
有两种形状的瓷砖：一种是 2 x 1 的多米诺形，另一种是形如 "L" 的托米诺形。两种形状都可以旋转。



给定整数 n ，返回可以平铺 2 x n 的面板的方法的数量。返回对 109 + 7 取模 的值。

平铺指的是每个正方形都必须有瓷砖覆盖。两个平铺不同，当且仅当面板上有四个方向上的相邻单元中的两个，使得恰好有一个平铺有一个瓷砖占据两个正方形。



示例 1:



输入: n = 3
输出: 5
解释: 五种不同的方法如上所示。
示例 2:

输入: n = 1
输出: 1


提示：

1 <= n <= 1000
```

```js
var numTilings = function (n) {
  if (n <= 2) return n;
  let n1 = 2;
  let n2 = 1;
  let n3 = 1;
  let result = 0;
  const m = Math.pow(10, 9) + 7;

  for (let i = 3; i <= n; i++) {
    result = (n1 * 2 + n3) % m;
    n3 = n2;
    n2 = n1;
    n1 = result;
  }
  return result;
};
```

# 数组字符串

## 1143. 最长公共子序列

[1143. 最长公共子序列](https://leetcode.cn/problems/longest-common-subsequence/description/?envType=study-plan-v2&envId=leetcode-75)

```
给定两个字符串 text1 和 text2，返回这两个字符串的最长 公共子序列 的长度。如果不存在 公共子序列 ，返回 0 。

一个字符串的 子序列 是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。

例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。
两个字符串的 公共子序列 是这两个字符串所共同拥有的子序列。



示例 1：

输入：text1 = "abcde", text2 = "ace"
输出：3
解释：最长公共子序列是 "ace" ，它的长度为 3 。
示例 2：

输入：text1 = "abc", text2 = "abc"
输出：3
解释：最长公共子序列是 "abc" ，它的长度为 3 。
示例 3：

输入：text1 = "abc", text2 = "def"
输出：0
解释：两个字符串没有公共子序列，返回 0 。


提示：

1 <= text1.length, text2.length <= 1000
text1 和 text2 仅由小写英文字符组成。

```

```js
var longestCommonSubsequence = function (text1, text2) {
  const m = text1.length,
    n = text2.length;
  const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      if (text1[i - 1] === text2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
      }
    }
  }
  return dp[m][n];
};
```

## 交替合并字符串(简单)

[1768. 交替合并字符串](https://leetcode.cn/problems/merge-strings-alternately/?envType=study-plan-v2&envId=leetcode-75)

给你两个字符串 word1 和 word2 。请你从 word1 开始，通过交替添加字母来合并字符串。如果一个字符串比另一个字符串长，就将多出来的字母追加到合并后字符串的末尾。

返回 合并后的字符串 。

**示例 1：**

```
输入：word1 = "abc", word2 = "pqr"
输出："apbqcr"
解释：字符串合并情况如下所示：
word1：  a   b   c
word2：    p   q   r
合并后：  a p b q c r
```

**示例 2：**

```
输入：word1 = "ab", word2 = "pqrs"
输出："apbqrs"
解释：注意，word2 比 word1 长，"rs" 需要追加到合并后字符串的末尾。
word1：  a   b
word2：    p   q   r   s
合并后：  a p b q   r   s
```

**示例 3：**

```
输入：word1 = "abcd", word2 = "pq"
输出："apbqcd"
解释：注意，word1 比 word2 长，"cd" 需要追加到合并后字符串的末尾。
word1：  a   b   c   d
word2：    p   q
合并后：  a p b q c   d
```

**提示：**

```
1 <= word1.length, word2.length <= 100
word1 和 word2 由小写英文字母组成
```

**答案**

```js
/**
 * @param {string} word1
 * @param {string} word2
 * @return {string}
 */
var mergeAlternately = function (word1, word2) {
  let len = Math.min(word1.length, word2.length);
  let preStr = [];
  for (let i = 0; i < len; i++) {
    preStr.push(word1[i], word2[i]); //前面融合
  }
  let suffixStr = ''; //后面截取
  if (word1.length > word2.length) {
    suffixStr = word1.substring(len);
  } else {
    suffixStr = word2.substring(len);
  }
  return preStr.join('') + suffixStr;
};
```

## 字符串的最大公因子(简单)

[1071. 字符串的最大公因子](https://leetcode.cn/problems/greatest-common-divisor-of-strings/?envType=study-plan-v2&envId=leetcode-75)

对于字符串 s 和 t，只有在 s = t + ... + t（t 自身连接 1 次或多次）时，我们才认定 “t 能除尽 s”。

给定两个字符串 str1 和 str2 。返回 最长字符串 x，要求满足 x 能除尽 str1 且 x 能除尽 str2 。

**示例 1：**

```
输入：str1 = "ABCABC", str2 = "ABC"
输出："ABC"
```

**示例 2：**

```
输入：str1 = "ABABAB", str2 = "ABAB"
输出："AB"
```

**示例 3：**

```
输入：str1 = "LEET", str2 = "CODE"
输出：""
```

**提示：**

```
1 <= str1.length, str2.length <= 1000
str1 和 str2 由大写英文字母组成
```

**答案**

```js
/**
 * @param {string} str1
 * @param {string} str2
 * @return {string}
 */
var gcdOfStrings = function (str1, str2) {
  if (str1.length == str2.length) {
    return str1 == str2 ? str1 : '';
  } else {
    let maxStr, minStr;
    if (str1.length < str2.length) {
      minStr = str1;
      maxStr = str2;
    } else {
      minStr = str2;
      maxStr = str1;
    }

    for (let i = minStr.length; i >= 1; i--) {
      let str = minStr.substring(0, i); //截取短字符串部分

      let tag1 = maxStr.replace(new RegExp(str, 'g'), '');
      let tag2 = minStr.replace(new RegExp(str, 'g'), '');

      if (!tag1 && !tag2) {
        //两个字符串都能整除
        return str;
      }
    }
  }
  return '';
};
```

**精选答案**

```js
var gcdOfStrings = function (str1, str2) {
  if (str1 + str2 !== str2 + str1) return '';
  //最大公因子=>gcd算法
  const gcd = (a, b) => (0 === b ? a : gcd(b, a % b));
  //当确定有解的情况下，最优解是长度为 gcd(str1.length, str2.length) 的字符串。
  return str1.substring(0, gcd(str1.length, str2.length));
};
```

## 拥有最多糖果的孩子(简单)

[1431. 拥有最多糖果的孩子](https://leetcode.cn/problems/kids-with-the-greatest-number-of-candies/?envType=study-plan-v2&envId=leetcode-75)

给你一个数组 candies 和一个整数 extraCandies ，其中 candies[i] 代表第 i 个孩子拥有的糖果数目。

对每一个孩子，检查是否存在一种方案，将额外的 extraCandies 个糖果分配给孩子们之后，此孩子有 最多 的糖果。注意，允许有多个孩子同时拥有 最多 的糖果数目。

```
示例 1：

输入：candies = [2,3,5,1,3], extraCandies = 3
输出：[true,true,true,false,true]
解释：
孩子 1 有 2 个糖果，如果他得到所有额外的糖果（3个），那么他总共有 5 个糖果，他将成为拥有最多糖果的孩子。
孩子 2 有 3 个糖果，如果他得到至少 2 个额外糖果，那么他将成为拥有最多糖果的孩子。
孩子 3 有 5 个糖果，他已经是拥有最多糖果的孩子。
孩子 4 有 1 个糖果，即使他得到所有额外的糖果，他也只有 4 个糖果，无法成为拥有糖果最多的孩子。
孩子 5 有 3 个糖果，如果他得到至少 2 个额外糖果，那么他将成为拥有最多糖果的孩子。

示例 2：

输入：candies = [4,2,1,1,2], extraCandies = 1
输出：[true,false,false,false,false]
解释：只有 1 个额外糖果，所以不管额外糖果给谁，只有孩子 1 可以成为拥有糖果最多的孩子。

示例 3：

输入：candies = [12,1,12], extraCandies = 10
输出：[true,false,true]


提示：

2 <= candies.length <= 100
1 <= candies[i] <= 100
1 <= extraCandies <= 50
```

**答案**

```js
/**
 * @param {number[]} candies
 * @param {number} extraCandies
 * @return {boolean[]}
 */
var kidsWithCandies = function (candies, extraCandies) {
  let max = Math.max(...candies);
  return candies.map((item) => item + extraCandies >= max);
};
```

## 种花问题(简单)

[605. 种花问题](https://leetcode.cn/problems/can-place-flowers/?envType=study-plan-v2&envId=leetcode-75)

假设有一个很长的花坛，一部分地块种植了花，另一部分却没有。可是，花不能种植在相邻的地块上，它们会争夺水源，两者都会死去。

给你一个整数数组 flowerbed 表示花坛，由若干 0 和 1 组成，其中 0 表示没种植花，1 表示种植了花。另有一个数 n ，能否在不打破种植规则的情况下种入 n 朵花？能则返回 true ，不能则返回 false 。

```
示例 1：

输入：flowerbed = [1,0,0,0,1], n = 1
输出：true

示例 2：

输入：flowerbed = [1,0,0,0,1], n = 2
输出：false


提示：

1 <= flowerbed.length <= 2 * 104
flowerbed[i] 为 0 或 1
flowerbed 中不存在相邻的两朵花
0 <= n <= flowerbed.length
```

**答案**

```js
/**
 * @param {number[]} flowerbed
 * @param {number} n
 * @return {boolean}
 */
var canPlaceFlowers = function (flowerbed, n) {
  //扩展边界
  flowerbed.unshift(0);
  flowerbed.push(0);
  let count = 0;
  for (let i = 1; i < flowerbed.length - 1; i++) {
    if (flowerbed[i - 1] === 0 && flowerbed[i] === 0 && flowerbed[i + 1] === 0) {
      count++;
      flowerbed[i] = 1;
    }
  }
  return n <= count;
};

var canPlaceFlowers = function (flowerbed, n) {
  const m = flowerbed.length;
  for (let i = 0; i < m; i++) {
    if (
      (i === 0 || flowerbed[i - 1] === 0) &&
      flowerbed[i] === 0 &&
      (i === m - 1 || flowerbed[i + 1] === 0)
    ) {
      n--;
      i++; // 下一个位置肯定不能种花，直接跳过
    }
  }
  return n <= 0;
};
```

## 345. 反转字符串中的元音字母

[345. 反转字符串中的元音字母](https://leetcode.cn/problems/reverse-vowels-of-a-string/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个字符串 s ，仅反转字符串中的所有元音字母，并返回结果字符串。

元音字母包括 'a'、'e'、'i'、'o'、'u'，且可能以大小写两种形式出现不止一次。



示例 1：

输入：s = "hello"
输出："holle"
示例 2：

输入：s = "leetcode"
输出："leotcede"


提示：

1 <= s.length <= 3 * 105
s 由 可打印的 ASCII 字符组成
```

```js
var reverseVowels = function (s) {
  let strArr = s.split('');
  let yuan = ['a', 'e', 'i', 'o', 'u'];
  let yuanMap = {};
  for (let i = 0; i < strArr.length; i++) {
    if (yuan.includes(strArr[i].toLowerCase())) {
      yuanMap[i] = strArr[i];
    }
  }

  let sortKeys = Object.keys(yuanMap).sort((a, b) => b - a);
  let count = 0;
  for (let k in yuanMap) {
    strArr[k] = yuanMap[sortKeys[count]];
    count++;
  }
  return strArr.join('');
};
```

双指针

```js
var reverseVowels = function (s) {
  let strArr = s.split('');
  let start = 0,
    end = strArr.length - 1;
  let yuan = 'aeiouAEIOU';
  while (start < end) {
    console.log(start, end);
    while (yuan.indexOf(strArr[start]) == -1 && start < strArr.length - 1) {
      start++;
    }
    while (yuan.indexOf(strArr[end]) == -1 && end > 0) {
      end--;
    }
    if (start < end) {
      let temp = strArr[start];
      strArr[start] = strArr[end];
      strArr[end] = temp;
      start++;
      end--;
    }
  }
  return strArr.join('');
};
```

## 151. 反转字符串中的单词

[151. 反转字符串中的单词](https://leetcode.cn/problems/reverse-words-in-a-string/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个字符串 s ，请你反转字符串中 单词 的顺序。

单词 是由非空格字符组成的字符串。s 中使用至少一个空格将字符串中的 单词 分隔开。

返回 单词 顺序颠倒且 单词 之间用单个空格连接的结果字符串。

注意：输入字符串 s中可能会存在前导空格、尾随空格或者单词间的多个空格。返回的结果字符串中，单词间应当仅用单个空格分隔，且不包含任何额外的空格。



示例 1：

输入：s = "the sky is blue"
输出："blue is sky the"
示例 2：

输入：s = "  hello world  "
输出："world hello"
解释：反转后的字符串中不能存在前导空格和尾随空格。
示例 3：

输入：s = "a good   example"
输出："example good a"
解释：如果两个单词间有多余的空格，反转后的字符串需要将单词间的空格减少到仅有一个。


提示：

1 <= s.length <= 104
s 包含英文大小写字母、数字和空格 ' '
s 中 至少存在一个 单词


进阶：如果字符串在你使用的编程语言中是一种可变数据类型，请尝试使用 O(1) 额外空间复杂度的 原地 解法。
```

```js
/**
 * @param {string} s
 * @return {string}
 */
var reverseWords = function (s) {
  let strArr = s.split(' ').filter((a) => a);
  return strArr.reverse().join(' ');
};
```

## 238. 除自身以外数组的乘积

[238. 除自身以外数组的乘积](https://leetcode.cn/problems/product-of-array-except-self/?envType=study-plan-v2&envId=leetcode-75)

```js
给你一个整数数组 nums，返回 数组 answer ，其中 answer[i] 等于 nums 中除 nums[i] 之外其余各元素的乘积 。

题目数据 保证 数组 nums之中任意元素的全部前缀元素和后缀的乘积都在  32 位 整数范围内。

请 不要使用除法，且在 O(n) 时间复杂度内完成此题。



示例 1:

输入: nums = [1,2,3,4]
输出: [24,12,8,6]
示例 2:

输入: nums = [-1,1,0,-3,3]
输出: [0,0,9,0,0]


提示：

2 <= nums.length <= 105
-30 <= nums[i] <= 30
保证 数组 nums之中任意元素的全部前缀元素和后缀的乘积都在  32 位 整数范围内


进阶：你可以在 O(1) 的额外空间复杂度内完成这个题目吗？（ 出于对空间复杂度分析的目的，输出数组 不被视为 额外空间。）
```

```js
/**
 * @param {number[]} nums
 * @return {number[]}
 */
var productExceptSelf = function (nums) {
  let result = [];

  for (let i = 0; i < nums.length; i++) {
    let a = nums.reduce((accumulator, val, idx) => {
      if (i != idx) {
        return accumulator * val;
      }
      return accumulator * 1;
    }, 1);
    result.push(a);
  }

  return result;
};
```

```js
/**
 * @param {number[]} nums
 * @return {number[]}
 */
var productExceptSelf = function (nums) {
  let zeros = [];
  let l = nums.reduce((l, i, idx) => {
    if (i === 0) zeros.push(idx);
    l.push((nums[idx - 1] ?? 1) * (l[idx - 1] ?? 1));
    return l;
  }, []);
  let r = nums.reduceRight((l, i, idx) => {
    l[idx] = (nums[idx + 1] ?? 1) * (l[idx + 1] ?? 1);
    return l;
  }, new Array(nums.length));
  return l.map((item, idx) => item * r[idx]);
};
```

```js
/**
 * @param {number[]} nums
 * @return {number[]}
 */
var productExceptSelf = function (nums) {
  let zeros = [];
  let l = nums.reduce((l, i, idx) => {
    if (i === 0) zeros.push(idx);
    l.push((nums[idx - 1] ?? 1) * (l[idx - 1] ?? 1));
    return l;
  }, []);
  let r = nums.reduceRight((l, i, idx) => {
    l[idx] = (nums[idx + 1] ?? 1) * (l[idx + 1] ?? 1);
    return l;
  }, new Array(nums.length));
  return l.map((item, idx) => item * r[idx]);
};

var productExceptSelf = function (nums) {
  let len = nums.length;
  let ans = Array.from({ length: len });
  let R = 1;
  ans[0] = 1;
  // ans[i]等于数组i左侧所有数字的乘积
  for (let i = 1; i < len; i++) {
    ans[i] = ans[i - 1] * nums[i - 1];
  }
  // 乘上R即所有右侧元素的乘积
  for (let i = len - 1; i >= 0; i--) {
    ans[i] = ans[i] * R;
    R *= nums[i];
  }
  return ans;
};
```

## 334. 递增的三元子序列

[334. 递增的三元子序列](https://leetcode.cn/problems/increasing-triplet-subsequence/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个整数数组 nums ，判断这个数组中是否存在长度为 3 的递增子序列。

如果存在这样的三元组下标 (i, j, k) 且满足 i < j < k ，使得 nums[i] < nums[j] < nums[k] ，返回 true ；否则，返回 false 。



示例 1：

输入：nums = [1,2,3,4,5]
输出：true
解释：任何 i < j < k 的三元组都满足题意
示例 2：

输入：nums = [5,4,3,2,1]
输出：false
解释：不存在满足题意的三元组
示例 3：

输入：nums = [2,1,5,0,4,6]
输出：true
解释：三元组 (3, 4, 5) 满足题意，因为 nums[3] == 0 < nums[4] == 4 < nums[5] == 6


提示：

1 <= nums.length <= 5 * 105
-231 <= nums[i] <= 231 - 1


进阶：你能实现时间复杂度为 O(n) ，空间复杂度为 O(1) 的解决方案吗？
```

```js
/**
 * @param {number[]} nums
 * @return {boolean}
 */
var increasingTriplet = function (nums) {
  let small = Number.MAX_VALUE,
    middle = Number.MAX_VALUE;
  for (let i = 0; i < nums.length; i++) {
    if (nums[i] <= small) {
      small = nums[i];
    } else if (nums[i] <= middle) {
      middle = nums[i];
    } else {
      return true;
    }
  }
  return false;
};
```

## 443. 压缩字符串

[443. 压缩字符串](https://leetcode.cn/problems/string-compression/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个字符数组 chars ，请使用下述算法压缩：

从一个空字符串 s 开始。对于 chars 中的每组 连续重复字符 ：

如果这一组长度为 1 ，则将字符追加到 s 中。
否则，需要向 s 追加字符，后跟这一组的长度。
压缩后得到的字符串 s 不应该直接返回 ，需要转储到字符数组 chars 中。需要注意的是，如果组长度为 10 或 10 以上，则在 chars 数组中会被拆分为多个字符。

请在 修改完输入数组后 ，返回该数组的新长度。

你必须设计并实现一个只使用常量额外空间的算法来解决此问题。



示例 1：

输入：chars = ["a","a","b","b","c","c","c"]
输出：返回 6 ，输入数组的前 6 个字符应该是：["a","2","b","2","c","3"]
解释："aa" 被 "a2" 替代。"bb" 被 "b2" 替代。"ccc" 被 "c3" 替代。
示例 2：

输入：chars = ["a"]
输出：返回 1 ，输入数组的前 1 个字符应该是：["a"]
解释：唯一的组是“a”，它保持未压缩，因为它是一个字符。
示例 3：

输入：chars = ["a","b","b","b","b","b","b","b","b","b","b","b","b"]
输出：返回 4 ，输入数组的前 4 个字符应该是：["a","b","1","2"]。
解释：由于字符 "a" 不重复，所以不会被压缩。"bbbbbbbbbbbb" 被 “b12” 替代。


提示：

1 <= chars.length <= 2000
chars[i] 可以是小写英文字母、大写英文字母、数字或符号
```

```js
/**
 * @param {character[]} chars
 * @return {number}
 */
var compress = function (chars) {
  let count = 1;
  let i = 0;
  while (i < chars.length) {
    if (chars[i] === chars[i + 1]) {
      count++;
      chars.splice(i, 1);
    } else {
      if (count > 1) {
        i++;
        let str = count + '';
        let len = str.length;
        for (let k = 0; k < len; k++) {
          chars.splice(i, 0, str.charAt(k));
          i++;
        }
        count = 1; // 重新开始计数
      } else {
        i++; // 只有一个独特的字符，不重复，指针后移
      }
    }
  }
  return chars.length;
};
```

# 双指针

## 283. 移动零

[283. 移动零](https://leetcode.cn/problems/move-zeroes/?envType=study-plan-v2&envId=leetcode-75)

```
给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。

请注意 ，必须在不复制数组的情况下原地对数组进行操作。



示例 1:

输入: nums = [0,1,0,3,12]
输出: [1,3,12,0,0]
示例 2:

输入: nums = [0]
输出: [0]


提示:

1 <= nums.length <= 104
-231 <= nums[i] <= 231 - 1


进阶：你能尽量减少完成的操作次数吗？
```

```js
/**
 * @param {number[]} nums
 * @return {void} Do not return anything, modify nums in-place instead.
 */
var moveZeroes = function (nums) {
  let i = 0;
  let count = 0;
  while (i < nums.length) {
    if (nums[i] == 0) {
      nums.splice(i, 1);
      count++;
    } else {
      i++;
    }
  }
  for (i = 0; i < count; i++) {
    nums.push(0);
  }
  console.log(nums);
};

var moveZeroes = function (nums) {
  let j = 0;
  for (let i = 0; i < nums.length; i++) {
    if (nums[i] != 0) {
      let temp = nums[i];
      nums[i] = nums[j];
      nums[j++] = temp;
    }
  }
};
```

## 392. 判断子序列

[392. 判断子序列](https://leetcode.cn/problems/is-subsequence/?envType=study-plan-v2&envId=leetcode-75)

```
给定字符串 s 和 t ，判断 s 是否为 t 的子序列。

字符串的一个子序列是原始字符串删除一些（也可以不删除）字符而不改变剩余字符相对位置形成的新字符串。（例如，"ace"是"abcde"的一个子序列，而"aec"不是）。

进阶：

如果有大量输入的 S，称作 S1, S2, ... , Sk 其中 k >= 10亿，你需要依次检查它们是否为 T 的子序列。在这种情况下，你会怎样改变代码？

致谢：

特别感谢 @pbrother 添加此问题并且创建所有测试用例。



示例 1：

输入：s = "abc", t = "ahbgdc"
输出：true
示例 2：

输入：s = "axc", t = "ahbgdc"
输出：false


提示：

0 <= s.length <= 100
0 <= t.length <= 10^4
两个字符串都只由小写字符组成。
```

```js
/**
 * @param {string} s
 * @param {string} t
 * @return {boolean}
 */
var isSubsequence = function (s, t) {
  let i = 0;
  let j = 0;

  let count = 0;
  while (i < s.length) {
    while (j < t.length) {
      if (t[j] == s[i]) {
        console.log(i, j, count);
        count++;
        j++;
        break;
      }
      j++;
    }

    i++;
  }
  return count == s.length;
};

var isSubsequence = function (s, t) {
  let i = 0,
    j = 0;
  while (i < s.length && j < t.length) {
    if (s[i] == t[j]) i++;
    j++;
  }
  return i == s.length;
};
```

## 11. 盛最多水的容器

[11. 盛最多水的容器](https://leetcode.cn/problems/container-with-most-water/description/?envType=study-plan-v2&envId=leetcode-75)
![image](https://aliyun-lc-upload.oss-cn-hangzhou.aliyuncs.com/aliyun-lc-upload/uploads/2018/07/25/question_11.jpg)

```
给定一个长度为 n 的整数数组 height 。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) 。

找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

返回容器可以储存的最大水量。

说明：你不能倾斜容器。

输入：[1,8,6,2,5,4,8,3,7]
输出：49
解释：图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。
示例 2：

输入：height = [1,1]
输出：1


提示：

n == height.length
2 <= n <= 105
0 <= height[i] <= 104
```

```js
/**
 * @param {number[]} height
 * @return {number}
 */
var maxArea = function (height) {
  let left = 0,
    right = height.length - 1;
  let max = 0;
  while (left < right) {
    let m = Math.min(height[left], height[right]);
    let r = m * (right - left);
    if (max < r) {
      max = r;
    }
    if (height[left] < height[right]) {
      left++;
    } else {
      right--;
    }
  }
  return max;
};

var maxArea = function (height) {
  let res = 0;
  for (let i = 0, j = height.length - 1; i < j; ) {
    res = Math.max(res, Math.min(height[i], height[j]) * (j - i));
    height[i] < height[j] ? i++ : j--;
  }
  return res;
};
```

## 1679. K 和数对的最大数目

[1679. K 和数对的最大数目](https://leetcode.cn/problems/max-number-of-k-sum-pairs/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个整数数组 nums 和一个整数 k 。

每一步操作中，你需要从数组中选出和为 k 的两个整数，并将它们移出数组。

返回你可以对数组执行的最大操作数。



示例 1：

输入：nums = [1,2,3,4], k = 5
输出：2
解释：开始时 nums = [1,2,3,4]：
- 移出 1 和 4 ，之后 nums = [2,3]
- 移出 2 和 3 ，之后 nums = []
不再有和为 5 的数对，因此最多执行 2 次操作。
示例 2：

输入：nums = [3,1,3,4,3], k = 6
输出：1
解释：开始时 nums = [3,1,3,4,3]：
- 移出前两个 3 ，之后nums = [1,4,3]
不再有和为 6 的数对，因此最多执行 1 次操作。


提示：

1 <= nums.length <= 10^5
1 <= nums[i] <= 10^9
1 <= k <= 10^9
```

```js
/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number}
 */
var maxOperations = function (nums, k) {
  let count = 0;
  const numCounts = new Map();

  for (const num of nums) {
    const a = k - num;
    if (numCounts.has(a) && numCounts.get(a) > 0) {
      count++;
      numCounts.set(a, numCounts.get(a) - 1);
    } else {
      numCounts.set(num, (numCounts.get(num) || 0) + 1);
    }
  }

  return count;
};
```

# 滑动窗口

## 1456. 定长子串中元音的最大数目

[1456. 定长子串中元音的最大数目](https://leetcode.cn/problems/maximum-number-of-vowels-in-a-substring-of-given-length/?envType=study-plan-v2&envId=leetcode-75)

```
给你字符串 s 和整数 k 。

请返回字符串 s 中长度为 k 的单个子字符串中可能包含的最大元音字母数。

英文中的 元音字母 为（a, e, i, o, u）。



示例 1：

输入：s = "abciiidef", k = 3
输出：3
解释：子字符串 "iii" 包含 3 个元音字母。
示例 2：

输入：s = "aeiou", k = 2
输出：2
解释：任意长度为 2 的子字符串都包含 2 个元音字母。
示例 3：

输入：s = "leetcode", k = 3
输出：2
解释："lee"、"eet" 和 "ode" 都包含 2 个元音字母。
示例 4：

输入：s = "rhythms", k = 4
输出：0
解释：字符串 s 中不含任何元音字母。
示例 5：

输入：s = "tryhard", k = 4
输出：1


提示：

1 <= s.length <= 10^5
s 由小写英文字母组成
1 <= k <= s.length
```

```js
const yuan = 'aeiou';
function getYuan(s) {
  if (yuan.indexOf(s) >= 0) {
    return 1;
  } else {
    return 0;
  }
}
var maxVowels = function (s, k) {
  let max = 0,
    sum = 0;

  for (let i = 0; i < k; i++) {
    if (yuan.indexOf(s[i]) >= 0) {
      max++;
    }
  }

  sum = max;

  for (let i = k; i < s.length; i++) {
    let t = getYuan(s[i]);
    let tag = getYuan(s[i - k]);
    sum = sum + t - tag;
    max = Math.max(max, sum);
    // console.log(i, s[i], sum, t, max);
    tag = t;
  }
  return max;
};
```

## 643. 子数组最大平均数 I

[643. 子数组最大平均数 I](https://leetcode.cn/problems/maximum-average-subarray-i/?envType=study-plan-v2&envId=leetcode-75)

```
给你一个由 n 个元素组成的整数数组 nums 和一个整数 k 。

请你找出平均数最大且 长度为 k 的连续子数组，并输出该最大平均数。

任何误差小于 10-5 的答案都将被视为正确答案。



示例 1：

输入：nums = [1,12,-5,-6,50,3], k = 4
输出：12.75
解释：最大平均数 (12-5-6+50)/4 = 51/4 = 12.75
示例 2：

输入：nums = [5], k = 1
输出：5.00000


提示：

n == nums.length
1 <= k <= n <= 10^5
-10^4 <= nums[i] <= 10^4
```

```js
/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number}
 */
var findMaxAverage = function (nums, k) {
  var max = 0,
    sum = 0;

  for (let i = 0; i < k; i++) {
    sum += nums[i];
  }
  max = sum;
  for (let i = k; i < nums.length; i++) {
    sum = sum + nums[i] - nums[i - k];
    max = Math.max(max, sum);
  }
  return max / k;
};
```

## 1004. 最大连续 1 的个数 III

[1004. 最大连续 1 的个数 III](https://leetcode.cn/problems/max-consecutive-ones-iii/?envType=study-plan-v2&envId=leetcode-75)

```
给定一个二进制数组 nums 和一个整数 k，如果可以翻转最多 k 个 0 ，则返回 数组中连续 1 的最大个数 。



示例 1：

输入：nums = [1,1,1,0,0,0,1,1,1,1,0], K = 2
输出：6
解释：[1,1,1,0,0,1,1,1,1,1,1]
粗体数字从 0 翻转到 1，最长的子数组长度为 6。
示例 2：

输入：nums = [0,0,1,1,0,0,1,1,1,0,1,1,0,0,0,1,1,1,1], K = 3
输出：10
解释：[0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1]
粗体数字从 0 翻转到 1，最长的子数组长度为 10。


提示：

1 <= nums.length <= 105
nums[i] 不是 0 就是 1
0 <= k <= nums.length
```

```js
/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number}
 */
var longestOnes = function (nums, k) {
  let N = nums.length;
  let res = 0;
  let left = 0,
    right = 0;
  let zeros = 0;
  while (right < N) {
    if (nums[right] == 0) zeros++;
    while (zeros > k) {
      if (nums[left++] == 0) zeros--;
    }
    res = Math.max(res, right - left + 1);
    right++;
  }
  return res;
};
```

## 1493. 删掉一个元素以后全为 1 的最长子数组

https://leetcode.cn/problems/longest-subarray-of-1s-after-deleting-one-element/description/?envType=study-plan-v2&envId=leetcode-75

```
给你一个二进制数组 nums ，你需要从中删掉一个元素。

请你在删掉元素的结果数组中，返回最长的且只包含 1 的非空子数组的长度。

如果不存在这样的子数组，请返回 0 。



提示 1：

输入：nums = [1,1,0,1]
输出：3
解释：删掉位置 2 的数后，[1,1,1] 包含 3 个 1 。
示例 2：

输入：nums = [0,1,1,1,0,1,1,0,1]
输出：5
解释：删掉位置 4 的数字后，[0,1,1,1,1,1,0,1] 的最长全 1 子数组为 [1,1,1,1,1] 。
示例 3：

输入：nums = [1,1,1]
输出：2
解释：你必须要删除一个元素。


提示：

1 <= nums.length <= 105
nums[i] 要么是 0 要么是 1 。
```

```js
/**
 * @param {number[]} nums
 * @return {number}
 */
var longestSubarray = function (nums) {
  let left = 0,
    zero = 0,
    max = 0;
  for (let i = 0; i < nums.length; i++) {
    if (nums[i] == 0) {
      zero++;
    }
    while (zero > 1) {
      if (nums[left] == 0) {
        zero--;
      }
      left++;
    }
    max = Math.max(max, i - left + 1 - zero);
  }
  return max == nums.length ? max - 1 : max;
};
```

# 每日温度

[739. 每日温度](https://leetcode.cn/problems/daily-temperatures/solutions/283196/mei-ri-wen-du-by-leetcode-solution/?envType=study-plan-v2&envId=leetcode-75)

```
给定一个整数数组 temperatures ，表示每天的温度，返回一个数组 answer ，其中 answer[i] 是指对于第 i 天，下一个更高温度出现在几天后。如果气温在这之后都不会升高，请在该位置用 0 来代替。



示例 1:

输入: temperatures = [73,74,75,71,69,72,76,73]
输出: [1,1,4,2,1,1,0,0]

示例 2:

输入: temperatures = [30,40,50,60]
输出: [1,1,1,0]

示例 3:

输入: temperatures = [30,60,90]
输出: [1,1,0]


提示：

1 <= temperatures.length <= 105
30 <= temperatures[i] <= 100
```

```js
/**
 * @param {number[]} temperatures
 * @return {number[]}
 */
var dailyTemperatures = function (temperatures) {
  let result = [];
  for (let i = 0; i < temperatures.length; i++) {
    let tag = false;
    for (let j = i + 1; j < temperatures.length; j++) {
      if (temperatures[j] > temperatures[i]) {
        result[i] = j - i;
        tag = true;
        break;
      }
    }
    if (!tag) {
      result[i] = 0;
    }
  }
  return result;
};
```

# 901. 股票价格跨度

[901. 股票价格跨度](https://leetcode.cn/problems/online-stock-span/?envType=study-plan-v2&envId=leetcode-75)

```
设计一个算法收集某些股票的每日报价，并返回该股票当日价格的 跨度 。

当日股票价格的 跨度 被定义为股票价格小于或等于今天价格的最大连续日数（从今天开始往回数，包括今天）。

例如，如果未来 7 天股票的价格是 [100,80,60,70,60,75,85]，那么股票跨度将是 [1,1,1,2,1,4,6] 。

实现 StockSpanner 类：

StockSpanner() 初始化类对象。
int next(int price) 给出今天的股价 price ，返回该股票当日价格的 跨度 。


示例：

输入：
["StockSpanner", "next", "next", "next", "next", "next", "next", "next"]
[[], [100], [80], [60], [70], [60], [75], [85]]
输出：
[null, 1, 1, 1, 2, 1, 4, 6]

解释：
StockSpanner stockSpanner = new StockSpanner();
stockSpanner.next(100); // 返回 1
stockSpanner.next(80);  // 返回 1
stockSpanner.next(60);  // 返回 1
stockSpanner.next(70);  // 返回 2
stockSpanner.next(60);  // 返回 1
stockSpanner.next(75);  // 返回 4 ，因为截至今天的最后 4 个股价 (包括今天的股价 75) 都小于或等于今天的股价。
stockSpanner.next(85);  // 返回 6

提示：

1 <= price <= 105
最多调用 next 方法 104 次
```

# LRU 缓存

```
[1,2,3,4,3,4,2,4],3
//
```

# 63. 不同路径 II

https://leetcode.cn/problems/unique-paths-ii/submissions/511892353/

```txt
一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish”）。

现在考虑网格中有障碍物。那么从左上角到右下角将会有多少条不同的路径？

网格中的障碍物和空位置分别用 1 和 0 来表示。



示例 1：


输入：obstacleGrid = [[0,0,0],[0,1,0],[0,0,0]]
输出：2
解释：3x3 网格的正中间有一个障碍物。
从左上角到右下角一共有 2 条不同的路径：
1. 向右 -> 向右 -> 向下 -> 向下
2. 向下 -> 向下 -> 向右 -> 向右


示例 2：


输入：obstacleGrid = [[0,1],[0,0]]
输出：1


提示：

m == obstacleGrid.length
n == obstacleGrid[i].length
1 <= m, n <= 100
obstacleGrid[i][j] 为 0 或 1
```

动态规划，记忆化

```js
/**
 * @param {number[][]} obstacleGrid
 * @return {number}
 */
var uniquePathsWithObstacles = function (obstacleGrid) {
  const m = obstacleGrid.length;
  if (m === 0) return;
  const n = obstacleGrid[0].length;

  const dp = new Array(m);
  for (let i = 0; i < dp.length; i++) dp[i] = new Array(n).fill(0);

  for (let i = 0; i < m; i++) {
    for (let j = 0; j < n; j++) {
      if (obstacleGrid[i][j]) dp[i][j] = 0;
      else if (i === 0 && j === 0) dp[i][j] = 1;
      else if (i === 0) dp[i][j] = dp[i][j - 1];
      else if (j === 0) dp[i][j] = dp[i - 1][j];
      else dp[i][j] = dp[i - 1][j] + dp[i][j - 1];
    }
  }

  return dp[m - 1][n - 1];
};
```
