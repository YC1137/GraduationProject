<template>
  <div class="bomb-leaderboard">
    <!-- 标题行 -->
    <div class="lb-header">
      <div class="lb-title-wrap">
        <div class="lb-icon">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="#fff">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 14l-4-4 1.41-1.41L10 13.17l6.59-6.59L18 8l-8 8z"/>
          </svg>
        </div>
        <span class="lb-title">挑战成功榜</span>
        <span class="lb-sub">· 近期成功诱导 AI 的记录</span>
      </div>
      <button class="lb-refresh" @click="load" :disabled="loading">
        <svg viewBox="0 0 24 24" width="14" height="14" :class="{ spinning: loading }"
          fill="currentColor">
          <path d="M17.65 6.35A7.96 7.96 0 0 0 12 4C7.58 4 4 7.58 4 12s3.58 8 8 8c3.73 0 6.84-2.55 7.73-6h-2.08A5.99 5.99 0 0 1 12 18c-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/>
        </svg>
        刷新
      </button>
    </div>

    <!-- 加载中 -->
    <div class="lb-loading" v-if="loading">
      <div class="loading-dots"><span></span><span></span><span></span></div>
    </div>

    <!-- 空状态 -->
    <div class="lb-empty" v-else-if="records.length === 0">
      <svg viewBox="0 0 24 24" width="36" height="36" fill="var(--border-color)">
        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/>
      </svg>
      <p>还没有人成功挑战，来做第一个！</p>
    </div>

    <!-- 记录列表 -->
    <div class="lb-list" v-else>
      <div
        v-for="(rec, idx) in records"
        :key="rec.id"
        class="lb-item"
        @click="openDetail(rec)"
      >
        <!-- 序号 -->
        <div class="lb-rank" :class="{ top3: idx < 3 }">{{ idx + 1 }}</div>

        <!-- 主内容 -->
        <div class="lb-main">
          <div class="lb-row1">
            <span class="lb-user">{{ rec.username || '匿名用户' }}</span>
            <span class="lb-project">{{ rec.projectName }}</span>
          </div>
          <div class="lb-row2">
            <span class="lb-tag">第 {{ rec.winRound }} 轮</span>
            <span class="lb-leaked">说出「<strong>{{ rec.leakedChar }}</strong>」</span>
            <span class="lb-time">{{ formatTime(rec.createdAt) }}</span>
          </div>
        </div>

        <!-- 查看箭头 -->
        <svg viewBox="0 0 24 24" width="14" height="14" fill="var(--text-light)" class="lb-arrow">
          <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6z"/>
        </svg>
      </div>
    </div>

    <!-- 对话详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      class="bomb-dialog"
      destroy-on-close
    >
      <div class="dialog-meta" v-if="activeRecord">
        <span class="dialog-tag">第 {{ activeRecord.winRound }} 轮引爆</span>
        <span class="dialog-leaked">说出了「<strong>{{ activeRecord.leakedChar }}</strong>」</span>
        <span class="dialog-time">{{ formatTime(activeRecord.createdAt) }}</span>
      </div>
      <div class="dialog-msgs" v-if="activeMessages.length">
        <div
          v-for="(msg, i) in activeMessages"
          :key="i"
          :class="['dm-row', msg.role]"
        >
          <div class="dm-avatar" :class="msg.role === 'ai' ? 'dm-ai-av' : 'dm-user-av'">
            <svg v-if="msg.role === 'ai'" viewBox="0 0 24 24" width="13" height="13" fill="#fff">
              <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/>
            </svg>
            <span v-else class="dm-user-initial">{{ (activeRecord?.username || '我').charAt(0).toUpperCase() }}</span>
          </div>
          <div class="dm-body" :style="msg.role === 'user' ? 'align-items:flex-end' : ''">
            <div class="dm-name">{{ msg.role === 'ai' ? 'AI 守护者' : (activeRecord?.username || '玩家') }}</div>
            <div :class="['dm-bubble', msg.role]" v-html="highlightLeaked(msg.content, msg.role, msg.greeting, activeRecord)"></div>
          </div>
        </div>
      </div>
      <template #footer>
        <el-button @click="dialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getBombLatest } from '@/api/bomb'

