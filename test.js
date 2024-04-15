function compose(...fn) {
  if (!fn.length) return (v) => v;
  if (fn.length === 1) return fn[0];
  return fn.reduce((pre, cur) => (...args) => {
    console.log(args);
    return pre(cur(...args));
  });
}
const sum = (a, b) => a + b;
const multi = (a, b) => a * (b | 1);

console.log(compose(multi, sum)(3, 4));
