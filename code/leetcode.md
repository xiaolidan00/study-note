# 1790

https://mp.weixin.qq.com/s/QLj53-h6m6nBj1ER3btQYQ

给你长度相等的两个字符串 `s1` 和 `s2` 。

一次字符串交换操作的步骤如下：选出某个字符串中的两个下标（不必不同），并交换这两个下标所对应的字符。

如果对其中一个字符串执行最多一次字符串交换就可以使两个字符串相等，返回 `true` ，否则，返回 `false` 。

示例 1：

```
输入：s1 = "bank", s2 = "kanb"

输出：true

解释：例如，交换 s2 中的第一个和最后一个字符可以得到 "bank"
```

示例 2：

```
输入：s1 = "attack", s2 = "defend"

输出：false

解释：一次字符串交换无法使两个字符串相等
```

示例 3：

```
输入：s1 = "kelb", s2 = "kelb"

输出：true

解释：两个字符串已经相等，所以不需要进行字符串交换
```

示例 4：

```
输入：s1 = "abcd", s2 = "dcba"

输出：false
```

提示：

- `1<=s1.length,s2.length<=100`
- `s1.length=s2.length`
- `s1` 和 `s2` 仅由小写英文字母组成

根据题意进行模拟即可 : 使用 `a` 和 `b` 记录不同的位置下标，初始值为 `-1`，若「不同位置超过 个」或「只有 个」直接返回 `false`，若「不存在不同位置」或「不同位置字符相同」，则返回 `true`。

## 题解

```ts
function areAlmostEqual(s1, s2) {
  const n = s1.length;
  //记录需要交换的字符串索引
  let a = -1,
    b = -1;
  for (let i = 0; i < n; i++) {
    //字符相同则跳过
    if (s1[i] == s2[i]) continue;
    //字符串不同，记录前后索引
    if (a == -1) a = i;
    else if (b == -1) b = i;
    //字符不同的数量超过两个，则不符合，返回false
    else return false;
  }
  //没有不同的字符，代表字符串完全一样，返回true
  if (a == -1) return true;
  //有一个不同的字符，不符合，返回false
  if (b == -1) return false;
  //要交换的前后索引字符交换后一样，返回true
  return s1[a] === s2[b] && s1[b] == s2[a];
}

console.log(areAlmostEqual('bank', 'kanb'));
console.log(areAlmostEqual('abcd', 'dcba'));
```

# 784

https://mp.weixin.qq.com/s/uR0w11ZeRhq9qtFG8DvjPw

给定一个字符串 `s`，通过将字符串 `s` 中的每个字母转变大小写，我们可以获得一个新的字符串。

返回所有可能得到的字符串集合，以任意顺序返回输出。

示例 1：

```
输入：s = "a1b2"

输出：["a1b2", "a1B2", "A1b2", "A1B2"]
```

示例 2:

```
输入: s = "3z4"

输出: ["3z4","3Z4"]
```

提示:

- `1<=s.length<=12`
- `s` 由小写英文字母、大写英文字母和数字组成

## 题解1

数据范围为 12，同时要我们求所有具体方案，容易想到使用 `DFS` 进行「爆搜」。

我们可以从前往后考虑每个` s[i]`，根据` s[i]`是否为字母进行分情况讨论：

- 若 ` s[i]`不是字母，直接保留
- 若 ` s[i]`是字母，则有「保留原字母」或「进行大小写转换」两种决策

设计 `DFS` 函数为 `void dfs(int idx, int n, String cur)`：其中`n` 固定为具体方案的长度（即原字符串长度），而 `idx` 和 `cur` 分别为当前处理到哪一个 `s[idx]`，而 `cur` 则是当前具体方案。

根据上述分析可知，当 `s[idx]`不为字母，将其直接追加到 `cur` 上，并决策下一个位置 `idx+1`；而当 `s[idx]`为字母时，我们可以选择将 `s[idx]`追加到 `cur` 上（保留原字母）或是将`s[idx]`进行翻转后再追加到 `cur` 上（进行大小写转换）。

