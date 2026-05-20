import request from './request'
import { rsaEncrypt } from '@/utils/crypto'

/**
 * 用户登录（密码用服务端RSA公钥加密后传输）
 */
export const login = async (username, password) => {
    const encryptedPassword = await rsaEncrypt(password)
    return request.post('/user/login', { username, encryptedPassword })
}

/**
 * 用户注册（密码用服务端RSA公钥加密后传输）
 */
export const register = async (username, password, email, nickname) => {
    const encryptedPassword = await rsaEncrypt(password)
    return request.post('/user/register', { username, encryptedPassword, email, nickname })
}

/**
 * 上传并更新头像
 */
export const uploadAvatar = async (userId, file) => {
    const formData = new FormData()
    formData.append('file', file)
    return request.post(`/user/avatar/${userId}`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
    })
}

/**
 * 切换收藏
 */
export const toggleFavorite = async (heritageId, userId) => {
    return request.post(`/user/favorite/${heritageId}`, null, { params: { userId } })
}

/**
 * 切换点赞
 */
export const toggleLike = async (heritageId, userId) => {
    return request.post(`/user/like/${heritageId}`, null, { params: { userId } })
}

/**
 * 获取用户收藏列表（ID）
 */
export const getUserFavorites = async (userId) => {
    return request.get(`/user/favorites/${userId}`)
}

/**
 * 获取用户收藏详情列表（完整遗产数据）
 */
export const getUserFavoritesDetail = async (userId) => {
    return request.get(`/user/favorites-detail/${userId}`)
}


/**
 * 获取用户点赞列表（ID）
 */
export const getUserLikes = async (userId) => {
    return request.get(`/user/likes/${userId}`)
}

/**
 * 获取用户点赞详情列表（完整遗产数据）
 */
export const getUserLikesDetail = async (userId) => {
    return request.get(`/user/likes-detail/${userId}`)
}

/**
 * 更新用户昵称
 */
export const updateNickname = async (userId, nickname) => {
    return request.put(`/user/nickname/${userId}`, { nickname })
}

