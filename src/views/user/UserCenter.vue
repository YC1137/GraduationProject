<template>
  <div class="user-center">
    <div class="container">

      <!-- 用户信息卡片 -->
      <div class="profile-card">
        <div class="profile-avatar-wrap" @click="triggerAvatarUpload" title="点击更换头像">
          <el-avatar :src="authStore.currentUser?.avatar" :size="80" class="profile-avatar" />
          <div class="avatar-overlay">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="#fff">
              <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
            </svg>
            <span>更换头像</span>
          </div>
          <div class="avatar-uploading" v-if="avatarUploading">
            <div class="upload-spinner"></div>
          </div>
          <input
            ref="avatarInputRef"
            type="file"
            accept="image/*"
            style="display:none"
            @change="handleAvatarChange"
          />
        </div>
        <div class="profile-info">
          <div class="profile-name-row">
            <h2 class="profile-name">{{ authStore.currentUser?.nickname || authStore.currentUser?.username }}</h2>
            <el-button type="primary" link @click="showEditNickname" class="edit-name-btn">
              <el-icon><Edit /></el-icon> 编辑
            </el-button>
          </div>
          <p v-if="authStore.currentUser?.nickname" class="profile-account">@{{ authStore.currentUser?.username }}</p>
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
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-num">{{ digitalAssetList.length }}</span>
              <span class="stat-label">数字藏品</span>
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
        <button
          class="tab-btn"
          :class="{ active: activeTab === 'assets' }"
          @click="switchTab('assets')"
        >
          <svg viewBox="0 0 24 24" class="tab-icon"><path d="M12 2L3 7v10l9 5 9-5V7l-9-5zm0 2.18L18.74 8 12 11.82 5.26 8 12 4.18zM5 9.69l6 3.4v6.73l-6-3.33V9.69zm14 6.8l-6 3.33v-6.73l6-3.4v6.8z"/></svg>
          我的数字藏品
          <span class="tab-count">{{ digitalAssetList.length }}</span>
        </button>
      </div>


      <!-- 内容区域 -->
      <div class="content-area" v-loading="loading">

        <div v-if="activeTab === 'assets' && !loading && digitalAssetList.length === 0" class="empty-state">
          <div class="empty-icon">
            <svg viewBox="0 0 24 24"><path d="M12 2L3 7v10l9 5 9-5V7l-9-5zm0 2.18L18.74 8 12 11.82 5.26 8 12 4.18zM5 9.69l6 3.4v6.73l-6-3.33V9.69zm14 6.8l-6 3.33v-6.73l6-3.4v6.8z"/></svg>
          </div>
          <p class="empty-text">还没有数字藏品，去数字藏品页面铸造吧</p>
          <el-button type="primary" @click="$router.push('/digital-collection')">去铸造</el-button>
        </div>

        <div v-else-if="activeTab !== 'assets' && !loading && currentList.length === 0" class="empty-state">
          <div class="empty-icon">
            <svg v-if="activeTab === 'favorites'" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
            <svg v-else viewBox="0 0 24 24"><path d="M1 21h4V9H1v12zm22-11c0-1.1-.9-2-2-2h-6.31l.95-4.57.03-.32c0-.41-.17-.79-.44-1.06L14.17 1 7.59 7.59C7.22 7.95 7 8.45 7 9v10c0 1.1.9 2 2 2h9c.83 0 1.54-.5 1.84-1.22l3.02-7.05c.09-.23.14-.47.14-.73v-2z"/></svg>
          </div>
          <p class="empty-text">{{ activeTab === 'favorites' ? '还没有收藏任何项目' : '还没有点赞任何项目' }}</p>
          <el-button type="primary" @click="$router.push('/category')">去发现更多</el-button>
        </div>

        <div v-else-if="activeTab !== 'assets'" class="heritage-grid">
          <div
            v-for="item in currentList"
            :key="item.id"
            class="heritage-card"
            @click="goDetail(item.id)"
          >
            <div class="card-cover">
              <img
                :src="getThumbnail(item)"
                :alt="item.name"
                class="cover-img"
                @error="handleImgError"
              />
              <button
                class="remove-btn"
                @click.stop="removeItem(item)"
                :title="activeTab === 'favorites' ? '取消收藏' : '取消点赞'"
              >
                <svg viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
              </button>
            </div>
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

        <div v-else class="asset-grid">
          <div
            v-for="asset in digitalAssetList"
            :key="asset.id"
            class="asset-card"
            :class="asset.rarityClass"
            @click="openAssetDetail(asset)"
          >
            <div class="asset-cover-wrap">
              <img :src="asset.cover" :alt="asset.name" class="asset-cover" @error="handleImgError" />
              <span class="asset-rarity" :class="asset.rarityClass">{{ asset.rarity }}</span>
              <div class="asset-hover-tip">点击查看详情</div>
            </div>
            <div class="asset-body">
              <h3 class="asset-name">{{ asset.name }}</h3>
              <p class="asset-meta">编号：{{ asset.serial || '-' }}</p>
              <p class="asset-meta">获得时间：{{ asset.ownedAt || '-' }}</p>
              <div class="asset-actions">
                <span class="chain-status" :class="asset.onChain ? 'ok' : 'pending'">{{ asset.onChain ? '已上链' : '待确认' }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 藏品详情弹窗 -->
        <div v-if="detailAsset" class="asset-detail-overlay" @click.self="detailAsset = null">
          <div class="asset-detail-modal" :class="detailAsset.rarityClass">
            <button class="detail-close" @click="detailAsset = null">✕</button>
            <div class="detail-left">
              <div class="detail-cover-wrap" :class="detailAsset.rarityClass">
                <img :src="detailAsset.cover" :alt="detailAsset.name" class="detail-cover" @error="handleImgError" />
                <span class="detail-rarity-badge" :class="detailAsset.rarityClass">{{ detailAsset.rarity }}</span>
              </div>
            </div>
            <div class="detail-right">
              <h2 class="detail-name">{{ detailAsset.name }}</h2>
              <p v-if="detailAsset.description" class="detail-desc">{{ detailAsset.description }}</p>
              <div class="detail-info-list">
                <div class="detail-info-row"><span class="di-label">藏品编号</span><span class="di-val">{{ detailAsset.serial || '-' }}</span></div>
                <div class="detail-info-row"><span class="di-label">来　　源</span><span class="di-val">{{ detailAsset.origin || '-' }}</span></div>
                <div class="detail-info-row"><span class="di-label">获得时间</span><span class="di-val">{{ detailAsset.ownedAt || '-' }}</span></div>
                <div class="detail-info-row"><span class="di-label">网络</span><span class="di-val">{{ detailAsset.chain === 'Sepolia' ? 'ETH Sepolia 测试网' : (detailAsset.chain || '-') }}</span></div>
                <div class="detail-info-row center-align">
                  <span class="di-label">链上状态</span>
                  <span class="chain-status" :class="detailAsset.onChain ? 'ok' : 'pending'">{{ detailAsset.onChain ? '已上链' : '待确认' }}</span>
                </div>
                <div class="detail-info-row">
                  <span class="di-label">交易哈希</span>
                  <div class="di-val hash-copy-row" @click="copyText(detailAsset.txHash || '', $event)"><span class="hash-text">{{ detailAsset.txHash || '-' }}</span><span class="copy-btn-text">复制</span></div>
                </div>
                <div v-if="detailAsset.blockNumber" class="detail-info-row"><span class="di-label">区块高度</span><span class="di-val">{{ detailAsset.blockNumber }}</span></div>
                <div v-if="detailAsset.contractAddress" class="detail-info-row">
                  <span class="di-label">合约地址</span>
                  <div class="di-val hash-copy-row" @click="copyText(detailAsset.contractAddress, $event)">
                    <span class="hash-text">{{ detailAsset.contractAddress }}</span>
                    <span class="copy-btn-text">复制</span>
                  </div>
                </div>
              </div>
              <a
                v-if="detailAsset.explorerUrl"
                :href="detailAsset.explorerUrl"
                target="_blank"
                rel="noopener noreferrer"
                class="detail-explorer-btn"
              >在区块链浏览器中查看 →</a>
            </div>
          </div>
        </div>

      </div>

    </div>
  </div>

  <!-- 编辑昵称弹窗 -->
  <el-dialog v-model="editNicknameVisible" title="修改昵称" width="440px" :close-on-click-modal="false" class="edit-nickname-dialog">
    <el-form label-width="0">
      <el-form-item>
        <el-input v-model="editNicknameValue" placeholder="请输入昵称（2-20个字符，支持中英文）" maxlength="20" clearable @keyup.enter="handleSaveNickname" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="editNicknameVisible = false">取消</el-button>
      <el-button type="primary" :loading="editNicknameLoading" @click="handleSaveNickname">保存</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useUserStore } from '@/stores/user'
