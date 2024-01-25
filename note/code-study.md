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

# 数组

## 二分查找法++

```js
function binarySearch(arr, target) {
  let left = 0,
    right = arr.length - 1; //在[left,right]之间查找

  while (left <= right) {
    //left==right时仍有效
    let mid = left + (right - left) / 2;
    if (arr[mid] == target) {
      return mid;
    }
    //mid不是target
    if (target > arr[mid]) {
      //target在[mid+1,right]之间
      left = mid + 1;
    } else {
      //target在[left,mid-1]之间
      right = mid - 1;
    }
  }
  return -1;
}
```

## 283. 移动零++

https://leetcode.cn/problems/move-zeroes/description/

```js
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
var moveZeroes = function (nums) {
  let k = 0; //非零元素索引
  for (let i = 0; i < nums.length; i++) {
    //将所有非零元素向前移动
    if (nums[i]) {
      nums[k++] = nums[i];
    }
  }
  for (let i = k; i < nums.length; i++) {
    //后面的元素置零
    nums[i] = 0;
  }
};

var moveZeroes = function (nums) {
  let k = 0; //非零元素索引
  for (let i = 0; i < nums.length; i++) {
    //非零元素与零元素置换位置
    if (nums[i]) {
      if (i != k) {
        let temp = nums[i];
        nums[i] = nums[k];
        nums[k++] = temp;
      } else {
        k++;
      }
    }
  }
};
```

## 27. 移除元素

https://leetcode.cn/problems/remove-element/description/

```
给你一个数组 nums 和一个值 val，你需要 原地 移除所有数值等于 val 的元素，并返回移除后数组的新长度。

不要使用额外的数组空间，你必须仅使用 O(1) 额外空间并 原地 修改输入数组。

元素的顺序可以改变。你不需要考虑数组中超出新长度后面的元素。



说明:

为什么返回数值是整数，但输出的答案是数组呢?

请注意，输入数组是以「引用」方式传递的，这意味着在函数里修改输入数组对于调用者是可见的。

你可以想象内部操作如下:

// nums 是以“引用”方式传递的。也就是说，不对实参作任何拷贝
int len = removeElement(nums, val);

// 在函数里修改输入数组对于调用者是可见的。
// 根据你的函数返回的长度, 它会打印出数组中 该长度范围内 的所有元素。
for (int i = 0; i < len; i++) {
    print(nums[i]);
}


示例 1：

输入：nums = [3,2,2,3], val = 3
输出：2, nums = [2,2]
解释：函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。你不需要考虑数组中超出新长度后面的元素。例如，函数返回的新长度为 2 ，而 nums = [2,2,3,3] 或 nums = [2,2,0,0]，也会被视作正确答案。
示例 2：

输入：nums = [0,1,2,2,3,0,4,2], val = 2
输出：5, nums = [0,1,3,0,4]
解释：函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4。注意这五个元素可为任意顺序。你不需要考虑数组中超出新长度后面的元素。


提示：

0 <= nums.length <= 100
0 <= nums[i] <= 50
0 <= val <= 100
```

```js
/**
 * @param {number[]} nums
 * @param {number} val
 * @return {number}
 */

var removeElement = function (nums, val) {
  let k = 0; //非零元素索引
  let len = 0; //计算数组长度
  for (let i = 0; i < nums.length; i++) {
    //不是指定值的元素置换位置到后面
    if (nums[i] != val) {
      len++;
      if (k != i) {
        nums[k] = nums[i];
      }
      k++;
    }
  }
  return len;
};

var removeElement = function (nums, val) {
  let k = 0; //非零元素索引
  let len = 0; //计算数组长度
  for (let i = 0; i < nums.length; i++) {
    //不是指定值的元素置换位置到后面
    if (nums[i] != val) {
      len++;
      if (i != k) {
        let temp = nums[i];
        nums[i] = nums[k];
        nums[k++] = temp;
      } else {
        k++;
      }
    }
  }
  return len;
};
```

## 80. 删除有序数组中的重复项 II

https://leetcode.cn/problems/remove-duplicates-from-sorted-array-ii/description/

```
给你一个有序数组 nums ，请你 原地 删除重复出现的元素，使得出现次数超过两次的元素只出现两次 ，返回删除后数组的新长度。

不要使用额外的数组空间，你必须在 原地 修改输入数组 并在使用 O(1) 额外空间的条件下完成。



说明：

为什么返回数值是整数，但输出的答案是数组呢？

请注意，输入数组是以「引用」方式传递的，这意味着在函数里修改输入数组对于调用者是可见的。

你可以想象内部操作如下:

// nums 是以“引用”方式传递的。也就是说，不对实参做任何拷贝
int len = removeDuplicates(nums);

// 在函数里修改输入数组对于调用者是可见的。
// 根据你的函数返回的长度, 它会打印出数组中 该长度范围内 的所有元素。
for (int i = 0; i < len; i++) {
    print(nums[i]);
}


示例 1：

输入：nums = [1,1,1,2,2,3]
输出：5, nums = [1,1,2,2,3]
解释：函数应返回新长度 length = 5, 并且原数组的前五个元素被修改为 1, 1, 2, 2, 3。 不需要考虑数组中超出新长度后面的元素。
示例 2：

输入：nums = [0,0,1,1,1,1,2,3,3]
输出：7, nums = [0,0,1,1,2,3,3]
解释：函数应返回新长度 length = 7, 并且原数组的前七个元素被修改为 0, 0, 1, 1, 2, 3, 3。不需要考虑数组中超出新长度后面的元素。


提示：

1 <= nums.length <= 3 * 104
-104 <= nums[i] <= 104
nums 已按升序排列
```

```js
/**
 * @param {number[]} nums
 * @return {number}
 */
var removeDuplicates = function (nums) {
  if (nums.length < 3) return nums.length;
  let j = 2;
  for (let i = 2; i < nums.length; i++) {
    if (nums[i] != nums[j - 2]) {
      if (j != i) {
        nums[j] = nums[i];
      }
      j++;
    }
  }
  return j;
};
```

## 75. 颜色分类++

https://leetcode.cn/problems/sort-colors/description/

```
给定一个包含红色、白色和蓝色、共 n 个元素的数组 nums ，原地对它们进行排序，使得相同颜色的元素相邻，并按照红色、白色、蓝色顺序排列。

我们使用整数 0、 1 和 2 分别表示红色、白色和蓝色。

必须在不使用库内置的 sort 函数的情况下解决这个问题。



示例 1：

输入：nums = [2,0,2,1,1,0]
输出：[0,0,1,1,2,2]
示例 2：

输入：nums = [2,0,1]
输出：[0,1,2]


提示：

n == nums.length
1 <= n <= 300
nums[i] 为 0、1 或 2


进阶：

你能想出一个仅使用常数空间的一趟扫描算法吗？
```

**三路排序**

```js
/**
 * @param {number[]} nums
 * @return {void} Do not return anything, modify nums in-place instead.
 */
var sortColors = function (nums) {
  let zero = -1;
  let two = nums.length;
  for (let i = 0; i < two; ) {
    if (nums[i] === 1) {
      i++;
    } else if (nums[i] === 2) {
      two--;
      if (two != i) {
        let temp = nums[i];
        nums[i] = nums[two];
        nums[two] = temp;
      }
    } else {
      //num[i]==0
      zero++;
      if (zero != i) {
        let temp = nums[i];
        nums[i] = nums[zero];
        nums[zero] = temp;
      }
      i++;
    }
  }
};
```

## 88. 合并两个有序数组

https://leetcode.cn/problems/merge-sorted-array/description/

```
给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2，另有两个整数 m 和 n ，分别表示 nums1 和 nums2 中的元素数目。

请你 合并 nums2 到 nums1 中，使合并后的数组同样按 非递减顺序 排列。

注意：最终，合并后数组不应由函数返回，而是存储在数组 nums1 中。为了应对这种情况，nums1 的初始长度为 m + n，其中前 m 个元素表示应合并的元素，后 n 个元素为 0 ，应忽略。nums2 的长度为 n 。



示例 1：

输入：nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
输出：[1,2,2,3,5,6]
解释：需要合并 [1,2,3] 和 [2,5,6] 。
合并结果是 [1,2,2,3,5,6] ，其中斜体加粗标注的为 nums1 中的元素。
示例 2：

输入：nums1 = [1], m = 1, nums2 = [], n = 0
输出：[1]
解释：需要合并 [1] 和 [] 。
合并结果是 [1] 。
示例 3：

输入：nums1 = [0], m = 0, nums2 = [1], n = 1
输出：[1]
解释：需要合并的数组是 [] 和 [1] 。
合并结果是 [1] 。
注意，因为 m = 0 ，所以 nums1 中没有元素。nums1 中仅存的 0 仅仅是为了确保合并结果可以顺利存放到 nums1 中。


提示：

nums1.length == m + n
nums2.length == n
0 <= m, n <= 200
1 <= m + n <= 200
-109 <= nums1[i], nums2[j] <= 109


进阶：你可以设计实现一个时间复杂度为 O(m + n) 的算法解决此问题吗？
```

