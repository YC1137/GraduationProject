import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getHeritageList, getHeritageDetail } from '@/api/heritage'

export const useHeritageStore = defineStore('heritage', () => {
    const heritageList = ref([])
    const currentHeritage = ref(null)
    const categories = ref(['传统技艺', '传统戏剧', '传统美术', '传统音乐', '民俗'])
    const regions = ref(['江苏', '陕西', '贵州', '浙江', '湖南'])
    const levels = ref(['国家级', '省级', '市级'])

    // 获取非遗项目列表
    const fetchHeritageList = async (params = {}) => {
        try {
            const data = await getHeritageList(params)
            heritageList.value = data
            return data
        } catch (error) {
            console.error('获取非遗列表失败:', error)
            return []
        }
    }

    // 获取非遗项目详情
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
        fetchHeritageDetail
    }
})