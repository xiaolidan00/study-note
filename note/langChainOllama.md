## install

```sh
pnpm add @langchain/core @langchain/ollama langchain @langchain/textsplitters
```

## 用 LangChain 构建语义搜索引擎

```js
import {Document} from '@langchain/core/documents';
import {RecursiveCharacterTextSplitter} from '@langchain/textsplitters';

const documents = [
  new Document({
    pageContent: 'Dogs are great companions, known for their loyalty and friendliness.',
    metadata: {source: 'mammal-pets-doc'}
  }),
  new Document({
    pageContent: 'Cats are independent pets that often enjoy their own space.',
    metadata: {source: 'mammal-pets-doc'}
  })
];
//分词
const textSplitter = new RecursiveCharacterTextSplitter({
  chunkSize: 1000,
  chunkOverlap: 200
});

const allSplits = await textSplitter.splitDocuments(documents);
//分词数量
console.log(allSplits.length);
```