尾指针

```js
/**
 * @param {number[]} nums1
 * @param {number} m
 * @param {number[]} nums2
 * @param {number} n
 * @return {void} Do not return anything, modify nums1 in-place instead.
 */
var merge = function (nums1, m, nums2, n) {
  let i = m - 1,
    j = n - 1,
    k = m + n - 1;
  while (i >= 0 || j >= 0) {
    if (i < 0) nums1[k--] = nums2[j--]; //处理nums1为空数组情况
    else if (j < 0) nums1[k--] = nums1[i--]; //处理nums2为空数组情况
    else if (nums1[i] < nums2[j]) nums1[k--] = nums2[j--];
    else nums1[k--] = nums1[i--];
  }
  return nums1;
};
```

## 215. 数组中的第 K 个最大元素

https://leetcode.cn/problems/kth-largest-element-in-an-array/description/

```
给定整数数组 nums 和整数 k，请返回数组中第 k 个最大的元素。

请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。

你必须设计并实现时间复杂度为 O(n) 的算法解决此问题。



示例 1:

输入: [3,2,1,5,6,4], k = 2
输出: 5
示例 2:

输入: [3,2,3,1,2,4,5,5,6], k = 4
输出: 4


提示：

1 <= k <= nums.length <= 105
-104 <= nums[i] <= 104
```

```js
/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number}
 */
var findKthLargest = function (s, idx) {
  //超时，循环太多了
  if (s.length == 1) return s[0];
  let k = s.length - idx;
  let l = 0;
  let r = s.length - 1;
  while (l < r) {
    let i = l,
      j = r,
      x = s[l];

    while (i < j) {
      while (i < j && s[j] >= x)
        // 从右向左找第一个小于x的数
        j--;

      while (i < j && s[i] < x)
        // 从左向右找第一个大于等于x的数
        i++;
      if (i < j) {
        s[i++] = s[j];
      }
      if (i > j) {
        break;
      }
      if (i < j) {
        s[j--] = s[i];
      }
    }
    s[i] = x;
    //  减少分治
    if (i == k) {
      return x;
    } else if (i < k) {
      l = i + 1;
    } else {
      r = i - 1;
    }
  }
  return s[k];
};
```

```js
/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number}
 */
function quickselect(nums, l, r, k) {
  if (l == r) return nums[k];
  let x = nums[l],
    i = l - 1,
    j = r + 1;
  while (i < j) {
    do i++;
    while (nums[i] < x);
    do j--;
    while (nums[j] > x);
    if (i < j) {
      let tmp = nums[i];
      nums[i] = nums[j];
      nums[j] = tmp;
    }
  }
  if (k <= j) return quickselect(nums, l, j, k);
  else return quickselect(nums, j + 1, r, k);
}
var findKthLargest = function (nums, k) {
  let n = nums.length;
  return quickselect(nums, 0, n - 1, n - k);
};
```

## 快速排序

```js
//快速排序
void quick_sort(int s[], int l, int r)
{
    if (l < r)
    {
        //Swap(s[l], s[(l + r) / 2]); //将中间的这个数和第一个数交换 参见注1
        int i = l, j = r, x = s[l];
        while (i < j)
        {
            while(i < j && s[j] >= x) // 从右向左找第一个小于x的数
                j--;
            if(i < j)
                s[i++] = s[j];

            while(i < j && s[i] < x) // 从左向右找第一个大于等于x的数
                i++;
            if(i < j)
                s[j--] = s[i];
        }
        s[i] = x;
        quick_sort(s, l, i - 1); // 递归调用
        quick_sort(s, i + 1, r);
    }
}
```

## 167. 两数之和 II - 输入有序数组++

https://leetcode.cn/problems/two-sum-ii-input-array-is-sorted/description/

```
给你一个下标从 1 开始的整数数组 numbers ，该数组已按 非递减顺序排列  ，请你从数组中找出满足相加之和等于目标数 target 的两个数。如果设这两个数分别是 numbers[index1] 和 numbers[index2] ，则 1 <= index1 < index2 <= numbers.length 。

以长度为 2 的整数数组 [index1, index2] 的形式返回这两个整数的下标 index1 和 index2。

你可以假设每个输入 只对应唯一的答案 ，而且你 不可以 重复使用相同的元素。

你所设计的解决方案必须只使用常量级的额外空间。


示例 1：

输入：numbers = [2,7,11,15], target = 9
输出：[1,2]
解释：2 与 7 之和等于目标数 9 。因此 index1 = 1, index2 = 2 。返回 [1, 2] 。
示例 2：

输入：numbers = [2,3,4], target = 6
输出：[1,3]
解释：2 与 4 之和等于目标数 6 。因此 index1 = 1, index2 = 3 。返回 [1, 3] 。
示例 3：

输入：numbers = [-1,0], target = -1
输出：[1,2]
解释：-1 与 0 之和等于目标数 -1 。因此 index1 = 1, index2 = 2 。返回 [1, 2] 。


提示：

2 <= numbers.length <= 3 * 104
-1000 <= numbers[i] <= 1000
numbers 按 非递减顺序 排列
-1000 <= target <= 1000
仅存在一个有效答案
```

循环+二分查找法

```js
function binarySearch(nums, l, r, target) {
  console.log(target);
  while (l <= r) {
    let mid = Math.round(l + (r - l) / 2);
    console.log(mid);
    if (nums[mid] == target) {
      return mid;
    } else if (nums[mid] > target) {
      r = mid - 1;
    } else {
      //nums[mid]<target
      l = mid + 1;
    }
  }
  return -1;
}
var twoSum = function (nums, target) {
  for (let i = 0; i < nums.length; i++) {
    let j = binarySearch(nums, i + 1, nums.length - 1, target - nums[i]);
    if (j !== -1) {
      return [i + 1, j + 1];
    }
  }
};
```

对撞指针,双指针

```js
var twoSum = function (nums, target) {
  let i = 0;
  let j = nums.length - 1;
  while (i < j) {
    let sum = nums[i] + nums[j];
    if (sum > target) {
      j--;
    } else if (sum < target) {
      i++;
    } else {
      //target == sum
      return [i + 1, j + 1];
    }
  }
  return [-1, -1];
};
```

## 125. 验证回文串

https://leetcode.cn/problems/valid-palindrome/description/

```txt
如果在将所有大写字符转换为小写字符、并移除所有非字母数字字符之后，短语正着读和反着读都一样。则可以认为该短语是一个 回文串 。

字母和数字都属于字母数字字符。

给你一个字符串 s，如果它是 回文串 ，返回 true ；否则，返回 false 。



示例 1：

输入: s = "A man, a plan, a canal: Panama"
输出：true
解释："amanaplanacanalpanama" 是回文串。
示例 2：

输入：s = "race a car"
输出：false
解释："raceacar" 不是回文串。
示例 3：

输入：s = " "
输出：true
解释：在移除非字母数字字符之后，s 是一个空字符串 "" 。
由于空字符串正着反着读都一样，所以是回文串。


提示：

1 <= s.length <= 2 * 105
s 仅由可打印的 ASCII 字符组成
```

```js
/**
 * @param {string} s
 * @return {boolean}
 */
var isPalindrome = function (s) {
  s = s.toLowerCase();
  let i = 0;
  j = s.length - 1;
  while (i <= j) {
    while (!/[0-9a-zA-Z]/.test(s[i])) {
      i++;
    }
    while (!/[0-9a-zA-Z]/.test(s[j])) {
      j--;
    }

    if (s[i] != s[j]) {
      return false;
    }
    i++;
    j--;
  }
  return true;
};
```

## 344. 反转字符串

https://leetcode.cn/problems/reverse-string/description/

```txt
编写一个函数，其作用是将输入的字符串反转过来。输入字符串以字符数组 s 的形式给出。

不要给另外的数组分配额外的空间，你必须原地修改输入数组、使用 O(1) 的额外空间解决这一问题。



示例 1：

输入：s = ["h","e","l","l","o"]
输出：["o","l","l","e","h"]
示例 2：

输入：s = ["H","a","n","n","a","h"]
输出：["h","a","n","n","a","H"]


提示：

1 <= s.length <= 105
s[i] 都是 ASCII 码表中的可打印字符
```

