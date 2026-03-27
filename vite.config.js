import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 3000,
    host: '0.0.0.0',
    open: true,
    cors: true,
    allowedHosts: true,
    proxy: {
      // AI 接口代理：/ai-proxy/... → https://api.siliconflow.cn/...
      '/ai-proxy': {
        target: 'https://api.siliconflow.cn',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/ai-proxy/, '')
      }
    }
  },
  build: {
    // rollupOptions: {
    //   output: {
    //     manualChunks: {
    //       'element-plus': ['element-plus'],
    //       'vue-vendor': ['vue', 'vue-router', 'pinia']
    //     }
    //   }
    // }
  }
})
