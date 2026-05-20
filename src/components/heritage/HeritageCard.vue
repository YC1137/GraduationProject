<template>
    <div class="heritage-card" @click="goToDetail">
      <!-- 缩略图 -->
      <div class="card-image">
        <img 
          v-lazy="heritage.thumbnail" 
          :alt="heritage.name"
          loading="lazy"
        />
        <div class="image-overlay">
          <el-tag :type="levelType" size="large">{{ heritage.level }}</el-tag>
        </div>
      </div>
      
      <!-- 内容区域 -->
      <div class="card-content">
        <h3 class="card-title">{{ heritage.name }}</h3>
        
        <div class="card-meta">
          <span class="meta-item">
            <el-icon><Location /></el-icon>
            {{ heritage.region }}
          </span>
          <span class="meta-item">
            <el-icon><Histogram /></el-icon>
            {{ heritage.category }}
          </span>
        </div>
        
        <p class="card-desc">{{ heritage.description }}</p>
        
        <div class="card-footer">
          <div class="stats">
            <span class="stat-item">
              <el-icon><View /></el-icon>
              {{ formatNumber(heritage.views) }}
            </span>
            <span class="stat-item">
              <el-icon><Star /></el-icon>
              {{ formatNumber(heritage.likes) }}
            </span>
          </div>
          
          <el-button type="primary" link>
            查看详情
            <el-icon class="el-icon--right"><ArrowRight /></el-icon>
          </el-button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { computed } from 'vue'
  import { useRouter } from 'vue-router'
  
  const props = defineProps({
    heritage: {
      type: Object,
      required: true
    }
  })
  
  const router = useRouter()
  
  const levelType = computed(() => {
    const levelMap = {
      '国家级': 'danger',
      '省级': 'warning',
      '市级': 'success'
    }
    return levelMap[props.heritage.level] || 'info'
  })
  
  const goToDetail = () => {
    router.push(`/detail/${props.heritage.id}`)
  }
  
  const formatNumber = (num) => {
    if (num >= 10000) {
      return (num / 10000).toFixed(1) + 'w'
    }
    return num
  }
  
  // 懒加载指令
  const vLazy = {
    mounted(el, binding) {
      const loadImage = () => {
        el.src = binding.value
        el.classList.add('loaded')
      }
      
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            loadImage()
            observer.unobserve(el)
          }
        })
      })
      
      observer.observe(el)
    }
  }
  </script>
  
  <style lang="scss" scoped>
  .heritage-card {
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    overflow: hidden;
    cursor: pointer;
    transition: var(--transition);
    
    &:hover {
      box-shadow: var(--shadow-lg);
      transform: translateY(-8px);
      
      .card-image img {
        transform: scale(1.1);
      }
    }
  }
  
  .card-image {
    width: 100%;
    height: 220px;
    overflow: hidden;
    position: relative;
    background: var(--bg-dark);
    
    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
      opacity: 0;
      
      &.loaded {
        opacity: 1;
        transition: opacity 0.3s ease, transform 0.5s ease;
      }
    }
  }
  
  .image-overlay {
    position: absolute;
    top: 15px;
    right: 15px;
    
    .el-tag {
      font-weight: 600;
      backdrop-filter: blur(5px);
    }
  }
  
  .card-content {
    padding: 20px;
  }
  
  .card-title {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 12px;
    color: var(--text-primary);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  
  .card-meta {
    display: flex;
    gap: 15px;
    margin-bottom: 12px;
    flex-wrap: wrap;
  }
  
  .meta-item {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 14px;
    color: var(--text-secondary);
    
    .el-icon {
      color: var(--primary-color);
    }
  }
  
  .card-desc {
    font-size: 14px;
    color: var(--text-secondary);
    line-height: 1.6;
    margin-bottom: 15px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
  
  .card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 15px;
    border-top: 1px solid var(--border-light);
  }
  
  .stats {
    display: flex;
    gap: 15px;
  }
  
  .stat-item {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 13px;
    color: var(--text-light);
    
    .el-icon {
      font-size: 16px;
    }
  }
  </style>
  