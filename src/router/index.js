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
        component: () => import('../views/Category.vue'),
        meta: { title: '分类浏览' }
    },
    {
        path: '/detail/:id',
        name: 'Detail',
        component: () => import('../views/Detail.vue'),
        meta: { title: '项目详情' }
    },
    {
        path: '/quiz',
        name: 'Quiz',
        component: () => import('../views/Quiz.vue'),
        meta: { title: '知识测验', requiresAuth: true }
    },
    {
        path: '/profile',
        name: 'UserCenter',
        component: () => import('../views/UserCenter.vue'),
        meta: { title: '个人中心', requiresAuth: true }
    },
    {
        path: '/comments',
        name: 'Comments',
        component: () => import('../views/Comments.vue'),
        meta: { title: '评论审核' }
    },
    {
        path: '/ai-chat',
        name: 'AiChat',
        component: () => import('../views/AiChat.vue'),
        meta: { title: 'AI智能问答' }
        // 注意：登录拦截在页面内部处理（展示遮罩），不在路由守卫拦截
    },
    {
        path: '/digital-collection',
        name: 'DigitalCollection',
        component: () => import('../views/DigitalCollection.vue'),
        meta: { title: '数字藏品' }
    },
    {
        path: '/heritage-map',
        name: 'HeritageMap',
        component: () => import('../views/HeritageMap.vue'),
        meta: { title: '非遗地图' }
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
    document.title = to.meta.title ? `${to.meta.title} - 非遗数字化展示平台` : '非遗数字化展示平台'
    
    // 检查是否需要登录
    if (to.meta.requiresAuth) {
        const authStore = useAuthStore()
        if (!authStore.isLoggedIn) {
            ElMessage.warning('请先登录后再进行答题')
            next('/')
            return
        }
    }
    
    next()
})

export default router