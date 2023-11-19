import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue2'
import { resolve } from 'path'

export default defineConfig({
  resolve: {
    extensions: [".mjs", ".js", ".ts", ".jsx", ".tsx", ".json", ".vue"],
    alias: {
      '@': resolve(__dirname, './src'),
      '@assets': resolve(__dirname, 'app/assets'),
    },
  },

  plugins: [
    RubyPlugin(),
    vue(),
  ],
})
