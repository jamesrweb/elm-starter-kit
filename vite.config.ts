import { join } from "path";
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";
import elmPlugin from "vite-plugin-elm";

const rootDirectory = import.meta.dirname;
const frontendRoot = join(rootDirectory, "src", "frontend");
const backendRoot = join(rootDirectory, "src", "backend");
const outputRoot = join(rootDirectory, "dist");

export default defineConfig({
  root: frontendRoot,
  plugins: [elmPlugin(), tailwindcss()],
  server: {
    open: true,
    https: {
      cert: join(backendRoot, "cert.pem"),
      key: join(backendRoot, "key.pem"),
    },
    proxy: {
      "/api": {
        target: "https://localhost:443",
        changeOrigin: true,
        secure: false,
      },
      "/api-spec": {
        target: "https://localhost:443",
        changeOrigin: true,
        secure: false,
      },
      "/api-docs": {
        target: "https://localhost:443",
        changeOrigin: true,
        secure: false,
      },
    },
  },
  build: {
    outDir: outputRoot,
    emptyOutDir: true,
  },
});
