<template>
    <div id="app" class="heritage-app">
      <!-- 开屏动画 (仅手机端显示) -->
      <SplashScreen v-if="showSplash" />

      <!-- 全局导航栏 -->
      <AppHeader v-if="!$route.meta.hideHeader" />
      
      <!-- 主内容区域 -->
      <main class="main-content">
        <router-view />
      </main>
      
      <!-- 全局页脚 -->
      <AppFooter v-if="!$route.meta.hideFooter" />
      
      <!-- 返回顶部按钮 -->
      <BackToTop />
      
      <!-- 右下角悬浮 AI 聊天（仅 PC 端） -->
      <AiChatFloat />
      
      <!-- 全局加载动画 -->
      <GlobalLoading v-if="isLoading" />
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, watch } from 'vue'
  import { useRoute } from 'vue-router'
  import AppHeader from './components/layout/AppHeader.vue'
  import AppFooter from './components/layout/AppFooter.vue'
import BackToTop from './components/common/BackToTop.vue'
import GlobalLoading from './components/common/GlobalLoading.vue'
import SplashScreen from './components/common/SplashScreen.vue'
import AiChatFloat from './components/common/AiChatFloat.vue'
  import { useLoadingStore } from './stores/AppLoading'
  import { storeToRefs } from 'pinia'
  
  const route = useRoute()
  const loadingStore = useLoadingStore()
  const { isLoading } = storeToRefs(loadingStore)

  const showSplash = ref(false)
  const isFirstVisit = ref(!sessionStorage.getItem('has_visited'))

  // 判断是否为手机端
  const checkIsMobile = () => {
    return window.innerWidth <= 768 || /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
  }

  // 监听路由变化，只有访问首页时才可能触发开屏
  watch(() => route.path, (newPath) => {
    if (newPath === '/' && isFirstVisit.value && checkIsMobile()) {
      showSplash.value = true
      isFirstVisit.value = false // 仅在当前会话的第一次进入首页时显示
      sessionStorage.setItem('has_visited', 'true')
    }
  }, { immediate: true })
  </script>
  
  <style lang="scss">
  .heritage-app {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    background: var(--bg-color);
  }
  
  .main-content {
    flex: 1;
    padding-top: 80px;
    min-height: calc(100vh - 80px - 200px);
  }
  
  // 路由切换动画
  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.3s ease;
  }
  
  .fade-enter-from,
  .fade-leave-to {
    opacity: 0;
  }
  </style>