```js
var reverseString = function (s) {
  let i = 0,
    j = s.length - 1;
  while (i < j) {
    if (s[i] != s[j]) {
      //如果两个字符不相等才掉换位置了
      let temp = s[i];
      s[i] = s[j];
      s[j] = temp;
    }

    i++;
    j--;
  }
};
```

## 345. 反转字符串中的元音字母

https://leetcode.cn/problems/reverse-vowels-of-a-string/description/

```txt
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
/**
 * @param {string} s
 * @return {string}
 */
var reverseVowels = function (s) {
  let arr = s.split('');
  let i = 0,
    j = arr.length - 1;
  while (i < j) {
    while (!/[aeiouAEIOU]/.test(arr[i])) {
      i++;
    }
    while (!/[aeiouAEIOU]/.test(arr[j])) {
      j--;
    }
    if (i >= j) {
      //存在没有元音字母的情况直接跳出循环
      break;
    }
    if (arr[i] != arr[j]) {
      //如果两个字符不相等才掉换位置了
      let temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }

    i++;
    j--;
  }
  return arr.join('');
};
```

## 11. 盛最多水的容器

https://leetcode.cn/problems/container-with-most-water/description/

```txt
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
```

```js
var maxArea = function (height) {
  let i = 0,
    j = height.length - 1;
  let max = 0;
  while (i < j) {
    max = Math.max(max, (j - i) * Math.min(height[i], height[j]));
    if (height[i] < height[j]) {
      i++;
    } else {
      j--;
    }
  }
  return max;
};

var maxArea = function (height) {
  let i = 0,
    j = height.length - 1;
  let max = 0;
  let temp = 0;
  while (i < j) {
    max = Math.max(max, (j - i) * Math.min(height[i], height[j]));
    if (height[i] < height[j]) {
      temp = height[i];
      while (height[++i] < temp && i < j); //寻找比原来高的左侧
    } else {
      temp = height[j];
      while (height[--j] < temp && i < j); //寻找比原来高的右侧
    }
  }
  return max;
};
```

## 209. 长度最小的子数组，滑动窗口，子数组++

https://leetcode.cn/problems/minimum-size-subarray-sum/description/

```txt
给定一个含有 n 个正整数的数组和一个正整数 target 。

找出该数组中满足其总和大于等于 target 的长度最小的 连续子数组 [numsl, numsl+1, ..., numsr-1, numsr] ，并返回其长度。如果不存在符合条件的子数组，返回 0 。



示例 1：

输入：target = 7, nums = [2,3,1,2,4,3]
输出：2
解释：子数组 [4,3] 是该条件下的长度最小的子数组。
示例 2：

输入：target = 4, nums = [1,4,4]
输出：1
示例 3：

输入：target = 11, nums = [1,1,1,1,1,1,1,1]
输出：0


提示：

1 <= target <= 109
1 <= nums.length <= 105
1 <= nums[i] <= 105


进阶：

如果你已经实现 O(n) 时间复杂度的解法, 请尝试设计一个 O(n log(n)) 时间复杂度的解法。
```

滑动窗口：减少重叠计算

```js
/**
 * @param {number} target
 * @param {number[]} nums
 * @return {number}
 */
var minSubArrayLen = function (target, nums) {
  let i = 0,
    j = -1;
  let len = nums.length + 1;
  let sum = 0;
  while (i < nums.length) {
    if (j + 1 < nums.length && sum < target) {
      sum += nums[++j];
    } else {
      sum -= nums[i++];
    }
    if (nums[i] >= target || nums[j] >= target) {
      //如果当前值等于目标值就是最小数组
      return 1;
    }
    if (sum >= target) {
      len = Math.min(len, j - i + 1);
    }
  }
  if (len == nums.length + 1) return 0;
  return len;
};
```

## 3. 无重复字符的最长子串++

https://leetcode.cn/problems/longest-substring-without-repeating-characters/description/

```txt
给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串 的长度。



示例 1:

输入: s = "abcabcbb"
输出: 3
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
示例 2:

输入: s = "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
示例 3:

输入: s = "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。


提示：

0 <= s.length <= 5 * 104
s 由英文字母、数字、符号和空格组成
```

```js
/**
 * @param {string} s
 * @return {number}
 */
var lengthOfLongestSubstring = function (s) {
  let letter = {};
  let l = 0,
    r = -1;
  let len = 0;
  while (l < s.length) {
    if (r + 1 < s.length && !letter[s[r + 1]]) {
      letter[s[++r]] = 1;
    } else {
      letter[s[l++]] = 0;
    }
    len = Math.max(r - l + 1, len);
  }
  return len;
};
var lengthOfLongestSubstring = function (s) {
  let letter = {};
  let l = 0,
    r = -1;
  let len = 0;
  while (l < s.length) {
    while (r + 1 < s.length && !letter[s[r + 1]]) {
      letter[s[++r]] = 1;
    }

    len = Math.max(r - l + 1, len);
    letter[s[l++]] = 0;
  }
  return len;
};
//99% 动态规划
var lengthOfLongestSubstring = function (s) {
  let l = 0,
    res = 0;
  const map = new Map();
  for (let i = 0; i < s.length; i++) {
    if (map.has(s[i])) {
      l = Math.max(map.get(s[i]) + 1, l);
    }
    res = Math.max(res, i - l + 1);
    map.set(s[i], i);
  }
  return res;
};
```

## 438. 找到字符串中所有字母异位词

https://leetcode.cn/problems/find-all-anagrams-in-a-string/description/

```txt
给定两个字符串 s 和 p，找到 s 中所有 p 的 异位词 的子串，返回这些子串的起始索引。不考虑答案输出的顺序。

异位词 指由相同字母重排列形成的字符串（包括相同的字符串）。



示例 1:

输入: s = "cbaebabacd", p = "abc"
输出: [0,6]
解释:
起始索引等于 0 的子串是 "cba", 它是 "abc" 的异位词。
起始索引等于 6 的子串是 "bac", 它是 "abc" 的异位词。
 示例 2:

输入: s = "abab", p = "ab"
输出: [0,1,2]
解释:
起始索引等于 0 的子串是 "ab", 它是 "ab" 的异位词。
起始索引等于 1 的子串是 "ba", 它是 "ab" 的异位词。
起始索引等于 2 的子串是 "ab", 它是 "ab" 的异位词。


提示:

1 <= s.length, p.length <= 3 * 104
s 和 p 仅包含小写字母
```

```js
/**
 * @param {string} s
 * @param {string} p
 * @return {number[]}
 */
function getIndex(letter) {
  return new String(letter).charCodeAt() - 'a'.charCodeAt();
}
var findAnagrams = function (s, p) {
  if (s.length < p.length) {
    return [];
  }

  const ans = [];

  const letter = new Array(26).fill(0);
  for (let i = 0; i < p.length; ++i) {
    ++letter[getIndex(s[i])];
    --letter[getIndex(p[i])];
  }
  let sum = 0;
  for (let i = 0; i < 26; i++) {
    if (letter[i] != 0) {
      sum++;
    }
  }

  if (sum === 0) {
    ans.push(0);
  }
  for (let i = 0; i < s.length - p.length; ++i) {
    if (letter[getIndex(s[i])] === 1) {
      sum--;
    } else if (letter[getIndex(s[i])] === 0) {
      sum++;
    }
    letter[getIndex(s[i])]--;
    if (letter[getIndex(s[i + p.length])] === -1) {
      sum--;
    } else if (letter[getIndex(s[i + p.length])] === 0) {
      sum++;
    }
    letter[getIndex(s[i + p.length])]++;
    if (sum == 0) {
      ans.push(i + 1);
    }
  }

  return ans;
};
```

## 76. 最小覆盖子串

https://leetcode.cn/problems/minimum-window-substring/description/?envType=list&envId=bsb9by2

```txt
给你一个字符串 s 、一个字符串 t 。返回 s 中涵盖 t 所有字符的最小子串。如果 s 中不存在涵盖 t 所有字符的子串，则返回空字符串 "" 。



注意：

对于 t 中重复字符，我们寻找的子字符串中该字符数量必须不少于 t 中该字符数量。
如果 s 中存在这样的子串，我们保证它是唯一的答案。


示例 1：

输入：s = "ADOBECODEBANC", t = "ABC"
输出："BANC"
解释：最小覆盖子串 "BANC" 包含来自字符串 t 的 'A'、'B' 和 'C'。
示例 2：

输入：s = "a", t = "a"
输出："a"
解释：整个字符串 s 是最小覆盖子串。
示例 3:

输入: s = "a", t = "aa"
输出: ""
解释: t 中两个字符 'a' 均应包含在 s 的子串中，
因此没有符合条件的子字符串，返回空字符串。


提示：

m == s.length
n == t.length
1 <= m, n <= 105
s 和 t 由英文字母组成


进阶：你能设计一个在 o(m+n) 时间内解决此问题的算法吗？
```

