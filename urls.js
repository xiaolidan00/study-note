((root, factory) => {
  if (typeof exports === 'object') {
    //CommonJS
    module.exports = factory();
  } else {
    //都不是，浏览器全局定义
    root.urls = factory();
  }
})(this, () => {
  return (urls = [
    { name: '主页', url: 'index.md' },
    { name: '掘金博客', url: 'https://juejin.cn/user/224781403162798' },
    { name: '面试题', url: 'interview/index.md' },

    { name: '算法题' },
    { name: '手写代码', url: 'code/interview-code.md' },
    { name: 'Leetcode学习笔记', url: 'code/code-study.md' },
    { name: '练习算法题', url: 'code/code.md' },
    { name: '动态规划算法题学习笔记', url: 'code/dongtai.md' },
    { name: '学习笔记' },
    // { name: 'react18 学习笔记', url: 'note/react-guide.md' },
    { name: '2024 年 4 月读书笔记', url: 'study/2024-4.md' },
    { name: '2024 年 5 月读书笔记', url: 'study/2024-5.md' },
    { name: '2024 年 6 月读书笔记', url: 'study/2024-6.md' },
    { name: '2024 年 7 月读书笔记', url: 'study/2024-7.md' },
    { name: '2024 年 8 月读书笔记', url: 'study/2024-8.md' },
    { name: '2024 年 9 月读书笔记', url: 'study/2024-9.md' },
    { name: '2024 年 10 月读书笔记', url: 'study/2024-10.md' },
    { name: '软考' },
    { name: '系统分析师笔记', url: 'ruankao/analysis.md' },
    { name: '2022 年 11 月软考架构师', url: 'ruankao/note.md' },
    { name: '读书笔记' },
    { name: '《React技术揭秘》学习笔记', url: 'books/react-tech.md' },
    { name: '《Vue.js 技术内幕》学习笔记', url: 'books/vue3.md' },
    { name: '阮一峰《Typescript 教程》', url: 'books/ts.md' },
    { name: '《React Hooks 开发实战》', url: 'books/react-hook.md' },
    { name: '《前端开发必知必会：从工程核心到前沿实战》', url: 'books/book1.md' },
    { name: '《HTML5 Canvas 核心技术 图形、动画与游戏开发》', url: 'books/canvas.md' }
  ]);
});
// { name: '代码阅读', url: 'interview/readcode.md' },
// { name: 'js/es6', url: 'interview/js.md' },
// { name: 'html5/css3', url: 'interview/html.md' },
// { name: 'vue', url: 'interview/vue.md' },
// { name: 'react', url: 'interview/react.md' },
// { name: '工程化', url: 'interview/project.md' },
// { name: '手写代码', url: 'interview/code.md' },
// { name: 'Three.js', url: 'interview/three.md' },
// { name: 'node.js', url: 'interview/node.md' },
// { name: '网络', url: 'interview/network.md' },
// { name: 'Rollup', url: 'interview/Rollup.md' },
// { name: 'webpack', url: 'interview/webpack.md' },
// { name: 'package.json', url: 'interview/project.md' },
// { name: '前端整理' },
// { "name": "基础", "url": "interview/interview-base.md" },
// { "name": "网络", "url": "interview/interview-netword.md" },
// { "name": "vue", "url": "interview/interview-vue.md" },
// { "name": "react", "url": "interview/interview-react.md" },
// { "name": "工程化", "url": "interview/interview-project.md" },
// { "name": "性能优化", "url": "interview/performance.md" },
// { name: '拉钩 React 面试题', url: 'interview/lagou-react.md' },
