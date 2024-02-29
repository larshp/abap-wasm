import * as fs from "node:fs";
import * as os from "node:os";

import {initializeABAP} from "../output/init.mjs";
await initializeABAP();

const folders = [];
for (const dir of fs.readdirSync("testsuite", {withFileTypes: true})) {
  if (dir.isDirectory() === false) {
    continue;
  }
  folders.push(dir.name);
}

fs.rmSync("web", {recursive: true});
if (fs.existsSync("web") === false) {
  fs.mkdirSync("web");
}

const numCPUs = Math.min(os.availableParallelism() - 1, folders.length);
console.log("CPUs: " + numCPUs);

for (const folder of folders) {
  const lo_result = await abap.Classes["CL_TESTSUITE"].run({iv_folder: new abap.types.String().set(folder)});
  const html = (await lo_result.get().render_html()).get();
  const json = (await lo_result.get().render_json()).get();
  fs.writeFileSync("web/" + folder + ".html", html);
  fs.writeFileSync("web/" + folder + ".json", json);
}

let html = `<html><body>
<table>
<tr>
<th align="left">Folder</th>
<th align="left">Errors</th>
<th align="left">Warnings</th>
<th align="left">Successes</th>
<th align="left">Runtime</th>
</tr>\n`;
for (const folder of folders) {
  const json = JSON.parse(fs.readFileSync("web/" + folder + ".json"));
  html += `<tr>
  <td><a href="./${folder}.html">${folder}</a></td>
  <td align="right">${json.errors}</td>
  <td align="right">${json.warnings}</td>
  <td align="right">${json.successes}</td>
  <td align="right">${json.runtime}s</td>
  </tr>\n`;
}
html += "</table>\n";
html += "</body></html>";
fs.writeFileSync("web/index.html", html);