```js
/**
 * @param {string} s
 * @param {string} t
 * @return {string}
 */
function getIdx(a) {
  let code = new String(a).charCodeAt();
  if (code >= 97) {
    //a-z
    return code - 97 + 26;
  } else {
    //A-Z
    return code - 65;
  }
}
var minWindow = function (s, t) {
  let n = s.length,
    tot = 0;
  const c1 = Array(52).fill(0), //记录t的字符
    c2 = Array(52).fill(0);
  for (const x of t) {
    if (++c1[getIdx(x)] === 1) tot++;
  }
  let ans = '';
  for (let i = 0, j = 0; i < n; i++) {
    const idx1 = getIdx(s[i]);
    if (++c2[idx1] == c1[idx1]) tot--;
    while (j < i) {
      const idx2 = getIdx(s[j]);
      if (c2[idx2] > c1[idx2] && --c2[idx2] >= 0) j++;
      else break;
    }
    if (tot == 0 && (!ans || ans.length > i - j + 1)) ans = s.substring(j, i + 1);
  }
  return ans;
};

/**
 * @param {string} s
 * @param {string} t
 * @return {string}
 */
var minWindow = function (s, t) {
  let l = 0,
    r = 0,
    match = 0,
    start = 0,
    minLen = s.length + 1;
  const map = {};
  for (let c of t) {
    map[c] ? map[c]++ : (map[c] = 1);
  }
  const count = Object.keys(map).length;
  while (r < s.length) {
    const c = s[r];
    if (map[c] !== undefined) {
      map[c]--;
    }
    if (map[c] === 0) {
      match++;
    }
    r++;
    while (count === match) {
      if (r - l < minLen) {
        minLen = r - l;
        start = l;
      }
      const c2 = s[l];
      if (map[c2] != undefined) {
        map[c2]++;
      }
      if (map[c2] > 0) {
        match--;
      }
      l++;
    }
  }
  return minLen === s.length + 1 ? '' : s.substr(start, minLen);
};
```

# 查找

1. 是否存在，set
2. 对应关系，键值对，出现几次,map

二分搜索树：O(logn) set ，map
哈希表:hash O(1),失去数据的顺序性

## 349. 两个数组的交集++

https://leetcode.cn/problems/intersection-of-two-arrays/description/

```txt
给定两个数组 nums1 和 nums2 ，返回 它们的交集 。输出结果中的每个元素一定是 唯一 的。我们可以 不考虑输出结果的顺序 。



示例 1：

输入：nums1 = [1,2,2,1], nums2 = [2,2]
输出：[2]
示例 2：

输入：nums1 = [4,9,5], nums2 = [9,4,9,8,4]
输出：[9,4]
解释：[4,9] 也是可通过的


提示：

1 <= nums1.length, nums2.length <= 1000
0 <= nums1[i], nums2[i] <= 1000
```

## 350. 两个数组的交集 II++

https://leetcode.cn/problems/intersection-of-two-arrays-ii/description/

```txt
给你两个整数数组 nums1 和 nums2 ，请你以数组形式返回两数组的交集。返回结果中每个元素出现的次数，应与元素在两个数组中都出现的次数一致（如果出现次数不一致，则考虑取较小值）。可以不考虑输出结果的顺序。



示例 1：

输入：nums1 = [1,2,2,1], nums2 = [2,2]
输出：[2,2]
示例 2:

输入：nums1 = [4,9,5], nums2 = [9,4,9,8,4]
输出：[4,9]


提示：

1 <= nums1.length, nums2.length <= 1000
0 <= nums1[i], nums2[i] <= 1000


进阶：

如果给定的数组已经排好序呢？你将如何优化你的算法？
如果 nums1 的大小比 nums2 小，哪种方法更优？
如果 nums2 的元素存储在磁盘上，内存是有限的，并且你不能一次加载所有的元素到内存中，你该怎么办？
```

```js
/**
 * @param {number[]} nums1
 * @param {number[]} nums2
 * @return {number[]}
 */
var intersect = function (nums1, nums2) {
  const map = {};
  const ans = [];
  for (let a of nums1) {
    map[a] = (map[a] || 0) + 1;
  }
  for (let a of nums2) {
    if (map[a]) {
      ans.push(a);
      map[a]--;
    }
  }

  return ans;
};
//有序时
/**
 * @param {number[]} nums1
 * @param {number[]} nums2
 * @return {number[]}
 */
var intersect = function (nums1, nums2) {
  let index1 = 0,
    index2 = 0;
  let len1 = nums1.length,
    len2 = nums2.length;
  nums1.sort((a, b) => a - b);
  nums2.sort((a, b) => a - b);
  let arr = [];
  while (index1 < len1 && index2 < len2) {
    if (nums1[index1] === nums2[index2]) {
      arr.push(nums1[index1]);
      index1++;
      index2++;
    } else if (nums1[index1] < nums2[index2]) {
      index1++;
    } else {
      index2++;
    }
  }
  return arr;
};
```

## 242

## 202

## 290

## 205

## 451

## 1. 两数之和++

https://leetcode.cn/problems/two-sum/description/

```txt
给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target  的那 两个 整数，并返回它们的数组下标。

你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。

你可以按任意顺序返回答案。



示例 1：

输入：nums = [2,7,11,15], target = 9
输出：[0,1]
解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
示例 2：

输入：nums = [3,2,4], target = 6
输出：[1,2]
示例 3：

输入：nums = [3,3], target = 6
输出：[0,1]


提示：

2 <= nums.length <= 104
-109 <= nums[i] <= 109
-109 <= target <= 109
只会存在一个有效答案


进阶：你可以想出一个时间复杂度小于 O(n2) 的算法吗？
```

```js
/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function (nums, target) {
  let map = new Map();
  for (let i = 0; i < nums.length; i++) {
    if (map.has(target - nums[i])) {
      return [map.get(target - nums[i]), i];
    }
    map.set(nums[i], i);
  }
};
```

## 15

## 18

## 16

## 454. 四数相加 II++

https://leetcode.cn/problems/4sum-ii/

```txt
给你四个整数数组 nums1、nums2、nums3 和 nums4 ，数组长度都是 n ，请你计算有多少个元组 (i, j, k, l) 能满足：

0 <= i, j, k, l < n
nums1[i] + nums2[j] + nums3[k] + nums4[l] == 0


示例 1：

输入：nums1 = [1,2], nums2 = [-2,-1], nums3 = [-1,2], nums4 = [0,2]
输出：2
解释：
两个元组如下：
1. (0, 0, 0, 1) -> nums1[0] + nums2[0] + nums3[0] + nums4[1] = 1 + (-2) + (-1) + 2 = 0
2. (1, 1, 0, 0) -> nums1[1] + nums2[1] + nums3[0] + nums4[0] = 2 + (-1) + (-1) + 0 = 0
示例 2：

输入：nums1 = [0], nums2 = [0], nums3 = [0], nums4 = [0]
输出：1


  提示：

n == nums1.length
n == nums2.length
n == nums3.length
n == nums4.length
1 <= n <= 200
-228 <= nums1[i], nums2[i], nums3[i], nums4[i] <= 228
```

```js
var fourSumCount = function (nums1, nums2, nums3, nums4) {
  const map = new Map();
  for (let a of nums1) {
    for (let b of nums2) {
      let sum = a + b;
      map.set(sum, (map.get(sum) || 0) + 1);
    }
  }
  let ans = 0;
  for (let a of nums3) {
    for (let b of nums4) {
      let k = 0 - a - b;
      if (map.has(k)) {
        ans += map.get(k);
      }
    }
  }
  return ans;
};
```

## 49

## 447. 回旋镖的数量++

https://leetcode.cn/problems/number-of-boomerangs/description/

```txt
给定平面上 n 对 互不相同 的点 points ，其中 points[i] = [xi, yi] 。回旋镖 是由点 (i, j, k) 表示的元组 ，其中 i 和 j 之间的欧式距离和 i 和 k 之间的欧式距离相等（需要考虑元组的顺序）。

返回平面上所有回旋镖的数量。


示例 1：

输入：points = [[0,0],[1,0],[2,0]]
输出：2
解释：两个回旋镖为 [[1,0],[0,0],[2,0]] 和 [[1,0],[2,0],[0,0]]
示例 2：

输入：points = [[1,1],[2,2],[3,3]]
输出：2
示例 3：

输入：points = [[1,1]]
输出：0


提示：

n == points.length
1 <= n <= 500
points[i].length == 2
-104 <= xi, yi <= 104
所有点都 互不相同
```

