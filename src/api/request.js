import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建 axios 实例
const request = axios.create({
    // 动态获取当前访问的主机名，解决手机端访问时 localhost 指向错误的问题
    baseURL: import.meta.env.VITE_API_BASE_URL?.includes('localhost') 
        ? `http://${window.location.hostname}:8080/api`
        : (import.meta.env.VITE_API_BASE_URL || `http://${window.location.hostname}:8080/api`),
    timeout: 10000,
    headers: {
        'Content-Type': 'application/json'
    }
})

// 请求拦截器
request.interceptors.request.use(
    config => {
        // 可以在这里添加 token 等认证信息
        const token = localStorage.getItem('token')
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }
        return config
    },
    error => {
        console.error('请求错误:', error)
        return Promise.reject(error)
    }
)

// 响应拦截器
request.interceptors.response.use(
    response => {
        console.log('Response interceptor - status:', response.status, 'data:', response.data)
        
        // 后端返回格式: { code: 200, message: "success", data: ... }
        const res = response.data
        
        // 如果是文件下载等特殊情况，直接返回
        if (response.config.responseType === 'blob') {
            return response
        }
        
        // 检查是否是标准的后端响应格式
        if (res && typeof res === 'object' && 'code' in res) {
            if (res.code === 200) {
                return res.data  // 返回 data 字段
            } else {
                // 对于登录接口的特殊处理，统一错误消息并显示
                if (response.config.url?.includes('/user/login')) {
                    console.log('Login error in success handler:', res.message)
                    ElMessage.error('账号或密码错误')
                    // 抛出一个特殊标记的错误，避免在错误拦截器中被重复处理
                    const error = new Error('账号或密码错误')
                    error.__isLoginError = true
                    return Promise.reject(error)
                }
                ElMessage.error(res.message || '请求失败')
                return Promise.reject(new Error(res.message || '请求失败'))
            }
        }
        
        // 兜底：直接返回响应数据
        return res
    },
    error => {
        // 如果是登录错误已经被处理过，直接返回，不重复显示
        if (error.__isLoginError) {
            console.log('Login error already handled, skipping...')
            return Promise.reject(error)
        }

        console.log('Error interceptor:', error.config?.url, error.message, error.response?.status, error.response?.data)
        
        // 对于登录接口，直接显示账号或密码错误，不进入下面的状态码判断
        if (error.config?.url?.includes('/user/login')) {
            console.log('Login error in error handler')
            ElMessage.error('账号或密码错误')
            return Promise.reject(error)
        }

        let message = '网络请求失败'

        if (error.response) {
            switch (error.response.status) {
                case 400:
                    message = '请求参数错误'
                    break
                case 401:
                    message = '未授权，请登录'
                    break
                case 403:
                    message = '拒绝访问'
                    break
                case 404:
                    message = '请求地址不存在'
                    break
                case 500:
                    message = '服务器内部错误'
                    break
                default:
                    message = error.response.data?.message || '请求失败'
            }
        }

        ElMessage.error(message)
        return Promise.reject(error)
    }
)

export default request