/*
 * @Author: YC1137 3030924277@qq.com
 * @Date: 2026-03-04 17:43:10
 * @LastEditors: YC1137 3030924277@qq.com
 * @LastEditTime: 2026-03-27 21:24:30
 * @FilePath: \bysj3 - 副本 - 副本 (3) - 副本\backend\admin\vite.config.js
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  base: "/admin/",
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      }
    }
  }
})
