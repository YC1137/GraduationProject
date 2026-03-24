import request from './request'

/**
 * 用户登录
 */
export const login = async (username, password) => {
    return request.post('/user/login', { username, password })
}

/**
 * 用户注册
 */
export const register = async (username, password, email) => {
    return request.post('/user/register', { username, password, email })
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

