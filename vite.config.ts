import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue2'
// import * as path from 'path'
import { resolve } from 'path'

export default defineConfig({
  // define: {
  //   global: {
  //     process: 'aaa',
  //   }
  // },

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
