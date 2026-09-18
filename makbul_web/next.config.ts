import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  images: {
    unoptimized: true,
    remotePatterns: [
      {
        protocol: "https",
        hostname: "www.makbul.com",
        pathname: "/Content/global/images/products/**",
      },
    ],
  },
};

export default nextConfig;
