<template>
  <!-- 只在 PC 端显示 -->
  <div v-if="!isMobile" class="ai-float-wrap">
    <!-- 聊天对话框 -->
    <transition name="chat-pop">
      <div v-if="open" class="ai-chat-box">
        <!-- 头部 -->
        <div class="chat-header">
          <div class="chat-header-left">
            <div class="avatar-ring">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/></svg>
            </div>
            <div>
              <div class="chat-title">遗遗问答</div>
              <div class="chat-subtitle">非遗文化小助手</div>
            </div>
          </div>
          <button class="close-btn" @click="open = false">
            <svg viewBox="0 0 24 24" width="18" height="18"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" fill="currentColor"/></svg>
          </button>
        </div>

        <!-- 消息列表 -->
        <div class="chat-messages" ref="msgListRef">
          <!-- 欢迎语 -->
          <div v-if="messages.length === 0" class="welcome-msg">
            <div class="bot-bubble">
              哇，你来啦～ (≧▽≦) 我是遗遗，专注非遗文化的小助手！有什么想问的尽管说哟~
            </div>
          </div>

          <div v-for="(msg, i) in messages" :key="i" class="msg-row" :class="msg.role">
          <div v-if="msg.role === 'assistant'" class="bot-avatar">
              <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/></svg>
            </div>
            <div class="bubble" :class="msg.role">
              <span v-if="msg.role === 'assistant'" v-html="renderMd(msg.content)"></span>
              <span v-else>{{ msg.content }}</span>
            </div>
          </div>

          <!-- 打字中 -->
          <div v-if="loading" class="msg-row assistant">
            <div class="bot-avatar">
              <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/></svg>
            </div>
            <div class="bubble assistant typing">
              <span class="dot"></span><span class="dot"></span><span class="dot"></span>
            </div>
          </div>
        </div>

        <!-- 输入框 -->
        <div class="chat-input-wrap">
          <input
            v-model="inputText"
            class="chat-input"
            placeholder="问问遗遗吧..."
            @keydown.enter.exact.prevent="send"
            :disabled="loading"
            maxlength="300"
            ref="inputRef"
          />
          <button class="send-btn" @click="send" :disabled="loading || !inputText.trim()">
            <svg viewBox="0 0 24 24" width="18" height="18"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" fill="currentColor"/></svg>
          </button>
        </div>
      </div>
    </transition>

    <!-- 个人中心按钮 -->
    <div class="float-btn profile-btn" @click="goProfile">
      <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor">
        <path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/>
      </svg>
      <span class="float-label">个人中心</span>
    </div>

    <!-- 悬浮按钮 -->
    <div class="float-btn" @click="toggleChat" :class="{ active: open }">
      <transition name="icon-switch" mode="out-in">
        <svg v-if="open" key="close" viewBox="0 0 24 24" width="18" height="18">
          <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z" fill="currentColor"/>
        </svg>
        <svg v-else key="chat" viewBox="0 0 24 24" width="18" height="18">
          <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z" fill="currentColor"/>
        </svg>
      </transition>
      <span class="float-label">{{ open ? '关闭' : 'AI 助手' }}</span>
      <!-- 未读红点 -->
      <span v-if="unread > 0 && !open" class="unread-dot">{{ unread > 9 ? '9+' : unread }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, nextTick, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { sendChatMessage } from '@/api/ai.js'

const router = useRouter()
const goProfile = () => router.push('/profile')

const STORAGE_KEY = 'ai_chat_history'

const open = ref(false)
const inputText = ref('')
const loading = ref(false)
const unread = ref(0)
const msgListRef = ref(null)
const inputRef = ref(null)
const windowWidth = ref(window.innerWidth)

// 从 localStorage 恢复聊天记录
const loadMessages = () => {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : []
  } catch {
    return []
  }
}
const messages = ref(loadMessages())

// 监听 messages 变化，自动同步到 localStorage
watch(messages, (val) => {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(val))
  } catch {}
}, { deep: true })

const isMobile = computed(() => windowWidth.value <= 768)

const handleResize = () => { windowWidth.value = window.innerWidth }
onMounted(() => window.addEventListener('resize', handleResize))
onUnmounted(() => window.removeEventListener('resize', handleResize))

const toggleChat = () => {
  open.value = !open.value
  if (open.value) {
    unread.value = 0
    nextTick(() => {
      scrollBottom()
      inputRef.value?.focus()
    })
  }
}

const scrollBottom = () => {
  nextTick(() => {
    if (msgListRef.value) {
      msgListRef.value.scrollTop = msgListRef.value.scrollHeight
    }
  })
}

// 简单 markdown 渲染（加粗、换行）
const renderMd = (text) => {
  return text
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\n/g, '<br/>')
}

// 获取历史（只取最近 10 条，避免 token 超限）
const getHistory = () => {
  return messages.value.slice(-10).map(m => ({ role: m.role, content: m.content }))
}

const send = async () => {
  const text = inputText.value.trim()
  if (!text || loading.value) return

  messages.value.push({ role: 'user', content: text })
  inputText.value = ''
  loading.value = true
  scrollBottom()

  try {
    const history = getHistory().slice(0, -1) // 不含刚加进去的这条
    const reply = await sendChatMessage(text, history)
    messages.value.push({ role: 'assistant', content: reply })
    if (!open.value) unread.value++
  } catch (e) {
    messages.value.push({ role: 'assistant', content: '哎呀，出了点小问题，稍后再试试吧 (>_<)' })
  } finally {
    loading.value = false
    scrollBottom()
  }
}
</script>