import { getUserFavoritesDetail, getUserLikesDetail } from '@/api/user'
import { getUserDigitalAssets, getDigitalCollectionList } from '@/api/digitalAsset'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Edit } from '@element-plus/icons-vue'


const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const userStore = useUserStore()

const activeTab = ref('favorites')
const loading = ref(false)
const favoriteList = ref([])
const likeList = ref([])
const digitalAssetList = ref([])
const detailAsset = ref(null)
// itemId -> description 映射缓存
const collectionDescMap = ref({})

const openAssetDetail = async (asset) => {
  detailAsset.value = { ...asset, description: collectionDescMap.value[asset.itemId] || '' }
  // 若还没加载过描述，异步补充
  if (asset.itemId && !collectionDescMap.value[asset.itemId]) {
    try {
      const list = await getDigitalCollectionList()
      if (Array.isArray(list)) {
        list.forEach(item => { collectionDescMap.value[item.id] = item.description || '' })
      }
      if (detailAsset.value && detailAsset.value.itemId === asset.itemId) {
        detailAsset.value = { ...detailAsset.value, description: collectionDescMap.value[asset.itemId] || '' }
      }
    } catch { /* 忽略 */ }
  }
}


// 头像上传
const avatarInputRef = ref(null)
const avatarUploading = ref(false)

