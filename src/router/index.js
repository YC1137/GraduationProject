import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { ElMessage } from 'element-plus'

const routes = [
    {
        path: '/',
        name: 'Home',
        component: () => import('../views/Home.vue'),
        meta: { title: '首页' }
    },
    {
        path: '/category',
        name: 'Category',
        component: () => import('../views/heritage/Category.vue'),
        meta: { title: '分类浏览' }
    },
    {
        path: '/detail/:id',
        name: 'Detail',
        component: () => import('../views/heritage/HeritageDetail.vue'),
        meta: { title: '项目详情' }
    },
    {
        path: '/quiz',
        name: 'Quiz',
        component: () => import('../views/game/Quiz.vue'),
        meta: { title: '知识测验', requiresAuth: true }
    },
    {
        path: '/profile',
        name: 'UserCenter',
        component: () => import('../views/user/UserCenter.vue'),
        meta: { title: '个人中心', requiresAuth: true }
    },
    {
        path: '/comments',
        name: 'Comments',
        component: () => import('../views/admin/CommentReview.vue'),
        meta: { title: '评论审核' }
    },
    {
        path: '/ai-chat',
        name: 'AiChat',
        component: () => import('../views/chat/AiChat.vue'),
        meta: { title: 'AI智能问答' }
        // 注意：登录拦截在页面内部处理（展示遮罩），不在路由守卫拦截
    },
    {
        path: '/digital-collection',
        name: 'DigitalCollection',
        component: () => import('../views/collection/DigitalCollection.vue'),
        meta: { title: '数字藏品' }
    },
    {
        path: '/heritage-map',
        name: 'HeritageMap',
        component: () => import('../views/heritage/HeritageMap.vue'),
        meta: { title: '非遗地图' }
    },
    {
        path: '/bomb',
        name: 'HeritageBomb',
        component: () => import('../views/game/HeritageBomb.vue'),
        meta: { title: '非遗炸弹', requiresAuth: true }
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes,
    scrollBehavior(to, from, savedPosition) {
        if (savedPosition) {
            return savedPosition
        } else {
            return { top: 0 }
        }
    }
})

// 路由守卫 - 登录验证和页面标题
router.beforeEach((to, from, next) => {
    document.title = to.meta.title ? `${to.meta.title} - 遗见` : '遗见'
    
    // 检查是否需要登录
    if (to.meta.requiresAuth) {
        const authStore = useAuthStore()
        if (!authStore.isLoggedIn) {
            const msg = to.name === 'HeritageBomb' ? '请先登录后再来挑战非遗炸弹' : '请先登录后再进行答题'
            ElMessage.warning(msg)
            next('/')
            return
        }
    }
    
    next()
})

export default router