<style lang="scss" scoped>
.ai-float-wrap {
  position: fixed;
  right: 40px;
  bottom: 122px;
  z-index: 2000;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 12px;
}

/* 悬浮按钮 - 胶囊形，图标+文字 */
.float-btn {
  position: relative;
  width: 120px;
  height: 44px;
  padding: 0 16px 0 12px;
  background: var(--primary-color);
  color: #fff;
  border-radius: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  cursor: pointer;
  box-shadow: var(--shadow-md);
  transition: var(--transition);
  white-space: nowrap;
  user-select: none;

  &:hover {
    background: var(--primary-light);
    transform: translateY(-3px);
    box-shadow: var(--shadow-lg);
  }

  &:active {
    transform: translateY(-1px);
  }
}

.float-label {
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.04em;
}

/* 个人中心按钮用稍深的配色区分 */
.profile-btn {
  background: rgba(var(--primary-color-rgb, 200, 48, 43), 0.82);
  backdrop-filter: blur(4px);

  &:hover {
    background: var(--primary-color);
  }
}

.unread-dot {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 18px;
  height: 18px;
  padding: 0 4px;
  background: #f5a623;
  color: #fff;
  border-radius: 9px;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid #fff;
}

/* 聊天对话框 */
.ai-chat-box {
  width: 360px;
  height: 500px;
  background: #fff;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.18);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  border: 1px solid rgba(200, 48, 43, 0.12);
}

/* 头部 */
.chat-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  background: linear-gradient(135deg, #c8302b 0%, #e05a3a 100%);
  color: #fff;
  flex-shrink: 0;
}

.chat-header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.avatar-ring {
  width: 36px;
  height: 36px;
  background: rgba(255,255,255,0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
}

.chat-title {
  font-size: 15px;
  font-weight: 700;
  line-height: 1.2;
}

.chat-subtitle {
  font-size: 11px;
  opacity: 0.8;
  margin-top: 1px;
}

.close-btn {
  background: rgba(255,255,255,0.2);
  border: none;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: #fff;
  transition: background 0.2s;
  flex-shrink: 0;

  &:hover { background: rgba(255,255,255,0.35); }
}

/* 消息列表 */
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px 14px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  background: #fdf9f5;

  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-thumb { background: #ddd; border-radius: 2px; }
}

.welcome-msg .bot-bubble {
  background: #fff;
  border: 1px solid #f0e0d0;
  border-radius: 4px 14px 14px 14px;
  padding: 10px 14px;
  font-size: 13px;
  color: #444;
  line-height: 1.6;
  max-width: 85%;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}

.msg-row {
  display: flex;
  align-items: flex-end;
  gap: 8px;

  &.user {
    flex-direction: row-reverse;
  }
}

.bot-avatar {
  width: 28px;
  height: 28px;
  background: linear-gradient(135deg, #c8302b, #e05a3a);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: #fff;
}

.bubble {
  max-width: 78%;
  padding: 9px 13px;
  font-size: 13.5px;
  line-height: 1.65;
  word-break: break-word;

  &.assistant {
    background: #fff;
    border: 1px solid #f0e0d0;
    border-radius: 4px 14px 14px 14px;
    color: #333;
    box-shadow: 0 1px 4px rgba(0,0,0,0.06);

    :deep(strong) { color: #c8302b; }
  }

  &.user {
    background: linear-gradient(135deg, #c8302b, #e05a3a);
    border-radius: 14px 4px 14px 14px;
    color: #fff;
  }

  &.typing {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 12px 16px;
  }
}

.dot {
  width: 7px;
  height: 7px;
  background: #c8302b;
  border-radius: 50%;
  animation: bounce 1.2s infinite;

  &:nth-child(2) { animation-delay: 0.2s; }
  &:nth-child(3) { animation-delay: 0.4s; }
}

@keyframes bounce {
  0%, 60%, 100% { transform: translateY(0); opacity: 0.5; }
  30% { transform: translateY(-5px); opacity: 1; }
}

/* 输入区域 */
.chat-input-wrap {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 14px;
  border-top: 1px solid #f0e0d0;
  background: #fff;
  flex-shrink: 0;
}

.chat-input {
  flex: 1;
  height: 38px;
  padding: 0 12px;
  border: 1.5px solid #e8d8c8;
  border-radius: 19px;
  font-size: 13.5px;
  color: #333;
  background: #fdf9f5;
  outline: none;
  transition: border-color 0.2s;

  &:focus { border-color: #c8302b; background: #fff; }
  &::placeholder { color: #bbb; }
  &:disabled { opacity: 0.6; }
}

.send-btn {
  width: 38px;
  height: 38px;
  background: linear-gradient(135deg, #c8302b, #e05a3a);
  border: none;
  border-radius: 50%;
  color: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  flex-shrink: 0;

  &:hover:not(:disabled) { transform: scale(1.08); box-shadow: 0 3px 10px rgba(200,48,43,0.4); }
  &:disabled { opacity: 0.45; cursor: not-allowed; }
}

/* 弹出动画 */
.chat-pop-enter-active {
  animation: pop-in 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.chat-pop-leave-active {
  animation: pop-in 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) reverse;
}
@keyframes pop-in {
  from { opacity: 0; transform: scale(0.85) translateY(20px); transform-origin: bottom right; }
  to   { opacity: 1; transform: scale(1) translateY(0);       transform-origin: bottom right; }
}

/* 图标切换动画 */
.icon-switch-enter-active, .icon-switch-leave-active { transition: all 0.15s; }
.icon-switch-enter-from { opacity: 0; transform: rotate(-45deg) scale(0.5); }
.icon-switch-leave-to   { opacity: 0; transform: rotate(45deg) scale(0.5); }
</style>
