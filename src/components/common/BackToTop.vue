<template>
    <transition name="fade">
      <div 
        v-show="visible" 
        class="back-to-top"
        @click="scrollToTop"
        :title="'返回顶部'"
      >
        <el-icon :size="24">
          <Top />
        </el-icon>
      </div>
    </transition>
  </template>
  
  <script setup>
  import { ref, onMounted, onUnmounted } from 'vue'
  
  const visible = ref(false)
  
  const handleScroll = () => {
    visible.value = window.scrollY > 300
  }
  
  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }
  
  onMounted(() => {
    window.addEventListener('scroll', handleScroll)
  })
  
  onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll)
  })
  </script>
  
  <style lang="scss" scoped>
  .back-to-top {
    position: fixed;
    bottom: 60px;
    right: 40px;
    width: 50px;
    height: 50px;
    background: var(--primary-color);
    color: #ffffff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: var(--shadow-md);
    transition: var(--transition);
    z-index: 999;
    
    &:hover {
      background: var(--primary-light);
      transform: translateY(-5px);
      box-shadow: var(--shadow-lg);
    }
    
    &:active {
      transform: translateY(-3px);
    }
  }
  
  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.3s ease;
  }
  
  .fade-enter-from,
  .fade-leave-to {
    opacity: 0;
  }
  
  @media (max-width: 768px) {
    .back-to-top {
      bottom: 30px;
      right: 20px;
      width: 45px;
      height: 45px;
    }
  }
  </style>