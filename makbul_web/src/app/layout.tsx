import type { Metadata, Viewport } from "next";
import { Outfit, Roboto_Mono } from "next/font/google";
import "./globals.css";

const outfit = Outfit({
  variable: "--font-outfit",
  subsets: ["latin"],
});

const robotoMono = Roboto_Mono({
  variable: "--font-roboto-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Makbul Mağazası | Ürün Kataloğu",
  description:
    "Makbul Mağazası ürünlerini isim, ürün kodu ve kategoriye göre kolayca keşfedin.",
  icons: {
    icon: "/app-icon.svg",
    apple: "/logo.png",
  },
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Makbul",
  },
};

export const viewport: Viewport = {
  themeColor: "#125d3b",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="tr" className={`${outfit.variable} ${robotoMono.variable}`}>
      <body>{children}</body>
    </html>
  );
}
