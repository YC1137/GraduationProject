import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useLoadingStore = defineStore('loading', () => {
    const isLoading = ref(false)
    const loadingText = ref('加载中...')

    const showLoading = (text = '加载中...') => {
        isLoading.value = true
        loadingText.value = text
    }

    const hideLoading = () => {
        isLoading.value = false
    }

    return {
        isLoading,
        loadingText,
        showLoading,
        hideLoading
    }
})