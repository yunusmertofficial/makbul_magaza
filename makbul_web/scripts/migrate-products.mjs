import { cp, mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

// Ürünleri Flutter kaynağından (product_service.dart) okuyup web kataloğuna aktarır.
// Kaynak proje klasörü ilk argümanla verilir, verilmezse üst klasör kullanılır:
//   node scripts/migrate-products.mjs C:/makbul_magaza
const scriptDirectory = dirname(fileURLToPath(import.meta.url));
const projectDirectory = resolve(scriptDirectory, "..");
const flutterDirectory = resolve(projectDirectory, process.argv[2] ?? "..");

const sourcePath = resolve(flutterDirectory, "lib", "services", "product_service.dart");
const assetDirectory = resolve(flutterDirectory, "assets", "products");
const publicImageDirectory = resolve(projectDirectory, "public", "products");
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

// Flutter tarafında görseller `assets/products/...` altında duruyor; web tarafında
// aynı dosyalar `public/products/` altından `/products/...` ile servis ediliyor.
const toWebImageUrl = (rawImageUrl) => {
  if (!rawImageUrl) return "";
  if (rawImageUrl.startsWith("assets/products/")) {
    return `/products/${rawImageUrl.slice("assets/products/".length)}`;
  }
  return rawImageUrl.replace("$_base", imageBase);
};

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
    imageUrl: toWebImageUrl(rawImageUrl),
  });
}

if (products.length < 150) {
  throw new Error(`Beklenenden az ürün çıkarıldı: ${products.length}`);
}

await mkdir(dirname(outputPath), { recursive: true });
await writeFile(outputPath, `${JSON.stringify(products, null, 2)}\n`, "utf8");

let copiedAssets = 0;
try {
  await cp(assetDirectory, publicImageDirectory, { recursive: true });
  copiedAssets = products.filter((product) => product.imageUrl.startsWith("/products/")).length;
} catch (error) {
  if (error.code !== "ENOENT") throw error;
}

const duplicateCodes = [...new Set(
  products
    .filter((product, index) => products.findIndex((item) => item.code === product.code) !== index)
    .map((product) => product.code),
)];

const missingImages = products.filter((product) => !product.imageUrl).length;

console.log(`${products.length} ürün ${outputPath} dosyasına aktarıldı.`);
console.log(`${copiedAssets} ürün yerel görsel kullanıyor (public/products/).`);
console.log(`${missingImages} üründe görsel yok.`);
console.log(`${duplicateCodes.length} tekrarlı ürün kodu kaynak listedeki haliyle korundu.`);
