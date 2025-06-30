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
