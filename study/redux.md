# redux

<https://cn.redux.js.org/tutorials/essentials/part-1-overview-concepts>

- **state**：驱动应用的真实数据源头
- **view**：基于当前状态的视图声明性描述
- **actions**：根据用户输入在应用程序中发生的事件，并触发状态更新

接下来简要介绍  **"单向数据流（one-way data flow）"** :

- 用 state 来描述应用程序在特定时间点的状况
- 基于 state 来渲染出 View
- 当发生某些事情时（例如用户单击按钮），state 会根据发生的事情进行更新，生成新的 state
- 基于新的 state 重新渲染 View

- **初始启动：**

  - 使用最顶层的 root reducer 函数创建 Redux store
  - store 调用一次 root reducer，并将返回值保存为它的初始 `state`
  - 当视图 首次渲染时，视图组件访问 Redux store 的当前 state，并使用该数据来决定要呈现的内容。同时监听 store 的更新，以便他们可以知道 state 是否已更改。

- **更新环节：**

  - 应用程序中发生了某些事情，例如用户单击按钮
  - dispatch 一个 action 到 Redux store，例如 `dispatch({type: 'counter/increment'})`
  - store 用之前的 `state` 和当前的 `action` 再次运行 reducer 函数，并将返回值保存为新的 `state`
  - store 通知所有订阅过的视图，通知它们 store 发生更新
  - 每个订阅过 store 数据的视图 组件都会检查它们需要的 state 部分是否被更新。
  - 发现数据被更新的每个组件都强制使用新数据重新渲染，紧接着更新网页

![image](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3c5a3508ddca4b2e933d46fcc40a0a56~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1280\&h=866\&s=25103\&e=png\&b=ffffff)

**总结**

- **Redux 是一个管理全局应用状态的库**

  - Redux 通常与 React-Redux 库一起使用，把 Redux 和 React 集成在一起
  - Redux Toolkit 是编写 Redux 逻辑的推荐方式

- **Redux 使用 "单向数据流"**

  - State 描述了应用程序在某个时间点的状态，视图基于该 state 渲染

  - 当应用程序中发生某些事情时：

    - 视图 dispatch 一个 action
    - store 调用 reducer，随后根据发生的事情来更新 state
    - store 将 state 发生了变化的情况通知 UI

  - 视图基于新 state 重新渲染

- **Redux 有这几种类型的代码**

  - Action 是有 `type` 字段的纯对象，描述发生了什么
  - Reducer 是纯函数，基于先前的 state 和 action 来计算新的 state
  - 每当 dispatch 一个 action 后，store 就会调用 root reducer

```tsx
//chartReducer
import { createSlice, type PayloadAction } from '@reduxjs/toolkit';
import { type RootState } from './store';

export interface EchartsOption {
  [n: string | number]: string | number | boolean | EchartsOption;
}
export interface ChartState {
  value: number;
  options: string[];
  series: string[];
  config: EchartsOption;
  seriesConfig: EchartsOption[];
}

const initialState: ChartState = {
  value: 0,
  options: [],
  series: [],
  config: {},
  seriesConfig: []
};
export const chartSlice = createSlice({
  name: 'chart',
  initialState,
  reducers: {
    addSeries: (state, action: PayloadAction<string>) => {
      state.series.push(action.payload);
    },
    addOptions: (state, action: PayloadAction<string>) => {
      state.options.push(action.payload);
    },
    delSeries: (state, action: PayloadAction<number>) => {
      state.series.splice(action.payload, 1);
    },
    delOptions: (state, action: PayloadAction<number>) => {
      state.options.splice(action.payload, 1);
    },
    setConfig: (state, action: PayloadAction<EchartsOption>) => {
      state.config = action.payload;
    },
    setSeriesConfig: (state, action: PayloadAction<EchartsOption[]>) => {
      state.seriesConfig = action.payload;
    }
  }
});

export const actions = chartSlice.actions;

export const getters = {
  chartConfig: (state: RootState) => state.chart.config,
  chartOptions: (state: RootState) => state.chart.options,
  chartSeries: (state: RootState) => state.chart.series,
  chartSeriesConfig: (state: RootState) => state.chart.seriesConfig
};

export default chartSlice.reducer;

//hook
import { useDispatch, useSelector } from 'react-redux';
import type { AppDispatch, RootState } from './store';

// Use throughout your app instead of plain `useDispatch` and `useSelector`
export const useAppDispatch = useDispatch.withTypes<AppDispatch>();
export const useAppSelector = useSelector.withTypes<RootState>();

//store
import { configureStore, ThunkAction, Action } from '@reduxjs/toolkit';
import chartReducer from './chartReducer';

const store = configureStore({
  reducer: {
    chart: chartReducer
  }
});
export default store;
// 从 store 本身推断出 `RootState` 和 `AppDispatch` 类型
export type RootState = ReturnType<typeof store.getState>;
// 推断出类型: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch;

export type AppThunk<ReturnType = void> = ThunkAction<ReturnType, RootState, unknown, Action<string>>;


//main.tsx
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';
import './index.scss';
import { Provider } from 'react-redux';
import { type ThemeConfig, theme, ConfigProvider } from 'antd';
import store from './store/store.ts';
const config: ThemeConfig = {
  algorithm: theme.darkAlgorithm
};
ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <Provider store={store}>
      <ConfigProvider theme={config}>
        <App />
      </ConfigProvider>
    </Provider>
  </React.StrictMode>
);

```

使用

```ts
const chartConfig=useAppSelector(getters.chartConfig);

const dispatch = useAppDispatch()

dispatch(actions.setConfig(data))
```

异步操作createAsyncThunk

```tsx
import { createAsyncThunk, createSlice } from '@reduxjs/toolkit';
import { userAPI } from './userAPI';

// First, create the thunk
const fetchUserById = createAsyncThunk(
  'users/fetchByIdStatus',
  async (userId: number, thunkAPI) => {
    const response = await userAPI.fetchById(userId);
    return response.data;
  }
);

interface UsersState {
  entities: User[];
  loading: 'idle' | 'pending' | 'succeeded' | 'failed';
}

const initialState = {
  entities: [],
  loading: 'idle'
} satisfies UserState as UsersState;

// Then, handle actions in your reducers:
const usersSlice = createSlice({
  name: 'users',
  initialState,
  reducers: {
    // standard reducer logic, with auto-generated action types per reducer
  },
  extraReducers: (builder) => {
    // Add reducers for additional action types here, and handle loading state as needed
    builder.addCase(fetchUserById.fulfilled, (state, action) => {
      // Add user to the state array
      state.entities.push(action.payload);
    });
  }
});

// Later, dispatch the thunk as needed in the app
dispatch(fetchUserById(123));
```

## redux immer

```js
import produce from 'immer'

const baseState = [
  {
    todo: 'Learn typescript',
    done: true,
  },
  {
    todo: 'Try immer',
    done: false,
  },
]

const nextState = produce(baseState, (draftState) => {
  // "mutate" the draft array
  draftState.push({ todo: 'Tweet about it' })
  // "mutate" the nested state
  draftState[1].done = true
})

console.log(baseState === nextState)
// false - the array was copied
console.log(baseState[0] === nextState[0])
// true - the first item was unchanged, so same reference
console.log(baseState[1] === nextState[1])
// false - the second item was copied and update
```
