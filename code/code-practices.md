# 442. 数组中重复的数据

<https://leetcode.cn/problems/find-all-duplicates-in-an-array/description/>

给你一个长度为 n 的整数数组 nums ，其中 **nums 的所有整数都在范围 [1, n] 内**，且每个整数出现 一次 或 两次 。请你找出所有出现 两次 的整数，并以数组形式返回。

你必须设计并实现一个时间复杂度为 O(n) 且仅使用常量额外空间的算法解决此问题。

```txt

示例 1：

输入：nums = [4,3,2,7,8,2,3,1]
输出：[2,3]
示例 2：

输入：nums = [1,1,2]
输出：[1]
示例 3：

输入：nums = [1]
输出：[]
 

提示：

n == nums.length
1 <= n <= 105
1 <= nums[i] <= n
nums 中的每个元素出现 一次 或 两次
```

```js
var findDuplicates = function (nums) {
  const ans = [];
  for (let i = 0; i < nums.length; i++) {
    const t = nums[i];
    //console.log(i + '|' + t + '-->' + nums.join(','));
    if (t < 0 || t - 1 == i) continue;
    //当nums[i]−1!=i时 nums[nums[i]−1]=nums[i]，则说明该数字出现了超过一次，加入答案
    if (nums[t - 1] === t) {
      ans.push(t);
      //变成负数，避免重复比较
      nums[i] *= -1;
    } else {
      //将当前处理到的 nums[i] 放到目标位置 nums[i]−1 处
      let c = nums[t - 1];
      nums[t - 1] = t;
      nums[i--] = c;
    }
  }
  //console.log('last' + nums.join(','));
  return ans;
};
```

# 146. LRU 缓存

<https://leetcode.cn/problems/lru-cache/description/>

请你设计并实现一个满足  LRU (最近最少使用) 缓存 约束的数据结构。
实现 LRUCache 类：
LRUCache(int capacity) 以 正整数 作为容量 capacity 初始化 LRU 缓存
int get(int key) 如果关键字 key 存在于缓存中，则返回关键字的值，否则返回 -1 。
void put(int key, int value) 如果关键字 key 已经存在，则变更其数据值 value ；如果不存在，则向缓存中插入该组 key-value 。如果插入操作导致关键字数量超过 capacity ，则应该 逐出 最久未使用的关键字。
函数 get 和 put 必须以 O(1) 的平均时间复杂度运行。

```txt
示例：

输入
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
输出
[null, null, null, 1, null, -1, null, -1, 3, 4]

解释
LRUCache lRUCache = new LRUCache(2);
lRUCache.put(1, 1); // 缓存是 {1=1}
lRUCache.put(2, 2); // 缓存是 {1=1, 2=2}
lRUCache.get(1);    // 返回 1
lRUCache.put(3, 3); // 该操作会使得关键字 2 作废，缓存是 {1=1, 3=3}
lRUCache.get(2);    // 返回 -1 (未找到)
lRUCache.put(4, 4); // 该操作会使得关键字 1 作废，缓存是 {4=4, 3=3}
lRUCache.get(1);    // 返回 -1 (未找到)
lRUCache.get(3);    // 返回 3
lRUCache.get(4);    // 返回 4
 

提示：

1 <= capacity <= 3000
0 <= key <= 10000
0 <= value <= 105
最多调用 2 * 105 次 get 和 put
```

```js
var LRUCache = function(capacity) {
    this.capacity = capacity;
    this.map = new Map();
};

/** 
 * @param {number} key
 * @return {number}
 */
LRUCache.prototype.get = function(key) {
    if(this.map.has(key)){
        let temp=this.map.get(key)
         this.map.delete(key);
         //有key 缓存value 删掉key 再set一遍,该key会置底
         this.map.set(key, temp);
         return temp
    }else{
        return -1
    }
};

/** 
 * @param {number} key 
 * @param {number} value
 * @return {void}
 */
LRUCache.prototype.put = function(key, value) {
    if(this.map.has(key)){
        this.map.delete(key);
    }
    this.map.set(key,value);
    if(this.map.size > this.capacity){
        //put 有key 删掉 重新set 超出内存 删掉第一个key
        this.map.delete(this.map.keys().next().value);
    }
};
 
```

双链表

```js
/**
 * @param {number} capacity
 */

class ListNode {
    constructor(key = null, val = null) {
        this.key = key;
        this.val = val;
        this.prev = null;
        this.next = null;
    }
}

var LRUCache = function(capacity) {
    this.cache = new Map();
    this.capacity = capacity;
    this.tail = null;
    this.head = new ListNode();
    this.tail = new ListNode();
    this.head.next = this.tail;
    this.tail.prev = this.head;
};

/** 
 * @param {number} key
 * @return {number}
 */
LRUCache.prototype.get = function(key) {
    if(this.cache.has(key)){
        let node = this.cache.get(key);
        this.move(node);
        return node.val; 
    }
    return -1;
};


LRUCache.prototype._remove = function(node) {
        let temp1 = node.prev;
        let temp2 = node.next;
        temp1.next = temp2;
        temp2.prev = temp1;
};

LRUCache.prototype._add = function(node) {
    node.next = this.head.next;
    node.prev = this.head;
    this.head.next.prev = node;
    this.head.next = node;
};

LRUCache.prototype.move = function(node) {
        this._remove(node);
        this._add(node);
};

/** 
 * @param {number} key 
 * @param {number} value
 * @return {void}
 */
LRUCache.prototype.put = function(key, value) {
    if (this.cache.has(key)) {
        let node = this.cache.get(key);
        node.val = value;
        this.move(node);
    } else {
        if (this.cache.size >= this.capacity) {
            let node = this.tail.prev;
            this._remove(node);
            this.cache.delete(node.key);
        }
        let newNode = new ListNode(key, value);
        this.cache.set(key, newNode);
        this._add(newNode);
    }
}; 
 
```
