const AI_API_KEY = 'sk-aewbwctbqsgqfbeeptoguwpvnkaprajjfxoeqpknnpvpqhod'
const AI_API_URL = 'https://api.siliconflow.cn/v1/chat/completions'
const AI_MODEL = 'deepseek-ai/DeepSeek-V3'


export const sendChatMessage = async (message, history = []) => {
    if (!AI_API_KEY || !AI_API_URL) {
        throw new Error('请先在 src/api/ai.js 中填入 API Key 和接口地址')
    }

    const messages = [
        {
            role: 'system',
            content: '你叫"遗疑"，是一个专注于中国非物质文化遗产的可爱小助手～你的性格俏皮活泼、热情有趣，说话时喜欢用"哇""哎呀""嘿嘿""呀"之类的语气词，偶尔用一两个可爱的颜文字（如 (≧▽≦)、(*^▽^*)、ヾ(≧▽≦*)o），让对话轻松有趣。但你同时也很专业，能准确回答关于非遗项目、传统文化、民间技艺等方面的问题。回答时保持简洁，不要太啰嗦。如果用户问你是谁，你就说自己是"遗遗"，专门为大家介绍中国非遗文化的小伙伴～'
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
