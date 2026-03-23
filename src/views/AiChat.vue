<template>
  <div class="ai-chat-page ink-wash-bg">
    <div class="container">

      <!-- 未登录遮罩 -->
      <div class="login-mask" v-if="!authStore.isLoggedIn">
        <div class="mask-card">
          <div class="mask-icon">
            <svg viewBox="0 0 24 24" width="56" height="56" fill="var(--primary-color)">
              <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
            </svg>
          </div>
          <h2>遗遗 AI 问答</h2>
          <p>登录后即可与遗遗畅聊非遗文化知识 (≧▽≦)</p>
          <el-button type="primary" size="large" class="mask-login-btn" @click="handleLoginClick">
            立即登录
          </el-button>
        </div>
      </div>

      <!-- 已登录：正式内容 -->
      <template v-else>
        <!-- 页面标题 -->
        <div class="page-title-bar">
          <div class="page-title-left">
            <div class="title-icon-wrap">
              <svg viewBox="0 0 24 24" width="22" height="22" fill="#fff">
                <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
              </svg>
            </div>
            <div>
              <h1 class="page-title-text">遗遗 AI 问答</h1>
              <p class="page-title-sub">你的非遗文化知识小伙伴 (≧▽≦)</p>
            </div>
          </div>
          <div class="title-actions">
            <el-button type="primary" class="new-chat-btn" @click="createNewSession">
              <el-icon><Plus /></el-icon> 新建对话
            </el-button>
            <el-button link class="clear-btn" @click="deleteCurrentSession" :disabled="!currentSessionId">
              <el-icon><Delete /></el-icon> 删除此对话
            </el-button>
          </div>
        </div>

        <div class="chat-layout">
          <!-- 左侧：会话列表 -->
          <aside class="chat-aside">
            <div class="aside-header">
              <el-icon><ChatDotRound /></el-icon>
              <span>历史对话</span>
              <span class="aside-count">{{ sessionList.length }}</span>
            </div>
            <div class="aside-empty" v-if="sessionList.length === 0">
              <svg viewBox="0 0 24 24" width="32" height="32" fill="#ccc"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
              <p>暂无对话记录</p>
            </div>
            <div class="aside-list" v-else>
              <div
                v-for="sess in sessionList"
                :key="sess.id"
                :class="['aside-item', { active: sess.id === currentSessionId }]"
                @click="switchSession(sess.id)"
              >
                <div class="aside-item-q">{{ sess.title }}</div>
                <div class="aside-item-meta">
                  <span>{{ sess.msgCount }} 条消息</span>
                  <span>{{ sess.updatedAt }}</span>
                </div>
              </div>
            </div>
          </aside>

          <!-- 右侧：聊天区 -->
          <div class="chat-main">
            <!-- 消息列表 -->
            <div class="msg-list" ref="msgListRef">

              <!-- 欢迎页 -->
              <div class="welcome-screen" v-if="messages.length === 0">
                <div class="welcome-avatar">
                  <svg viewBox="0 0 24 24" width="40" height="40" fill="var(--primary-color)">
                    <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
                  </svg>
                </div>
                <h3>你好，{{ authStore.currentUser?.username }}！我是遗遗～ ヾ(≧▽≦*)o</h3>
                <p>专门为你介绍中国非物质文化遗产，想了解什么尽管问我哦！</p>
                <div class="quick-wrap">
                  <p class="quick-label">快捷提问：</p>
                  <div class="quick-list">
                    <button
                      v-for="q in quickQuestions"
                      :key="q"
                      class="quick-btn"
                      @click="quickAsk(q)"
                    >{{ q }}</button>
                  </div>
                </div>
              </div>

              <!-- 对话列表 -->
              <template v-else>
                <div
                  v-for="(msg, index) in messages"
                  :key="index"
                  :class="['msg-row', msg.role]"
                >
                  <!-- AI头像 -->
                  <div v-if="msg.role === 'assistant'" class="msg-avatar ai-av">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="#fff">
                      <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                    </svg>
                  </div>

                  <div class="msg-body">
                    <div :class="['msg-bubble', msg.role]" v-html="formatMsg(msg.content)"></div>
                    <span class="msg-time">{{ msg.time }}</span>
                  </div>

                  <!-- 用户头像 -->
                  <div v-if="msg.role === 'user'" class="msg-avatar user-av">
                    <el-avatar :src="authStore.currentUser?.avatar" :size="36" />
                  </div>
                </div>

                <!-- 打字中 -->
                <div class="msg-row assistant" v-if="isLoading">
                  <div class="msg-avatar ai-av">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="#fff">
                      <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                    </svg>
                  </div>
                  <div class="msg-body">
                    <div class="msg-bubble assistant">
                      <div class="typing-dots">
                        <span></span><span></span><span></span>
                      </div>
                    </div>
                  </div>
                </div>
              </template>
            </div>

            <!-- 错误条 -->
            <div class="err-bar" v-if="errMsg">
              <el-icon><Warning /></el-icon>
              <span>{{ errMsg }}</span>
              <button class="err-close" @click="errMsg = ''">×</button>
            </div>

            <!-- 输入栏 -->
            <div class="input-bar">
              <el-input
                v-model="inputVal"
                type="textarea"
                :autosize="{ minRows: 2, maxRows: 5 }"
                placeholder="输入问题，Enter 发送，Shift+Enter 换行..."
                :disabled="isLoading"
                @keydown="onKeydown"
                resize="none"
                class="chat-input"
              />
              <div class="input-footer">
                <span class="input-tip">Shift+Enter 换行</span>
                <el-button
                  type="primary"
                  class="send-btn"
                  :loading="isLoading"
                  :disabled="!inputVal.trim()"
                  @click="send"
                >
                  <el-icon v-if="!isLoading"><Promotion /></el-icon>
                  {{ isLoading ? '思考中...' : '发  送' }}
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </template>

    </div>
  </div>
