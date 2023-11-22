《程序员的算法趣题》[日]增井民克.著 绝云.译

# 入门

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

# LeetCode 75

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