```js
function distance(a, b) {
  return (a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]);
}
var numberOfBoomerangs = function (points) {
  let ans = 0;
  for (let i = 0; i < points.length; i++) {
    const map = new Map();
    for (let j = 0; j < points.length; j++) {
      if (i != j) {
        let d = distance(points[i], points[j]);
        map.set(d, (map.get(d) || 0) + 1);
      }
    }
    map.forEach((val, key) => {
      if (val >= 2) {
        ans += val * (val - 1);
      }
    });
  }

  return ans;
};
```

## 149. 直线上最多的点数(困难)++

https://leetcode.cn/problems/max-points-on-a-line/description/

```txt
给你一个数组 points ，其中 points[i] = [xi, yi] 表示 X-Y 平面上的一个点。求最多有多少个点在同一条直线上。



示例 1：


输入：points = [[1,1],[2,2],[3,3]]
输出：3
示例 2：


输入：points = [[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]
输出：4


提示：

1 <= points.length <= 300
points[i].length == 2
-104 <= xi, yi <= 104
points 中的所有点 互不相同
```

```js
var maxPoints = function (points) {
  const n = points.length;
  if (n <= 2) {
    return n;
  }
  let ret = 0;
  for (let i = 0; i < n; i++) {
    if (ret >= n - i || ret > n / 2) {
      break;
    }
    const map = new Map();
    for (let j = i + 1; j < n; j++) {
      let x = points[i][0] - points[j][0];
      let y = points[i][1] - points[j][1];
      if (x === 0) {
        y = 1;
      } else if (y === 0) {
        x = 1;
      } else {
        if (y < 0) {
          x = -x;
          y = -y;
        }
        const gcdXY = gcd(Math.abs(x), Math.abs(y));
        x /= gcdXY;
        y /= gcdXY;
      }
      const key = y + x * 20001;
      map.set(key, (map.get(key) || 0) + 1);
    }
    let maxn = 0;
    for (const num of map.values()) {
      maxn = Math.max(maxn, num + 1);
    }
    ret = Math.max(ret, maxn);
  }
  return ret;
};

const gcd = (a, b) => {
  return b != 0 ? gcd(b, a % b) : a;
};
```

## 219. 存在重复元素 II++

https://leetcode.cn/problems/contains-duplicate-ii/description/

```txt
给你一个整数数组 nums 和一个整数 k ，判断数组中是否存在两个 不同的索引 i 和 j ，满足 nums[i] == nums[j] 且 abs(i - j) <= k 。如果存在，返回 true ；否则，返回 false 。



示例 1：

输入：nums = [1,2,3,1], k = 3
输出：true
示例 2：

输入：nums = [1,0,1,1], k = 1
输出：true
示例 3：

输入：nums = [1,2,3,1,2,3], k = 2
输出：false




提示：

1 <= nums.length <= 105
-109 <= nums[i] <= 109
0 <= k <= 105
```

滑动窗口+查找表

```js
var containsNearbyDuplicate = function (nums, k) {
  const map = new Map();
  let min = k + 1;
  for (let i = 0; i < nums.length; i++) {
    if (map.has(nums[i])) {
      min = Math.min(i - map.get(nums[i]), min);
    }
    map.set(nums[i], i);
  }
  return min <= k;
};
```

## 217. 存在重复元素++

https://leetcode.cn/problems/contains-duplicate/description/

```txt
给你一个整数数组 nums 。如果任一值在数组中出现 至少两次 ，返回 true ；如果数组中每个元素互不相同，返回 false 。


示例 1：

输入：nums = [1,2,3,1]
输出：true
示例 2：

输入：nums = [1,2,3,4]
输出：false
示例 3：

输入：nums = [1,1,1,3,3,4,3,2,4,2]
输出：true


提示：

1 <= nums.length <= 105
-109 <= nums[i] <= 109
```

```js
/**
 * @param {number[]} nums
 * @return {boolean}
 */
var containsDuplicate = function (nums) {
  const s = new Set();

  for (let a of nums) {
    if (s.has(a)) {
      return true;
    }
    s.add(a);
  }
  return false;
};
```

## 220. 存在重复元素 III++

https://leetcode.cn/problems/contains-duplicate-iii/description/

```txt
给你一个整数数组 nums 和两个整数 indexDiff 和 valueDiff 。

找出满足下述条件的下标对 (i, j)：

i != j,
abs(i - j) <= indexDiff
abs(nums[i] - nums[j]) <= valueDiff
如果存在，返回 true ；否则，返回 false 。



示例 1：

输入：nums = [1,2,3,1], indexDiff = 3, valueDiff = 0
输出：true
解释：可以找出 (i, j) = (0, 3) 。
满足下述 3 个条件：
i != j --> 0 != 3
abs(i - j) <= indexDiff --> abs(0 - 3) <= 3
abs(nums[i] - nums[j]) <= valueDiff --> abs(1 - 1) <= 0
示例 2：

输入：nums = [1,5,9,1,5,9], indexDiff = 2, valueDiff = 3
输出：false
解释：尝试所有可能的下标对 (i, j) ，均无法满足这 3 个条件，因此返回 false 。


提示：

2 <= nums.length <= 105
-109 <= nums[i] <= 109
1 <= indexDiff <= nums.length
0 <= valueDiff <= 109
```

```js
var containsNearbyAlmostDuplicate = function (nums, k, t) {
  const n = nums.length;
  const mp = new Map();
  for (let i = 0; i < n; ++i) {
    const x = nums[i];
    const id = getID(x, t + 1);
    if (mp.has(id)) {
      return true;
    }
    if (mp.has(id - 1) && Math.abs(x - mp.get(id - 1)) <= t) {
      return true;
    }
    if (mp.has(id + 1) && Math.abs(x - mp.get(id + 1)) <= t) {
      return true;
    }
    mp.set(id, x);
    if (i >= k) {
      mp.delete(getID(nums[i - k], t + 1));
    }
  }
  return false;
};

const getID = (x, w) => {
  return x < 0 ? Math.floor((x + 1) / w) - 1 : Math.floor(x / w);
};
```

# 链表

```js
function ListNode(val, next) {
  this.val = val === undefined ? 0 : val;
  this.next = next === undefined ? null : next;
}
function createLink(arr) {
  let head = new ListNode(0);
  let pre = head;
  let i = 0;
  while (i < arr.length) {
    let cur = new ListNode(arr[i]);
    pre.next = cur;
    pre = cur;
    i++;
  }

  return head.next;
}
function printLink(head) {
  let cur = head;
  let i = 0;
  while (cur) {
    console.log(`${i}=${cur.val}`);
    cur = cur.next;
    i++;
  }
}
```

## 206. 反转链表++

https://leetcode.cn/problems/reverse-linked-list/description/

```txt
给你单链表的头节点 head ，请你反转链表，并返回反转后的链表。


示例 1：


输入：head = [1,2,3,4,5]
输出：[5,4,3,2,1]
示例 2：


输入：head = [1,2]
输出：[2,1]
示例 3：

输入：head = []
输出：[]


提示：

链表中节点的数目范围是 [0, 5000]
-5000 <= Node.val <= 5000


进阶：链表可以选用迭代或递归方式完成反转。你能否用两种方法解决这道题？
```

```js
/**
 * @param {ListNode} head
 * @return {ListNode}
 */
var reverseList = function (head) {
  let pre = null,
    cur = head;
  while (cur) {
    let next = cur.next;
    cur.next = pre;
    pre = cur;
    cur = next;
  }
  return pre;
};
```

## 92

## 83

## 86

## 328

## 2

## 445

## 203. 移除链表元素++

https://leetcode.cn/problems/remove-linked-list-elements/description/

```txt
给你一个链表的头节点 head 和一个整数 val ，请你删除链表中所有满足 Node.val == val 的节点，并返回 新的头节点 。


示例 1：


输入：head = [1,2,6,3,4,5,6], val = 6
输出：[1,2,3,4,5]
示例 2：

输入：head = [], val = 1
输出：[]
示例 3：

输入：head = [7,7,7,7], val = 7
输出：[]


提示：

列表中的节点数目在范围 [0, 104] 内
1 <= Node.val <= 50
0 <= val <= 50
```

