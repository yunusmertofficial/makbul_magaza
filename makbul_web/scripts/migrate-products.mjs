import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const projectDirectory = resolve(scriptDirectory, "..");
const sourcePath = resolve(projectDirectory, "..", "lib", "services", "product_service.dart");
const outputPath = resolve(projectDirectory, "src", "data", "products.json");
const imageBase = "https://www.makbul.com/Content/global/images/products";

const source = await readFile(sourcePath, "utf8");
const listStart = source.indexOf("static final List<Product> _defaultProducts = [");
const listEnd = source.indexOf("\n  ];", listStart);

if (listStart === -1 || listEnd === -1) {
  throw new Error("Flutter ürün listesi bulunamadı.");
}

const productPattern = /Product\(id: '([^']+)', code: '([^']+)', name: '((?:\\'|[^'])*)', imageUrl: '([^']*)'\),/;
let category = "Diğer";
const products = [];

for (const rawLine of source.slice(listStart, listEnd).split(/\r?\n/)) {
  const line = rawLine.trim();

  if (line.startsWith("// ")) {
    category = line.slice(3).trim();
    continue;
  }

  const match = line.match(productPattern);
  if (!match) continue;

  const [, id, code, escapedName, rawImageUrl] = match;
  products.push({
    id,
    code,
    name: escapedName.replaceAll("\\'", "'"),
    category,
    imageUrl: rawImageUrl.replace("$_base", imageBase),
  });
}

if (products.length < 150) {
  throw new Error(`Beklenenden az ürün çıkarıldı: ${products.length}`);
}

await mkdir(dirname(outputPath), { recursive: true });
await writeFile(outputPath, `${JSON.stringify(products, null, 2)}\n`, "utf8");

const duplicateCodes = [...new Set(
  products
    .filter((product, index) => products.findIndex((item) => item.code === product.code) !== index)
    .map((product) => product.code),
)];

console.log(`${products.length} ürün ${outputPath} dosyasına aktarıldı.`);
console.log(`${duplicateCodes.length} tekrarlı ürün kodu kaynak listedeki haliyle korundu.`);