const triggerAvatarUpload = () => {
  avatarInputRef.value?.click()
}

const handleAvatarChange = async (e) => {
  const file = e.target.files?.[0]
  if (!file) return
  if (file.size > 5 * 1024 * 1024) {
    ElMessage.warning('图片不能超过 5MB')
    return
  }
  avatarUploading.value = true
  await authStore.updateAvatar(file)
  avatarUploading.value = false
  e.target.value = ''
}

// 编辑昵称
const editNicknameVisible = ref(false)
const editNicknameValue = ref('')
const editNicknameLoading = ref(false)

const showEditNickname = () => {
  editNicknameValue.value = authStore.currentUser?.nickname || ''
  editNicknameVisible.value = true
}

const handleSaveNickname = async () => {
  const nickname = editNicknameValue.value.trim()
  if (nickname && (nickname.length < 2 || nickname.length > 20)) {
    ElMessage.warning('昵称长度需要在 2-20 个字符之间')
    return
  }
  editNicknameLoading.value = true
  await authStore.updateNickname(nickname)
  editNicknameLoading.value = false
  editNicknameVisible.value = false
}

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
  if (!userId) return
  loading.value = true
  try {
    const result = await getUserFavoritesDetail(userId)
    favoriteList.value = result || []
  } catch (e) {
    ElMessage.error('加载收藏失败')
    favoriteList.value = []
  } finally {
    loading.value = false
  }
}

// 加载点赞
const loadLikes = async () => {
  const userId = authStore.currentUser?.userId
  if (!userId) return
  loading.value = true
  try {
    const result = await getUserLikesDetail(userId)
    likeList.value = result || []
  } catch (e) {
    ElMessage.error('加载点赞失败')
    likeList.value = []
  } finally {
    loading.value = false
  }
}

