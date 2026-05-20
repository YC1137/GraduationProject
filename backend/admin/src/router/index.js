import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Layout from '../views/Layout.vue'
import Dashboard from '../views/Dashboard.vue'
import UserManagement from '../views/UserManagement.vue'
import HeritageManagement from '../views/HeritageManagement.vue'
import CommentManagement from '../views/CommentManagement.vue'
import QuizManagement from '../views/QuizManagement.vue'
import DigitalCollectionManagement from '../views/DigitalCollectionManagement.vue'
import BannerManagement from '../views/BannerManagement.vue'
import AnnouncementManagement from '../views/AnnouncementManagement.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: Dashboard
      },
      {
        path: 'users',
        name: 'UserManagement',
        component: UserManagement
      },
      {
        path: 'heritage',
        name: 'HeritageManagement',
        component: HeritageManagement
      },
      {
        path: 'comments',
        name: 'CommentManagement',
        component: CommentManagement
      },
      {
        path: 'quiz',
        name: 'QuizManagement',
        component: QuizManagement
      },
      {
        path: 'digital-collection',
        name: 'DigitalCollectionManagement',
        component: DigitalCollectionManagement
      },
      {
        path: 'banner',
        name: 'BannerManagement',
        component: BannerManagement
      },
      {
        path: 'announcement',
        name: 'AnnouncementManagement',
        component: AnnouncementManagement
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory('/admin/'),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('adminToken')
  if (to.path !== '/login' && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router
