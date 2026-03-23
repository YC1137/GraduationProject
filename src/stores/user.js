import { defineStore } from 'pinia'
import { ref } from 'vue'
import { toggleFavorite as apiToggleFavorite, toggleLike as apiToggleLike, getUserFavorites, getUserLikes } from '../api/user'
import { ElMessage } from 'element-plus'

export const useUserStore = defineStore('user', () => {
    // 用户收藏的非遗项目ID列表
    const favorites = ref(JSON.parse(localStorage.getItem('favorites') || '[]'))

    // 用户点赞的非遗项目ID列表
    const likes = ref(JSON.parse(localStorage.getItem('likes') || '[]'))

    // 用户点赞的评论ID列表
    const commentLikes = ref(JSON.parse(localStorage.getItem('commentLikes') || '[]'))

    // 从后端加载用户数据
    const loadUserData = async (userId) => {
        try {
            const [favs, lks] = await Promise.all([
                getUserFavorites(userId),
                getUserLikes(userId)
            ])
            favorites.value = favs
            likes.value = lks
            localStorage.setItem('favorites', JSON.stringify(favorites.value))
            localStorage.setItem('likes', JSON.stringify(likes.value))
        } catch (error) {
            console.error('加载用户数据失败:', error)
        }
    }

    // 切换收藏
    const toggleFavorite = async (heritageId) => {
        const userId = JSON.parse(localStorage.getItem('currentUser'))?.userId
        if (!userId) {
            ElMessage.warning('请先登录')
            return
        }

        try {
            const response = await apiToggleFavorite(heritageId, userId)
            if (response.isFavorite) {
                favorites.value.push(heritageId)
                ElMessage.success('收藏成功')
            } else {
                const index = favorites.value.indexOf(heritageId)
                if (index > -1) favorites.value.splice(index, 1)
                ElMessage.success('已取消收藏')
            }
            localStorage.setItem('favorites', JSON.stringify(favorites.value))
        } catch (error) {
            ElMessage.error('操作失败')
        }
    }

    // 切换点赞
    const toggleLike = async (heritageId) => {
        const userId = JSON.parse(localStorage.getItem('currentUser'))?.userId
        if (!userId) {
            ElMessage.warning('请先登录')
            return
        }

        try {
            const response = await apiToggleLike(heritageId, userId)
            if (response.isLiked) {
                likes.value.push(heritageId)
            } else {
                const index = likes.value.indexOf(heritageId)
                if (index > -1) likes.value.splice(index, 1)
            }
            localStorage.setItem('likes', JSON.stringify(likes.value))
        } catch (error) {
            ElMessage.error('操作失败')
        }
    }

    // 判断是否收藏
    const isFavorite = (heritageId) => {
        return favorites.value.includes(heritageId)
    }

    // 判断是否点赞
    const isLiked = (heritageId) => {
        return likes.value.includes(heritageId)
    }

    // 切换评论点赞（本地状态管理）
    const toggleCommentLike = (commentId) => {
        const index = commentLikes.value.indexOf(commentId)
        if (index > -1) {
            commentLikes.value.splice(index, 1)
        } else {
            commentLikes.value.push(commentId)
        }
        localStorage.setItem('commentLikes', JSON.stringify(commentLikes.value))
        return commentLikes.value.includes(commentId)
    }

    // 判断是否点赞评论
    const isCommentLiked = (commentId) => {
        return commentLikes.value.includes(commentId)
    }

    return {
        favorites,
        likes,
        commentLikes,
        loadUserData,
        toggleFavorite,
        toggleLike,
        toggleCommentLike,
        isFavorite,
        isLiked,
        isCommentLiked
    }
})