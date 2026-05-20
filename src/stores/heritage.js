import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getHeritageList, getHeritageDetail } from '@/api/heritage'

const CACHE_KEY_LIST      = 'heritage_list_cache_v4'
const CACHE_KEY_LIST_TIME = 'heritage_list_cache_time_v4'
const CACHE_TTL           = 30 * 60 * 1000 // 30 分钟

// 只缓存首页/列表页用到的轻量字段，避免 localStorage 超限
const SLIM_FIELDS = ['id', 'name', 'thumbnail', 'sidebarImage', 'sidebar_image', 'category', 'region', 'level', 'views', 'enabled']

const slimItem = (item) => {
    const o = {}
    SLIM_FIELDS.forEach(k => { if (k in item) o[k] = item[k] })
    return o
}

const readListCache = () => {
    try {
        const time = parseInt(localStorage.getItem(CACHE_KEY_LIST_TIME) || '0', 10)
        if (Date.now() - time > CACHE_TTL) return null
        const raw = localStorage.getItem(CACHE_KEY_LIST)
        return raw ? JSON.parse(raw) : null
    } catch {
        return null
    }
}

const writeListCache = (data) => {
    try {
        const slim = data.map(slimItem)
        localStorage.setItem(CACHE_KEY_LIST, JSON.stringify(slim))
        localStorage.setItem(CACHE_KEY_LIST_TIME, String(Date.now()))
    } catch {
        // 存储失败（如容量不足）忽略，下次访问会重新请求
    }
}

export const useHeritageStore = defineStore('heritage', () => {
    const heritageList = ref([])
    const currentHeritage = ref(null)
    const categories = ref(['传统技艺', '传统戏剧', '传统美术', '传统音乐', '民俗'])
    const regions = ref(['江苏', '陕西', '贵州', '浙江', '湖南'])
    const levels = ref(['国家级', '省级', '市级'])

    // 获取非遗项目列表（带本地缓存，30 分钟内不重复请求）
    const fetchHeritageList = async (params = {}) => {
        try {
            // 无额外 params 时才使用缓存（分页/搜索请求不走缓存）
            const useCache = Object.keys(params).length === 0
            if (useCache) {
                const cached = readListCache()
                if (cached) {
                    heritageList.value = cached
                    return cached
                }
            }

            const data = await getHeritageList(params)
            heritageList.value = data

            if (useCache) {
                writeListCache(data)
            }

            return data
        } catch (error) {
            console.error('获取非遗列表失败:', error)
            // 请求失败时如果有旧缓存（即使过期）也返回，减少白屏
            try {
                const raw = localStorage.getItem(CACHE_KEY_LIST)
                if (raw) return JSON.parse(raw)
            } catch {}
            return []
        }
    }

    // 清除缓存（管理员操作后可调用）
    const clearHeritageListCache = () => {
        localStorage.removeItem(CACHE_KEY_LIST)
        localStorage.removeItem(CACHE_KEY_LIST_TIME)
    }

    // 获取非遗项目详情（详情不走列表缓存）
    const fetchHeritageDetail = async (id) => {
        try {
            const data = await getHeritageDetail(id)
            currentHeritage.value = data
            return data
        } catch (error) {
            console.error('获取非遗详情失败:', error)
            return null
        }
    }

    return {
        heritageList,
        currentHeritage,
        categories,
        regions,
        levels,
        fetchHeritageList,
        fetchHeritageDetail,
        clearHeritageListCache
    }
})