const records = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const activeRecord = ref(null)

const activeMessages = computed(() => {
  if (!activeRecord.value?.messages) return []
  try {
    return JSON.parse(activeRecord.value.messages)
  } catch {
    return []
  }
})

const dialogTitle = computed(() => {
  if (!activeRecord.value) return '对话回顾'
  return `${activeRecord.value.username || '匿名'} · ${activeRecord.value.projectName} · 挑战成功`
})

const load = async () => {
  loading.value = true
  try {
    const data = await getBombLatest(30)
    records.value = Array.isArray(data) ? data : []
  } catch {
    records.value = []
  } finally {
    loading.value = false
  }
}

const openDetail = (rec) => {
  activeRecord.value = rec
  dialogVisible.value = true
}

const highlightLeaked = (text, role, greeting, rec) => {
  if (!text || role !== 'ai' || greeting) return text
  const project = rec?.projectName
  if (!project) return text
  let result = text
  for (const char of project) {
    if (!char.trim()) continue
    result = result.replace(
      new RegExp(char, 'g'),
      `<mark class="leaked-mark">${char}</mark>`
    )
  }
  return result
}

const formatTime = (val) => {
  if (!val) return ''
  try {
    const d = new Date(val)
    const now = new Date()
    const diff = now - d
    if (diff < 60000) return '刚刚'
    if (diff < 3600000) return `${Math.floor(diff / 60000)} 分钟前`
    if (diff < 86400000) return `${Math.floor(diff / 3600000)} 小时前`
    const month = d.getMonth() + 1
    const day = d.getDate()
    return `${month}月${day}日`
  } catch {
    return ''
  }
}

onMounted(load)
</script>

<style lang="scss" scoped>
.bomb-leaderboard {
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  box-shadow: var(--shadow-sm);
  overflow: hidden;
}

// ===== 标题行 =====
.lb-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border-color);
  background: var(--bg-color);
}

.lb-title-wrap {
  display: flex;
  align-items: center;
  gap: 8px;
}