虚拟头结点

```js
/**
 * @param {ListNode} head
 * @param {number} val
 * @return {ListNode}
 */
var removeElements = function (head, val) {
  const dummyHead = new ListNode(0);
  dummyHead.next = head;
  let temp = dummyHead;
  while (temp.next !== null) {
    if (temp.next.val == val) {
      temp.next = temp.next.next;
    } else {
      temp = temp.next;
    }
  }
  return dummyHead.next;
};
```

## 82

## 21

## 24. 两两交换链表中的节点++

https://leetcode.cn/problems/swap-nodes-in-pairs/description/

```txt
给你一个链表，两两交换其中相邻的节点，并返回交换后链表的头节点。你必须在不修改节点内部的值的情况下完成本题（即，只能进行节点交换）。



示例 1：


输入：head = [1,2,3,4]
输出：[2,1,4,3]
示例 2：

输入：head = []
输出：[]
示例 3：

输入：head = [1]
输出：[1]


提示：

链表中节点的数目在范围 [0, 100] 内
0 <= Node.val <= 100
```

虚拟节点，相邻节点交换位置，用两个 node 辅助

```js
var swapPairs = function (head) {
  let dummyHead = new ListNode(0);
  dummyHead.next = head;
  let temp = dummyHead;
  while (temp.next && temp.next.next) {
    let node1 = temp.next;
    let node2 = node1.next;
    let next = node2.next;
    node2.next = node1;
    node1.next = next;
    temp.next = node2;

    temp = node1;
  }
  return dummyHead.next;
};
```

## 25

## 147

## 148

## 237. 删除链表中的节点++

https://leetcode.cn/problems/delete-node-in-a-linked-list/description/

```txt
有一个单链表的 head，我们想删除它其中的一个节点 node。

给你一个需要删除的节点 node 。你将 无法访问 第一个节点  head。

链表的所有值都是 唯一的，并且保证给定的节点 node 不是链表中的最后一个节点。

删除给定的节点。注意，删除节点并不是指从内存中删除它。这里的意思是：

给定节点的值不应该存在于链表中。
链表中的节点数应该减少 1。
node 前面的所有值顺序相同。
node 后面的所有值顺序相同。
自定义测试：

对于输入，你应该提供整个链表 head 和要给出的节点 node。node 不应该是链表的最后一个节点，而应该是链表中的一个实际节点。
我们将构建链表，并将节点传递给你的函数。
输出将是调用你函数后的整个链表。


示例 1：


输入：head = [4,5,1,9], node = 5
输出：[4,1,9]
解释：指定链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 4 -> 1 -> 9
示例 2：


输入：head = [4,5,1,9], node = 1
输出：[4,5,9]
解释：指定链表中值为 1 的第三个节点，那么在调用了你的函数之后，该链表应变为 4 -> 5 -> 9


提示：

链表中节点的数目范围是 [2, 1000]
-1000 <= Node.val <= 1000
链表中每个节点的值都是 唯一 的
需要删除的节点 node 是 链表中的节点 ，且 不是末尾节点
```

要删除的节点赋值为下一个节点，然后删除下一个节点

```js
/**
 * @param {ListNode} node
 * @return {void} Do not return anything, modify node in-place instead.
 */
var deleteNode = function (node) {
  if (node === null) return;
  if (node.next === null) {
    //尾结点
    node = null;
    return;
  }
  node.val = node.next.val;
  let delnode = node.next;
  node.next = delnode.next;
};
```

## 19. 删除链表的倒数第 N 个结点++

https://leetcode.cn/problems/remove-nth-node-from-end-of-list/description/

```txt
给你一个链表，删除链表的倒数第 n 个结点，并且返回链表的头结点。



示例 1：


输入：head = [1,2,3,4,5], n = 2
输出：[1,2,3,5]
示例 2：

输入：head = [1], n = 1
输出：[]
示例 3：

输入：head = [1,2], n = 1
输出：[1]


提示：

链表中结点的数目为 sz
1 <= sz <= 30
0 <= Node.val <= 100
1 <= n <= sz


进阶：你能尝试使用一趟扫描实现吗？
```

```js
/**
 * @param {ListNode} head
 * @param {number} n
 * @return {ListNode}
 */
var removeNthFromEnd = function (head, n) {
  const dummyHead = new ListNode(0);
  dummyHead.next = head;
  let temp = dummyHead;
  let temp1 = dummyHead;
  for (let i = 0; i < n; i++) {
    //先走n步
    temp1 = temp1.next;
  }
  while (temp1.next !== null) {
    //两个指针同步前进，temp1当next为空时即为最后一个元素，此时temp所在位置是删除元素的前一个
    temp1 = temp1.next;
    temp = temp.next;
  }

  temp.next = temp.next.next;
  return dummyHead.next;
};
```

## 61

## 143

中间元素获取：temp1 走两步，temp 走一步，然后当 temp1 的元素 next 为空时,temp 在中间的位置

## 234. 回文链表++

https://leetcode.cn/problems/palindrome-linked-list/description/

```txt
给你一个单链表的头节点 head ，请你判断该链表是否为回文链表。如果是，返回 true ；否则，返回 false 。



示例 1：


输入：head = [1,2,2,1]
输出：true
示例 2：


输入：head = [1,2]
输出：false


提示：

链表中节点数目在范围[1, 105] 内
0 <= Node.val <= 9


进阶：你能否用 O(n) 时间复杂度和 O(1) 空间复杂度解决此题？
```

```js
const reverseList = (head) => {
  let prev = null;
  let curr = head;
  while (curr !== null) {
    let nextTemp = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nextTemp;
  }
  return prev;
};

const endOfFirstHalf = (head) => {
  let fast = head;
  let slow = head;
  while (fast.next !== null && fast.next.next !== null) {
    fast = fast.next.next;
    slow = slow.next;
  }
  return slow;
};

var isPalindrome = function (head) {
  if (head == null) return true;

  // 找到前半部分链表的尾节点并反转后半部分链表
  const firstHalfEnd = endOfFirstHalf(head);
  const secondHalfStart = reverseList(firstHalfEnd.next);

  // 判断是否回文
  let p1 = head;
  let p2 = secondHalfStart;
  let result = true;
  while (result && p2 != null) {
    if (p1.val != p2.val) result = false;
    p1 = p1.next;
    p2 = p2.next;
  }

  // 还原链表并返回结果
  firstHalfEnd.next = reverseList(secondHalfStart);
  return result;
};
```

# 栈与队列

## 20. 有效的括号++

https://leetcode.cn/problems/valid-parentheses/description/

```txt
给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。

有效字符串需满足：

左括号必须用相同类型的右括号闭合。
左括号必须以正确的顺序闭合。
每个右括号都有一个对应的相同类型的左括号。


示例 1：

输入：s = "()"
输出：true
示例 2：

输入：s = "()[]{}"
输出：true
示例 3：

输入：s = "(]"
输出：false


提示：

1 <= s.length <= 104
s 仅由括号 '()[]{}' 组成
```

```js
/**
 * @param {string} s
 * @return {boolean}
 */
var isValid = function (s) {
  let stack = [];
  for (let i = 0; i < s.length; i++) {
    if (['{', '[', '('].includes(s[i])) {
      stack.push(s[i]);
    } else {
      let top = stack[stack.length - 1];
      if (top == '{' && '}' == s[i]) {
        stack.pop();
      } else if (top == '[' && ']' == s[i]) {
        stack.pop();
      } else if (top == '(' && ')' == s[i]) {
        stack.pop();
      } else {
        return false;
      }
    }
  }

  return stack.length === 0;
};
```

## 150

## 71

## 144. 二叉树的前序遍历++

https://leetcode.cn/problems/binary-tree-preorder-traversal/description/

```txt
给你二叉树的根节点 root ，返回它节点值的 前序 遍历。



示例 1：


输入：root = [1,null,2,3]
输出：[1,2,3]
示例 2：

输入：root = []
输出：[]
示例 3：

输入：root = [1]
输出：[1]
示例 4：


输入：root = [1,2]
输出：[1,2]
示例 5：


输入：root = [1,null,2]
输出：[1,2]


提示：

树中节点数目在范围 [0, 100] 内
-100 <= Node.val <= 100


进阶：递归算法很简单，你可以通过迭代算法完成吗？
```

根左右

