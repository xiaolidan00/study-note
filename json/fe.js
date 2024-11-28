const axios = require('axios');
const fs = require('fs');
const pageNum = 2;
const fileName = 'minprogram';
async function main() {
  const list = [];
  for (let i = 1; i <= pageNum; i++) {
    const url = `https://fe.ecool.fun/api/exercise/list?vid=9&tagId=23&exerciseCate=0&pageNum=1&pageSize=10&ignoreMaster=1&difficulty=&orderBy=default&order=desc`;
    const d = await axios.get(url).then(({ data }) => data.data.list);
    console.log(d.length);
    list.push(...d);
  }
  console.log(list.length);
  fs.writeFileSync(`./${fileName}.json`, JSON.stringify(list));
}
main();
