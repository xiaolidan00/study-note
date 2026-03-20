# Token 经济学：AI 应用的成本控制与计费优化实战
https://mp.weixin.qq.com/s/QkrmJnMdhWXU57Q1bu9a3g

上一篇我们聊了AI 应用的前端性能优化，里面提到了流式渲染、Token 节约和缓存策略。当时更多是从「快」的角度出发，今天我们换个视角——**从「省」的角度**，系统地聊聊 AI 应用的成本控制。

用过 OpenAI、Claude API 的同学应该都有这个体会：**原型做起来很爽，账单看起来很慌。**

一个 AI 对话功能，开发阶段一天花 $2，上线后用户一多，分分钟变成一天 $200。更要命的是，你甚至不知道钱花在了哪里——是 System Prompt 太长？是用户疯狂追问？还是某个接口在无效调用？

这篇文章就来彻底搞清楚：**Token 到底怎么计费、钱都花在哪了、怎么优化才能省得多又不影响效果。**

![Token 经济学全景图](https://mmbiz.qpic.cn/mmbiz_jpg/QCpJyyjNHodw6te9jeGqWgVvPqN6S0JfZNN3K0lMAcz0TTFICRSkYa4qic43GxkicHHIW0KUVg3sICqia5DXxzvTu8O8ibQfOeYL4LbvLicgmaGs/640?from=appmsg&tp=webp&wxfrom=5&wx_lazy=1#imgIndex=0)

------

## 一、Token 到底是什么？

很多人以为 1 个字 = 1 个 Token，这个理解**大错特错**。

### ▎1.1 Tokenization 基础

Token 是大语言模型处理文本的最小单位。模型不直接理解文字，而是先把文字切分成 Token，再把 Token 转换成数字向量进行计算。

不同语言的 Token 效率差别很大：

英文：
"Hello, world!" → ["Hello", ",", " world", "!"] → 4 tokens

中文：
"你好世界" → ["你好", "世界"] → 2 tokens (GPT-4o)
"你好世界" → ["你", "好", "世", "界"] → 4 tokens (早期模型)

**关键认知：**

| 语言 | 大约比例             | 说明                    |
| :--- | :------------------- | :---------------------- |
| 英文 | 1 token ≈ 4 个字符   | 大约 3/4 个单词         |
| 中文 | 1 token ≈ 1-2 个汉字 | GPT-4o 对中文优化了很多 |
| 代码 | 差异很大             | 变量名、符号各算 token  |

### ▎1.2 实际看看 Token 怎么切

OpenAI 提供了一个在线工具 Tokenizer，你可以把自己的 Prompt 贴进去看看实际消耗。

不过在代码里，我们通常用 `tiktoken` 来精确计算：

typescript

// 安装：npm install tiktoken
import { encoding_for_model } from 'tiktoken';

function countTokens(text: string, model: string = 'gpt-4o'): number {
 const enc = encoding_for_model(model as any);
 const tokens = enc.encode(text);
 enc.free();
 return tokens.length;
}

// 实测对比
console.log(countTokens('Hello, world!'));    // 4 tokens
console.log(countTokens('你好，世界！'));      // 约 4-6 tokens
console.log(countTokens('const x = 42;'));    // 5 tokens

// 一段典型的 System Prompt
const systemPrompt = `你是一个前端技术助手，擅长 React、Vue、TypeScript。
请用简洁的中文回答问题，必要时给出代码示例。
不要回答与前端技术无关的问题。`;
console.log(countTokens(systemPrompt));      // 约 60-80 tokens

### ▎1.3 为什么你要关心 Token 数量？

因为 **Token 直接等于钱**。API 的计费方式就是：

总费用 = 输入 Token 数 × 输入单价 + 输出 Token 数 × 输出单价

而且输出通常比输入贵 3-5 倍。所以：

- ▸**System Prompt 越长** → 每次请求的固定成本越高
- ▸**用户输入 + 历史上下文越长** → 输入成本越高
- ▸**模型回复越啰嗦** → 输出成本越高

------

## 二、主流模型计费模式与价格对比

![主流模型价格对比](https://mmbiz.qpic.cn/sz_mmbiz_jpg/QCpJyyjNHofPcELBjoUBmfnYy6u3OwTzvHKBk54GYMpm44eNibNvuWg80loSsgIxfR6e4R7XNiaVH7FPK8gjxjj3fffvDasCuPzK2PibGDT8iao/640?from=appmsg&tp=webp&wxfrom=5&wx_lazy=1#imgIndex=1)

### ▎2.1 价格速查表（2025 年中）

| 模型              | 输入 ($/1M tokens) | 输出 ($/1M tokens) | 上下文窗口 | 适合场景         |
| :---------------- | :----------------- | :----------------- | :--------- | :--------------- |
| GPT-4o            | $2.50              | $10.00             | 128K       | 复杂推理、多模态 |
| GPT-4o-mini       | $0.15              | $0.60              | 128K       | 日常对话、分类   |
| o1-mini           | $1.10              | $4.40              | 128K       | 数学/代码推理    |
| Claude 3.5 Sonnet | $3.00              | $15.00             | 200K       | 代码生成、长文档 |
| Claude 3.5 Haiku  | $0.80              | $4.00              | 200K       | 快速任务         |
| DeepSeek V3       | $0.27              | $1.10              | 64K        | 国产性价比之选   |
| Llama 3.1 70B     | 自部署成本         | 自部署成本         | 128K       | 数据隐私要求高   |

> ⚠️ 价格经常调整，以官网为准。重点看**比例关系**——4o-mini 的输入成本只有 4o 的 **6%**！

### ▎2.2 一笔账算清楚

假设你的 AI 应用日活 1000 人，每人每天 10 次对话，每次对话平均消耗：

- ▸输入：2000 tokens（System Prompt + 用户消息 + 历史）
- ▸输出：500 tokens（模型回复）

**用 GPT-4o：**

日成本 = 1000 × 10 × (2000/1M × $2.50 + 500/1M × $10.00)
    = 10000 × ($0.005 + $0.005)
    = $100/天 ≈ $3,000/月

**用 GPT-4o-mini：**

日成本 = 10000 × (2000/1M × $0.15 + 500/1M × $0.60)
    = 10000 × ($0.0003 + $0.0003)
    = $6/天 ≈ $180/月

**差距 16 倍！** 而对于大多数日常对话场景，4o-mini 的效果完全够用。

### ▎2.3 容易被忽略的隐藏成本

除了直接的 Token 费用，还有几个隐藏的成本大头：

typescript

// 1. Reasoning Tokens（思考 token）
// o1/o3 模型会产生大量的推理 token，这些也算输出计费
const result = await openai.chat.completions.create({
 model: 'o1-mini',
 messages: [{ role: 'user', content: '证明根号2是无理数' }],
});
// usage.completion_tokens 可能包含大量 reasoning tokens

// 2. Tool Calling 的额外消耗
// 每定义一个 tool，schema 都会消耗输入 token
// 10 个 tool 大约额外消耗 2000-3000 tokens
const tools = [
 { type: 'function', function: { name: 'search', parameters: { /* ... */ } } },
 { type: 'function', function: { name: 'calculate', parameters: { /* ... */ } } },
 // 每多一个 tool，输入成本就多一截
];

// 3. 多轮对话的上下文膨胀
// 第 1 轮：输入 1000 tokens
// 第 5 轮：输入 5000 tokens（累积了所有历史）
// 第 10 轮：输入 10000 tokens（还在膨胀...）

------

## 三、成本优化四板斧

了解了成本结构，下面上干货——**四个立竿见影的优化策略**。

![成本优化四板斧](https://mmbiz.qpic.cn/mmbiz_jpg/QCpJyyjNHodD5GDVU4rblgfLgqHWUGsK9n7Bmfibm6zOgAkc9bbE5KGa6XJaMvic7JiaXwmEy6LOlyGWfc6UVFQriaE9JRLXolcgOdKNNDmicBcg/640?from=appmsg&tp=webp&wxfrom=5&wx_lazy=1#imgIndex=2)

### ▎3.1 第一斧：Prompt 压缩

System Prompt 是每次请求都要发送的固定成本。很多人写 Prompt 像写作文，啰嗦得不行：

typescript

// ❌ 臃肿的 System Prompt（约 500 tokens）
const bloatedPrompt = `
你是一个非常专业的前端技术助手。你的名字叫小助手。
你擅长 React、Vue、Angular、Svelte 等前端框架。
你也精通 TypeScript、JavaScript、HTML、CSS。
你在回答问题的时候，需要保持专业且友好的态度。
如果用户问了与前端技术无关的问题，你需要礼貌地拒绝。
你回答的时候请尽量给出代码示例，代码示例要用 TypeScript。
你不需要解释太基础的概念，假设用户有一定的前端基础。
如果你不确定答案，请诚实地说你不知道，而不是编造答案。
...（还有更多）
`;

// ✅ 精简后的 System Prompt（约 80 tokens）
const leanPrompt = `前端技术助手。用简洁中文回答，附 TypeScript 代码示例。拒绝非前端问题。假设用户有基础，不解释基本概念。不确定时说明。`;

效果几乎一样，但 Token 消耗减少了 80%+。

**动态上下文裁剪——只发送相关的历史：**

typescript

interface Message {
 role: 'system' | 'user' | 'assistant';
 content: string;
 tokens?: number;
}

function trimConversation(
 messages: Message[],
 maxTokens: number = 4000
): Message[] {
 const system = messages.filter(m => m.role === 'system');
 const conversation = messages.filter(m => m.role !== 'system');

 let totalTokens = system.reduce((sum, m) => sum + (m.tokens || 0), 0);
 const trimmed: Message[] = [];

 // 从最新的消息开始保留，直到达到上限
 for (let i = conversation.length - 1; i >= 0; i--) {
  const msgTokens = conversation[i].tokens || estimateTokens(conversation[i].content);
  if (totalTokens + msgTokens > maxTokens) break;
  totalTokens += msgTokens;
  trimmed.unshift(conversation[i]);
 }

 return [...system, ...trimmed];
}

function estimateTokens(text: string): number {
 // 粗略估算：中文约 1 token/字，英文约 1 token/4字符
 return Math.ceil(text.length * 0.6);
}

**长文档用摘要替代全文：**

typescript

async function summarizeForContext(
 longDocument: string,
 question: string
): Promise<string> {
 // 先用便宜的模型提取相关摘要
 const summary = await openai.chat.completions.create({
  model: 'gpt-4o-mini',
  messages: [
   {
    role: 'system',
    content: '提取与用户问题相关的关键信息，输出不超过 500 字的摘要。'
   },
   {
    role: 'user',
    content: `文档：${longDocument.slice(0, 8000)}\n\n问题：${question}`
   }
  ],
  max_tokens: 300,
 });

 return summary.choices[0].message.content || '';
}

### ▎3.2 第二斧：模型路由

不是每个请求都需要 GPT-4o。**根据任务复杂度自动选择模型**，是最有效的省钱手段：

typescript

type ModelTier = 'premium' | 'standard' | 'budget';

interface RouterConfig {
 premium: string;  // 复杂任务
 standard: string; // 普通任务
 budget: string;  // 简单任务
}

const defaultConfig: RouterConfig = {
 premium: 'gpt-4o',
 standard: 'gpt-4o-mini',
 budget: 'gpt-4o-mini',
};

class ModelRouter {
 constructor(private config: RouterConfig = defaultConfig) {}

 route(task: string, context?: string): { model: string; tier: ModelTier } {
  // 策略 1：基于任务类型的规则路由
  if (this.isSimpleTask(task)) {
   return { model: this.config.budget, tier: 'budget' };
  }
  if (this.isComplexTask(task)) {
   return { model: this.config.premium, tier: 'premium' };
  }
  return { model: this.config.standard, tier: 'standard' };
 }

 private isSimpleTask(task: string): boolean {
  const simplePatterns = [
   /翻译|translate/i,
   /分类|classify|categorize/i,
   /提取|extract/i,
   /格式化|format/i,
   /纠错|fix\s?(typo|grammar)/i,
  ];
  return simplePatterns.some(p => p.test(task));
 }

 private isComplexTask(task: string): boolean {
  const complexPatterns = [
   /分析.*架构|architecture/i,
   /重构|refactor/i,
   /设计.*方案|design.*solution/i,
   /debug.*complex|排查.*问题/i,
   /code\s?review/i,
  ];
  return complexPatterns.some(p => p.test(task));
 }
}

// 使用示例
const router = new ModelRouter();

router.route('翻译这段话成英文');
// → { model: 'gpt-4o-mini', tier: 'budget' }

router.route('帮我分析这个微服务架构的性能瓶颈');
// → { model: 'gpt-4o', tier: 'premium' }

**进阶：基于 LLM 的智能路由**

对于更复杂的场景，可以用一个小模型来判断该用哪个大模型：

typescript

async function smartRoute(userMessage: string): Promise<string> {
 const routerResponse = await openai.chat.completions.create({
  model: 'gpt-4o-mini',
  messages: [
   {
    role: 'system',
    content: `判断以下用户请求的复杂度。
返回 JSON: {"complexity": "low" | "medium" | "high", "reason": "简短原因"}
low: 简单翻译、分类、格式化
medium: 普通问答、代码补全、文案生成
high: 复杂推理、架构设计、多步骤分析`
   },
   { role: 'user', content: userMessage }
  ],
  response_format: { type: 'json_object' },
  max_tokens: 100,
 });

 const { complexity } = JSON.parse(routerResponse.choices[0].message.content || '{}');

 const modelMap: Record<string, string> = {
  low: 'gpt-4o-mini',
  medium: 'gpt-4o-mini',
  high: 'gpt-4o',
 };

 return modelMap[complexity] || 'gpt-4o-mini';
}

路由本身的成本非常低（约 100 tokens × $0.15/1M = 几乎免费），但能帮你省下 60%+ 的整体成本。

### ▎3.3 第三斧：缓存策略

同样的问题，用户问了 100 次，你就调了 100 次 API？加个缓存吧。

#### 精确缓存

最简单直接——**相同的输入，直接返回缓存的输出：**

typescript

import { createHash } from 'crypto';

class ResponseCache {
 private cache = new Map<string, { response: string; timestamp: number }>();
 private ttl: number;

 constructor(ttlMinutes: number = 60) {
  this.ttl = ttlMinutes * 60 * 1000;
 }

 private makeKey(messages: Array<{ role: string; content: string }>): string {
  const normalized = messages.map(m => `${m.role}:${m.content.trim().toLowerCase()}`).join('|');
  return createHash('sha256').update(normalized).digest('hex');
 }

 get(messages: Array<{ role: string; content: string }>): string | null {
  const key = this.makeKey(messages);
  const entry = this.cache.get(key);
  if (!entry) return null;
  if (Date.now() - entry.timestamp > this.ttl) {
   this.cache.delete(key);
   return null;
  }
  return entry.response;
 }

 set(messages: Array<{ role: string; content: string }>, response: string): void {
  const key = this.makeKey(messages);
  this.cache.set(key, { response, timestamp: Date.now() });
 }
}

// 包装 API 调用
const cache = new ResponseCache(30); // 30 分钟过期

async function cachedCompletion(messages: Array<{ role: string; content: string }>) {
 const cached = cache.get(messages);
 if (cached) {
  console.log('Cache HIT - saved $$$');
  return cached;
 }

 const result = await openai.chat.completions.create({
  model: 'gpt-4o-mini',
  messages: messages as any,
 });

 const response = result.choices[0].message.content || '';
 cache.set(messages, response);
 return response;
}

#### 语义缓存

更高级的方式——**意思相近的问题，也能命中缓存：**

typescript

import { embed } from 'ai';
import { openai } from '@ai-sdk/openai';

class SemanticCache {
 private entries: Array<{
  embedding: number[];
  question: string;
  response: string;
  timestamp: number;
 }> = [];

 private similarityThreshold = 0.92;

 async get(question: string): Promise<string | null> {
  const { embedding } = await embed({
   model: openai.embedding('text-embedding-3-small'),
   value: question,
  });

  for (const entry of this.entries) {
   const similarity = cosineSimilarity(embedding, entry.embedding);
   if (similarity >= this.similarityThreshold) {
    return entry.response;
   }
  }
  return null;
 }

 async set(question: string, response: string): Promise<void> {
  const { embedding } = await embed({
   model: openai.embedding('text-embedding-3-small'),
   value: question,
  });

  this.entries.push({
   embedding,
   question,
   response,
   timestamp: Date.now(),
  });
 }
}

function cosineSimilarity(a: number[], b: number[]): number {
 let dotProduct = 0, normA = 0, normB = 0;
 for (let i = 0; i < a.length; i++) {
  dotProduct += a[i] * b[i];
  normA += a[i] * a[i];
  normB += b[i] * b[i];
 }
 return dotProduct / (Math.sqrt(normA) * Math.sqrt(normB));
}

这样，"React 怎么用 hooks？"和"React hooks 怎么使用？"就能命中同一个缓存。

#### OpenAI Prompt Caching

OpenAI 和 Anthropic 都提供了原生的 Prompt Caching。对于**长且重复的 System Prompt**，这个功能能自动省 50% 的输入费用：

typescript

// OpenAI 自动 Prompt Caching（2024年10月起默认开启）
// 当 prompt 前缀长度 >= 1024 tokens 且重复出现时自动生效
// 缓存命中后，缓存部分的输入费用减半

const longSystemPrompt = `
你是一个专业的代码审查助手...
（此处省略 1000+ tokens 的详细规则和示例）
`;

// 第一次调用：正常计费
// 第二次及之后的调用（相同前缀）：缓存部分输入费用减 50%
const result = await openai.chat.completions.create({
 model: 'gpt-4o',
 messages: [
  { role: 'system', content: longSystemPrompt },
  { role: 'user', content: userQuestion },
 ],
});

// 从 usage 里可以看到缓存情况
console.log(result.usage);
// {
//  prompt_tokens: 1500,
//  prompt_tokens_details: { cached_tokens: 1200 }, // 1200 tokens 命中缓存
//  completion_tokens: 300,
// }

### ▎3.4 第四斧：批量处理

如果你有大量不紧急的请求，**Batch API** 能直接打五折：

typescript

import OpenAI from 'openai';
import * as fs from 'fs';

const client = new OpenAI();

// 1. 准备批量请求文件（JSONL 格式）
function prepareBatchFile(tasks: Array<{ id: string; prompt: string }>): string {
 const lines = tasks.map(task => JSON.stringify({
  custom_id: task.id,
  method: 'POST',
  url: '/v1/chat/completions',
  body: {
   model: 'gpt-4o-mini',
   messages: [
    { role: 'system', content: '你是一个技术文档翻译助手。' },
    { role: 'user', content: task.prompt },
   ],
   max_tokens: 500,
  },
 }));

 const filePath = '/tmp/batch_input.jsonl';
 fs.writeFileSync(filePath, lines.join('\n'));
 return filePath;
}

// 2. 上传文件并创建批量任务
async function submitBatch(filePath: string) {
 const file = await client.files.create({
  file: fs.createReadStream(filePath),
  purpose: 'batch',
 });

 const batch = await client.batches.create({
  input_file_id: file.id,
  endpoint: '/v1/chat/completions',
  completion_window: '24h', // 24小时内完成
 });

 console.log(`Batch created: ${batch.id}`);
 console.log('Status:', batch.status);
 // 价格优惠：输入 $0.075/1M, 输出 $0.30/1M (4o-mini 的 50%)
 return batch;
}

// 3. 轮询检查状态
async function pollBatch(batchId: string) {
 while (true) {
  const batch = await client.batches.retrieve(batchId);

  if (batch.status === 'completed') {
   console.log(`Done! Output file: ${batch.output_file_id}`);
   return batch;
  }
  if (batch.status === 'failed' || batch.status === 'expired') {
   throw new Error(`Batch ${batch.status}: ${JSON.stringify(batch.errors)}`);
  }

  console.log(E6DB74">`Status: ${batch.status}, waiting...`);
  await new Promise(resolve => setTimeout(resolve, 60_000));
 }
}

**适合批量处理的场景：**

- ▸批量翻译文档
- ▸批量生成商品描述
- ▸夜间跑数据分析
- ▸批量内容审核

------

## 四、Token 预算管理系统

光优化不够，还得建立一套**预算管理机制**，防止成本失控。

![Token 预算管理架构](https://mmbiz.qpic.cn/mmbiz_jpg/QCpJyyjNHoc6spwSicPH7nCOUBiaYP47Ouy9VHNZtoyicLEBZMicWThm4tRwWVtS7NsEajjvWuxvElEE0K7bl31uHKPWLCbhFEySALDTWlfb0N0/640?from=appmsg&tp=webp&wxfrom=5&wx_lazy=1#imgIndex=3)

### ▎4.1 用户级配额

不同等级的用户给不同的额度：

typescript

interface UserQuota {
 userId: string;
 tier: 'free' | 'pro' | 'enterprise';
 dailyTokenLimit: number;
 dailyUsed: number;
 monthlyTokenLimit: number;
 monthlyUsed: number;
}

const QUOTA_CONFIG = {
 free: {
  dailyTokenLimit: 50_000,   // 约 50 次对话
  monthlyTokenLimit: 500_000,
  allowedModels: ['gpt-4o-mini'],
  maxTokensPerRequest: 1000,
 },
 pro: {
  dailyTokenLimit: 500_000,
  monthlyTokenLimit: 10_000_000,
  allowedModels: ['gpt-4o-mini', 'gpt-4o'],
  maxTokensPerRequest: 4000,
 },
 enterprise: {
  dailyTokenLimit: Infinity,
  monthlyTokenLimit: Infinity,
  allowedModels: ['gpt-4o-mini', 'gpt-4o', 'o1-mini'],
  maxTokensPerRequest: 8000,
 },
};

class QuotaManager {
 private store: Map<string, UserQuota> = new Map();

 async checkQuota(userId: string): Promise<{
  allowed: boolean;
  remaining: number;
  reason?: string;
 }> {
  const quota = await this.getQuota(userId);
  const config = QUOTA_CONFIG[quota.tier];

  if (quota.dailyUsed >= config.dailyTokenLimit) {
   return {
    allowed: false,
    remaining: 0,
    reason: `已达日用量上限 (${config.dailyTokenLimit.toLocaleString()} tokens)`,
   };
  }

  if (quota.monthlyUsed >= config.monthlyTokenLimit) {
   return {
    allowed: false,
    remaining: 0,
    reason: E6DB74">`已达月用量上限`,
   };
  }

  return {
   allowed: true,
   remaining: config.dailyTokenLimit - quota.dailyUsed,
  };
 }

 async recordUsage(userId: string, tokensUsed: number): Promise<void> {
  const quota = await this.getQuota(userId);
  quota.dailyUsed += tokensUsed;
  quota.monthlyUsed += tokensUsed;
  this.store.set(userId, quota);
 }

 private async getQuota(userId: string): Promise<UserQuota> {
  return this.store.get(userId) || {
   userId,
   tier: 'free',
   dailyTokenLimit: QUOTA_CONFIG.free.dailyTokenLimit,
   dailyUsed: 0,
   monthlyTokenLimit: QUOTA_CONFIG.free.monthlyTokenLimit,
   monthlyUsed: 0,
  };
 }
}

### ▎4.2 请求级预算控制

每次 API 调用都要设置预算上限：

typescript

interface RequestBudget {
 maxInputTokens: number;
 maxOutputTokens: number;
 model: string;
 timeout: number;
}

function getRequestBudget(
 userTier: 'free' | 'pro' | 'enterprise',
 taskType: string
): RequestBudget {
 const budgets: Record<string, RequestBudget> = {
  'free:chat': {
   maxInputTokens: 2000,
   maxOutputTokens: 500,
   model: 'gpt-4o-mini',
   timeout: 15_000,
  },
  'pro:chat': {
   maxInputTokens: 8000,
   maxOutputTokens: 2000,
   model: 'gpt-4o-mini',
   timeout: 30_000,
  },
  'pro:analysis': {
   maxInputTokens: 16000,
   maxOutputTokens: 4000,
   model: 'gpt-4o',
   timeout: 60_000,
  },
  'enterprise:chat': {
   maxInputTokens: 32000,
   maxOutputTokens: 8000,
   model: 'gpt-4o',
   timeout: 120_000,
  },
 };

 return budgets[`${userTier}:${taskType}`] || budgets['free:chat']!;
}

// 带预算控制的 API 调用
async function budgetedCompletion(
 messages: Array<{ role: string; content: string }>,
 budget: RequestBudget
) {
 const inputTokens = estimateTokens(messages.map(m => m.content).join(''));

 if (inputTokens > budget.maxInputTokens) {
  throw new Error(`输入超出预算: ${inputTokens} > ${budget.maxInputTokens} tokens`);
 }

 const controller = new AbortController();
 const timeoutId = setTimeout(() => controller.abort(), budget.timeout);

 try {
  const result = await openai.chat.completions.create({
   model: budget.model,
   messages: messages as any,
   max_tokens: budget.maxOutputTokens,
  }, { signal: controller.signal });

  return result;
 } finally {
  clearTimeout(timeoutId);
 }
}

### ▎4.3 实时计量与降级

当用量接近上限时，自动降级而不是直接拒绝：

typescript

class TokenMeter {
 async processRequest(
  userId: string,
  messages: any[],
  quotaManager: QuotaManager
 ) {
  const quotaCheck = await quotaManager.checkQuota(userId);

  if (!quotaCheck.allowed) {
   return { error: quotaCheck.reason, code: 'QUOTA_EXCEEDED' };
  }

  // 根据剩余额度动态调整策略
  const remaining = quotaCheck.remaining;
  const strategy = this.getDegradationStrategy(remaining);

  const result = await openai.chat.completions.create({
   model: strategy.model,
   messages,
   max_tokens: strategy.maxTokens,
  });

  const tokensUsed =
   (result.usage?.prompt_tokens || 0) + (result.usage?.completion_tokens || 0);

  await quotaManager.recordUsage(userId, tokensUsed);

  return {
   response: result.choices[0].message.content,
   usage: result.usage,
   degraded: strategy.degraded,
  };
 }

 private getDegradationStrategy(remainingTokens: number) {
  if (remainingTokens > 100_000) {
   return { model: 'gpt-4o', maxTokens: 4000, degraded: false };
  }
  if (remainingTokens > 10_000) {
   return { model: 'gpt-4o-mini', maxTokens: 1000, degraded: true };
  }
  // 额度快用完了，极限节省
  return { model: 'gpt-4o-mini', maxTokens: 300, degraded: true };
 }
}

------

## 五、监控与告警

有了预算管理，还需要**可视化监控**来发现异常。

![Token 监控仪表盘](https://mmbiz.qpic.cn/sz_mmbiz_jpg/QCpJyyjNHoeVhIlwS1jaaGibTwmhhZuIKzSibzGfNXAUI2BAtJke48EP6BmkGmkCheKR6ljOYQGLBj3IpHTWUNV7DZZALBIKNUVQL7KcDcfnA/640?from=appmsg&tp=webp&wxfrom=5&wx_lazy=1#imgIndex=4)

### ▎5.1 成本监控中间件

在每次 API 调用前后都记录数据：

typescript

interface TokenLog {
 timestamp: number;
 userId: string;
 endpoint: string;
 model: string;
 inputTokens: number;
 outputTokens: number;
 cost: number;
 latency: number;
 cached: boolean;
}

const PRICING: Record<string, { input: number; output: number }> = {
 'gpt-4o': { input: 2.5, output: 10.0 },
 'gpt-4o-mini': { input: 0.15, output: 0.6 },
 'claude-3-5-sonnet': { input: 3.0, output: 15.0 },
 'claude-3-5-haiku': { input: 0.8, output: 4.0 },
 'deepseek-v3': { input: 0.27, output: 1.1 },
};

function calculateCost(model: string, inputTokens: number, outputTokens: number): number {
 const price = PRICING[model];
 if (!price) return 0;
 return (inputTokens / 1_000_000) * price.input + (outputTokens / 1_000_000) * price.output;
}

// Express 中间件示例
function tokenMonitorMiddleware() {
 const logs: TokenLog[] = [];

 return async (req: any, res: any, next: any) => {
  const startTime = Date.now();

  const originalJson = res.json.bind(res);
  res.json = (body: any) => {
   if (body.usage) {
    const log: TokenLog = {
     timestamp: Date.now(),
     userId: req.userId || 'anonymous',
     endpoint: req.path,
     model: body.model || 'unknown',
     inputTokens: body.usage.prompt_tokens || 0,
     outputTokens: body.usage.completion_tokens || 0,
     cost: calculateCost(
      body.model,
      body.usage.prompt_tokens || 0,
      body.usage.completion_tokens || 0
     ),
     latency: Date.now() - startTime,
     cached: body.cached || false,
    };

​    logs.push(log);
​    checkAlerts(log);
   }
   return originalJson(body);
  };

  next();
 };
}

### ▎5.2 告警规则

typescript

interface AlertRule {
 name: string;
 condition: (log: TokenLog) => boolean;
 severity: 'warning' | 'critical';
 message: (log: TokenLog) => string;
}

const alertRules: AlertRule[] = [
 {
  name: '单次请求成本过高',
  condition: (log) => log.cost > 0.5,
  severity: 'warning',
  message: (log) => `单次请求花费 $${log.cost.toFixed(3)}（用户: ${log.userId}，接口: ${log.endpoint}）`,
 },
 {
  name: '异常大量 Token 消耗',
  condition: (log) => log.inputTokens + log.outputTokens > 50000,
  severity: 'critical',
  message: (log) => E6DB74">`单次消耗 ${log.inputTokens + log.outputTokens} tokens！`,
 },
 {
  name: '响应超时',
  condition: (log) => log.latency > 30000,
  severity: 'warning',
  message: (log) => E6DB74">`请求耗时 ${(log.latency / 1000).toFixed(1)}s（模型: ${log.model}）`,
 },
];

function checkAlerts(log: TokenLog) {
 for (const rule of alertRules) {
  if (rule.condition(log)) {
   sendAlert({
    rule: rule.name,
    severity: rule.severity,
    message: rule.message(log),
    timestamp: new Date().toISOString(),
   });
  }
 }
}

async function sendAlert(alert: { rule: string; severity: string; message: string; timestamp: string }) {
 // 发送到你的告警渠道：企业微信、钉钉、Slack 等
 console.warn(`[${alert.severity.toUpperCase()}] ${alert.rule}: ${alert.message}`);

 // 示例：发送到企业微信机器人
 if (alert.severity === 'critical') {
  await fetch(process.env.WECHAT_WEBHOOK_URL!, {
   method: 'POST',
   headers: { 'Content-Type': 'application/json' },
   body: JSON.stringify({
    msgtype: 'markdown',
    markdown: {
     content: E6DB74">`**🚨 Token 成本告警**\n规则：${alert.rule}\n详情：${alert.message}\n时间：${alert.timestamp}`,
    },
   }),
  });
 }
}

### ▎5.3 日报聚合

每天生成一份成本日报：

typescript

interface DailyReport {
 date: string;
 totalCost: number;
 totalRequests: number;
 avgCostPerRequest: number;
 modelBreakdown: Record<string, { count: number; cost: number }>;
 topEndpoints: Array<{ endpoint: string; cost: number; count: number }>;
 cacheHitRate: number;
 anomalies: string[];
}

function generateDailyReport(logs: TokenLog[], date: string): DailyReport {
 const dayLogs = logs.filter(l => new Date(l.timestamp).toISOString().startsWith(date));

 const totalCost = dayLogs.reduce((sum, l) => sum + l.cost, 0);
 const cachedCount = dayLogs.filter(l => l.cached).length;

 const modelBreakdown: Record<string, { count: number; cost: number }> = {};
 const endpointCosts: Record<string, { cost: number; count: number }> = {};

 for (const log of dayLogs) {
  if (!modelBreakdown[log.model]) {
   modelBreakdown[log.model] = { count: 0, cost: 0 };
  }
  modelBreakdown[log.model].count++;
  modelBreakdown[log.model].cost += log.cost;

  if (!endpointCosts[log.endpoint]) {
   endpointCosts[log.endpoint] = { cost: 0, count: 0 };
  }
  endpointCosts[log.endpoint].cost += log.cost;
  endpointCosts[log.endpoint].count++;
 }

 return {
  date,
  totalCost,
  totalRequests: dayLogs.length,
  avgCostPerRequest: dayLogs.length ? totalCost / dayLogs.length : 0,
  modelBreakdown,
  topEndpoints: Object.entries(endpointCosts)
   .map(([endpoint, data]) => ({ endpoint, ...data }))
   .sort((a, b) => b.cost - a.cost)
   .slice(0, 5),
  cacheHitRate: dayLogs.length ? cachedCount / dayLogs.length : 0,
  anomalies: [],
 };
}

------

## 六、开源与自部署：另一条路

如果你的数据隐私要求高，或者请求量大到 API 费用扛不住，可以考虑自部署开源模型。

### ▎6.1 成本对比

场景：日均 10 万次请求，平均 2000 input + 500 output tokens

GPT-4o API:
 月成本 = 100K × 30 × ($0.005 + $0.005) = $30,000/月

GPT-4o-mini API:
 月成本 = 100K × 30 × ($0.0003 + $0.0003) = $1,800/月

自部署 Llama 3.1 70B (2×A100 GPU):
 GPU 租赁 ≈ $4,000/月（云厂商按需）
 运维人力 ≈ $2,000/月
 总成本 ≈ $6,000/月
 但请求量翻倍，成本基本不变！

### ▎6.2 什么时候考虑自部署？

| 维度      | 用 API          | 自部署         |
| :-------- | :-------------- | :------------- |
| 月 API 费 | < $5,000        | > $10,000      |
| 数据隐私  | 可接受第三方    | 严格不出域     |
| 定制需求  | 通用能力够用    | 需要微调模型   |
| 团队能力  | 无 GPU 运维经验 | 有 ML Ops 团队 |
| 延迟要求  | 可接受网络延迟  | 需要极低延迟   |

### ▎6.3 混合方案

实际上最优策略通常是**混合部署**：

typescript

class HybridModelService {
 private localEndpoint = 'http://localhost:8080/v1'; // 自部署模型
 private cloudClient = new OpenAI(); // 云端 API

 async complete(messages: any[], options: { needHighQuality?: boolean } = {}) {
  if (options.needHighQuality) {
   return this.cloudClient.chat.completions.create({
    model: 'gpt-4o',
    messages,
   });
  }

  // 优先用本地模型
  try {
   const localClient = new OpenAI({
    baseURL: this.localEndpoint,
    apiKey: 'not-needed',
   });

   return await localClient.chat.completions.create({
    model: 'llama-3.1-70b',
    messages,
   });
  } catch {
   // 本地模型挂了，fallback 到云端
   return this.cloudClient.chat.completions.create({
    model: 'gpt-4o-mini',
    messages,
   });
  }
 }
}

------

## 七、避坑指南：5 个常见的成本陷阱

### ▎坑 1：上下文窗口当数据库用

typescript

// ❌ 把所有历史消息都塞进去
const messages = allConversationHistory; // 可能有几万 tokens

// ✅ 只保留最近 N 轮 + 摘要
const messages = [
 { role: 'system', content: systemPrompt },
 { role: 'system', content: E6DB74">`之前的对话摘要：${summary}` },
 ...recentMessages.slice(-6), // 只保留最近 3 轮
];

### ▎坑 2：Tool 定义过多导致隐性成本

typescript

// ❌ 一次性注册 20 个 tools
const tools = allAvailableTools; // 20 个 tool 的 schema ≈ 5000 tokens

// ✅ 根据对话阶段动态注册
function getRelevantTools(context: string): Tool[] {
 if (context.includes('查询')) return [searchTool, databaseTool];
 if (context.includes('文件')) return [readFileTool, writeFileTool];
 return [generalTool]; // 默认只给基础 tool
}

### ▎坑 3：重试没有退避策略

typescript

// ❌ 无脑重试 = 3倍费用
async function callWithRetry(fn: () => Promise<any>, retries = 3) {
 for (let i = 0; i < retries; i++) {
  try { return await fn(); } catch (e) { /* 继续重试 */ }
 }
}

// ✅ 带退避 + 只对可重试的错误重试
async function smartRetry(fn: () => Promise<any>, retries = 3) {
 for (let i = 0; i < retries; i++) {
  try {
   return await fn();
  } catch (e: any) {
   if (e.status === 400) throw e; // 参数错误，重试也没用
   if (e.status === 429) {
    await new Promise(r => setTimeout(r, Math.pow(2, i) * 1000));
    continue;
   }
   throw e;
  }
 }
}

### ▎坑 4：流式响应忘记 abort

typescript

// ❌ 用户关闭页面，后端还在接收 tokens
app.post('/api/chat', async (req, res) => {
 const stream = await openai.chat.completions.create({ stream: true, /* ... */ });
 for await (const chunk of stream) {
  res.write(chunk.choices[0]?.delta?.content || '');
 }
});

// ✅ 监听客户端断开，立即终止
app.post('/api/chat', async (req, res) => {
 const controller = new AbortController();

 req.on('close', () => {
  controller.abort(); // 客户端断开时终止 API 调用
 });

 try {
  const stream = await openai.chat.completions.create(
   { stream: true, model: 'gpt-4o-mini', messages: req.body.messages },
   { signal: controller.signal }
  );

  for await (const chunk of stream) {
   if (res.destroyed) break;
   res.write(chunk.choices[0]?.delta?.content || '');
  }
 } catch (e: any) {
  if (e.name === 'AbortError') return; // 正常中断
  throw e;
 }
});

### ▎坑 5：没有设置 max_tokens

typescript

// ❌ 不设置 max_tokens，模型可能生成超长回复
const result = await openai.chat.completions.create({
 model: 'gpt-4o',
 messages,
 // max_tokens 没设置 → 可能输出几千 tokens
});

// ✅ 根据场景设置合理上限
const result = await openai.chat.completions.create({
 model: 'gpt-4o',
 messages,
 max_tokens: 1000, // 对话场景 1000 tokens 通常足够
});

------

## 八、总结：Token 省钱 Checklist

回顾一下，做好 AI 应用的成本控制，核心就是这几件事：

1. **搞清楚钱花在哪** — 精确计量每一个请求的 Token 消耗和成本
2. **Prompt 压缩** — 精简 System Prompt，动态裁剪上下文
3. **模型路由** — 简单任务用小模型，复杂任务用大模型
4. **缓存** — 精确缓存 + 语义缓存 + Prompt Caching 三管齐下
5. **批量处理** — 不紧急的任务用 Batch API 打五折
6. **预算管理** — 用户配额 + 请求预算 + 实时计量 + 自动降级
7. **监控告警** — 成本仪表盘 + 异常检测 + 日报

**实际项目中的优化效果参考：**

| 优化手段             | 预期节省 | 实施难度 |
| :------------------- | :------- | :------- |
| Prompt 压缩          | 20-40%   | ⭐        |
| 模型路由             | 40-70%   | ⭐⭐       |
| 响应缓存             | 30-60%   | ⭐⭐       |
| Batch API            | 50%      | ⭐        |
| 用户配额             | 防止失控 | ⭐⭐       |
| 自部署（大量请求时） | 50-80%   | ⭐⭐⭐⭐     |

组合使用这些手段，**总成本降低 60%-80% 是完全可以实现的**。

### ▎推荐资源

- ▸OpenAI Pricing — 官方价格页，建议收藏定期查看
- ▸Anthropic Pricing — Claude 模型价格
- ▸OpenAI Batch API 文档 — 批量处理指南
- ▸tiktoken — 官方 Token 计数工具
- ▸LiteLLM — 多模型代理网关，统一管理和监控
- ▸OpenRouter — 多模型路由平台，自动选最便宜的