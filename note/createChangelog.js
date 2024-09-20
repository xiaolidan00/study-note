import { exec } from "child_process";
import fs from "fs";

//https://git-scm.com/docs/git-log/zh_HANS-CN
function createLog(startTime, endTime) {
  const packageJson = JSON.parse(fs.readFileSync("./package.json").toString());
  exec(
    `git --no-pager log  --since="${startTime}" --until="${endTime}" --pretty="format:%C(auto)%s"`,
    (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      //   console.log(stdout);
      const data = stdout.split("\n");
      const map = { feat: {}, fix: {} };
      data.forEach((item) => {
        const s = item.split(":");
        const type = s[0];
        const msg = s[1];
        if (map[type] && !map[type][msg]) {
          map[type][msg] = 1;
        }
      });
      console.log(map);
      fs.writeFileSync(
        "./changelog.md",
        `# V${
          packageJson.version
        }(${startTime}~${endTime})\n\n## 新增功能\n\n${Object.keys(map.feat)
          .map((a) => "- " + a)
          .join("\n")}\n\n## 修复问题\n\n${Object.keys(map.fix)
          .map((a) => "- " + a)
          .join("\n")}`
      );

      if (stderr) console.log(`stderr: ${stderr}`);
    }
  );
}
createLog("2024-09-01", "2024-09-10");
