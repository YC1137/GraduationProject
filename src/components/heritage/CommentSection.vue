<template>
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
              :class="{ liked: isCommentLiked(comment.id), 'just-liked': justLiked === comment.id }"
              @click="toggleCommentLike(comment)"
            >
              <span class="ripple"></span>
              <span v-if="justLiked === comment.id" class="particles">
                <span v-for="i in 8" :key="i" class="particle" :style="getParticleStyle(i)"></span>
              </span>
              <svg class="heart-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
              </svg>
              <span class="like-count">
                <span class="count-num" :key="comment.likes">{{ comment.likes }}</span>
              </span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { postComment, getComments, toggleCommentLike as toggleCommentLikeApi } from '@/api/heritage'
import { useUserStore } from '@/stores/user'

const props = defineProps({
  heritageId: { type: [Number, String], required: true }
})

const userStore = useUserStore()

const comments = ref([])
const newComment = ref('')
const commentLoading = ref(false)
const justLiked = ref(null)

// 加载评论（自动在组件挂载时调用）
const loadComments = async () => {
  comments.value = await getComments(props.heritageId)
}

// 组件挂载时自动加载评论
onMounted(() => {
  loadComments()
})

// 发表评论
const handlePostComment = async () => {
  if (!newComment.value.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  commentLoading.value = true
  try {
    await postComment({ heritageId: props.heritageId, content: newComment.value })
    ElMessage.success('评论发布成功，等待管理员审核后显示')
    newComment.value = ''
    comments.value = await getComments(props.heritageId)
  } catch {
    ElMessage.error('评论发布失败')
  } finally {
    commentLoading.value = false
  }
}

// 评论点赞
const isCommentLiked = (commentId) => userStore.isCommentLiked(commentId)

const toggleCommentLike = async (comment) => {
  const isNowLiked = userStore.toggleCommentLike(comment.id)
  comment.likes = isNowLiked ? comment.likes + 1 : Math.max(0, comment.likes - 1)
  try {
    await toggleCommentLikeApi(comment.id)
  } catch {
    userStore.toggleCommentLike(comment.id)
    comment.likes = isNowLiked ? Math.max(0, comment.likes - 1) : comment.likes + 1
    ElMessage.error('点赞失败，请重试')
    return
  }
  if (isNowLiked) {
    justLiked.value = comment.id
    setTimeout(() => { justLiked.value = null }, 700)
  }
}

// 粒子动画样式
const getParticleStyle = (i) => {
  const colors = ['#e83e3e', '#ff6b6b', '#ff9999', '#ffcc00', '#ff6600', '#ff3366', '#cc0000', '#ff4081']
  return { '--angle': `${(i - 1) * 45}deg`, '--color': colors[i - 1] }
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  try {
    const date = new Date(time)
    const diff = Date.now() - date
    if (diff < 60000) return '刚刚'
    if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前'
    if (diff < 86400000) return Math.floor(diff / 3600000) + '小时前'
    if (diff < 604800000) return Math.floor(diff / 86400000) + '天前'
    return date.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' })
  } catch {
    return time
  }
}

defineExpose({ loadComments })
</script>

<style lang="scss" scoped>
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
  &:hover { background: var(--bg-dark); }
}

.comment-content { flex: 1; }

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.comment-username { font-weight: 600; color: var(--text-primary); }
.comment-time { font-size: 12px; color: var(--text-light); }
.comment-text { line-height: 1.8; color: var(--text-secondary); margin-bottom: 10px; }
.comment-actions { display: flex; gap: 15px; }

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
    .heart-icon { transform: scale(1.2); }
  }

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
    .like-count { color: #e83e3e; font-weight: 600; }
  }
}

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
</style>
