import axios from 'axios'
import { ElMessage } from 'element-plus'

/**
 * 从 Cookie 中读取 token
 */
const getTokenFromCookie = () => {
    const cookies = document.cookie.split(';')
    for (let i = 0; i < cookies.length; i++) {
        const cookie = cookies[i].trim()
        if (cookie.startsWith('token=')) {
            return cookie.substring('token='.length)
        }
    }
    return null
}

/**
 * 获取 token（优先从 localStorage，如果没有则从 cookie）
 */
const getToken = () => {
    return localStorage.getItem('token') || getTokenFromCookie()
}

// 创建 axios 实例
const request = axios.create({
    // 后端服务器地址 - 固定使用 yichengjiang:8080
    // 如果需要修改为其他地址，请更改下面这行
    baseURL: 'http://yichengjiang:8080/api',
    timeout: 10000,
    headers: {
        'Content-Type': 'application/json'
    }
})

// 请求拦截器
request.interceptors.request.use(
    config => {
        // 优先从 localStorage 获取 token，如果没有则从 cookie 获取
        const token = getToken()
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }
        
        // 打印登录请求的详细信息
        if (config.url?.includes('/user/login') || config.url?.includes('/user/register')) {
            console.log('=== 请求拦截器 ===')
            console.log('请求URL:', config.url)
            console.log('请求数据:', config.data)
            console.log('请求头:', config.headers)
            console.log('=== 请求拦截器结束 ===')
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
        console.log('Response config URL:', response.config.url)
        console.log('Response request data:', response.config.data)
        
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
                const businessError = new Error(res.message || '请求失败')
                businessError.__handled = true
                businessError.__backendCode = res.code
                businessError.config = response.config
                return Promise.reject(businessError)
            }
        }
        
        // 兜底：直接返回响应数据
        return res
    },
    error => {
        // 业务错误已在成功拦截器里提示过，避免重复提示
        if (error.__handled || error.__isLoginError) {
            return Promise.reject(error)
        }

        console.log('Error interceptor:', error.config?.url, error.message, error.response?.status, error.response?.data)

        // 对于登录接口，直接显示账号或密码错误，不进入下面的状态码判断
        if (error.config?.url?.includes('/user/login')) {
            ElMessage.error('账号或密码错误')
            return Promise.reject(error)
        }

        let message = error.message || '网络请求失败'

        if (error.code === 'ECONNABORTED') {
            message = '请求超时，请稍后重试'
        } else if (error.response) {
            switch (error.response.status) {
                case 400:
                    message = error.response.data?.message || '请求参数错误'
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
                    message = error.response.data?.message || '服务器内部错误'
                    break
                default:
                    message = error.response.data?.message || message
            }
        }

        ElMessage.error(message)
        return Promise.reject(error)
    }
)

export default request