```js
/**
 * Definition for a binary tree node.
 * function TreeNode(val, left, right) {
 *     this.val = (val===undefined ? 0 : val)
 *     this.left = (left===undefined ? null : left)
 *     this.right = (right===undefined ? null : right)
 * }
 */
/**
 * @param {TreeNode} root
 * @return {number[]}
 */
var preorderTraversal = function (root) {
  let list = [];
  if (root) {
    list.push(root.val);
    list = list.concat(preorderTraversal(root.left));
    list = list.concat(preorderTraversal(root.right));
  }
  return list;
};

var preorderTraversal = function (root) {
  let stack = [];
  let list = [];
  if (root) {
    stack.push(root);
  }
  while (stack.length > 0) {
    let cur = stack.pop();
    list.push(cur.val);
    //栈的特性，先进后出，所以左右节点入栈顺序要调转
    if (cur.right) {
      stack.push(cur.right);
    }
    if (cur.left) {
      stack.push(cur.left);
    }
  }
  return list;
};
```

## 94. 二叉树的中序遍历++

https://leetcode.cn/problems/binary-tree-inorder-traversal/description/

```txt
给定一个二叉树的根节点 root ，返回 它的 中序 遍历 。



示例 1：


输入：root = [1,null,2,3]
输出：[1,3,2]
示例 2：

输入：root = []
输出：[]
示例 3：

输入：root = [1]
输出：[1]


提示：

树中节点数目在范围 [0, 100] 内
-100 <= Node.val <= 100


进阶: 递归算法很简单，你可以通过迭代算法完成吗？
```

左根右

```js
var inorderTraversal = function (root) {
  let list = [];
  if (root) {
    list = list.concat(inorderTraversal(root.left));
    list.push(root.val);
    list = list.concat(inorderTraversal(root.right));
  }
  return list;
};

var inorderTraversal = function (root) {
  let stack = [];
  let list = [];
  let visited = [];
  if (root) {
    stack.push(root);
  }
  while (stack.length > 0) {
    let cur = stack.pop();

    //记录访问过的节点，调整出入栈顺序
    if (!visited.includes(cur)) {
      visited.push(cur);
      if (cur.right) {
        stack.push(cur.right);
      }
      stack.push(cur);
      if (cur.left) {
        stack.push(cur.left);
      }
    } else {
      list.push(cur.val);
    }
  }
  return list;
};
```

## 145. 二叉树的后序遍历++

https://leetcode.cn/problems/binary-tree-postorder-traversal/description/

```txt
给你一棵二叉树的根节点 root ，返回其节点值的 后序遍历 。



示例 1：


输入：root = [1,null,2,3]
输出：[3,2,1]
示例 2：

输入：root = []
输出：[]
示例 3：

输入：root = [1]
输出：[1]


提示：

树中节点的数目在范围 [0, 100] 内
-100 <= Node.val <= 100


进阶：递归算法很简单，你可以通过迭代算法完成吗？
```

左右根

```js
var postorderTraversal = function (root) {
  let list = [];
  if (root) {
    list = list.concat(postorderTraversal(root.left));

    list = list.concat(postorderTraversal(root.right));
    list.push(root.val);
  }
  return list;
};

var postorderTraversal = function (root) {
  let stack = [];
  let list = [];
  let visited = [];
  if (root) {
    stack.push(root);
  }
  while (stack.length > 0) {
    let cur = stack.pop();

    //记录访问过的节点，调整出入栈顺序
    if (!visited.includes(cur)) {
      visited.push(cur);
      stack.push(cur);
      if (cur.right) {
        stack.push(cur.right);
      }

      if (cur.left) {
        stack.push(cur.left);
      }
    } else {
      list.push(cur.val);
    }
  }
  return list;
};
```

## 341

## 102. 二叉树的层序遍历++

https://leetcode.cn/problems/binary-tree-level-order-traversal/description/

```txt
给你二叉树的根节点 root ，返回其节点值的 层序遍历 。 （即逐层地，从左到右访问所有节点）。



示例 1：


输入：root = [3,9,20,null,null,15,7]
输出：[[3],[9,20],[15,7]]
示例 2：

输入：root = [1]
输出：[[1]]
示例 3：

输入：root = []
输出：[]


提示：

树中节点数目在范围 [0, 2000] 内
-1000 <= Node.val <= 1000
```

使用队列存储每一层的节点然后再出队

```js
/**
 * @param {TreeNode} root
 * @return {number[][]}
 */
var levelOrder = function (root) {
  let list = [];
  if (!root) return list;
  const q = [root];

  while (q.length > 0) {
    let level = [];
    let size = q.length;
    for (let i = 1; i <= size; i++) {
      const node = q.shift();
      level.push(node.val);
      node.left && q.push(node.left);
      node.right && q.push(node.right);
    }
    list.push(level);
  }
  return list;
};
```

## 107

## 103

## 199

## 279. 完全平方数++

https://leetcode.cn/problems/perfect-squares/description/

```txt
给你一个整数 n ，返回 和为 n 的完全平方数的最少数量 。

完全平方数 是一个整数，其值等于另一个整数的平方；换句话说，其值等于一个整数自乘的积。例如，1、4、9 和 16 都是完全平方数，而 3 和 11 不是。



示例 1：

输入：n = 12
输出：3
解释：12 = 4 + 4 + 4
示例 2：

输入：n = 13
输出：2
解释：13 = 4 + 9

提示：

1 <= n <= 104
```

动态规划

```js
/**
 * @param {number} n
 * @return {number}
 */
var numSquares = function (n) {
  const dp = new Array(n + 1).fill(0); // 数组长度为n+1，值均为0

  for (let i = 1; i <= n; i++) {
    dp[i] = i; // 最坏的情况就是每次+1
    for (let j = 1; i - j * j >= 0; j++) {
      dp[i] = Math.min(dp[i], dp[i - j * j] + 1); // 动态转移方程
    }
  }
  return dp[n];
};
```

队列和图广度优先遍历

```js
var numSquares = function (n) {
  const q = [[n, 0]];
  const visited = new Array(n + 1).fill(false);
  visited[n] = true;
  let min = n + 1;
  while (q.length) {
    let latest = q.shift();
    let num = latest[0];
    let step = latest[1];

    if (num == 0) {
      min = Math.min(min, step);
    }
    //广度优先遍历

    for (let i = 1; ; i++) {
      let a = num - i * i;
      if (a < 0) {
        break;
      }
      if (a == 0) {
        min = Math.min(min, step + 1);
      }
      if (!visited[a]) {
        q.push([a, step + 1]);
        visited[a] = true;
      }
    }
  }
  return min;
};
```

## 127

## 126

## 347. 前 K 个高频元素++

https://leetcode.cn/problems/top-k-frequent-elements/description/

```txt
给你一个整数数组 nums 和一个整数 k ，请你返回其中出现频率前 k 高的元素。你可以按 任意顺序 返回答案。



示例 1:

输入: nums = [1,1,1,2,2,3], k = 2
输出: [1,2]
示例 2:

输入: nums = [1], k = 1
输出: [1]


提示：

1 <= nums.length <= 105
k 的取值范围是 [1, 数组中不相同的元素的个数]
题目数据保证答案唯一，换句话说，数组中前 k 个高频元素的集合是唯一的


进阶：你所设计算法的时间复杂度 必须 优于 O(n log n) ，其中 n 是数组大小。
```

```js
/**
 * @param {number[]} nums
 * @param {number} k
 * @return {number[]}
 */
var topKFrequent = function (nums, k) {
  const map = {};

  for (let i = 0; i < nums.length; i++) {
    map[nums[i]] = (map[nums[i]] || 0) + 1;
  }
  let res = [];
  for (let k in map) {
    res.push([k, map[k]]);
  }
  res.sort((a, b) => b[1] - a[1]);

  return res.slice(0, k).map((a) => Number(a[0]));
};

var topKFrequent = function (nums, k) {
  const map = new Map();
  nums.forEach((n) => {
    map.set(n, map.has(n) ? map.get(n) + 1 : 1);
  });
  // 先将 map 转化为 Array
  const list = Array.from(map).sort((a, b) => b[1] - a[1]);
  // 只取元素值
  return list.slice(0, k).map((n) => n[0]);
};
```

## 23

# 二叉树与递归

## 104. 二叉树的最大深度++

https://leetcode.cn/problems/maximum-depth-of-binary-tree/description/

```txt
给定一个二叉树 root ，返回其最大深度。

二叉树的 最大深度 是指从根节点到最远叶子节点的最长路径上的节点数。

示例 1：
输入：root = [3,9,20,null,null,15,7]
输出：3

示例 2：
输入：root = [1,null,2]
输出：2

提示：

树中节点的数量在 [0, 104] 区间内。
-100 <= Node.val <= 100
```