最后当我们满足 `idx = n` 时，说明已经对原字符串的每一位置决策完成，将当前具体方案 `cur` 加入答案。



时间复杂度`O(nx2^n)`

空间复杂度`O(nx2^n)`

```js
function letterCasePermutation(s) {
  const ans = new Array();
  const n = s.length;
  function dfs(idx, cur) {
    if (idx == n) {
      ans.push(cur);
      return;
    }
    //添加原字符
    dfs(idx + 1, cur + s[idx]);
    //转换大小写
    if ((s[idx] >= "a" && s[idx] <= "z") || (s[idx] >= "A" && s[idx] <= "Z")) {
      dfs(idx + 1, cur + String.fromCharCode(s.charCodeAt(idx) ^ 32));
    }
  }
  dfs(0, "");
  return ans;
}
console.log(letterCasePermutation("a1b2"));

```

##  题解2

根据解法一可知，具体方案的个数与字符串 `s1` 存在的字母个数相关，当 `s1` 存在 `m` 个字母时，由于每个字母存在两种决策，总的方案数个数为`2^m` 个。

因此可以使用「二进制枚举」的方式来做：使用变量 `s` 代表字符串 `s1` 的字母翻转状态，`s` 的取值范围为 `[0, 1 << m)`。若 `s` 的第 位为 `0` 代表在 `s1` 中第 个字母不进行翻转，而当为 `1` 时则代表翻转。

每一个状态 `s` 对应了一个具体方案，通过枚举所有翻转状态 `s`，可构造出所有具体方案。

时间复杂度`O(nx2^n)`

空间复杂度`O(nx2^n)`

```js
function letterCasePermutation(str) {
  function isLetter(ch) {
    return (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z");
  }
  const ans = new Array();
  const n = str.length;
  let m = 0;
  for (let i = 0; i < n; i++) m += isLetter(str[i]) ? 1 : 0;
  for (let s = 0; s < 1 << m; s++) {
    let cur = "";
    for (let i = 0, j = 0; i < n; i++) {
      if (!isLetter(str[i]) || ((s >> j) & 1) == 0) cur += str[i];
      else cur += String.fromCharCode(str.charCodeAt(i) ^ 32);
      if (isLetter(str[i])) j++;
    }
    ans.push(cur);
  }
  return ans;
}
console.log(letterCasePermutation("a1b2"));

```

# 779

https://mp.weixin.qq.com/s/P4naJB9ee969nlmYzUJHtA

我们构建了一个包含 `n` 行( 索引从 `1` 开始 )的表。首先在第一行我们写上一个 `0`。接下来的每一行，将前一行中的 `0` 替换为 `01`，`1` 替换为 `10`。

例如，对于 `n = 3`，第 `1` 行是 `0` ，第 `2` 行是 `01`，第 `3` 行是 `0110` 。

给定行数 `n` 和序数 `k`，返回第 `n` 行中第 `k` 个字符。（ `k` 从索引 `1` 开始）

示例 1:

```
输入: n = 1, k = 1

输出: 0

解释: 第一行：0
```

示例 2:

```
输入: n = 2, k = 1

输出: 0

解释: 
第一行: 0 
第二行: 01
```

示例 3:

```
输入: n = 2, k = 2

输出: 1

解释:
第一行: 0
第二行: 01
```

提示:

- `1<=n<=30`
- `1<=k<=2^(n-1)`



##  

整理一下条件：首行为 `0`，每次用当前行拓展出下一行时，字符数量翻倍（将 `0` 拓展为 `01`，将 `1` 拓展为 `10`），且字符种类仍为 `01`。

要求我们输出第` n`行第`k`列的字符，我们可以通过「倒推验证」的方式来求解：假设第 `n`行第 为 `1`，若能倒推出首行为 `0`，说明假设成立，返回 `1`，否则返回 `0`。

倒推验证可通过实现递归函数 `int dfs(int r, int c, int cur)` 来做，含义为当第`r`行第`c`列的字符为`cur`时，首行首列字符为何值。同时实现该函数是容易的：