</template>

<script setup>
import { ref, computed, nextTick, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Delete, Clock, Warning, Promotion, Plus, ChatDotRound } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth'
import { sendChatMessage } from '@/api/ai'

const authStore = useAuthStore()

// ============ 多会话持久化 ============
// 数据结构：
// ai_sessions_{userId} = [ { id, title, updatedAt, msgCount } ]  // 会话索引
// ai_session_{userId}_{sessionId} = [ ...messages ]              // 每条会话的消息

const userPrefix = computed(() =>
  authStore.currentUser?.id ? `ai_${authStore.currentUser.id}` : 'ai_guest'
)

const sessionsKey = computed(() => `${userPrefix.value}_sessions`)

// 读取会话索引列表
const loadSessionList = () => {
  try {
    return JSON.parse(localStorage.getItem(sessionsKey.value) || '[]')
  } catch { return [] }
}

// 保存会话索引列表
const saveSessionList = (list) => {
  localStorage.setItem(sessionsKey.value, JSON.stringify(list))
}

// 读取某条会话的消息
const loadSessionMessages = (sid) => {
  try {
    return JSON.parse(localStorage.getItem(`${userPrefix.value}_s_${sid}`) || '[]')
  } catch { return [] }
}

// 保存某条会话的消息
const saveSessionMessages = (sid, msgs) => {
  localStorage.setItem(`${userPrefix.value}_s_${sid}`, JSON.stringify(msgs))
}

// 删除某条会话的消息
const removeSessionData = (sid) => {
  localStorage.removeItem(`${userPrefix.value}_s_${sid}`)
}

// 生成唯一ID
const genId = () => Date.now().toString(36) + Math.random().toString(36).slice(2, 6)

// 格式化日期
const fmtDate = (ts) => {
  const d = new Date(ts)
  const now = new Date()
  const isToday = d.toDateString() === now.toDateString()
  if (isToday) return `${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`
  return `${d.getMonth()+1}/${d.getDate()}`
}

// ============ 状态 ============
const sessionList       = ref(loadSessionList())
const currentSessionId  = ref(sessionList.value[0]?.id || null)
const messages          = ref(currentSessionId.value ? loadSessionMessages(currentSessionId.value) : [])
const inputVal          = ref('')
const isLoading         = ref(false)
const errMsg            = ref('')
const msgListRef        = ref(null)

