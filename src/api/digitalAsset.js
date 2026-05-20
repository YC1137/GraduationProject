import request from './request'

// ── 数字藏品列表缓存（30 分钟 TTL）──────────────────────────
const DC_CACHE_KEY      = 'digital_collection_list_cache'
const DC_CACHE_TIME_KEY = 'digital_collection_list_cache_time'
const DC_CACHE_TTL      = 30 * 60 * 1000

const readDCCache = () => {
  try {
    const time = parseInt(localStorage.getItem(DC_CACHE_TIME_KEY) || '0', 10)
    if (Date.now() - time > DC_CACHE_TTL) return null
    const raw = localStorage.getItem(DC_CACHE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

const writeDCCache = (data) => {
  try {
    localStorage.setItem(DC_CACHE_KEY, JSON.stringify(data))
    localStorage.setItem(DC_CACHE_TIME_KEY, String(Date.now()))
  } catch {
    // 容量不足时忽略
  }
}

export const mintDigitalAsset = async (payload) => {
  return request.post('/digital-asset/mint', payload, { timeout: 15000 })
}

/**
 * 根据测评分数和专题查询可领取的奖励藏品
 * topicName 为空时退化为仅按分数查询（不限专题的藏品）
 */
export const getCollectionByScore = async (score, topicName = '') => {
  const params = { score }
  if (topicName) params.topicName = topicName
  return request.get('/digital-collection/reward', { params })
}

export const getUserDigitalAssets = async (userId) => {
  return request.get(`/digital-asset/user/${userId}`)
}

export const getDigitalCollectionList = async (saleStatus) => {
  // 仅全量请求（无 saleStatus 过滤）才走缓存
  if (!saleStatus) {
    const cached = readDCCache()
    if (cached) return cached
  }
  const params = saleStatus ? { saleStatus } : {}
  const result = await request.get('/digital-collection/list', { params })
  if (!saleStatus && result) {
    writeDCCache(result)
  }
  return result
}

/**
 * 清除数字藏品列表缓存（管理员操作后调用）
 */
export const clearDigitalCollectionCache = () => {
  localStorage.removeItem(DC_CACHE_KEY)
  localStorage.removeItem(DC_CACHE_TIME_KEY)
}