- 若「当前列 为`c`偶数且`cur=0` 」或「当前列`c` 为奇数且`cur=1` 」时，说明当前列所在的组为 `10`，由此可推出其是由上一行的 `1` 拓展而来，结合每次拓展新行字符数量翻倍的条件，可知是由第`r-1`行的第`((c-1)/2)+1`列的 `1` 拓展而来，递归处理；
- 否则，同理，必然是上一行（第`r-1`行）对应位置的 `0` 拓展而来，递归处理。

最终，当倒推到首行时，我们找到了递归出口，直接返回 `cur`。

- 时间复杂度：`O(n)`

- 空间复杂度：`O(1)`

```js
function kthGrammar(n, k) {
  function dfs(r, c, cur) {
    if (r == 1) return cur;
    if ((c % 2 == 0 && cur == 0) || (c % 2 == 1 && cur == 1)) return dfs(r - 1, Math.floor((c - 1) / 2) + 1, 1);
    else return dfs(r - 1, Math.floor((c - 1) / 2) + 1, 0);
  }
  return dfs(n, k, 1) == 0 ? 1 : 0;
}
console.log(kthGrammar(2, 2));
console.log(kthGrammar(2, 1));
```

# 1802

https://mp.weixin.qq.com/s/pIRyd1yrENSEDbTLPoVG8g

给你三个正整数 `n`、`index` 和 `maxSum`。

你需要构造一个同时满足下述所有条件的数组 `nums`（下标 从 `0` 开始 计数）：

- `nums.length == n`
- `nums[i]` 是 正整数 ，其中 `0 <= i < n`
- `abs(nums[i] - nums[i+1]) <= 1` ，其中 `0 <= i < n-1`
- `nums` 中所有元素之和不超过 `maxSum`
- `nums[index]` 的值被 最大化
- 返回你所构造的数组中的 `nums[index]`

注意：`abs(x)` 等于 `x` 的前提是 `x >= 0`；否则，`abs(x)` 等于 `-x`。

示例 1：

```
输入：n = 4, index = 2,  maxSum = 6

输出：2

解释：数组 [1,1,2,1] 和 [1,2,2,1] 满足所有条件。不存在其他在指定下标处具有更大值的有效数组。
```

示例 2：

```
输入：n = 6, index = 1,  maxSum = 10

输出：3
```

提示：

- `1<=n<=maxSum<=10^9`
- `0<=index<n`

## 题解

根据题意，容易想到以 `ans` 为分割点的正整数数组具有二段性，其中 `ans` 为最大的`nums[idx]` 。

小于等于 `ans` 的值均能通过直接调整`nums[idx]` 来构造，不会违反总和不超过 `max` 的限制；大于 `ans` 的值则无法满足 `max` 限制。基于此我们可通过「二分」的方式来找分割点。

假设当前二分到的值为 `x`，考虑如何实现一个 `check` 函数，该函数用于判断 `x` 能否作为 `nums[idx]`：

为了令 `nums[idx]=x`时，数组总和 `sum` 不超过 `max` 限制，我们应当贪心构造`nums` 的剩余元素：从` idx`开始往两侧构造，按照递减的方式进行逐个构造，若递减到 `1`则维持不变。

这样可确保构造出来的`nums`既满足`nums[idx]=x`同时元素总和最小。

位置 `idx` 的值为 `x`，其左边有 `idx` 个元素，其右边有 `n - idx - 1` 个元素。

利用「等差数列求和」公式分别从 `x - 1` 开始构造（注意：这里说的构造仅是计算`nums`总和），若总和不超过 `max` 说明 `nums[idx]=x`满足要求，我们令 `l=mid`，否则令`r=mid-1` 。

- 时间复杂度`O(logN)`
- 空间复杂度`O(1)`

