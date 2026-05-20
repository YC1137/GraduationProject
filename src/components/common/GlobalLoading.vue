<template>
    <div class="global-loading">
      <div class="loading-content">
        <div class="ink-drop"></div>
        <div class="ink-drop"></div>
        <div class="ink-drop"></div>
        <p class="loading-text">{{ loadingText }}</p>
      </div>
    </div>
  </template>
  
  <script setup>
  import { useLoadingStore } from '@/stores/AppLoading'
  import { storeToRefs } from 'pinia'
  
  const loadingStore = useLoadingStore()
  const { loadingText } = storeToRefs(loadingStore)
  </script>
  
  <style lang="scss" scoped>
  .global-loading {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(248, 244, 230, 0.9);
    backdrop-filter: blur(5px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  }
  
  .loading-content {
    text-align: center;
  }
  
  .ink-drop {
    width: 20px;
    height: 20px;
    background: var(--primary-color);
    border-radius: 50%;
    display: inline-block;
    margin: 0 8px;
    animation: ink-bounce 1.4s infinite ease-in-out both;
    
    &:nth-child(1) {
      animation-delay: -0.32s;
    }
    
    &:nth-child(2) {
      animation-delay: -0.16s;
    }
  }
  
  @keyframes ink-bounce {
    0%, 80%, 100% {
      transform: scale(0);
      opacity: 0.5;
    }
    40% {
      transform: scale(1);
      opacity: 1;
    }
  }
  
  .loading-text {
    margin-top: 20px;
    font-size: 16px;
    color: var(--text-primary);
    letter-spacing: 0.1em;
  }
  </style>
  