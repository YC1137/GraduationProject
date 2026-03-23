<template>
  <div class="user-center">
    <div class="container">

      <!-- 用户信息卡片 -->
      <div class="profile-card">
        <div class="profile-avatar-wrap">
          <el-avatar :src="authStore.currentUser?.avatar" :size="80" class="profile-avatar" />
        </div>
        <div class="profile-info">
          <h2 class="profile-name">{{ authStore.currentUser?.username }}</h2>
          <p class="profile-email">{{ authStore.currentUser?.email || '暂无邮箱' }}</p>
          <div class="profile-stats">
            <div class="stat-item">
              <span class="stat-num">{{ favoriteList.length }}</span>
              <span class="stat-label">收藏</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-num">{{ likeList.length }}</span>
              <span class="stat-label">点赞</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Tab 切换 -->
      <div class="tab-bar">
        <button
          class="tab-btn"
          :class="{ active: activeTab === 'favorites' }"
          @click="switchTab('favorites')"
        >
          <svg viewBox="0 0 24 24" class="tab-icon"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
          我的收藏
          <span class="tab-count">{{ favoriteList.length }}</span>
        </button>
        <button
          class="tab-btn"
          :class="{ active: activeTab === 'likes' }"
          @click="switchTab('likes')"
        >
          <svg viewBox="0 0 24 24" class="tab-icon"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>
          我的点赞
          <span class="tab-count">{{ likeList.length }}</span>
        </button>
      </div>

      <!-- 内容区域 -->
      <div class="content-area" v-loading="loading">

        <!-- 空状态 -->
        <div
          v-if="!loading && currentList.length === 0"
          class="empty-state"
        >
          <div class="empty-icon">
            <svg v-if="activeTab === 'favorites'" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
            <svg v-else viewBox="0 0 24 24"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>
          </div>
          <p class="empty-text">{{ activeTab === 'favorites' ? '还没有收藏任何项目' : '还没有点赞任何项目' }}</p>
          <el-button type="primary" @click="$router.push('/category')">去发现更多</el-button>
        </div>

        <!-- 卡片列表 -->
        <div v-else class="heritage-grid">
          <div
            v-for="item in currentList"
            :key="item.id"
            class="heritage-card"
            @click="goDetail(item.id)"
          >
            <!-- 封面图 -->
            <div class="card-cover">
              <img
                :src="getThumbnail(item)"
                :alt="item.name"
                class="cover-img"
                @error="handleImgError"
              />
              <!-- 取消按钮 -->
              <button
                class="remove-btn"
                @click.stop="removeItem(item)"
                :title="activeTab === 'favorites' ? '取消收藏' : '取消点赞'"
              >
                <svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
              </button>
            </div>
            <!-- 信息 -->
            <div class="card-body">
              <h3 class="card-title">{{ item.name }}</h3>
              <div class="card-tags">
                <span class="tag tag-category">{{ item.category }}</span>
                <span class="tag tag-region">{{ item.region }}</span>
              </div>
              <p class="card-desc">{{ item.description }}</p>
              <div class="card-footer">
                <span class="footer-stat">
                  <svg viewBox="0 0 24 24"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                  {{ item.views || 0 }}
                </span>
                <span class="footer-stat">
                  <svg viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                  {{ item.likes || 0 }}
                </span>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useUserStore } from '@/stores/user'
import { getUserFavoritesDetail, getUserLikesDetail } from '@/api/user'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const userStore = useUserStore()

const activeTab = ref('favorites')
const loading = ref(false)
const favoriteList = ref([])
const likeList = ref([])

const currentList = computed(() =>
  activeTab.value === 'favorites' ? favoriteList.value : likeList.value
)

// 切换 Tab
const switchTab = (tab) => {
  activeTab.value = tab
  router.replace({ path: '/profile', query: { tab } })
}

// 加载收藏
const loadFavorites = async () => {
  const userId = authStore.currentUser?.userId
  console.log('[UserCenter] loadFavorites userId:', userId, 'currentUser:', authStore.currentUser)
  if (!userId) return
  loading.value = true
  try {
    const result = await getUserFavoritesDetail(userId)
    console.log('[UserCenter] favorites result:', result)
    favoriteList.value = result || []
  } catch (e) {
    console.error('[UserCenter] loadFavorites error:', e)
    ElMessage.error('加载收藏失败')
    favoriteList.value = []
  } finally {
    loading.value = false
  }
}

// 加载点赞
const loadLikes = async () => {
  const userId = authStore.currentUser?.userId
  console.log('[UserCenter] loadLikes userId:', userId, 'currentUser:', authStore.currentUser)
  if (!userId) return
  loading.value = true
  try {
    const result = await getUserLikesDetail(userId)
    console.log('[UserCenter] likes result:', result)
    likeList.value = result || []
  } catch (e) {
    console.error('[UserCenter] loadLikes error:', e)
    ElMessage.error('加载点赞失败')
    likeList.value = []
  } finally {
    loading.value = false
  }
}

