# MongoDB

https://w3schools.org.cn/mongodb/mongodb_mongosh_create_collection.php

# 下载

直接下msi

https://www.mongodb.com/try/download/community

命令行
https://www.mongodb.com/try/download/shell

# 安装选择用户

domain:.
username:当前电脑用户名
password:当前电脑密码

# 配置环境变量

bin路径

# 查看版本

```sh
mongod --version

mongosh --version
```

# 连接到数据库

```sh
mongosh "mongodb+srv://127.0.0.1/testdb" --apiVersion 1 --username root --password 123456

```

# 添加用户和密码

```sh
# 链接到数据库
mongosh
# 添加密码
use admin
db.createUser({
  user: "root",
  pwd: "123456",
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" }
  ]
})


db.createUser({
  user: "root",
  pwd: "123456",
  roles: [
    { role: "userAdminAnyDatabase", db: "test" },
    { role: "readWriteAnyDatabase", db: "test" }
  ]
})
```

`mongod.conf`修改配置文件，开启验证

```ini
security:
  authorization: "enabled"

```

重新启动mongodb

用用户连接到mongodb

```sh
mongosh -u root -p '123456' --authenticationDatabase admin
```

## 给指定数据库添加用户

```sh
use test
db.createUser({
  user: "test01",
  pwd: "test@123456",
  roles: [{ role: "readWrite", db: "test" }]
})
```

获取用户

```sh
db.getUsers()
```

连接到用户

```sh
mongosh -u test01 -p 'test_123456' --authenticationDatabase test
```

修改重置密码

```sh
db.changeUserPassword("test01", "test_123456")
```

修改角色和属性

```sh
db.updateUser("appUser", { roles: [{ role: "read", db: "test" }] })
```

# 无认证启动，忘记密码的情况

```sh
mongod --dbpath D:\softwares\MongoDB\data --bind_ip 127.0.0.1 --port 27017 --noauth
```

# 数据库

```sh
# 创建或使用数据库
use local

# 查看当前数据库
db
# 查看所有数据库
show dbs
```

# 合集

```sh
# 创建合集
db.createCollection("posts")

# 创建合集并插入数据
db.posts.insertOne({name:"hello",value:1})
```

# 插入数据

```sh
# 插入一条
db.posts.insertOne({
  title: "Post Title 1",
  body: "Body of post.",
  category: "News",
  likes: 1,
  tags: ["news", "events"],
  date: Date()
})
# 插入多条
db.posts.insertMany([
  {
    title: "Post Title 2",
    body: "Body of post.",
    category: "Event",
    likes: 2,
    tags: ["news", "events"],
    date: Date()
  },
  {
    title: "Post Title 3",
    body: "Body of post.",
    category: "Technology",
    likes: 3,
    tags: ["news", "events"],
    date: Date()
  },
  {
    title: "Post Title 4",
    body: "Body of post.",
    category: "Event",
    likes: 4,
    tags: ["news", "events"],
    date: Date()
  }
])
```

# 查找

```sh
db.posts.find( {category: "News"} )
# 查询一条，没有返回空
db.posts.findOne( {category: "News"} )

# 仅在结果中显示 title 和 date 字段。
db.posts.find({}, {title: 1, date: 1})
# 排除 _id 字段
db.posts.find({}, {_id: 0, title: 1, date: 1})
```

# 更新

```sh
# 将这篇帖子的“likes”更新为 2
db.posts.updateOne( { title: "Post Title 1" }, { $set: { likes: 2 } } )
# 更新文档，但如果未找到则插入
db.posts.updateOne(
  { title: "Post Title 5" },
  {
    $set:
      {
        title: "Post Title 5",
        body: "Body of post.",
        category: "Event",
        likes: 5,
        tags: ["news", "events"],
        date: Date()
      }
  },
  { upsert: true }
)
# 将所有文档的 likes 更新为 1。为此，我们将使用 $inc (increment) 操作符
db.posts.updateMany({}, { $inc: { likes: 1 } })
```

# 删除

```sh
db.posts.deleteOne({ title: "Post Title 5" })
```

# 创建操作符

### 比较

以下运算符可在查询中使用以比较值

- `$eq`: 值相等
- `$ne`: 值不相等
- `$gt`: 值大于另一个值
- `$gte`: 值大于或等于另一个值
- `$lt`: 值小于另一个值
- `$lte`: 值小于或等于另一个值
- `$in`: 值匹配数组中的一个

### 逻辑

以下运算符可以逻辑地比较多个查询。

- `$and`: 返回两个查询都匹配的文档
- `$or`: 返回任一查询匹配的文档
- `$nor`: 返回两个查询都不匹配的文档
- `$not`: 返回查询不匹配的文档

### 评估

以下运算符有助于评估文档。

- `$regex`: 允许在评估字段值时使用正则表达式
- `$text`: 执行文本搜索
- `$where`: 使用 JavaScript 表达式匹配文档

# 更新操作符

### Fields

以下操作符可用于更新字段：

