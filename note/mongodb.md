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
mongosh "mongodb+srv://127.0.0.1/testdb" --apiVersion 1 --username root

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