```js
/**
 * @param {TreeNode} root
 * @return {number}
 */
var maxDepth = function (root) {
  if (!root) return 0;
  return Math.max(maxDepth(root.left), maxDepth(root.right)) + 1;
};
```

## 111

## 226. 翻转二叉树++

https://leetcode.cn/problems/invert-binary-tree/description/

```txt
给你一棵二叉树的根节点 root ，翻转这棵二叉树，并返回其根节点。

示例 1：

输入：root = [4,2,7,1,3,6,9]
输出：[4,7,2,9,6,3,1]

示例 2：
输入：root = [2,1,3]
输出：[2,3,1]

示例 3：
输入：root = []
输出：[]


提示：

树中节点数目范围在 [0, 100] 内
-100 <= Node.val <= 100
```

```js
/**
 * @param {TreeNode} root
 * @return {TreeNode}
 */
var invertTree = function (root) {
  if (!root) {
    return null;
  }
  invertTree(root.left);
  invertTree(root.right);

  let temp = root.left;
  root.left = root.right;
  root.right = temp;

  return root;
};
```

## 100

## 101

## 222

## 101

## 112. 路径总和++

https://leetcode.cn/problems/path-sum/description/

```txt
给你二叉树的根节点 root 和一个表示目标和的整数 targetSum 。判断该树中是否存在 根节点到叶子节点 的路径，这条路径上所有节点值相加等于目标和 targetSum 。如果存在，返回 true ；否则，返回 false 。

叶子节点 是指没有子节点的节点。



示例 1：


输入：root = [5,4,8,11,null,13,4,7,2,null,null,null,1], targetSum = 22
输出：true
解释：等于目标和的根节点到叶节点路径如上图所示。
示例 2：


输入：root = [1,2,3], targetSum = 5
输出：false
解释：树中存在两条根节点到叶子节点的路径：
(1 --> 2): 和为 3
(1 --> 3): 和为 4
不存在 sum = 5 的根节点到叶子节点的路径。
示例 3：

输入：root = [], targetSum = 0
输出：false
解释：由于树是空的，所以不存在根节点到叶子节点的路径。


提示：

树中节点的数目在范围 [0, 5000] 内
-1000 <= Node.val <= 1000
-1000 <= targetSum <= 1000
```

```js
/**
 * @param {TreeNode} root
 * @param {number} targetSum
 * @return {boolean}
 */
var hasPathSum = function (root, targetSum) {
  if (root) {
    if (root.left == null && root.right == null) {
      //叶子节点
      return targetSum == root.val;
    }
    if (hasPathSum(root.left, targetSum - root.val)) return true;
    if (hasPathSum(root.right, targetSum - root.val)) return true;
  }
  return false;
};
```

## 404

## 257. 二叉树的所有路径++

https://leetcode.cn/problems/binary-tree-paths/description/

```txt
给你一个二叉树的根节点 root ，按 任意顺序 ，返回所有从根节点到叶子节点的路径。

叶子节点 是指没有子节点的节点。


示例 1：


输入：root = [1,2,3,null,5]
输出：["1->2->5","1->3"]
示例 2：

输入：root = [1]
输出：["1"]


提示：

树中节点的数目在范围 [1, 100] 内
-100 <= Node.val <= 100
```

```js
/**
 * @param {TreeNode} root
 * @return {string[]}
 */
var binaryTreePaths = function (root) {
  const paths = [];
  const construct_paths = (root, path) => {
    if (root) {
      path += root.val.toString();
      if (root.left === null && root.right === null) {
        // 当前节点是叶子节点
        paths.push(path); // 把路径加入到答案中
      } else {
        path += '->'; // 当前节点不是叶子节点，继续递归遍历
        construct_paths(root.left, path);
        construct_paths(root.right, path);
      }
    }
  };
  construct_paths(root, '');
  return paths;
};
```

## 113

## 129

## 437. 路径总和 III++

https://leetcode.cn/problems/path-sum-iii/description/

```txt
给定一个二叉树的根节点 root ，和一个整数 targetSum ，求该二叉树里节点值之和等于 targetSum 的 路径 的数目。

路径 不需要从根节点开始，也不需要在叶子节点结束，但是路径方向必须是向下的（只能从父节点到子节点）。



示例 1：



输入：root = [10,5,-3,3,2,null,11,3,-2,null,1], targetSum = 8
输出：3
解释：和等于 8 的路径有 3 条，如图所示。
示例 2：

输入：root = [5,4,8,11,null,13,4,7,2,null,null,5,1], targetSum = 22
输出：3


提示:

二叉树的节点个数的范围是 [0,1000]
-109 <= Node.val <= 109
-1000 <= targetSum <= 1000
```

递归嵌套递归

```js
/**
 * @param {TreeNode} root
 * @param {number} targetSum
 * @return {number}
 */
var pathSum = function (root, targetSum) {
  if (root === null) return 0;
  function findPath(root, sum) {
    if (root === null) return 0;
    let res = 0;
    if (sum == root.val) {
      res++;
    }
    res += findPath(root.left, sum - root.val);
    res += findPath(root.right, sum - root.val);
    return res;
  }
  //包含节点的路径
  let res = findPath(root, targetSum);
  //不包含节点的路径
  res += pathSum(root.left, targetSum);
  res += pathSum(root.right, targetSum);
  return res;
};
```

## 235. 二叉搜索树的最近公共祖先++

https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-search-tree/description/

```txt
给定一个二叉搜索树, 找到该树中两个指定节点的最近公共祖先。

百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”

例如，给定如下二叉搜索树:  root = [6,2,8,0,4,7,9,null,null,3,5]

示例 1:

输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
输出: 6
解释: 节点 2 和节点 8 的最近公共祖先是 6。
示例 2:

输入: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
输出: 2
解释: 节点 2 和节点 4 的最近公共祖先是 2, 因为根据定义最近公共祖先节点可以为节点本身。


说明:

所有节点的值都是唯一的。
p、q 为不同节点且均存在于给定的二叉搜索树中。
```

```js
/**
 * @param {TreeNode} root
 * @param {TreeNode} p
 * @param {TreeNode} q
 * @return {TreeNode}
 */
var lowestCommonAncestor = function (root, p, q) {
  if (!root) return null;
  if (p.val > root.val && q.val > root.val) {
    return lowestCommonAncestor(root.right, p, q);
  }
  if (p.val < root.val && q.val < root.val) {
    return lowestCommonAncestor(root.left, p, q);
  }
  return root;
};
```

## 450

## 108

## 230

## 236

# 递归和回溯

## 17. 电话号码的字母组合++

https://leetcode.cn/problems/letter-combinations-of-a-phone-number/description/

```txt
给定一个仅包含数字 2-9 的字符串，返回所有它能表示的字母组合。答案可以按 任意顺序 返回。

给出数字到字母的映射如下（与电话按键相同）。注意 1 不对应任何字母。

示例 1：

输入：digits = "23"
输出：["ad","ae","af","bd","be","bf","cd","ce","cf"]
示例 2：

输入：digits = ""
输出：[]
示例 3：

输入：digits = "2"
输出：["a","b","c"]


提示：

0 <= digits.length <= 4
digits[i] 是范围 ['2', '9'] 的一个数字。
```

回溯法，暴力破解

```js
/**
 * @param {string} digits
 * @return {string[]}
 */
const letter = {
  2: ['a', 'b', 'c'],
  3: ['d', 'e', 'f'],
  4: ['g', 'h', 'i'],
  5: ['j', 'k', 'l'],
  6: ['m', 'n', 'o'],
  7: ['p', 'q', 'r', 's'],
  8: ['t', 'u', 'v'],
  9: ['w', 'x', 'y', 'z']
};
var letterCombinations = function (digits) {
  let res = [];
  function getStr(idx, str) {
    if (idx == digits.length) {
      res.push(str);
      return;
    }
    let c = digits[idx];
    let letters = letter[c];
    if (letters) {
      letters.forEach((a) => {
        getStr(idx + 1, str + a);
      });
    } else {
      res.push(str);
    }
  }
  if (digits) {
    getStr(0, '');
  }
  return res;
};
```

## 93

## 131

## 46. 全排列

https://leetcode.cn/problems/permutations/description/

```txt
给定一个不含重复数字的数组 nums ，返回其 所有可能的全排列 。你可以 按任意顺序 返回答案。

示例 1：

输入：nums = [1,2,3]
输出：[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
示例 2：

输入：nums = [0,1]
输出：[[0,1],[1,0]]
示例 3：

输入：nums = [1]
输出：[[1]]


提示：

1 <= nums.length <= 6
-10 <= nums[i] <= 10
nums 中的所有整数 互不相同
```
