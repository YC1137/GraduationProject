import request from './request'

/**
 * 提交一条炸弹游戏挑战成功记录
 * @param {Object} record { userId, username, projectName, winRound, leakedChar, messages }
 *   messages 为对话数组，会在此处序列化为 JSON 字符串
 */
export const submitBombRecord = (record) => {
    return request.post('/bomb/records', {
        ...record,
        messages: JSON.stringify(record.messages)
    })
}

/**
 * 获取荣耀榜（最新挑战成功记录）
 * @param {number} limit 条数，默认 20
 */
export const getBombLatest = (limit = 20) => {
    return request.get('/bomb/records/latest', { params: { limit } })
}

/**
 * 获取某用户的挑战成功记录
 */
export const getUserBombRecords = (userId) => {
    return request.get(`/bomb/records/user/${userId}`)
}
