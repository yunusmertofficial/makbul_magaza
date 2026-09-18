import type { MetadataRoute } from "next";

export const dynamic = "force-static";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Makbul Mağazası Ürün Kataloğu",
    short_name: "Makbul",
    description: "Makbul ürünlerini adı veya koduyla hızlıca bulun.",
    start_url: "/",
    display: "standalone",
    background_color: "#f8f6ef",
    theme_color: "#125d3b",
    orientation: "portrait",
    icons: [
      {
        src: "/app-icon.svg",
        sizes: "any",
        type: "image/svg+xml",
        purpose: "any",
      },
      {
        src: "/logo.png",
        sizes: "124x89",
        type: "image/png",
        purpose: "any",
      },
    ],
  };
}
