// 用户认证状态管理
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login as apiLogin, register as apiRegister, uploadAvatar as apiUploadAvatar } from '../api/user'
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
            // 邮箱为空时传 null，避免后端把空字符串误判为重复邮箱
            const email = userData.email?.trim() || null
            await apiRegister(userData.username, userData.password, email)
            // 注册成功后自动登录
            return await login(userData)
        } catch (error) {
            // 错误消息已在 request.js 中统一弹出，这里不再重复显示
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

    // 更新头像
    const updateAvatar = async (file) => {
        const userId = currentUser.value?.userId
        if (!userId) return false
        try {
            const res = await apiUploadAvatar(userId, file)
            currentUser.value.avatar = res.avatar
            localStorage.setItem('currentUser', JSON.stringify(currentUser.value))
            ElMessage.success('头像更新成功')
            return true
        } catch (e) {
            ElMessage.error('头像上传失败')
            return false
        }
    }

    // 初始化
    initAuth()

    return {
        isLoggedIn,
        currentUser,
        login,
        register,
        logout,
        updateAvatar
    }
})