// 用户切换账号时重新加载
watch(() => authStore.currentUser?.id, () => {
  sessionList.value = loadSessionList()
  currentSessionId.value = sessionList.value[0]?.id || null
  messages.value = currentSessionId.value ? loadSessionMessages(currentSessionId.value) : []
})

// ============ 快捷提问 ============
const quickQuestions = [
  '什么是非物质文化遗产？',
  '中国有哪些著名的非遗项目？',
  '京剧是怎么起源的？',
  '剪纸艺术有哪些主要流派？',
  '如何保护濒危非遗项目？'
]

// ============ 会话操作 ============

// 新建对话
const createNewSession = () => {
  const id = genId()
  const newSess = { id, title: '新对话', updatedAt: fmtDate(Date.now()), msgCount: 0 }
  sessionList.value.unshift(newSess)
  saveSessionList(sessionList.value)
  currentSessionId.value = id
  messages.value = []
  errMsg.value = ''
}

// 切换会话
const switchSession = (id) => {
  if (id === currentSessionId.value) return
  currentSessionId.value = id
  messages.value = loadSessionMessages(id)
  errMsg.value = ''
  nextTick(() => {
    if (msgListRef.value) msgListRef.value.scrollTop = msgListRef.value.scrollHeight
  })
}

// 删除当前会话
const deleteCurrentSession = async () => {
  if (!currentSessionId.value) return
  try {
    await ElMessageBox.confirm('确定删除此对话记录吗？', '提示', {
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      type: 'warning'
    })
    removeSessionData(currentSessionId.value)
    sessionList.value = sessionList.value.filter(s => s.id !== currentSessionId.value)
    saveSessionList(sessionList.value)
    currentSessionId.value = sessionList.value[0]?.id || null
    messages.value = currentSessionId.value ? loadSessionMessages(currentSessionId.value) : []
    errMsg.value = ''
    ElMessage.success('对话已删除')
  } catch { /* 取消 */ }
}

// 更新会话索引（标题、时间、消息数）
const updateSessionMeta = (msgs) => {
  const idx = sessionList.value.findIndex(s => s.id === currentSessionId.value)
  if (idx === -1) return
  const firstUser = msgs.find(m => m.role === 'user')
  sessionList.value[idx].title = firstUser
    ? firstUser.content.slice(0, 20) + (firstUser.content.length > 20 ? '…' : '')
    : '新对话'
  sessionList.value[idx].msgCount = msgs.length
  sessionList.value[idx].updatedAt = fmtDate(Date.now())
  // 把当前会话移到最前
  const sess = sessionList.value.splice(idx, 1)[0]
  sessionList.value.unshift(sess)
  saveSessionList(sessionList.value)
}

// ============ 工具 ============
const now = () => {
  const d = new Date()
  return `${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`
}

const formatMsg = (text) =>
  text
    .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
    .replace(/\n/g,'<br>')

const scrollBottom = async () => {
  await nextTick()
  if (msgListRef.value) msgListRef.value.scrollTop = msgListRef.value.scrollHeight
}

// ============ 登录引导 ============
const handleLoginClick = () => {
  window.dispatchEvent(new CustomEvent('show-login'))
}

// ============ 发送消息 ============
const send = async () => {
  const text = inputVal.value.trim()
  if (!text || isLoading.value) return

  // 如果没有当前会话，先新建一个
  if (!currentSessionId.value) {
    const id = genId()
    sessionList.value.unshift({ id, title: '新对话', updatedAt: fmtDate(Date.now()), msgCount: 0 })
    saveSessionList(sessionList.value)
    currentSessionId.value = id
    messages.value = []
  }

  messages.value.push({ role: 'user', content: text, time: now() })
  const history = messages.value.slice(0, -1).map(m => ({ role: m.role, content: m.content }))
  inputVal.value = ''
  errMsg.value = ''
  isLoading.value = true
  await scrollBottom()

  try {
    const reply = await sendChatMessage(text, history)
    messages.value.push({ role: 'assistant', content: reply, time: now() })
  } catch (e) {
    errMsg.value = e.message || '请求失败，请检查 API 配置'
  } finally {
    isLoading.value = false
    await scrollBottom()
    // 保存到 localStorage
    saveSessionMessages(currentSessionId.value, messages.value)
    updateSessionMeta(messages.value)
  }
}