```js
function maxValue(n, index, maxSum) {
  function check(n, x, idx, maxSum) {
    let sum = x;
    if (idx > x - 1) {
      let an = x - 1,
        a1 = 1,
        cnt = x - 1;
      sum += (cnt * (a1 + an)) / 2;
      sum += idx - cnt;
    } else {
      let cnt = idx,
        an = x - 1,
        a1 = an - cnt - 1;
      sum += (cnt * (a1 + an)) / 2;
    }
    if (n - idx - 1 > x - 1) {
      let an = x - 1,
        a1 = 1,
        cnt = x - 1;
      sum += (cnt * (a1 + an)) / 2;
      sum += n - idx - 1 - cnt;
    } else {
      let cnt = n - idx,
        an = x - 1,
        a1 = an - cnt + 1;
      sum += (cnt * (a1 + an)) / 2;
    }
    return sum < maxSum;
  }
  let l = 1,
    r = maxSum;
  //贪心+二分法
  while (l < r) {
    let mid = (l + r + 1) >> 1;
    if (check(n, mid, index, maxSum)) l = mid;
    else r = mid - 1;
  }
  return r;
}
console.log(maxValue(4, 2, 6)); //2
console.log(maxValue(6, 1, 10)); //3
```

# 904

https://mp.weixin.qq.com/s/KyrcqLogEXjdBAhFJWrgKA

你正在探访一家农场，农场从左到右种植了一排果树。

这些树用一个整数数组 `fruits` 表示，其中 `fruits[i]` 是第 `i` 棵树上的水果种类。

你想要尽可能多地收集水果。然而，农场的主人设定了一些严格的规矩，你必须按照要求采摘水果：

- 你只有两个篮子，并且每个篮子只能装单一类型 的水果。每个篮子能够装的水果总量没有限制。
- 你可以选择任意一棵树开始采摘，你必须从每棵树（包括开始采摘的树）上恰好摘一个水果。采摘的水果应当符合篮子中的水果类型。每采摘一次，你将会向右移动到下一棵树，并继续采摘。
- 一旦你走到某棵树前，但水果不符合篮子的水果类型，那么就必须停止采摘。

给你一个整数数组 `fruits`，返回你可以收集的水果的最大数目。

示例 1：

```
输入：fruits = [1,2,1]

输出：3

解释：可以采摘全部 3 棵树。
```

示例 2：

```
输入：fruits = [0,1,2,2]

输出：3

解释：可以采摘 [1,2,2] 这三棵树。
如果从第一棵树开始采摘，则只能采摘 [0,1] 这两棵树。
```

示例 3：

```
输入：fruits = [1,2,3,2,2]

输出：4

解释：可以采摘 [2,3,2,2] 这四棵树。
如果从第一棵树开始采摘，则只能采摘 [1,2] 这两棵树。
```

示例 4：

```
输入：fruits = [3,3,3,1,2,1,1,2,3,3,4]

输出：5

解释：可以采摘 [1,2,1,1,2] 这五棵树。
```

提示：

- `1<=fruits.length<=10^5`
- `0<=fruits[i]<fruits.length`

 

## 题解：滑动窗口

通过对先看「示例」再阅读「题面」的理解方式，整理出基本题意：从任意位置开始，**「同时使用」**两个篮子采集，一旦选择后不能修改篮子所装的水果种类，当所有树处理完或遇到第一棵种类不同的树则停止。

核心求解思路为滑动窗口：使用 `j` 和 `i` 分别代表滑动窗口的两端，窗口种类不超过`2`种为合法。

- 时间复杂度O(n)
- 空间复杂度O(n)

```js
//滑动窗口
function totalFruit(fruits) {
  let n = fruits.length,
    ans = 0;
  const cnts = new Array(n + 10).fill(0);
  for (let i = 0, j = 0, tot = 0; i < n; i++) {
    if (++cnts[fruits[i]] == 1) tot++;
    while (tot > 2) {
      if (--cnts[fruits[j++]] == 0) tot--;
    }
    ans = Math.max(ans, i - j + 1);
  }
  return ans;
}
console.log(totalFruit([3, 3, 3, 1, 2, 1, 1, 2, 3, 3, 4])); //5

```

