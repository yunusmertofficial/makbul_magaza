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
    icon: [
      { url: "/logo-192.png", sizes: "192x192", type: "image/png" },
      { url: "/logo-512.png", sizes: "512x512", type: "image/png" },
    ],
    apple: "/logo-180.png",
  },
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Makbul Mağazası",
  },
};

export const viewport: Viewport = {
  themeColor: "#125d3b",
};

const installPromptCapture = `
  window.__makbulInstallPrompt = null;
  window.addEventListener("beforeinstallprompt", function (event) {
    event.preventDefault();
    window.__makbulInstallPrompt = event;
    window.dispatchEvent(new Event("makbul-install-ready"));
  });
`;

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="tr" className={`${outfit.variable} ${robotoMono.variable}`}>
      <body>
        <script dangerouslySetInnerHTML={{ __html: installPromptCapture }} />
        {children}
      </body>
    </html>
  );
}
