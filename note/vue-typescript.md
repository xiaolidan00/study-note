# Vue Typescript

https://cn.vuejs.org/guide/typescript/composition-api.html#typing-component-props

# Props

```ts
const props = defineProps({
  foo: { type: String, required: true },
  bar: Number
});

props.foo; // string
props.bar; // number | undefined
```

```ts
const props = defineProps<{
  foo: string;
  bar?: number;
}>();
```

```ts
interface Props {
  foo: string;
  bar?: number;
}

const props = defineProps<Props>();
```

```ts
import type { Props } from './foo';

const props = defineProps<Props>();
```

```ts
interface Props {
  msg?: string;
  labels?: string[];
}

const { msg = 'hello', labels = ['one', 'two'] } = defineProps<Props>();
```

```ts
interface Props {
  msg?: string;
  labels?: string[];
}

const props = withDefaults(defineProps<Props>(), {
  msg: 'hello',
  labels: () => ['one', 'two']
});
```

```ts
import { defineComponent } from 'vue';

export default defineComponent({
  props: {
    message: String
  },
  setup(props) {
    props.message; // <-- 类型：string
  }
});
```

```ts
interface Book {
  title: string;
  author: string;
  year: number;
}

const props = defineProps<{
  book: Book;
}>();
```

```ts
import type { PropType } from 'vue';

const props = defineProps({
  book: Object as PropType<Book>
});
```

```ts
import { defineComponent } from 'vue';
import type { PropType } from 'vue';

export default defineComponent({
  props: {
    book: Object as PropType<Book>
  }
});
```

# emit

```ts
// 运行时
const emit = defineEmits(['change', 'update']);

// 基于选项
const emit = defineEmits({
  change: (id: number) => {
    // 返回 `true` 或 `false`
    // 表明验证通过或失败
  },
  update: (value: string) => {
    // 返回 `true` 或 `false`
    // 表明验证通过或失败
  }
});

// 基于类型
const emit = defineEmits<{
  (e: 'change', id: number): void;
  (e: 'update', value: string): void;
}>();

// 3.3+: 可选的、更简洁的语法
const emit = defineEmits<{
  change: [id: number];
  update: [value: string];
}>();
```

```ts
import { defineComponent } from 'vue';

export default defineComponent({
  emits: ['change'],
  setup(props, { emit }) {
    emit('change'); // <-- 类型检查 / 自动补全
  }
});
```

# ref

```ts
import { ref } from 'vue';

// 推导出的类型：Ref<number>
const year = ref(2020);

// => TS Error: Type 'string' is not assignable to type 'number'.
year.value = '2020';
```

```ts
import { ref } from 'vue';
import type { Ref } from 'vue';

const year: Ref<string | number> = ref('2020');

year.value = 2020; // 成功！
```

```ts
// 得到的类型：Ref<string | number>
const year = ref<string | number>('2020');

year.value = 2020; // 成功！

// 推导得到的类型：Ref<number | undefined>
const n = ref<number>();
```

# reactive

```ts
import { reactive } from 'vue';

// 推导得到的类型：{ title: string }
const book = reactive({ title: 'Vue 3 指引' });
```

```ts
import { reactive } from 'vue';

interface Book {
  title: string;
  year?: number;
}

const book: Book = reactive({ title: 'Vue 3 指引' });
```

# computed

```ts
import { ref, computed } from 'vue';

const count = ref(0);

// 推导得到的类型：ComputedRef<number>
const double = computed(() => count.value * 2);

// => TS Error: Property 'split' does not exist on type 'number'
const result = double.value.split('');
```

```ts
const double = computed<number>(() => {
  // 若返回值不是 number 类型则会报错
});
```

# Event

```html
<script setup lang="ts">
  function handleChange(event) {
    // `event` 隐式地标注为 `any` 类型
    console.log(event.target.value);
  }
</script>

<template>
  <input type="text" @change="handleChange" />
</template>
```

```ts
function handleChange(event: Event) {
  console.log((event.target as HTMLInputElement).value);
}
```

# provide / inject

```ts
import { provide, inject } from 'vue';
import type { InjectionKey } from 'vue';

const key = Symbol() as InjectionKey<string>;

provide(key, 'foo'); // 若提供的是非字符串值会导致错误

const foo = inject(key); // foo 的类型：string | undefined
```

```ts
const foo = inject<string>('foo'); // 类型：string | undefined

const foo = inject<string>('foo', 'bar'); // 类型：string

const foo = inject('foo') as string;
```

# 模板

```ts
const el = useTemplateRef<HTMLInputElement>('el');
```

```html
<!-- App.vue -->
<script setup lang="ts">
  import { useTemplateRef } from 'vue';
  import Foo from './Foo.vue';
  import Bar from './Bar.vue';

  type FooType = InstanceType<typeof Foo>;
  type BarType = InstanceType<typeof Bar>;

  const compRef = useTemplateRef<FooType | BarType>('comp');
</script>

<template>
  <component :is="Math.random() > 0.5 ? Foo : Bar" ref="comp" />
</template>
```

```ts
import { useTemplateRef } from 'vue';
import type { ComponentPublicInstance } from 'vue';

const child = useTemplateRef<ComponentPublicInstance>('child');
```

```html
<!-- MyGenericModal.vue -->
<script setup lang="ts" generic="ContentType extends string | number">
  import { ref } from 'vue';

  const content = ref<ContentType | null>(null);

  const open = (newContent: ContentType) => (content.value = newContent);

  defineExpose({
    open
  });
</script>
```

```ts
import { useTemplateRef } from 'vue';
import MyGenericModal from './MyGenericModal.vue';
import type { ComponentExposed } from 'vue-component-type-helpers';

const modal = useTemplateRef<ComponentExposed<typeof MyGenericModal>>('modal');

const openModal = () => {
  modal.value?.open('newValue');
};
```
