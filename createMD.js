const fs = require('fs');
const info = require('./urls.js');
function write(fileName, fileContent) {
  fs.writeFile(fileName, fileContent, (err) => {
    if (err) {
      return console.error(err);
    }
    console.log(fileName, 'ok');
  });
}

const contentIndex = [];
const readme = [];
const header = `<div style='text-align:center;font-size:32px;color:#1a67ff'> 
<img style="height:32px;width:32px;border-radius:50%" src='http://www.xiaolidan00.top/bell-icon.png'/>
主页-xiaolidan00.top </div>
`;
contentIndex.push(header);
readme.push(header);

info.forEach((item) => {
  if (item.url) {
    readme.push(`- [${item.name}](${item.url})`);
    contentIndex.push(`- [${item.name}](#${item.url})`);
  } else {
    const title = '\n# ' + item.name + '\n';
    readme.push(title);
    contentIndex.push(title);
  }
});
// write('./urls.json', JSON.stringify(info));
write('./index.md', contentIndex.join('\n'));

write('./README.md', readme.join('\n'));