const quickAsk = (q) => { inputVal.value = q; send() }

const onKeydown = (e) => {
  if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send() }
}
</script>

<style lang="scss" scoped>
/* ===== 页面容器 ===== */
.ai-chat-page {
  min-height: calc(100vh - 140px);
  padding: 40px 0 60px;

  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    position: relative;
  }
}

/* ===== 未登录遮罩 ===== */
.login-mask {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 520px;

  .mask-card {
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    padding: 60px 48px;
    text-align: center;
    box-shadow: var(--shadow-md);
    max-width: 420px;
    width: 100%;

    .mask-icon { margin-bottom: 20px; }

    h2 {
      font-size: 24px;
      font-weight: 700;
      color: var(--text-primary);
      margin: 0 0 12px;
    }

    p {
      font-size: 15px;
      color: var(--text-secondary);
      margin: 0 0 32px;
      line-height: 1.6;
    }

    .mask-login-btn {
      width: 100%;
      height: 46px;
      font-size: 16px;
      border-radius: 10px;
    }
  }
}

/* ===== 标题栏 ===== */
.page-title-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 28px;

  .page-title-left {
    display: flex;
    align-items: center;
    gap: 14px;
  }

  .title-icon-wrap {
    width: 52px;
    height: 52px;
    background: var(--primary-color);
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .page-title-text {
    font-size: 26px;
    font-weight: 700;
    color: var(--text-primary);
    margin: 0 0 4px;
  }

  .page-title-sub {
    font-size: 14px;
    color: var(--text-secondary);
    margin: 0;
  }

  .title-actions {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .new-chat-btn {
    border-radius: 8px;
    font-size: 13px;
    padding: 8px 16px;
  }

  .clear-btn {
    color: var(--text-secondary);
    font-size: 13px;

    &:hover { color: #e74c3c; }
    &:disabled { opacity: 0.4; }
  }
}

/* ===== 布局 ===== */
.chat-layout {
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

/* ===== 左侧会话列表 ===== */
.chat-aside {
  width: 220px;
  flex-shrink: 0;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);

  .aside-header {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 14px 16px;
    font-size: 13px;
    font-weight: 600;
    color: var(--text-primary);
    border-bottom: 1px solid var(--border-color);
    background: var(--bg-color);

    .aside-count {
      margin-left: auto;
      background: var(--primary-color);
      color: #fff;
      font-size: 11px;
      border-radius: 10px;
      padding: 1px 7px;
      font-weight: 500;
    }
  }

  .aside-empty {
    padding: 40px 16px;
    text-align: center;
    color: #bbb;

    p { font-size: 12px; margin: 10px 0 0; }
  }

  .aside-list {
    max-height: 520px;
    overflow-y: auto;

    &::-webkit-scrollbar { width: 3px; }
    &::-webkit-scrollbar-thumb { background: #e0e0e0; border-radius: 2px; }
  }

  .aside-item {
    padding: 12px 16px;
    border-bottom: 1px solid var(--border-color);
    cursor: pointer;
    transition: background 0.2s;

    &:last-child { border-bottom: none; }
    &:hover { background: rgba(0,0,0,.03); }

    &.active {
      background: rgba(192,57,43,.06);
      border-left: 3px solid var(--primary-color);
      padding-left: 13px;
    }

    .aside-item-q {
      font-size: 13px;
      color: var(--text-primary);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      line-height: 1.5;
    }

    .aside-item-meta {
      display: flex;
      justify-content: space-between;
      font-size: 11px;
      color: #bbb;
      margin-top: 4px;
    }
  }
}

/* ===== 右侧聊天 ===== */
.chat-main {
  flex: 1;
  min-width: 0;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  box-shadow: var(--shadow-sm);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* ===== 消息列表 ===== */
.msg-list {
  flex: 1;
  min-height: 460px;
  max-height: 520px;
  overflow-y: auto;
  padding: 28px 24px;
  scroll-behavior: smooth;

  &::-webkit-scrollbar { width: 5px; }
  &::-webkit-scrollbar-thumb { background: #ddd; border-radius: 3px; }
}

/* 欢迎屏 */
.welcome-screen {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 50px 20px 30px;
  color: var(--text-secondary);

  .welcome-avatar {
    width: 72px;
    height: 72px;
    background: rgba(192,57,43,.08);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 18px;
  }

  h3 {
    font-size: 20px;
    color: var(--text-primary);
    margin: 0 0 10px;
    font-weight: 600;
  }

  p { font-size: 14px; margin: 0 0 28px; line-height: 1.6; }

  .quick-wrap {
    .quick-label {
      font-size: 12px;
      color: #aaa;
      margin-bottom: 10px;
    }
    .quick-list {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 8px;
    }
    .quick-btn {
      background: var(--bg-color);
      border: 1px solid var(--border-color);
      border-radius: 20px;
      padding: 6px 16px;
      font-size: 13px;
      color: var(--text-primary);
      cursor: pointer;
      transition: all .2s;

      &:hover {
        border-color: var(--primary-color);
        color: var(--primary-color);
        background: rgba(192,57,43,.04);
      }
    }
  }
}

/* 消息行 */
.msg-row {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  margin-bottom: 20px;

  &.user { flex-direction: row-reverse; }
}

/* 头像 */
.msg-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;

  &.ai-av { background: var(--primary-color); }

  &.user-av {
    overflow: hidden;
    :deep(.el-avatar) { width: 36px; height: 36px; }
  }
}

/* 消息主体 */
.msg-body {
  max-width: 68%;
  display: flex;
  flex-direction: column;

  .msg-row.user & { align-items: flex-end; }
}

/* 气泡 */
.msg-bubble {
  padding: 11px 16px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.75;
  word-break: break-word;

  &.assistant {
    background: var(--bg-color);
    border: 1px solid var(--border-color);
    color: var(--text-primary);
    border-bottom-left-radius: 4px;
  }

  &.user {
    background: var(--primary-color);
    color: #fff;
    border-bottom-right-radius: 4px;
  }
}

.msg-time {
  font-size: 11px;
  color: #c0c0c0;
  margin-top: 5px;
  padding: 0 2px;
}

/* 打字动画 */
.typing-dots {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 2px 0;

  span {
    width: 7px;
    height: 7px;
    background: #b0b0b0;
    border-radius: 50%;
    animation: dot-bounce 1.2s infinite ease-in-out;

    &:nth-child(2) { animation-delay: .2s; }
    &:nth-child(3) { animation-delay: .4s; }
  }
}

@keyframes dot-bounce {
  0%, 60%, 100% { transform: translateY(0); opacity: .4; }
  30%            { transform: translateY(-7px); opacity: 1; }
}

/* ===== 错误条 ===== */
.err-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: #fff2f0;
  border-top: 1px solid #ffccc7;
  font-size: 13px;
  color: #cf1322;

  .err-close {
    margin-left: auto;
    background: none;
    border: none;
    font-size: 16px;
    cursor: pointer;
    color: #cf1322;
    line-height: 1;
  }
}

/* ===== 输入栏 ===== */
.input-bar {
  padding: 16px 20px 18px;
  border-top: 1px solid var(--border-color);
  background: var(--bg-light);

  .chat-input {
    :deep(.el-textarea__inner) {
      border-radius: 10px;
      border-color: var(--border-color);
      padding: 10px 14px;
      font-size: 14px;
      resize: none;
      background: var(--bg-color);
      color: var(--text-primary);

      &:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 2px rgba(192,57,43,.1);
      }
    }
  }

  .input-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 10px;

    .input-tip {
      font-size: 12px;
      color: #bbb;
    }

    .send-btn {
      padding: 8px 28px;
      border-radius: 8px;
      font-size: 14px;
      letter-spacing: .5px;
    }
  }
}

/* ===== 响应式 ===== */
@media (max-width: 768px) {
  .ai-chat-page { padding: 20px 0 40px; }

  .page-title-text { font-size: 20px; }

  .chat-layout { flex-direction: column; }

  .chat-aside {
    width: 100%;
    .aside-list { max-height: 160px; }
  }

  .msg-body { max-width: 82%; }

  .page-title-bar {
    flex-wrap: wrap;
    gap: 12px;
  }
}
</style>
