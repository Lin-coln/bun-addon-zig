import path from "node:path";
import url from "node:url";

const __dirname = path.dirname(url.fileURLToPath(import.meta.url));

const addon = ffi('./zig-out/lib/addon.node');
console.log(addon)

function ffi<T = any>(filename: string): T {
  const exports: any = {};
  process.dlopen({exports}, path.resolve(__dirname, filename));
  return exports

}