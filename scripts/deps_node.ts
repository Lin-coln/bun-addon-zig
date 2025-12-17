import * as path from "node:path";
import * as url from "node:url";
import * as fs from "node:fs";

const __dirname = path.dirname(url.fileURLToPath(import.meta.url))

await main();

async function main(){
  const depsDirname = path.resolve(__dirname, '../deps');
  fs.existsSync(depsDirname) || await fs.promises.mkdir(depsDirname, { recursive: true});

  const version = await Bun.$`node -p "process.version"`.text().then(x=>x.trim().replace(/^v/, ''));

  if (fs.existsSync(path.resolve(depsDirname, `node-v${version}`))) return;

  const tarFilename = path.resolve(depsDirname, `node-v${version}-headers.tar.gz`);

  const headersUrl = `https://nodejs.org/download/release/v${version}/node-v${version}-headers.tar.gz`;
  await Bun.$`curl -L ${headersUrl} -o ${tarFilename}`;
  await Bun.$`tar -xzf ${tarFilename} -C ${depsDirname}`;
  await fs.promises.rm(tarFilename);
}