- `$currentDate`: 将字段值设置为当前日期
- `$inc`: 递增字段值
- `$rename`: 重命名字段
- `$set`: 设置字段的值
- `$unset`: 从文档中删除字段

### 数组

以下操作符有助于更新数组：

- `$addToSet`: 向数组添加不同的元素
- `$pop`: 删除数组的第一个或最后一个元素
- `$pull`: 从数组中删除所有与查询匹配的元素
- `$push`: 向数组添加一个元素

# 聚合

```sh
db.posts.aggregate([
  // Stage 1: Only find documents that have more than 1 like
  {
    $match: { likes: { $gt: 1 } }
  },
  // Stage 2: Group documents by category and sum each categories likes
  {
    $group: { _id: "$category", totalLikes: { $sum: "$likes" } }
  }
])


# 以property_type字段聚合，group by property_type
db.listingsAndReviews.aggregate(
    [ { $group : { _id : "$property_type" } } ]
)
```

# 分页

```sh
db.movies.aggregate([ { $limit: 1 } ])
```

# $project包含某字段

使用 1 来包含一个字段，使用 0 来排除一个字段
\_id 字段也包含在内。除非明确排除，否则此字段总是被包含

```sh
db.restaurants.aggregate([
  {
    $project: {
      "name": 1,
      "cuisine": 1,
      "address": 1
    }
  },
  {
    $limit: 5
  }
])
```

# 排序

1 表示升序，-1 表示降序

```sh
db.listingsAndReviews.aggregate([
  {
    $sort: { "accommodates": -1 }
  },
  {
    $project: {
      "name": 1,
      "accommodates": 1
    }
  },
  {
    $limit: 5
  }
])
```

# $match过滤条件

仅返回 property_type 为“House”

```sh
db.listingsAndReviews.aggregate([
  { $match : { property_type : "House" } },
  { $limit: 2 },
  { $project: {
    "name": 1,
    "bedrooms": 1,
    "price": 1
  }}
])
```

# $addFields 给聚合添加字段

将返回包含新字段 avgGrade 的文档，该字段将包含每个餐厅 grades.score 的平均值

```sh
db.restaurants.aggregate([
  {
    $addFields: {
      avgGrade: { $avg: "$grades.score" }
    }
  },
  {
    $project: {
      "name": 1,
      "avgGrade": 1
    }
  },
  {
    $limit: 5
  }
])
```

# $count计算总数

```sh
db.restaurants.aggregate([
  {
    $match: { "cuisine": "Chinese" }
  },
  {
    $count: "totalChinese"
  }
])
```

# 外键连接

from：用于在同一数据库中进行查找的集合
localField：主集合中可用作 from 集合中唯一标识符的字段。
foreignField：from 集合中可用作主集合中唯一标识符的字段。
as：将包含来自 from 集合的匹配文档的新字段的名称。

这将返回电影数据以及每条评论。

```sh
db.comments.aggregate([
  {
    $lookup: {
      from: "movies",
      localField: "movie_id",
      foreignField: "_id",
      as: "movie_details",
    },
  },
  {
    $limit: 1
  }
])
```

# 多表查询

在 MongoDB（NoSQL）里没有传统关系型数据库的“表”，而是“集合（collections）”。要做“多表查询”（等价于 SQL 的 join），常用方法是使用聚合管道里的 $lookup（以及其它聚合算子）。下面总结常用方式、示例和注意事项，帮助你根据场景选择实现方式。

一、常用方法概览

- $lookup（Aggregation Framework）：在聚合管道里做左外连接（支持两种形式：简单字段匹配和基于 pipeline 的复杂匹配）。
- $graphLookup：用于递归/层级关系查询（例如树形/分类的上下级关系）。
- $unionWith：把多个集合的结果合并（类似 SQL 的 UNION）。
- 客户端关联（Application-side join）：先分别查询集合，在应用里合并（适用于小数据量或复杂逻辑）。
- 反规范化（denormalization）：把常用关联数据嵌入到文档中以避免频繁 join（常见于高读场景）。
- map-reduce（已较少使用，通常用聚合替代）。

二、$lookup 基本用法（mongosh）
假设有两个集合：orders（含 customerId 字段），customers（以 \_id 标识）：

```js
db.orders.aggregate([
  {
    $lookup: {
      from: 'customers', // 要连接的集合
      localField: 'customerId', // orders 中的字段
      foreignField: '_id', // customers 中的字段
      as: 'customer' // 输出数组字段名
    }
  },
  // 如果想把 customer 数组展开为单个对象（且保留没有关联的 orders）
  {$unwind: {path: '$customer', preserveNullAndEmptyArrays: true}}
  // 可继续 $match / $project / $sort 等
]);
```

三、$lookup 的 pipeline 形式（更灵活，可用 $expr）
当关联条件更复杂或需要在 from 集合上做更多筛选/投影时，使用 pipeline 形式：

```js
db.orders.aggregate([
  {
    $lookup: {
      from: 'items',
      let: {orderId: '$_id', status: '$status'},
      pipeline: [
        {
          $match: {
            $expr: {$and: [{$eq: ['$orderId', '$$orderId']}, {$eq: ['$status', '$$status']}]}
          }
        },
        {$project: {name: 1, price: 1, _id: 0}}
      ],
      as: 'items'
    }
  }
]);
```

