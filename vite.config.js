import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  // 加载环境变量
  const env = loadEnv(mode, process.cwd())
  
  // 判断是否为生产环境
  const isProduction = mode === 'production'
  
  return {
    plugins: [vue()],
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src')
      }
    },
    server: {
      port: 3000,
      host: '0.0.0.0',
      open: false,
      cors: true,
      proxy: {
        // 上传文件代理
        '/api/uploads': {
          target: 'http://localhost:8080',
          changeOrigin: true
        },
        // 后端 API 代理
        '/api': {
          target: 'http://localhost:8080',
          changeOrigin: true
        },
        // 上传文件代理
        '/uploads': {
          target: 'http://localhost:8080',
          changeOrigin: true
        },
        // AI 接口代理
        '/ai-proxy': {
          target: 'https://api.siliconflow.cn',
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/ai-proxy/, '')
        }
      }
    },
    // 生产环境构建配置
    build: {
      outDir: 'dist',
      assetsDir: 'assets',
      sourcemap: false,
      chunkSizeWarningLimit: 1500
    }
  }
})