// 加载我的数字藏品
const loadDigitalAssets = async () => {
  const userId = authStore.currentUser?.userId
  if (!userId) return
  loading.value = true
  try {
    const result = await getUserDigitalAssets(userId)
    digitalAssetList.value = result || []
  } catch (e) {
    ElMessage.error('加载数字藏品失败')
    digitalAssetList.value = []
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

const shortHash = (hash) => {
  if (!hash) return ''
  return `${hash.slice(0, 10)}...${hash.slice(-8)}`
}

const copyText = (text, event) => {
  const textarea = document.createElement('textarea')
  textarea.value = text
  textarea.style.position = 'fixed'
  textarea.style.opacity = '0'
  document.body.appendChild(textarea)
  textarea.select()
  try {
    document.execCommand('copy')
    const el = event.currentTarget.querySelector('.copy-btn-text')
    if (el) {
      el.textContent = '已复制!'
      el.style.color = '#67c23a'
      setTimeout(() => { el.textContent = '复制'; el.style.color = '' }, 1200)
    }
  } catch (e) {
    ElMessage.warning('复制失败')
  }
  document.body.removeChild(textarea)
}


const initTab = async () => {
  if (!authStore.isLoggedIn) {
    ElMessage.warning('请先登录')
    router.push('/')
    return
  }
  const tab = ['favorites', 'likes', 'assets'].includes(route.query.tab) ? route.query.tab : 'favorites'
  activeTab.value = tab
  await Promise.all([loadFavorites(), loadLikes(), loadDigitalAssets()])
}


onMounted(initTab)

// 监听 URL query 变化（外部跳转时同步 activeTab）
watch(() => route.query.tab, (tab) => {
  const target = ['favorites', 'likes', 'assets'].includes(tab) ? tab : 'favorites'
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
  width: 80px; height: 80px;
  cursor: pointer;
  border-radius: 50%;
  flex-shrink: 0;
  background: #F5E6C8; // 米黄色背景

  .profile-avatar {
    border: 3px solid var(--primary-color);
    box-shadow: 0 4px 16px rgba(200, 48, 43, 0.25);
    display: block;
    background: #F5E6C8;
  }

  // hover 蒙层
  .avatar-overlay {
    position: absolute;
    inset: 0;
    border-radius: 50%;
    background: rgba(0,0,0,0.45);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 3px;
    opacity: 0;
    transition: opacity 0.2s;
    color: #fff;
    font-size: 11px;
    font-weight: 600;
    pointer-events: none;
  }

  &:hover .avatar-overlay { opacity: 1; }

  // 上传中遮罩
  .avatar-uploading {
    position: absolute;
    inset: 0;
    border-radius: 50%;
    background: rgba(0,0,0,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .upload-spinner {
    width: 24px; height: 24px;
    border: 3px solid rgba(255,255,255,.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  @keyframes spin { to { transform: rotate(360deg); } }
}

.profile-info {
  flex: 1;
}

.profile-name-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 4px;
}

.profile-name {
  font-size: 1.6rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.profile-account {
  font-size: 0.9rem;
  font-weight: 400;
  color: #333;
  margin: 0 0 6px;
}

.edit-name-btn {
  font-size: 13px;
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

.asset-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
}

.asset-card {
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  overflow: hidden;

  &.rare { border-color: rgba(37,99,235,0.35); }
  &.epic { border-color: rgba(124,58,237,0.35); }
  &.legendary { border-color: rgba(217,119,6,0.4); }
}

.asset-cover-wrap {
  position: relative;
  height: 180px;
  background: var(--bg-dark);
  cursor: pointer;

  &:hover .asset-hover-tip { opacity: 1; }
}

.asset-hover-tip {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 14px;
  opacity: 0;
  transition: opacity 0.25s;
  pointer-events: none;
}

.asset-cover {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.asset-rarity {
  position: absolute;
  left: 10px;
  top: 10px;
  font-size: 12px;
  padding: 2px 10px;
  border-radius: 999px;

  &.common { background: rgba(75,85,99,0.8); color: #e5e7eb; }
  &.rare { background: rgba(30,64,175,0.8); color: #bfdbfe; }
  &.epic { background: rgba(91,33,182,0.8); color: #ddd6fe; }
  &.legendary { background: rgba(146,64,14,0.85); color: #fde68a; }
}

.asset-body {
  padding: 14px;
}

.asset-name {
  margin: 0 0 8px;
  font-size: 16px;
  color: var(--text-primary);
}

.asset-meta {
  margin: 0 0 4px;
  font-size: 13px;
  color: var(--text-secondary);
}

.asset-actions {
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  justify-content: space-between;

  a {
    color: var(--primary-color);
    text-decoration: none;
    font-size: 13px;
  }

  a:hover {
    text-decoration: underline;
  }
}

.chain-status {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 999px;

  &.ok {
    color: #16a34a;
    background: rgba(22,163,74,0.12);
  }

  &.pending {
    color: #d97706;
    background: rgba(217,119,6,0.12);
  }
}

// 藏品详情弹窗
.asset-detail-overlay {
  position: fixed;
  inset: 0;
  background: rgba(44, 28, 18, 0.55);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  backdrop-filter: blur(3px);
}

.asset-detail-modal {
  position: relative;
  display: flex;
  gap: 32px;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 36px 36px 32px;
  max-width: 800px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 8px 40px rgba(44,28,18,0.18);

  // 顶部朱红色装饰条（与 profile-card 一致）
  &::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 4px;
    border-radius: 16px 16px 0 0;
    background: linear-gradient(90deg, var(--primary-color), var(--primary-light), #e8a87c);
  }

  // 稀有度边框点缀
  &.rare      { border-color: rgba(37,99,235,0.3); }
  &.epic      { border-color: rgba(124,58,237,0.3); }
  &.legendary { border-color: rgba(200,48,43,0.35); }
}

.detail-close {
  position: absolute;
  top: 14px;
  right: 16px;
  background: none;
  border: none;
  color: var(--text-light);
  font-size: 18px;
  cursor: pointer;
  line-height: 1;
  padding: 4px 8px;
  border-radius: 6px;
  transition: background 0.2s, color 0.2s;

  &:hover {
    background: rgba(200,48,43,0.08);
    color: var(--primary-color);
  }
}

.detail-left {
  flex-shrink: 0;
  width: 240px;
}

.detail-cover-wrap {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  border: 2px solid var(--border-color);

  &.rare      { border-color: rgba(37,99,235,0.45); }
  &.epic      { border-color: rgba(124,58,237,0.45); }
  &.legendary { border-color: rgba(200,48,43,0.45); }
}

.detail-cover {
  width: 100%;
  aspect-ratio: 1;
  object-fit: cover;
  display: block;
}

.detail-rarity-badge {
  position: absolute;
  bottom: 10px;
  left: 10px;
  font-size: 12px;
  padding: 3px 12px;
  border-radius: 999px;
  font-weight: 600;
  letter-spacing: 0.05em;

  &.common    { background: rgba(100,100,100,0.75); color: #fff; }
  &.rare      { background: rgba(30,64,175,0.8);   color: #bfdbfe; }
  &.epic      { background: rgba(91,33,182,0.8);   color: #ddd6fe; }
  &.legendary { background: rgba(200,48,43,0.82);  color: #fde68a; }
}

.detail-right {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.detail-name {
  margin: 8px 0 0;
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
  font-family: 'Noto Serif SC', '宋体', serif;
}

.detail-desc {
  margin: 0;
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.8;
  padding: 10px 14px;
  background: var(--bg-dark);
  border-left: 3px solid var(--primary-color);
  border-radius: 0 6px 6px 0;
}

.detail-info-list {
  display: flex;
  flex-direction: column;
  gap: 0;
  border: 1px solid var(--border-light);
  border-radius: 8px;
  overflow: hidden;
}

.detail-info-row {
  display: flex;
  align-items: flex-start;
  gap: 0;
  font-size: 13px;
  border-bottom: 1px solid var(--border-light);

  &.center-align {
    align-items: center;
  }

  &:last-child { border-bottom: none; }
}

.di-label {
  color: var(--text-secondary);
  flex-shrink: 0;
  width: 72px;
  padding: 9px 12px;
  background: var(--bg-dark);
  font-size: 12px;
  border-right: 1px solid var(--border-light);
}

.di-val {
  color: var(--text-primary);
  padding: 9px 14px;
  word-break: break-all;
  flex: 1;
}

.hash-val {
  font-family: 'Courier New', monospace;
  font-size: 12px;
  color: var(--primary-color);
}

.hash-copy-row {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  width: fit-content;

  .hash-text {
    font-family: 'Courier New', monospace;
    font-size: 12px;
    color: var(--primary-color);
    word-break: break-all;
    max-width: 320px;
  }

  .copy-btn-text {
    font-size: 11px;
    color: var(--primary-color);
    background: rgba(200,48,43,0.08);
    padding: 2px 8px;
    border-radius: 4px;
    white-space: nowrap;
    font-family: 'Inter', sans-serif;
    font-weight: 600;
    transition: background 0.2s;
    flex-shrink: 0;

    &:hover {
      background: rgba(200,48,43,0.15);
    }
  }
}

.detail-explorer-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  margin-top: 2px;
  padding: 8px 18px;
  background: transparent;
  border: 1px solid var(--primary-color);
  color: var(--primary-color);
  border-radius: 6px;
  font-size: 13px;
  text-decoration: none;
  transition: background 0.2s, color 0.2s;
  align-self: flex-start;

  &:hover {
    background: var(--primary-color);
    color: #fff;
  }
}

@media (max-width: 600px) {
  .asset-detail-modal {
    flex-direction: column;
    padding: 24px 20px 20px;
    gap: 20px;

    &::before { border-radius: 16px 16px 0 0; }
  }
  .detail-left { width: 100%; }
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

// 编辑昵称弹窗样式
.edit-nickname-dialog {
  :deep(.el-dialog) {
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
  }

  :deep(.el-dialog__header) {
    border-bottom: 1px solid var(--border-color);
    padding: 20px 24px 16px;
    margin: 0;
  }

  :deep(.el-dialog__title) {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-primary);
    font-family: 'Noto Serif SC', '宋体', serif;
  }

  :deep(.el-dialog__body) {
    padding: 24px;
  }

  :deep(.el-dialog__footer) {
    border-top: 1px solid var(--border-color);
    padding: 16px 24px;
  }
}
</style>
