<template>
    <div class="detail-page" v-loading="loading">
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
          <div class="action-buttons">
            <!-- 点赞 -->
            <button class="action-btn like-action" :class="{ active: isLiked }" @click="handleLike">
              <span class="action-bg"></span>
              <svg class="action-icon" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
              <span class="action-label">{{ isLiked ? '已点赞' : '点赞' }}</span>
              <span class="action-count">{{ heritage?.likes || 0 }}</span>
            </button>
            <!-- 收藏 -->
            <button class="action-btn fav-action" :class="{ active: isFavorited }" @click="handleFavorite">
              <span class="action-bg"></span>
              <svg class="action-icon" viewBox="0 0 24 24"><path d="M17 3H7c-1.1 0-2 .9-2 2v16l7-3 7 3V5c0-1.1-.9-2-2-2z"/></svg>
              <span class="action-label">{{ isFavorited ? '已收藏' : '收藏' }}</span>
              <span class="action-count">{{ heritage?.favorites || 0 }}</span>
            </button>
            <!-- 分享 -->
            <el-dropdown @command="handleShare" placement="bottom-end">
              <button class="action-btn share-action">
                <span class="action-bg"></span>
                <svg class="action-icon" viewBox="0 0 24 24"><path d="M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92s2.92-1.31 2.92-2.92-1.31-2.92-2.92-2.92z"/></svg>
                <span class="action-label">分享</span>
              </button>
              <template #dropdown>
                <el-dropdown-menu class="share-menu">
                  <el-dropdown-item command="weixin">
                    <svg viewBox="0 0 24 24" width="16" height="16" style="margin-right:8px;fill:#07c160"><path d="M9.5 12.5a1 1 0 100-2 1 1 0 000 2zm5 0a1 1 0 100-2 1 1 0 000 2zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>微信
                  </el-dropdown-item>
                  <el-dropdown-item command="weibo">
                    <svg viewBox="0 0 24 24" width="16" height="16" style="margin-right:8px;fill:#e6162d"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>微博
                  </el-dropdown-item>
                  <el-dropdown-item command="copy">
                    <svg viewBox="0 0 24 24" width="16" height="16" style="margin-right:8px;fill:#666"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>复制链接
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
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
            <section class="section-block">
              <h2 class="section-title">用户评论</h2>
              
              <!-- 发表评论 -->
              <div class="comment-form">
                <el-input
                  v-model="newComment"
                  type="textarea"
                  :rows="4"
                  placeholder="分享你对这个非遗项目的看法..."
                  maxlength="500"
                  show-word-limit
                />
                <el-button 
                  type="primary" 
                  @click="handlePostComment"
                  :loading="commentLoading"
                  style="margin-top: 15px;"
                >
                  发表评论
                </el-button>
              </div>
  
              <!-- 评论列表 -->
              <div class="comment-list">
                <div 
                  v-for="comment in comments" 
                  :key="comment.id"
                  class="comment-item"
                >
                  <el-avatar :src="comment.avatar" :size="50" />
                  <div class="comment-content">
                    <div class="comment-header">
                      <span class="comment-username">{{ comment.username }}</span>
                      <span class="comment-time">{{ formatTime(comment.createTime) }}</span>
                    </div>
                    <p class="comment-text">{{ comment.content }}</p>
                    <div class="comment-actions">
                      <button 
                        class="like-btn"
                        :class="{ 'liked': isCommentLiked(comment.id), 'just-liked': justLiked === comment.id }"
                        @click="toggleCommentLike(comment, $event)"
                      >
                        <!-- 涟漪层 -->
                        <span class="ripple"></span>
                        <!-- 粒子层 -->
                        <span v-if="justLiked === comment.id" class="particles">
                          <span v-for="i in 8" :key="i" class="particle" :style="getParticleStyle(i)"></span>
                        </span>
                        <!-- 爱心图标 -->
                        <svg class="heart-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                          <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                        <!-- 数字 -->
                        <span class="like-count">
                          <span class="count-num" :key="comment.likes">{{ comment.likes }}</span>
                        </span>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </section>
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
  import { ref, computed, onMounted } from 'vue'
  import { useRoute, useRouter } from 'vue-router'
  import { useHeritageStore } from '@/stores/heritage'
  import { useUserStore } from '@/stores/user'
  import { getComments, postComment, toggleCommentLike as toggleCommentLikeApi } from '@/api/heritage'
  import { ElMessage } from 'element-plus'
  import { 
    View,
    Picture
  } from '@element-plus/icons-vue'
  
  const route = useRoute()
  const router = useRouter()
  const heritageStore = useHeritageStore()
  const userStore = useUserStore()
  
  const loading = ref(false)
  const heritage = ref(null)
  const comments = ref([])
  const justLiked = ref(null) // 记录刚点赞的评论id，触发粒子动画
  const recommendList = ref([])
  const newComment = ref('')
  const commentLoading = ref(false)
  const show3DModel = ref(false) // 是否显示3D模型
  const modelContainer = ref(null)
  
  const isLiked = computed(() => 
    heritage.value ? userStore.isLiked(heritage.value.id) : false
  )
  
  const isFavorited = computed(() => 
    heritage.value ? userStore.isFavorite(heritage.value.id) : false
  )
  
  // 获取项目详情
  const fetchDetail = async () => {
    loading.value = true
    try {
      const id = route.params.id
      heritage.value = await heritageStore.fetchHeritageDetail(id)
      
      // 获取评论
      comments.value = await getComments(id)
      
      // 获取推荐列表（排除当前项目）
      const allList = await heritageStore.fetchHeritageList()
      // 确保 allList 是数组
      if (Array.isArray(allList) && allList.length > 0) {
        recommendList.value = allList
          .filter(item => item.id !== heritage.value.id)
          .slice(0, 3)
      } else {
        recommendList.value = []
      }
    } catch (error) {
      ElMessage.error('获取项目详情失败')
      console.error(error)
    } finally {
      loading.value = false
    }
  }
  
  // 点赞
  const handleLike = () => {
    userStore.toggleLike(heritage.value.id)
    ElMessage.success(isLiked.value ? '点赞成功' : '取消点赞')
  }
  
  // 收藏
  const handleFavorite = () => {
    userStore.toggleFavorite(heritage.value.id)
    ElMessage.success(isFavorited.value ? '收藏成功' : '取消收藏')
  }
  
  // 分享
  const handleShare = (command) => {
    const url = window.location.href
    
    switch (command) {
      case 'weixin':
        ElMessage.info('请使用微信扫描二维码分享')
        break
      case 'weibo':
        window.open(`https://service.weibo.com/share/share.php?url=${encodeURIComponent(url)}&title=${heritage.value.name}`)
        break
      case 'copy':
        navigator.clipboard.writeText(url)
        ElMessage.success('链接已复制到剪贴板')
        break
    }
  }
  
  // 发表评论
  const handlePostComment = async () => {
    if (!newComment.value.trim()) {
      ElMessage.warning('请输入评论内容')
      return
    }
    
    commentLoading.value = true
    try {
      console.log('=== 发布评论调试信息 ===')
      console.log('route.params.id:', route.params.id)
      console.log('heritage.value.id:', heritage.value.id)
      console.log('heritage.value:', heritage.value)
      
      const commentData = {
        heritageId: heritage.value.id,
        content: newComment.value
      }
      
      console.log('发送的评论数据:', commentData)
      
      await postComment(commentData)
      
      ElMessage.success('评论发布成功，等待管理员审核后显示')
      newComment.value = ''
      
      // 重新获取评论列表
      console.log('重新获取评论，heritageId:', heritage.value.id)
      comments.value = await getComments(heritage.value.id)
      console.log('获取到的评论数量:', comments.value.length)
    } catch (error) {
      ElMessage.error('评论发布失败')
    } finally {
      commentLoading.value = false
    }
  }
  
  // 格式化时间
  const formatTime = (time) => {
    if (!time) return ''
    
    try {
      const date = new Date(time)
      const now = new Date()
      const diff = now - date
      
      // 小于1分钟
      if (diff < 60000) {
        return '刚刚'
      }
      
      // 小于1小时
      if (diff < 3600000) {
        return Math.floor(diff / 60000) + '分钟前'
      }
      
      // 小于1天
      if (diff < 86400000) {
        return Math.floor(diff / 3600000) + '小时前'
      }
      
      // 小于7天
      if (diff < 604800000) {
        return Math.floor(diff / 86400000) + '天前'
      }
      
      // 超过7天显示具体日期
      return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      })
    } catch (error) {
      console.warn('时间格式化失败:', error)
      return time
    }
  }

  // 检查评论是否已点赞
  const isCommentLiked = (commentId) => {
    return userStore.isCommentLiked(commentId)
  }

  // 切换评论点赞状态（本地状态，即时响应）
  const toggleCommentLike = async (comment) => {
    const isNowLiked = userStore.toggleCommentLike(comment.id)
    comment.likes = isNowLiked ? comment.likes + 1 : Math.max(0, comment.likes - 1)

    // 调用后端 API 同步点赞状态
    try {
      await toggleCommentLikeApi(comment.id)
    } catch (error) {
      console.error('点赞同步失败:', error)
      // 如果同步失败，回滚本地状态
      userStore.toggleCommentLike(comment.id)
      comment.likes = isNowLiked ? Math.max(0, comment.likes - 1) : comment.likes + 1
      ElMessage.error('点赞失败，请重试')
      return
    }

    // 仅点赞时触发粒子动画
    if (isNowLiked) {
      justLiked.value = comment.id
      setTimeout(() => { justLiked.value = null }, 700)
    }
  }

  // 生成粒子角度/颜色样式
  const getParticleStyle = (i) => {
    const colors = ['#e83e3e', '#ff6b6b', '#ff9999', '#ffcc00', '#ff6600', '#ff3366', '#cc0000', '#ff4081']
    const angle = (i - 1) * 45
    return {
      '--angle': `${angle}deg`,
      '--color': colors[i - 1]
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
  
  .action-buttons {
    display: flex;
    gap: 12px;
    flex-shrink: 0;
    align-items: center;
  }

  .action-btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: 7px;
    padding: 10px 20px;
    border: 1.5px solid var(--border-color);
    border-radius: 50px;
    background: var(--bg-color);
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    color: var(--text-secondary);
    transition: all 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
    overflow: hidden;
    white-space: nowrap;

    .action-bg {
      position: absolute;
      inset: 0;
      border-radius: inherit;
      opacity: 0;
      transition: opacity 0.25s;
    }

    .action-icon {
      width: 18px;
      height: 18px;
      flex-shrink: 0;
      transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
      position: relative;
    }

    .action-label {
      position: relative;
    }

    .action-count {
      position: relative;
      font-size: 12px;
      padding: 1px 7px;
      border-radius: 20px;
      background: var(--bg-dark);
      color: var(--text-light);
      transition: all 0.25s;
    }

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    }
  }

  // 点赞按钮
  .like-action {
    .action-icon { fill: none; stroke: #bbb; stroke-width: 1.8; }

    &:hover {
      border-color: #e83e3e;
      color: #e83e3e;
      .action-icon { stroke: #e83e3e; transform: scale(1.2); }
    }

    &.active {
      border-color: #e83e3e;
      color: #e83e3e;
      background: rgba(232, 62, 62, 0.06);

      .action-bg { background: rgba(232, 62, 62, 0.06); opacity: 1; }
      .action-icon {
        fill: #e83e3e;
        stroke: #e83e3e;
        filter: drop-shadow(0 0 4px rgba(232,62,62,0.5));
        animation: heart-beat 0.45s cubic-bezier(0.34, 1.56, 0.64, 1);
      }
      .action-count { background: rgba(232,62,62,0.12); color: #e83e3e; font-weight: 600; }
    }
  }

  // 收藏按钮
  .fav-action {
    .action-icon { fill: none; stroke: #bbb; stroke-width: 1.8; }

    &:hover {
      border-color: #f59e0b;
      color: #f59e0b;
      .action-icon { stroke: #f59e0b; transform: scale(1.15); }
    }

    &.active {
      border-color: #f59e0b;
      color: #f59e0b;
      background: rgba(245, 158, 11, 0.06);

      .action-bg { background: rgba(245, 158, 11, 0.06); opacity: 1; }
      .action-icon {
        fill: #f59e0b;
        stroke: #f59e0b;
        filter: drop-shadow(0 0 4px rgba(245,158,11,0.5));
      }
      .action-count { background: rgba(245,158,11,0.12); color: #f59e0b; font-weight: 600; }
    }
  }

  // 分享按钮
  .share-action {
    .action-icon { fill: var(--text-light); }

    &:hover {
      border-color: var(--primary-color);
      color: var(--primary-color);
      .action-icon { fill: var(--primary-color); transform: scale(1.15) rotate(-10deg); }
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
  
  // 评论区
  .comment-form {
    margin-bottom: 30px;
  }
  
  .comment-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
  
  .comment-item {
    display: flex;
    gap: 15px;
    padding: 20px;
    background: var(--bg-color);
    border-radius: 8px;
    transition: var(--transition);
    
    &:hover {
      background: var(--bg-dark);
    }
  }
  
  .comment-content {
    flex: 1;
  }
  
  .comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
  }
  
  .comment-username {
    font-weight: 600;
    color: var(--text-primary);
  }
  
  .comment-time {
    font-size: 12px;
    color: var(--text-light);
  }
  
  .comment-text {
    line-height: 1.8;
    color: var(--text-secondary);
    margin-bottom: 10px;
  }
  
  .comment-actions {
    display: flex;
    gap: 15px;
  }

  .like-btn {
    position: relative;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    border: none;
    background: none;
    cursor: pointer;
    padding: 5px 10px;
    border-radius: 20px;
    overflow: visible;
    transition: background 0.2s;
    
    &:hover {
      background: rgba(232, 62, 62, 0.08);
      
      .heart-icon {
        transform: scale(1.2);
      }
    }

    // 涟漪
    .ripple {
      position: absolute;
      inset: 0;
      border-radius: 20px;
      pointer-events: none;
    }

    &.just-liked .ripple {
      animation: ripple-out 0.6s ease-out forwards;
    }
    
    .heart-icon {
      width: 18px;
      height: 18px;
      fill: none;
      stroke: #bbb;
      stroke-width: 1.8;
      transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
      flex-shrink: 0;
    }
    
    .like-count {
      font-size: 13px;
      color: #bbb;
      min-width: 14px;
      transition: color 0.25s;
      line-height: 1;
      overflow: hidden;
      height: 18px;
      display: flex;
      align-items: center;
    }

    .count-num {
      display: block;
      animation: count-up 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
    }
    
    &.liked {
      .heart-icon {
        fill: #e83e3e;
        stroke: #e83e3e;
        animation: heart-beat 0.45s cubic-bezier(0.34, 1.56, 0.64, 1);
        filter: drop-shadow(0 0 4px rgba(232, 62, 62, 0.6));
      }
      
      .like-count {
        color: #e83e3e;
        font-weight: 600;
      }
    }
  }

  // 粒子容器
  .particles {
    position: absolute;
    top: 50%;
    left: 18px;
    transform: translate(-50%, -50%);
    pointer-events: none;
    width: 0;
    height: 0;
  }

  .particle {
    position: absolute;
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: var(--color);
    animation: particle-fly 0.65s ease-out forwards;
    transform-origin: center;
    transform: rotate(var(--angle)) translateY(0) scale(1);
    opacity: 1;
  }

  @keyframes heart-beat {
    0%   { transform: scale(1); }
    25%  { transform: scale(0.8); }
    50%  { transform: scale(1.6); }
    75%  { transform: scale(0.95); }
    100% { transform: scale(1); }
  }

  @keyframes count-up {
    0%   { transform: translateY(60%); opacity: 0; }
    60%  { transform: translateY(-15%); opacity: 1; }
    100% { transform: translateY(0); opacity: 1; }
  }

  @keyframes ripple-out {
    0%   { box-shadow: 0 0 0 0px rgba(232, 62, 62, 0.35); background: rgba(232, 62, 62, 0.12); }
    60%  { box-shadow: 0 0 0 14px rgba(232, 62, 62, 0); }
    100% { box-shadow: 0 0 0 14px rgba(232, 62, 62, 0); background: transparent; }
  }

  @keyframes particle-fly {
    0%   { transform: rotate(var(--angle)) translateY(0)    scale(1);   opacity: 1; }
    60%  { transform: rotate(var(--angle)) translateY(-22px) scale(0.8); opacity: 0.9; }
    100% { transform: rotate(var(--angle)) translateY(-28px) scale(0);   opacity: 0; }
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
  