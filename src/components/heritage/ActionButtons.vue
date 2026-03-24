<template>
  <div class="action-buttons">
    <!-- 点赞 -->
    <button class="action-btn like-action" :class="{ active: isLiked }" @click="handleLike">
      <span class="action-bg"></span>
      <svg class="action-icon" viewBox="0 0 24 24">
        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
      </svg>
      <span class="action-label">{{ isLiked ? '已点赞' : '点赞' }}</span>
      <span class="action-count">{{ likes }}</span>
    </button>

    <!-- 收藏 -->
    <button class="action-btn fav-action" :class="{ active: isFavorited }" @click="handleFavorite">
      <span class="action-bg"></span>
      <svg class="action-icon" viewBox="0 0 24 24">
        <path d="M17 3H7c-1.1 0-2 .9-2 2v16l7-3 7 3V5c0-1.1-.9-2-2-2z"/>
      </svg>
      <span class="action-label">{{ isFavorited ? '已收藏' : '收藏' }}</span>
      <span class="action-count">{{ favorites }}</span>
    </button>

    <!-- 分享 -->
    <el-dropdown @command="handleShare" placement="bottom-end">
      <button class="action-btn share-action">
        <span class="action-bg"></span>
        <svg class="action-icon" viewBox="0 0 24 24">
          <path d="M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92s2.92-1.31 2.92-2.92-1.31-2.92-2.92-2.92z"/>
        </svg>
        <span class="action-label">分享</span>
      </button>
      <template #dropdown>
        <el-dropdown-menu class="share-menu">
          <el-dropdown-item command="weixin">
            <svg viewBox="0 0 24 24" width="16" height="16" style="margin-right:8px;fill:#07c160">
              <path d="M9.5 12.5a1 1 0 100-2 1 1 0 000 2zm5 0a1 1 0 100-2 1 1 0 000 2zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/>
            </svg>微信
          </el-dropdown-item>
          <el-dropdown-item command="weibo">
            <svg viewBox="0 0 24 24" width="16" height="16" style="margin-right:8px;fill:#e6162d">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/>
            </svg>微博
          </el-dropdown-item>
          <el-dropdown-item command="copy">
            <svg viewBox="0 0 24 24" width="16" height="16" style="margin-right:8px;fill:#666">
              <path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
            </svg>复制链接
          </el-dropdown-item>
        </el-dropdown-menu>
      </template>
    </el-dropdown>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const props = defineProps({
  heritageId: { type: [Number, String], required: true },
  name:       { type: String, default: '' },
  likes:      { type: Number, default: 0 },
  favorites:  { type: Number, default: 0 }
})

const userStore = useUserStore()

const isLiked     = computed(() => userStore.isLiked(props.heritageId))
const isFavorited = computed(() => userStore.isFavorite(props.heritageId))

const handleLike = () => {
  userStore.toggleLike(props.heritageId)
  ElMessage.success(isLiked.value ? '点赞成功' : '取消点赞')
}

const handleFavorite = () => {
  userStore.toggleFavorite(props.heritageId)
  ElMessage.success(isFavorited.value ? '收藏成功' : '取消收藏')
}

const handleShare = (command) => {
  const url = window.location.href
  switch (command) {
    case 'weixin':
      ElMessage.info('请使用微信扫描二维码分享')
      break
    case 'weibo':
      window.open(`https://service.weibo.com/share/share.php?url=${encodeURIComponent(url)}&title=${props.name}`)
      break
    case 'copy':
      navigator.clipboard.writeText(url)
      ElMessage.success('链接已复制到剪贴板')
      break
  }
}
</script>

<style lang="scss" scoped>
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

  .action-label { position: relative; }

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

.like-action {
  .action-icon { fill: none; stroke: #bbb; stroke-width: 1.8; }
  &:hover {
    border-color: #e83e3e; color: #e83e3e;
    .action-icon { stroke: #e83e3e; transform: scale(1.2); }
  }
  &.active {
    border-color: #e83e3e; color: #e83e3e; background: rgba(232, 62, 62, 0.06);
    .action-bg { background: rgba(232, 62, 62, 0.06); opacity: 1; }
    .action-icon { fill: #e83e3e; stroke: #e83e3e; filter: drop-shadow(0 0 4px rgba(232,62,62,0.5)); animation: heart-beat 0.45s cubic-bezier(0.34, 1.56, 0.64, 1); }
    .action-count { background: rgba(232,62,62,0.12); color: #e83e3e; font-weight: 600; }
  }
}

.fav-action {
  .action-icon { fill: none; stroke: #bbb; stroke-width: 1.8; }
  &:hover {
    border-color: #f59e0b; color: #f59e0b;
    .action-icon { stroke: #f59e0b; transform: scale(1.15); }
  }
  &.active {
    border-color: #f59e0b; color: #f59e0b; background: rgba(245, 158, 11, 0.06);
    .action-bg { background: rgba(245, 158, 11, 0.06); opacity: 1; }
    .action-icon { fill: #f59e0b; stroke: #f59e0b; filter: drop-shadow(0 0 4px rgba(245,158,11,0.5)); }
    .action-count { background: rgba(245,158,11,0.12); color: #f59e0b; font-weight: 600; }
  }
}

.share-action {
  .action-icon { fill: var(--text-light); }
  &:hover {
    border-color: var(--primary-color); color: var(--primary-color);
    .action-icon { fill: var(--primary-color); transform: scale(1.15) rotate(-10deg); }
  }
}

@keyframes heart-beat {
  0%   { transform: scale(1); }
  25%  { transform: scale(0.8); }
  50%  { transform: scale(1.6); }
  75%  { transform: scale(0.95); }
  100% { transform: scale(1); }
}

@media (max-width: 768px) {
  .action-buttons { width: 100%; }
  .action-btn { flex: 1; }
}
</style>