四、多个 $lookup（多个关联）
可以在同一聚合管道中连续使用多个 $lookup：

```js
db.orders.aggregate([
  {$lookup: {from: 'customers', localField: 'customerId', foreignField: '_id', as: 'customer'}},
  {$unwind: {path: '$customer', preserveNullAndEmptyArrays: true}},
  {$lookup: {from: 'shipments', localField: '_id', foreignField: 'orderId', as: 'shipments'}}
]);
```

五、$graphLookup（递归查询）
用于查找树形或图结构的所有子/父节点：

```js
db.categories.aggregate([
  {$match: {_id: ObjectId('...')}},
  {
    $graphLookup: {
      from: 'categories',
      startWith: '$_id',
      connectFromField: '_id',
      connectToField: 'parentId',
      as: 'descendants',
      maxDepth: 5, // 可选
      depthField: 'level' // 可选
    }
  }
]);
```

六、$unionWith（合并多个集合结果）
将多个集合的查询结果拼接起来：

```js
db.collectionA.aggregate([
  {$match: {active: true}},
  {$unionWith: {coll: 'collectionB', pipeline: [{$match: {active: true}}]}},
  {$sort: {createdAt: -1}}
]);
```

七：在驱动里的用法示例（Node.js / Python）
Node.js (mongodb 官方驱动)：

```js
const result = await db
  .collection('orders')
  .aggregate([
    {$match: {status: 'paid'}},
    {$lookup: {from: 'customers', localField: 'customerId', foreignField: '_id', as: 'customer'}},
    {$unwind: {path: '$customer', preserveNullAndEmptyArrays: true}}
  ])
  .toArray();
```

Python (pymongo):

```py
pipeline = [
    {"$match": {"status": "paid"}},
    {"$lookup": {
        "from": "customers",
        "localField": "customerId",
        "foreignField": "_id",
        "as": "customer"
    }},
    {"$unwind": {"path": "$customer", "preserveNullAndEmptyArrays": True}}
]
results = list(db.orders.aggregate(pipeline))
```

八、性能与注意事项

- $lookup 在 from 集合很大且没有合适索引时可能很慢。确保在 foreignField 上有索引（尤其是在大量数据关联时）。
- 尽量在管道前端用 $match / $project 削减文档数量与大小（提前过滤和只保留必要字段）。
- $lookup 本质上是左外连接（未匹配的仍保留，字段为空数组），可以用 $unwind preserveNullAndEmptyArrays 控制行为。
- $graphLookup 有递归开销，注意 depth 与集合大小。
- 对于高并发/大数据量场景，考虑反规范化以减少实时 join。
- $lookup 仅在同一 database 的集合之间；跨数据库需要特别处理（某些版本/部署可能受限）。
- 使用 explain() 检查聚合性能瓶颈。

# 聚合写入集合

第一个阶段将按 property_type 对房产进行分组，并为每个房产包含 name、accommodates 和 price 字段。
$out 阶段将在当前数据库中创建一个名为 properties_by_type 的新集合，并将结果文档写入该集合。

```sh
db.listingsAndReviews.aggregate([
  {
    $group: {
      _id: "$property_type",
      properties: {
        $push: {
          name: "$name",
          accommodates: "$accommodates",
          price: "$price",
        },
      },
    },
  },
  { $out: "properties_by_type" },
])
```

# 索引和搜索

第一阶段将返回 movies 集合中，在 title 字段包含 "star" 或 "wars" 字样的所有文档。

第二阶段将从每个文档中提取 title 和 year 字段。

```sh
db.movies.aggregate([
  {
    $search: {
      index: "default", // optional unless you named your index something other than "default"
      text: {
        query: "star wars",
        path: "title"
      },
    },
  },
  {
    $project: {
      title: 1,
      year: 1,
    }
  }
])
```

# 模式验证

创建当前数据库中的 posts 集合，并为该集合指定 JSON Schema 验证要求。

```sh
db.createCollection("posts", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [ "title", "body" ],
      properties: {
        title: {
          bsonType: "string",
          description: "Title of post - Required."
        },
        body: {
          bsonType: "string",
          description: "Body of post - Required."
        },
        category: {
          bsonType: "string",
          description: "Category of post - Optional."
        },
        likes: {
          bsonType: "int",
          description: "Post like count. Must be an integer - Optional."
        },
        tags: {
          bsonType: ["string"],
          description: "Must be an array of strings - Optional."
        },
        date: {
          bsonType: "date",
          description: "Must be a date - Optional."
        }
      }
    }
  }
})
```

# node.js 连接MongoDB

https://www.runoob.com/nodejs/nodejs-mongodb.html

https://www.npmjs.com/package/mongodb

https://www.mongodb.com/zh-cn/docs/drivers/node/current/databases-collections/

# Group

https://www.mongodb.com/zh-cn/docs/manual/reference/operator/aggregation/group/#std-label-group-pipeline-optimization
