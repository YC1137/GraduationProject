import request from './request'

// =============================================
// TODO: 在下方填入你的 AI API Key 和接口地址
// =============================================

const AI_API_KEY = 'sk-aewbwctbqsgqfbeeptoguwpvnkaprajjfxoeqpknnpvpqhod'
const AI_API_URL = 'https://api.siliconflow.cn/v1/chat/completions'
const AI_MODEL = 'deepseek-ai/DeepSeek-V3'

// =============================================

/**
 * 发送消息到 AI（直接调用第三方 API，不走后端）
 * @param {string} message - 用户输入的消息
 * @param {Array} history - 历史消息记录 [{role: 'user'|'assistant', content: '...'}]
 * @returns {Promise<string>} - AI 回复的文本
 */
export const sendChatMessage = async (message, history = []) => {
    if (!AI_API_KEY || !AI_API_URL) {
        throw new Error('请先在 src/api/ai.js 中填入 API Key 和接口地址')
    }

    const messages = [
        {
            role: 'system',
            content: '你叫"遗遗"，是一个专注于中国非物质文化遗产的可爱小助手～你的性格俏皮活泼、热情有趣，说话时喜欢用"哇""哎呀""嘿嘿""呀"之类的语气词，偶尔用一两个可爱的颜文字（如 (≧▽≦)、(*^▽^*)、ヾ(≧▽≦*)o），让对话轻松有趣。但你同时也很专业，能准确回答关于非遗项目、传统文化、民间技艺等方面的问题。回答时保持简洁，不要太啰嗦。如果用户问你是谁，你就说自己是"遗遗"，专门为大家介绍中国非遗文化的小伙伴～'
        },
        ...history,
        {
            role: 'user',
            content: message
        }
    ]

    const response = await fetch(AI_API_URL, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${AI_API_KEY}`
        },
        body: JSON.stringify({
            model: AI_MODEL,
            messages,
            stream: false
        })
    })

    if (!response.ok) {
        const err = await response.json().catch(() => ({}))
        throw new Error(err?.error?.message || `请求失败：${response.status}`)
    }

    const data = await response.json()
    return data.choices?.[0]?.message?.content || '暂无回复'
}

/**
 * （备选）通过后端代理调用 AI，避免前端暴露 Key
 * 需要后端在 /api/ai/chat 提供相应接口
 * @param {string} message
 * @param {Array} history
 */
export const sendChatMessageViaBackend = async (message, history = []) => {
    return request.post('/ai/chat', { message, history })
}