.lb-icon {
  width: 26px;
  height: 26px;
  background: var(--primary-color);
  border-radius: 7px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.lb-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.lb-sub {
  font-size: 12px;
  color: var(--text-light);
}

.lb-refresh {
  display: flex;
  align-items: center;
  gap: 4px;
  background: none;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  padding: 4px 10px;
  font-size: 12px;
  color: var(--text-secondary);
  cursor: pointer;
  transition: all .2s;

  &:hover:not(:disabled) {
    border-color: var(--primary-color);
    color: var(--primary-color);
  }

  &:disabled { opacity: 0.5; cursor: not-allowed; }

  svg { flex-shrink: 0; }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinning {
  animation: spin 0.8s linear infinite;
}

// ===== 加载 =====
.lb-loading {
  display: flex;
  justify-content: center;
  padding: 36px 0;
}

.loading-dots {
  display: flex;
  gap: 6px;

  span {
    width: 8px;
    height: 8px;
    background: #ccc;
    border-radius: 50%;
    animation: dot-b 1.2s infinite ease-in-out;

    &:nth-child(2) { animation-delay: .2s; }
    &:nth-child(3) { animation-delay: .4s; }
  }
}

@keyframes dot-b {
  0%, 60%, 100% { transform: translateY(0); opacity: .4; }
  30% { transform: translateY(-5px); opacity: 1; }
}

// ===== 空状态 =====
.lb-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 44px 0;

  p {
    font-size: 13px;
    color: var(--text-light);
    margin: 0;
  }
}

// ===== 列表 =====
.lb-list {
  max-height: 400px;
  overflow-y: auto;

  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-thumb { background: #ddd; border-radius: 2px; }
}

.lb-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 13px 20px;
  cursor: pointer;
  transition: background .15s;
  border-bottom: 1px solid var(--border-light, #f0eeea);

  &:last-child { border-bottom: none; }

  &:hover {
    background: rgba(200, 48, 43, 0.03);
  }
}

.lb-rank {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: var(--bg-color);
  border: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  color: var(--text-secondary);
  flex-shrink: 0;

  &.top3 {
    background: var(--primary-color);
    border-color: var(--primary-color);
    color: #fff;
  }
}

.lb-main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.lb-row1 {
  display: flex;
  align-items: center;
  gap: 8px;
}

.lb-user {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100px;
}

.lb-project {
  font-size: 13px;
  color: var(--primary-color);
  font-weight: 700;
  font-family: "Source Han Serif SC", "STSong", serif;
  letter-spacing: 1px;
}

.lb-row2 {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.lb-tag {
  font-size: 11px;
  background: rgba(200,48,43,0.08);
  color: var(--primary-color);
  border-radius: 3px;
  padding: 1px 6px;
  white-space: nowrap;
}

.lb-leaked {
  font-size: 12px;
  color: var(--text-secondary);

  strong {
    color: var(--primary-color);
    font-weight: 700;
  }
}

.lb-time {
  font-size: 11px;
  color: var(--text-light);
  margin-left: auto;
  white-space: nowrap;
}

.lb-arrow {
  flex-shrink: 0;
}

// ===== 弹窗对话 =====
.bomb-dialog {
  :deep(.el-dialog__header) {
    border-bottom: 1px solid var(--border-color);
    padding: 16px 20px 14px;
  }

  :deep(.el-dialog__title) {
    font-size: 15px;
    font-weight: 600;
    color: var(--text-primary);
  }

  :deep(.el-dialog__body) {
    padding: 0;
    max-height: 70vh;
    overflow-y: auto;
  }
}

.dialog-meta {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 20px;
  border-bottom: 1px solid var(--border-color);
  background: var(--bg-color);
  flex-wrap: wrap;
}

.dialog-tag {
  font-size: 12px;
  background: rgba(200,48,43,0.08);
  color: var(--primary-color);
  border-radius: 3px;
  padding: 2px 8px;
}

.dialog-leaked {
  font-size: 13px;
  color: var(--text-secondary);

  strong {
    color: var(--primary-color);
    font-weight: 700;
    font-size: 1.05em;
  }
}

.dialog-time {
  font-size: 12px;
  color: var(--text-light);
  margin-left: auto;
}

.dialog-msgs {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.dm-row {
  display: flex;
  align-items: flex-end;
  gap: 9px;

  &.user { justify-content: flex-end; }
}

.dm-avatar {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;

  &.dm-ai-av { background: var(--primary-color); }
  &.dm-user-av {
    background: var(--primary-color);
    color: #fff;
    font-size: 12px;
    font-weight: 700;
  }
}

.dm-user-initial {
  font-size: 12px;
  font-weight: 700;
}

.dm-body {
  max-width: 72%;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.dm-name {
  font-size: 11px;
  color: var(--text-light);
  padding: 0 2px;
}

.dm-row.user .dm-name { text-align: right; }

.dm-bubble {
  padding: 9px 13px;
  border-radius: 10px;
  font-size: 13px;
  line-height: 1.75;
  word-break: break-word;

  &.ai {
    background: var(--bg-color);
    border: 1px solid var(--border-color);
    color: var(--text-primary);
    border-bottom-left-radius: 3px;
  }

  &.user {
    background: var(--primary-color);
    color: #fff;
    border-bottom-right-radius: 3px;
  }

  :deep(.leaked-mark) {
    background: rgba(200,48,43,0.12);
    color: var(--primary-color);
    font-weight: 900;
    border-bottom: 2px solid var(--primary-color);
    padding: 0 2px;
    border-radius: 2px;
  }
}

// ===== 响应式 =====
@media (max-width: 600px) {
  .lb-user { max-width: 70px; }
  .lb-time { display: none; }
  .bomb-dialog { :deep(.el-dialog) { width: 92% !important; } }
}
</style>
