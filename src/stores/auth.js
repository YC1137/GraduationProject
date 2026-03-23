// 用户认证状态管理
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login as apiLogin, register as apiRegister } from '../api/user'
import { ElMessage } from 'element-plus'

export const useAuthStore = defineStore('auth', () => {
    // 状态
    const isLoggedIn = ref(false)
    const currentUser = ref(null)

    // 从 localStorage 恢复登录状态
    const initAuth = () => {
        const savedUser = localStorage.getItem('currentUser')
        if (savedUser) {
            try {
                currentUser.value = JSON.parse(savedUser)
                isLoggedIn.value = true
            } catch (e) {
                localStorage.removeItem('currentUser')
            }
        }
    }

    // 登录
    const login = async (userData) => {
        try {
            const response = await apiLogin(userData.username, userData.password)
            currentUser.value = {
                userId: response.userId,
                username: response.username,
                email: response.email,
                avatar: response.avatar,
                token: response.token,
                loginTime: new Date().toISOString()
            }
            isLoggedIn.value = true
            localStorage.setItem('currentUser', JSON.stringify(currentUser.value))
            localStorage.setItem('token', response.token)
            ElMessage.success('登录成功')
            return true
        } catch (error) {
            // 错误消息已在 request.js 中统一处理，这里不再重复显示
            return false
        }
    }

    // 注册
    const register = async (userData) => {
        try {
            await apiRegister(userData.username, userData.password, userData.email)
            // 注册成功后自动登录
            return await login(userData)
        } catch (error) {
            ElMessage.error(error.response?.data?.message || '注册失败')
            return false
        }
    }

    // 登出
    const logout = () => {
        currentUser.value = null
        isLoggedIn.value = false
        localStorage.removeItem('currentUser')
        localStorage.removeItem('token')
        ElMessage.success('已退出登录')
    }

    // 初始化
    initAuth()

    return {
        isLoggedIn,
        currentUser,
        login,
        register,
        logout
    }
})
