import Catalog from "@/components/catalog";
import products from "@/data/products.json";

export default function Home() {
  return <Catalog products={products} />;
}
