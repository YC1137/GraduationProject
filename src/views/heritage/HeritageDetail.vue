<template>
    <div class="detail-page">
      <div class="container" v-if="heritage">
        <!-- 面包屑导航 -->
        <el-breadcrumb separator="/" class="breadcrumb">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/category' }">分类浏览</el-breadcrumb-item>
          <el-breadcrumb-item>{{ heritage.name }}</el-breadcrumb-item>
        </el-breadcrumb>
  
        <!-- 项目头部 -->
        <div class="detail-header">
          <div class="header-content">
            <h1 class="heritage-name">{{ heritage.name }}</h1>
            <div class="heritage-tags">
              <el-tag type="danger" size="large">{{ heritage.level }}</el-tag>
              <el-tag type="info" size="large">{{ heritage.category }}</el-tag>
              <el-tag type="success" size="large">{{ heritage.region }}</el-tag>
            </div>
            <div class="heritage-stats">
              <span class="stat-item">
                <el-icon><View /></el-icon>
                {{ heritage.views }} 次浏览
              </span>
              <span class="stat-item">
                <el-icon><Star /></el-icon>
                {{ heritage.likes }} 人点赞
              </span>
              <span class="stat-item">
                <el-icon><Collection /></el-icon>
                {{ heritage.favorites }} 人收藏
              </span>
            </div>
          </div>
          
        <!-- 互动按钮 -->
        <ActionButtons
          :heritage-id="heritage.id"
          :name="heritage.name"
          :likes="heritage.likes"
          :favorites="heritage.favorites"
        />
        </div>
  
        <!-- 主要内容 -->
        <div class="detail-content">
          <!-- 左侧内容 -->
          <div class="content-main">
            <!-- 图片展示 -->
            <section class="section-block">
              <h2 class="section-title">项目图片</h2>
              <div class="image-gallery">
                <el-image
                  v-for="(img, index) in heritage.images"
                  :key="index"
                  :src="img"
                  :preview-src-list="heritage.images"
                  :initial-index="index"
                  :preview-teleported="true"
                  fit="cover"
                  class="gallery-image"
                  loading="lazy"
                >
                  <template #error>
                    <div class="image-error">
                      <el-icon><Picture /></el-icon>
                      <span>图片加载失败</span>
                    </div>
                  </template>
                </el-image>
              </div>
            </section>
  
            <!-- 项目介绍 -->
            <section class="section-block">
              <h2 class="section-title">项目介绍</h2>
              <p class="heritage-intro">{{ heritage.detailDescription }}</p>
            </section>
  
            <!-- 视频展示 -->
            <section class="section-block" v-if="heritage.video">
              <h2 class="section-title">视频展示</h2>
              <video 
                :src="heritage.video" 
                controls 
                class="heritage-video"
                preload="metadata"
              >
                您的浏览器不支持视频播放
              </video>
            </section>
  
            <!-- 音频展示 -->
            <section class="section-block" v-if="heritage.audio">
              <h2 class="section-title">音频展示</h2>
              <audio 
                :src="heritage.audio" 
                controls 
                class="heritage-audio"
                preload="metadata"
              >
                您的浏览器不支持音频播放
              </audio>
            </section>
  
            <!-- 发展历程时间轴 -->
            <section class="section-block">
              <h2 class="section-title">发展历程</h2>
              <el-timeline class="heritage-timeline">
                <el-timeline-item
                  v-for="(item, index) in heritage.timeline"
                  :key="index"
                  :timestamp="item.year"
                  placement="top"
                  :color="index === 0 ? '#c8302b' : '#3d4e5c'"
                >
                  <el-card>
                    <p>{{ item.event }}</p>
                  </el-card>
                </el-timeline-item>
              </el-timeline>
            </section>
  
            <!-- 3D模型展示（可选） -->
            <section class="section-block" v-if="show3DModel">
              <h2 class="section-title">3D模型展示</h2>
              <div ref="modelContainer" class="model-container"></div>
            </section>
  
            <!-- 评论区 -->
            <CommentSection
              ref="commentSectionRef"
              :heritage-id="heritage.id"
            />
          </div>
  
          <!-- 右侧信息栏 -->
          <div class="content-sidebar">
            <!-- 基本信息 -->
            <div class="info-card">
              <h3 class="info-title">基本信息</h3>
              <div class="info-list">
                <div class="info-item">
                  <span class="info-label">项目名称：</span>
                  <span class="info-value">{{ heritage.name }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">所属类别：</span>
                  <span class="info-value">{{ heritage.category }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">所属地域：</span>
                  <span class="info-value">{{ heritage.region }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">保护级别：</span>
                  <span class="info-value">{{ heritage.level }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">代表传承人：</span>
                  <span class="info-value">{{ heritage.inheritor }}</span>
                </div>
              </div>
            </div>
  
            <!-- 相关推荐 -->
            <div class="info-card">
              <h3 class="info-title">相关推荐</h3>
              <div class="recommend-list">
                <div 
                  v-for="item in recommendList" 
                  :key="item.id"
                  class="recommend-item"
                  @click="goToDetail(item.id)"
                >
                  <img :src="item.thumbnail" :alt="item.name" />
                  <div class="recommend-info">
                    <h4>{{ item.name }}</h4>
                    <p>{{ item.category }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useHeritageStore } from '@/stores/heritage'
import { ElMessage } from 'element-plus'
import { View, Picture, Star, Collection } from '@element-plus/icons-vue'
import CommentSection from '@/components/heritage/CommentSection.vue'
import ActionButtons from '@/components/heritage/ActionButtons.vue'
  
  const route = useRoute()
  const router = useRouter()
  const heritageStore = useHeritageStore()

  // 将 localhost:port 替换为当前访问的 origin，解决手机端/远程访问无法加载本地上传图片的问题
  const fixImageUrl = (url) => {
    if (!url || typeof url !== 'string') return url
    const origin = window.location.origin  // e.g. http://47.121.115.74
    return url.replace(/http:\/\/localhost(:\d+)?/g, origin)
  }

  const heritage = ref(null)
  const recommendList = ref([])
  const commentSectionRef = ref(null)
  const show3DModel = ref(false) // 是否显示3D模型
  const modelContainer = ref(null)

  // 获取项目详情
  const fetchDetail = async () => {
    try {
      const id = route.params.id
      heritage.value = await heritageStore.fetchHeritageDetail(id)

      // 修复图片 URL（手机访问时 localhost 需替换为实际 IP）
      if (heritage.value) {
        if (heritage.value.thumbnail) {
          heritage.value.thumbnail = fixImageUrl(heritage.value.thumbnail)
        }
        if (Array.isArray(heritage.value.images)) {
          heritage.value.images = heritage.value.images.map(fixImageUrl)
        }
      }
      
      // 获取推荐列表（排除当前项目）
      const allList = await heritageStore.fetchHeritageList()
      if (Array.isArray(allList) && allList.length > 0) {
        recommendList.value = allList
          .filter(item => item.id !== heritage.value.id)
          .slice(0, 3)
          .map(item => ({ ...item, thumbnail: fixImageUrl(item.thumbnail) }))
      } else {
        recommendList.value = []
      }
    } catch (error) {
      ElMessage.error('获取项目详情失败')
      console.error(error)
    } finally {

    }
  }

  // 跳转到详情
  const goToDetail = (id) => {
    router.push(`/detail/${id}`)
    window.scrollTo(0, 0)
    fetchDetail()
  }
  
  onMounted(() => {
    fetchDetail()
  })
  </script>
  
  <style lang="scss" scoped>
  .detail-page {
    padding: 30px 0 80px;
    min-height: calc(100vh - 80px);
  }
  
  .breadcrumb {
    margin-bottom: 30px;
  }
  
  // 项目头部
  .detail-header {
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    padding: 30px;
    margin-bottom: 30px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 30px;
  }
  
  .heritage-name {
    font-size: 2.5rem;
    margin-bottom: 20px;
    color: var(--text-primary);
  }
  
  .heritage-tags {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
  }
  
  .heritage-stats {
    display: flex;
    gap: 30px;
    flex-wrap: wrap;
  }
  
  .stat-item {
    display: flex;
    align-items: center;
    gap: 6px;
    color: var(--text-secondary);
    font-size: 14px;
    
    .el-icon {
      font-size: 18px;
      color: var(--primary-color);
    }
  }
  
  // 内容区域
  .detail-content {
    display: grid;
    grid-template-columns: 1fr 350px;
    gap: 30px;
  }
  
  .content-main {
    min-width: 0;
  }
  
  .section-block {
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    padding: 30px;
    margin-bottom: 30px;
  }
  
  .section-title {
    font-size: 1.5rem;
    margin-bottom: 25px;
    color: var(--text-primary);
    padding-bottom: 15px;
    border-bottom: 2px solid var(--border-color);
    position: relative;
    
    &::after {
      content: '';
      position: absolute;
      bottom: -2px;
      left: 0;
      width: 60px;
      height: 2px;
      background: var(--primary-color);
    }
  }
  
  // 图片画廊
  .image-gallery {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 15px;
  }
  
  .gallery-image {
    width: 100%;
    height: 200px;
    border-radius: 8px;
    cursor: pointer;
    transition: var(--transition);
    overflow: hidden;
    
    :deep(.el-image__inner) {
      transition: transform 0.3s ease;
    }
    
    &:hover {
      box-shadow: var(--shadow-md);
      
      :deep(.el-image__inner) {
        transform: scale(1.05);
      }
    }
    
    :deep(.el-image__wrapper) {
      width: 100%;
      height: 100%;
    }
  }
  
  .image-error {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: var(--bg-dark);
    color: var(--text-light);
    gap: 10px;
    
    .el-icon {
      font-size: 40px;
    }
  }
  
  // 项目介绍
  .heritage-intro {
    line-height: 2;
    color: var(--text-primary);
    text-indent: 2em;
    font-size: 16px;
  }
  
  // 视频/音频
  .heritage-video,
  .heritage-audio {
    width: 100%;
    border-radius: 8px;
    background: #000;
  }
  
  // 时间轴
  .heritage-timeline {
    padding: 20px;
    
    :deep(.el-timeline-item__timestamp) {
      font-size: 16px;
      font-weight: 600;
      color: var(--primary-color);
    }
    
    :deep(.el-card) {
      border-color: var(--border-color);
      background: var(--bg-color);
    }
  }
  
  // 3D模型容器
  .model-container {
    width: 100%;
    height: 500px;
    background: var(--bg-dark);
    border-radius: 8px;
  }
  
  // 侧边栏
  .content-sidebar {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
  
  .info-card {
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    border-radius: 12px;
    padding: 25px;
  }
  
  .info-title {
    font-size: 1.2rem;
    margin-bottom: 20px;
    color: var(--text-primary);
    padding-bottom: 12px;
    border-bottom: 2px solid var(--border-color);
  }
  
  .info-list {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }
  
  .info-item {
    display: flex;
    flex-direction: column;
    gap: 5px;
  }
  
  .info-label {
    font-size: 13px;
    color: var(--text-light);
  }
  
  .info-value {
    font-size: 15px;
    color: var(--text-primary);
    font-weight: 500;
  }
  
  // 推荐列表
  .recommend-list {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }
  
  .recommend-item {
    display: flex;
    gap: 12px;
    cursor: pointer;
    padding: 10px;
    border-radius: 8px;
    transition: var(--transition);
    
    &:hover {
      background: var(--bg-dark);
    }
    
    img {
      width: 80px;
      height: 80px;
      object-fit: cover;
      border-radius: 6px;
    }
  }
  
  .recommend-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    
    h4 {
      font-size: 15px;
      color: var(--text-primary);
      margin-bottom: 5px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
    
    p {
      font-size: 13px;
      color: var(--text-secondary);
    }
  }
  
  // 响应式设计
  @media (max-width: 1024px) {
    .detail-content {
      grid-template-columns: 1fr;
    }
    
    .content-sidebar {
      order: -1;
    }
  }
  
  @media (max-width: 768px) {
    .detail-header {
      flex-direction: column;
    }
    
    .heritage-name {
      font-size: 1.8rem;
    }
    
    .action-buttons {
      width: 100%;
      
      button {
        flex: 1;
      }
    }
    
    .image-gallery {
      grid-template-columns: 1fr;
    }
  }
  </style>
  