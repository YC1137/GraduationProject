import request from './request'
import { mockHeritageData } from './mock'

/**
 * 获取非遗项目列表
 * @param {Object} params - 查询参数
 * @param {string} params.category - 类别
 * @param {string} params.region - 地域
 * @param {string} params.level - 级别
 * @param {string} params.keyword - 关键词
 * @returns {Promise}
 */
export const getHeritageList = async (params = {}) => {
    // 对接后端 API
    return request.get('/heritage/list', { params })
}

/**
 * 获取非遗项目详情
 * @param {string|number} id - 项目ID
 * @returns {Promise}
 */
export const getHeritageDetail = async (id) => {
    // 对接后端 API
    return request.get(`/heritage/detail/${id}`)
}

/**
 * 获取评论列表
 * @param {string|number} heritageId - 项目ID
 * @returns {Promise}
 */
export const getComments = async (heritageId) => {
    try {
        return await request.get(`/comment/${heritageId}`)
    } catch (error) {
        console.error('获取评论失败:', error)
        return []
    }
}

/**
 * 发布评论
 * @param {Object} data - 评论数据
 * @param {string|number} data.heritageId - 项目ID
 * @param {string} data.content - 评论内容
 * @returns {Promise}
 */
export const postComment = async (data) => {
    // 从 localStorage 获取当前用户信息
    const currentUserStr = localStorage.getItem('currentUser')
    let userId = 1 // 默认用户ID
    
    if (currentUserStr) {
        try {
            const currentUser = JSON.parse(currentUserStr)
            userId = currentUser.userId || 1
        } catch (error) {
            console.warn('解析用户信息失败，使用默认用户ID:', error)
        }
    }
    
    try {
        console.log('=== 前端发布评论调试信息 ===')
        console.log('发送的数据:', data)
        console.log('用户ID:', userId)
        
        const response = await request.post('/comment', data, { 
            params: { userId }
        })
        
        console.log('评论发布成功:', response)
        return response
    } catch (error) {
        console.error('发布评论失败:', error)
        console.error('错误详情:', error.response?.data)
        throw error
    }
}

/**
 * 切换评论点赞状态
 * @param {string|number} commentId - 评论ID
 * @returns {Promise}
 */
export const toggleCommentLike = async (commentId) => {
    // 从 localStorage 获取当前用户信息
    const currentUserStr = localStorage.getItem('currentUser')
    let userId = 1 // 默认用户ID
    
    if (currentUserStr) {
        try {
            const currentUser = JSON.parse(currentUserStr)
            userId = currentUser.userId || 1
        } catch (error) {
            console.warn('解析用户信息失败，使用默认用户ID:', error)
        }
    }
    
    try {
        return await request.post(`/comment/${commentId}/like`, null, { 
            params: { userId }
        })
    } catch (error) {
        console.error('点赞操作失败:', error)
        throw error
    }
}

/**
 * 管理员：获取待审核评论列表
 * @returns {Promise}
 */
export const getPendingComments = async () => {
    try {
        return await request.get('/comment/admin/pending')
    } catch (error) {
        console.error('获取待审核评论失败:', error)
        throw error
    }
}

/**
 * 管理员：获取所有评论列表（用于审核页面）
 * @returns {Promise}
 */
export const getAllComments = async () => {
    try {
        return await request.get('/comment/admin/all')
    } catch (error) {
        console.error('获取所有评论失败:', error)
        throw error
    }
}

/**
 * 管理员：审核评论
 * @param {string|number} commentId - 评论ID
 * @param {number} status - 审核状态：1-通过，2-拒绝
 * @returns {Promise}
 */
export const reviewComment = async (commentId, status) => {
    try {
        return await request.put(`/comment/admin/${commentId}/review`, null, {
            params: { status }
        })
    } catch (error) {
        console.error('审核评论失败:', error)
        throw error
    }
}

/**
 * 管理员：删除评论
 * @param {string|number} commentId - 评论ID
 * @returns {Promise}
 */
export const deleteComment = async (commentId) => {
    try {
        return await request.delete(`/comment/admin/${commentId}`)
    } catch (error) {
        console.error('删除评论失败:', error)
        throw error
    }
}