import request from './request'

/**
 * 获取所有测验题目
 */
export const getQuizQuestions = async () => {
    return request.get('/quiz/questions')
}

/**
 * 获取所有专题名称
 */
export const getQuizTopics = async () => {
    return request.get('/quiz/topics')
}

/**
 * 根据专题获取题目
 */
export const getQuestionsByTopic = async (topicName) => {
    return request.get(`/quiz/questions/topic/${encodeURIComponent(topicName)}`)
}

/**
 * 提交答题记录
 */
export const submitQuizRecord = async (record) => {
    return request.post('/quiz/records', record)
}

/**
 * 获取总排行榜
 */
export const getTopRankings = async (limit = 100) => {
    return request.get('/quiz/rankings/top', { params: { limit } })
}

/**
 * 获取专题排行榜
 */
export const getTopicRanking = async (topicName, limit = 100) => {
    return request.get(`/quiz/rankings/topic/${encodeURIComponent(topicName)}`, { params: { limit } })
}

/**
 * 获取用户最佳记录
 */
export const getUserBestRecord = async (userId, topicName) => {
    return request.get(`/quiz/users/${userId}/topics/${encodeURIComponent(topicName)}/best`)
}

/**
 * 获取用户答题历史
 */
export const getUserHistory = async (userId) => {
    return request.get(`/quiz/users/${userId}/history`)
}