// 取消收藏/点赞
const removeItem = async (item) => {
  const action = activeTab.value === 'favorites' ? '取消收藏' : '取消点赞'
  try {
    await ElMessageBox.confirm(`确认${action}《${item.name}》？`, '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    })
    if (activeTab.value === 'favorites') {
      await userStore.toggleFavorite(item.id)
      favoriteList.value = favoriteList.value.filter(i => i.id !== item.id)
    } else {
      await userStore.toggleLike(item.id)
      likeList.value = likeList.value.filter(i => i.id !== item.id)
    }
    ElMessage.success(`已${action}`)
  } catch (e) {
    // 取消操作不提示
  }
}

// 获取封面图
const getThumbnail = (item) => {
  if (item.thumbnail) return item.thumbnail
  if (item.images && item.images.length > 0) return item.images[0]
  return 'https://via.placeholder.com/400x280?text=非遗'
}

const handleImgError = (e) => {
  e.target.src = 'https://via.placeholder.com/400x280?text=非遗'
}

const goDetail = (id) => {
  router.push(`/detail/${id}`)
}

const initTab = async () => {
  if (!authStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push('/')
    return
  }
  const tab = route.query.tab === 'likes' ? 'likes' : 'favorites'
  activeTab.value = tab
  // 同时加载两份数据，保证统计数字都正确
  await Promise.all([loadFavorites(), loadLikes()])
}

onMounted(initTab)

// 监听 URL query 变化（外部跳转时同步 activeTab）
watch(() => route.query.tab, (tab) => {
  const target = tab === 'likes' ? 'likes' : 'favorites'
  activeTab.value = target
})
</script>

<style lang="scss" scoped>
.user-center {
  padding: 40px 0 80px;
  min-height: calc(100vh - 80px);
}

// 用户信息卡片
.profile-card {
  display: flex;
  align-items: center;
  gap: 28px;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 32px 40px;
  margin-bottom: 32px;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 4px;
    background: linear-gradient(90deg, var(--primary-color), var(--primary-light), #e8a87c);
  }
}

.profile-avatar-wrap {
  position: relative;

  .profile-avatar {
    border: 3px solid var(--primary-color);
    box-shadow: 0 4px 16px rgba(200, 48, 43, 0.25);
  }
}

.profile-info {
  flex: 1;
}

.profile-name {
  font-size: 1.6rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 6px;
}

.profile-email {
  font-size: 14px;
  color: var(--text-light);
  margin: 0 0 16px;
}

.profile-stats {
  display: flex;
  align-items: center;
  gap: 24px;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;

  .stat-num {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--primary-color);
    line-height: 1;
  }

  .stat-label {
    font-size: 12px;
    color: var(--text-light);
  }
}

.stat-divider {
  width: 1px;
  height: 32px;
  background: var(--border-color);
}

// Tab 切换
.tab-bar {
  display: flex;
  gap: 0;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  padding: 6px;
  margin-bottom: 24px;
  width: fit-content;
}

.tab-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 28px;
  border: none;
  background: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  color: var(--text-secondary);
  transition: all 0.25s;

  .tab-icon {
    width: 18px;
    height: 18px;
    fill: currentColor;
    opacity: 0.6;
  }

  .tab-count {
    background: var(--bg-dark);
    border-radius: 20px;
    padding: 1px 8px;
    font-size: 12px;
    color: var(--text-secondary);
    transition: all 0.25s;
  }

  &:hover {
    color: var(--primary-color);
  }

  &.active {
    background: var(--primary-color);
    color: #fff;
    box-shadow: 0 4px 12px rgba(200, 48, 43, 0.3);

    .tab-icon { opacity: 1; }

    .tab-count {
      background: rgba(255,255,255,0.25);
      color: #fff;
    }
  }
}

// 空状态
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  gap: 16px;

  .empty-icon {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    background: var(--bg-dark);
    display: flex;
    align-items: center;
    justify-content: center;

    svg {
      width: 36px;
      height: 36px;
      fill: #ccc;
    }
  }

  .empty-text {
    font-size: 15px;
    color: var(--text-light);
    margin: 0;
  }
}

// 遗产卡片网格
.heritage-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.heritage-card {
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 32px rgba(0,0,0,0.12);
    border-color: var(--primary-color);

    .cover-img { transform: scale(1.05); }
    .remove-btn { opacity: 1; }
  }
}

.card-cover {
  position: relative;
  height: 200px;
  overflow: hidden;
  background: var(--bg-dark);
}

.cover-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.remove-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  border: none;
  background: rgba(0,0,0,0.55);
  color: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.2s;
  backdrop-filter: blur(4px);

  svg {
    width: 16px;
    height: 16px;
    fill: currentColor;
  }

  &:hover {
    background: rgba(200,48,43,0.85);
    transform: scale(1.1);
  }
}

.card-body {
  padding: 16px;
}

.card-title {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 10px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-tags {
  display: flex;
  gap: 6px;
  margin-bottom: 10px;
  flex-wrap: wrap;
}

.tag {
  padding: 2px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;

  &.tag-category {
    background: rgba(200, 48, 43, 0.1);
    color: var(--primary-color);
  }

  &.tag-region {
    background: rgba(61, 78, 92, 0.1);
    color: var(--text-secondary);
  }
}

.card-desc {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0 0 12px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-footer {
  display: flex;
  gap: 16px;
  padding-top: 10px;
  border-top: 1px solid var(--border-color);
}

.footer-stat {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: var(--text-light);

  svg {
    width: 14px;
    height: 14px;
    fill: currentColor;
  }
}

// 响应式
@media (max-width: 768px) {
  .profile-card {
    flex-direction: column;
    text-align: center;
    padding: 24px 20px;
  }

  .profile-stats { justify-content: center; }

  .heritage-grid {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 16px;
  }

  .tab-bar { width: 100%; }
  .tab-btn { flex: 1; justify-content: center; }
}
</style>
