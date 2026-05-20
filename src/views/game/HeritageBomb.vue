<template>
  <div class="bomb-page ink-wash-bg">
    <div class="container">

      <!-- ===== 开始页 ===== -->
      <div class="start-screen" v-if="phase === 'start'">
        <!-- 标题栏 -->
        <div class="page-title-bar">
          <div class="page-title-left">
            <div class="title-icon-wrap">
              <img src="@/img/game.png" class="title-icon-img" alt="game" />
            </div>
            <div>
              <h1 class="page-title-text">非遗炸弹</h1>
              <p class="page-title-sub">诱导 AI 守护者说出项目名里的字，炸弹引爆你就赢！</p>
            </div>
          </div>
        </div>

        <!-- 规则卡片 -->
        <div class="rules-card">
          <h3 class="rules-title">游戏规则</h3>
          <ul class="rules-list">
            <li>
              <div class="rule-icon">
                <svg viewBox="0 0 24 24" width="15" height="15" fill="var(--primary-color)"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
              </div>
              <span>游戏开始后，你将提前看到本局 AI 守护的非遗项目名</span>
            </li>
            <li>
              <div class="rule-icon">
                <svg viewBox="0 0 24 24" width="15" height="15" fill="var(--primary-color)"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/></svg>
              </div>
              <span>你有 <strong>5 次</strong>提问机会，AI 必须回答但会绕开名字里的字</span>
            </li>
            <li>
              <div class="rule-icon">
                <svg viewBox="0 0 24 24" width="15" height="15" fill="var(--primary-color)"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
              </div>
              <span>AI 回答中出现名字里的<strong>任意一个字</strong>，炸弹引爆，你赢！</span>
            </li>
            <li>
              <div class="rule-icon">
                <svg viewBox="0 0 24 24" width="15" height="15" fill="var(--primary-color)"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4z"/></svg>
              </div>
              <span>5 次机会用完 AI 还没说漏嘴，守护者胜利</span>
            </li>
          </ul>
        </div>

        <div class="start-actions">
          <el-button type="primary" size="large" class="start-btn" :loading="loadingProject" @click="startGame">
            {{ loadingProject ? '正在挑选项目…' : '开始游戏' }}
          </el-button>
        </div>

        <!-- 荣耀榜 -->
        <BombLeaderboard ref="leaderboardRef" class="start-leaderboard" />
      </div>

      <!-- ===== 游戏中 ===== -->
      <div class="game-screen" v-else-if="phase === 'playing'">

        <!-- 顶部标题栏 -->
        <div class="page-title-bar">
          <div class="page-title-left">
            <div class="title-icon-wrap">
              <img src="@/img/game.png" class="title-icon-img" alt="game" />
            </div>
            <div>
              <h1 class="page-title-text">非遗炸弹</h1>
              <p class="page-title-sub">第 {{ currentRound }} / 5 轮</p>
            </div>
          </div>
          <div class="title-actions">
            <div class="attempt-indicator">
              <span class="attempt-label">剩余机会</span>
              <div class="attempt-dots">
                <span v-for="i in 5" :key="i" class="attempt-dot" :class="{ used: i > remainingAttempts }"></span>
              </div>
            </div>
            <el-button size="small" @click="giveUp" class="give-up-btn">放弃本局</el-button>
          </div>
        </div>

        <!-- 进度条 -->
        <div class="fuse-bar"><div class="fuse-fill" :style="{ width: fuseWidth }"></div></div>

        <!-- 目标信息卡 -->
        <div class="target-card">
          <div class="target-card-left">
            <span class="target-tag">本局目标</span>
            <span class="target-name">{{ secretProject }}</span>
          </div>
          <div class="target-card-right">
            <p class="target-hint">诱导 AI 说出以下任意一个字即可获胜</p>
            <div class="char-badges">
              <span v-for="char in secretProject.split('')" :key="char" class="char-badge">{{ char }}</span>
            </div>
          </div>
        </div>

        <!-- 对话区 -->
        <div class="chat-main">
          <div class="msg-list" ref="chatAreaRef">
            <div v-for="(msg, idx) in messages" :key="idx" :class="['msg-row', msg.role]">
              <!-- AI 头像 -->
              <div v-if="msg.role === 'ai'" class="msg-avatar ai-av">
                <img src="@/img/game.png" class="ai-av-img" alt="AI" />
              </div>

              <div class="msg-body" :style="msg.role === 'user' ? 'align-items:flex-end' : ''">
                <div class="msg-name">{{ msg.role === 'ai' ? 'AI 守护者' : (authStore.currentUser?.username || '你') }}</div>
                <div :class="['msg-bubble', msg.role]" v-html="formatMsg(msg.content, msg.role, msg.greeting)"></div>
              </div>

              <!-- 用户头像 -->
              <div v-if="msg.role === 'user'" class="msg-avatar user-av">
                <img v-if="userAvatar" :src="userAvatar" class="user-av-img" alt="avatar" />
                <div v-else class="user-av-default">{{ userInitial }}</div>
              </div>
            </div>

            <!-- AI 思考中 -->
            <div class="msg-row ai" v-if="aiThinking">
              <div class="msg-avatar ai-av">
                <img src="@/img/game.png" class="ai-av-img" alt="AI" />
              </div>
              <div class="msg-body">
                <div class="msg-name">AI 守护者</div>
                <div class="msg-bubble ai">
                  <div class="typing-dots"><span></span><span></span><span></span></div>
                </div>
              </div>
            </div>
          </div>

          <!-- 输入栏 -->
          <div class="input-bar">
            <el-input
              v-model="userInput"
              placeholder="提问诱导 AI 说出名字里的字…"
              :disabled="aiThinking"
              @keyup.enter="submitInput"
              maxlength="100"
              show-word-limit
              class="chat-input"
            />
            <div class="input-footer">
              <div class="quick-questions" v-if="currentRound === 0 && !aiThinking">
                <span class="quick-label">提问思路：</span>
                <button v-for="q in quickQuestions" :key="q" class="quick-btn" @click="userInput = q">{{ q }}</button>
              </div>
              <div v-else></div>
              <el-button type="primary" class="send-btn" :loading="aiThinking" :disabled="!userInput.trim()" @click="submitInput">
                <el-icon v-if="!aiThinking"><Promotion /></el-icon>
                {{ aiThinking ? '守护者思考中…' : '提 问' }}
              </el-button>
            </div>
          </div>
        </div>
      </div>

      <!-- ===== 结果页 ===== -->
      <div class="result-screen" v-else-if="phase === 'result'">

        <!-- 标题栏 -->
        <div class="page-title-bar">
          <div class="page-title-left">
            <div class="title-icon-wrap" :class="resultType === 'win' ? '' : 'title-icon-lose'">
              <img src="@/img/game.png" class="title-icon-img" alt="game" />
            </div>
            <div>
              <h1 class="page-title-text" :class="resultType === 'win' ? 'title-win' : 'title-lose'">
                {{ resultType === 'win' ? '炸弹引爆，你赢了！' : '守护者胜利' }}
              </h1>
              <p class="page-title-sub" v-if="resultType === 'win'">
                守护者在第 <strong>{{ winRound }}</strong> 轮说出了「<strong class="leaked-word">{{ leakedChar }}</strong>」这个字
              </p>
              <p class="page-title-sub" v-else>5 次机会用完，守护者成功守住了秘密</p>
            </div>
          </div>
          <div class="title-actions">
            <div class="revealed-pill">
              <span class="revealed-label">本局项目</span>
              <span class="revealed-name">{{ secretProject }}</span>
            </div>
          </div>
        </div>

        <!-- 对话回顾 -->
        <div class="chat-main result-chat">
          <div class="result-chat-header">对话回顾</div>
          <div class="msg-list result-msg-list">
            <div v-for="(msg, i) in messages" :key="i" :class="['msg-row', msg.role]">
              <div v-if="msg.role === 'ai'" class="msg-avatar ai-av">
                <img src="@/img/game.png" class="ai-av-img" alt="AI" />
              </div>
              <div class="msg-body" :style="msg.role === 'user' ? 'align-items:flex-end' : ''">
                <div class="msg-name">{{ msg.role === 'ai' ? 'AI 守护者' : (authStore.currentUser?.username || '你') }}</div>
                <div :class="['msg-bubble', msg.role]" v-html="formatMsg(msg.content, msg.role, msg.greeting)"></div>
              </div>
              <div v-if="msg.role === 'user'" class="msg-avatar user-av">
                <img v-if="userAvatar" :src="userAvatar" class="user-av-img" alt="avatar" />
                <div v-else class="user-av-default">{{ userInitial }}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="result-actions">
          <el-button type="primary" size="large" @click="startGame" :loading="loadingProject">再来一局</el-button>
          <el-button size="large" @click="phase = 'start'">返回首页</el-button>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, nextTick, computed } from 'vue'
import { Promotion } from '@element-plus/icons-vue'
import { useHeritageStore } from '@/stores/heritage'
import { useAuthStore } from '@/stores/auth'
import { playBombGame } from '@/api/ai'
import { submitBombRecord } from '@/api/bomb'
import { ElMessage } from 'element-plus'
import BombLeaderboard from '@/components/bomb/BombLeaderboard.vue'

const heritageStore = useHeritageStore()
const authStore = useAuthStore()

const userAvatar = computed(() => authStore.currentUser?.avatar || '')
const userInitial = computed(() => {
  const name = authStore.currentUser?.username || ''
  return name ? name.charAt(0).toUpperCase() : '我'
})

const phase = ref('start')
const loadingProject = ref(false)
const aiThinking = ref(false)

const secretProject = ref('')
const currentRound = ref(0)
const remainingAttempts = ref(5)
const messages = ref([])
const userInput = ref('')
const winRound = ref(0)
const leakedChar = ref('')
const resultType = ref('')
const chatAreaRef = ref(null)
const questionHistory = ref([])
const leaderboardRef = ref(null)

const quickQuestions = [
  '这个非遗项目通常在什么节日表演？',
  '它流传于哪个省份或地区？',
  '请描述它的代表性技法或动作',
  '这个项目的名称有什么含义？',
]

const fuseWidth = computed(() => `${((5 - remainingAttempts.value) / 5) * 100}%`)

const pickRandomProject = async () => {
  loadingProject.value = true
  try {
    let list = heritageStore.heritageList
    if (!list || list.length === 0) list = await heritageStore.fetchHeritageList()
    if (!list || list.length === 0) {
      ElMessage.error('暂无非遗数据，请确保后端已启动')
      return null
    }
    return list[Math.floor(Math.random() * list.length)].name
  } finally {
    loadingProject.value = false
  }
}

const startGame = async () => {
  const name = await pickRandomProject()
  if (!name) return

  secretProject.value = name
  currentRound.value = 0
  remainingAttempts.value = 5
  messages.value = []
  questionHistory.value = []
  userInput.value = ''
  resultType.value = ''
  leakedChar.value = ''
  winRound.value = 0
  phase.value = 'playing'

  messages.value.push({
    role: 'ai',
    greeting: true,
    content: `游戏开始！我心里守护着一个非遗项目的秘密，你已经知道是哪个了——但我绝对不会亲口说出名字里的字！你有 5 次提问机会，尽管来！`
  })
}

const submitInput = async () => {
  const text = userInput.value.trim()
  if (!text || aiThinking.value) return
  await handleQuestion(text)
}

const handleQuestion = async (question) => {
  if (remainingAttempts.value <= 0) return

  currentRound.value++
  remainingAttempts.value--
  questionHistory.value.push(question)

  messages.value.push({ role: 'user', content: question })
  userInput.value = ''
  aiThinking.value = true
  scrollToBottom()

  try {
    const reply = await playBombGame({
      project: secretProject.value,
      question,
      round: currentRound.value,
      remaining: remainingAttempts.value,
      history: questionHistory.value.slice(0, -1)
    })

    messages.value.push({ role: 'ai', content: reply })

    const leaked = checkLeaked(reply, secretProject.value)
    if (leaked) {
      leakedChar.value = leaked
      winRound.value = currentRound.value
      resultType.value = 'win'
      // 保存挑战成功记录到数据库
      const user = authStore.currentUser
      if (user?.userId) {
        submitBombRecord({
          userId: user.userId,
          username: user.username || '',
          projectName: secretProject.value,
          winRound: currentRound.value,
          leakedChar: leaked,
          messages: messages.value
        }).then(() => {
          // 胜利后刷新榜单（返回开始页时显示最新）
          leaderboardRef.value?.load()
        }).catch(() => {/* 静默失败 */})
      }
      await nextTick()
      setTimeout(() => { phase.value = 'result' }, 800)
    } else if (remainingAttempts.value <= 0) {
      resultType.value = 'lose'
      messages.value.push({
        role: 'ai',
        greeting: true,
        content: `5 次机会用完啦！我成功守住了秘密，下次试试更刁钻的问题？`
      })
      await nextTick()
      setTimeout(() => { phase.value = 'result' }, 1200)
    }
  } catch (e) {
    ElMessage.error('AI 回复失败，请检查网络')
    messages.value.push({ role: 'ai', greeting: true, content: '守护者暂时失联了，请稍后再试…' })
  } finally {
    aiThinking.value = false
    scrollToBottom()
  }
}

const checkLeaked = (reply, projectName) => {
  for (const char of projectName) {
    if (char.trim() && reply.includes(char)) return char
  }
  return null
}

const giveUp = () => {
  resultType.value = 'lose'
  phase.value = 'result'
}

const formatMsg = (text, role, greeting) => {
  if (!text) return ''
  if (role !== 'ai' || greeting) return text
  const project = secretProject.value
  if (!project) return text
  let result = text
  for (const char of project) {
    if (!char.trim()) continue
    result = result.replace(
      new RegExp(char, 'g'),
      `<mark class="leaked-highlight">${char}</mark>`
    )
  }
  return result
}

const scrollToBottom = async () => {
  await nextTick()
  if (chatAreaRef.value) chatAreaRef.value.scrollTop = chatAreaRef.value.scrollHeight
}
</script>

<style lang="scss" scoped>
.bomb-page {
  min-height: calc(100vh - 140px);
  padding: 40px 0 60px;

  .container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 0 20px;
  }
}

// ===== 标题栏（复用 AiChat 风格）=====
.page-title-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 12px;
}

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
  overflow: hidden;

  &.title-icon-lose {
    background: var(--secondary-color);
  }
}

.title-icon-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 14px;
}

.page-title-text {
  font-size: 24px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 4px;
  font-family: "Source Han Serif SC", "STSong", serif;

  &.title-win  { color: var(--primary-color); }
  &.title-lose { color: var(--secondary-color); }
}

.page-title-sub {
  font-size: 13px;
  color: var(--text-secondary);
  margin: 0;
  line-height: 1.5;

  strong { color: var(--primary-dark); }
}

.title-actions {
  display: flex;
  align-items: center;
  gap: 14px;
}

.leaked-word {
  color: var(--primary-color);
  font-size: 1.1em;
}

// 剩余机会指示器
.attempt-indicator {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 5px;
}

.attempt-label {
  font-size: 11px;
  color: var(--text-light);
  letter-spacing: 0.5px;
}

.attempt-dots {
  display: flex;
  gap: 5px;
}

.attempt-dot {
  width: 11px;
  height: 11px;
  border-radius: 50%;
  background: var(--primary-color);
  box-shadow: 0 0 4px rgba(200,48,43,0.35);
  transition: all 0.3s;

  &.used {
    background: var(--border-color);
    box-shadow: none;
  }
}

.give-up-btn {
  font-size: 12px;
  color: var(--text-secondary);
  border-color: var(--border-color);
}

// 揭晓胶囊
.revealed-pill {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 8px 16px;
}

.revealed-label {
  font-size: 12px;
  color: var(--text-light);
}

.revealed-name {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--primary-color);
  letter-spacing: 3px;
  font-family: "Source Han Serif SC", "STSong", serif;
}

// ===== 进度条 =====
.fuse-bar {
  height: 3px;
  background: var(--border-light);
  border-radius: 2px;
  overflow: hidden;
  margin-bottom: 16px;
}

.fuse-fill {
  height: 100%;
  background: linear-gradient(to right, #4caf50, #ff9800, var(--primary-color));
  border-radius: 2px;
  transition: width 0.4s ease;
}

// ===== 目标信息卡 =====
.target-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-left: 3px solid var(--primary-color);
  border-radius: 10px;
  padding: 14px 20px;
  margin-bottom: 16px;
  box-shadow: var(--shadow-sm);
  flex-wrap: wrap;
  gap: 12px;
}

.target-card-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.target-tag {
  font-size: 11px;
  color: var(--text-light);
  border: 1px solid var(--border-color);
  border-radius: 4px;
  padding: 2px 8px;
  background: var(--bg-color);
  white-space: nowrap;
}

.target-name {
  font-size: 1.5rem;
  font-weight: 900;
  color: var(--primary-color);
  letter-spacing: 4px;
  font-family: "Source Han Serif SC", "STSong", serif;
}

.target-card-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
}

.target-hint {
  font-size: 12px;
  color: var(--text-secondary);
  margin: 0;
}

.char-badges {
  display: flex;
  gap: 5px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.char-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 6px;
  background: var(--primary-color);
  color: #fff;
  font-size: 0.95rem;
  font-weight: 700;
  box-shadow: 0 2px 5px rgba(200,48,43,0.25);
  font-family: "Source Han Serif SC", "STSong", serif;
}

// ===== 聊天主区（复用 AiChat 风格）=====
.chat-main {
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  box-shadow: var(--shadow-sm);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.msg-list {
  flex: 1;
  min-height: 360px;
  max-height: 420px;
  overflow-y: auto;
  padding: 24px 20px;

  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-thumb { background: #ddd; border-radius: 2px; }
}

.msg-row {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  margin-bottom: 18px;

  &.user { justify-content: flex-end; }
}

.msg-avatar {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;

  &.ai-av { background: transparent; }
}

.ai-av-img {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  object-fit: cover;
}

.user-av-img {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  object-fit: cover;
}

.user-av-default {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: var(--primary-color);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.85rem;
  font-weight: 700;
}

.msg-body {
  max-width: 68%;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.msg-name {
  font-size: 11px;
  color: var(--text-light);
  padding: 0 2px;
}

.msg-row.user .msg-name {
  text-align: right;
}

.msg-bubble {
  padding: 10px 14px;
  border-radius: 10px;
  font-size: 14px;
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

  :deep(.leaked-highlight) {
    background: rgba(200,48,43,0.12);
    color: var(--primary-color);
    font-weight: 900;
    border-bottom: 2px solid var(--primary-color);
    padding: 0 2px;
    border-radius: 2px;
  }
}

.typing-dots {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 2px 0;

  span {
    width: 7px;
    height: 7px;
    background: #bbb;
    border-radius: 50%;
    animation: dot-bounce 1.2s infinite ease-in-out;

    &:nth-child(2) { animation-delay: .2s; }
    &:nth-child(3) { animation-delay: .4s; }
  }
}

@keyframes dot-bounce {
  0%, 60%, 100% { transform: translateY(0); opacity: .4; }
  30% { transform: translateY(-6px); opacity: 1; }
}

// ===== 输入栏 =====
.input-bar {
  padding: 14px 18px 16px;
  border-top: 1px solid var(--border-color);
  background: var(--bg-light);

  .chat-input {
    :deep(.el-input__wrapper) {
      border-radius: 8px;
      background: var(--bg-color);
    }
    :deep(.el-input__inner) {
      font-size: 14px;
      color: var(--text-primary);
    }
  }
}

.input-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 10px;
  flex-wrap: wrap;
  gap: 8px;
}

.quick-questions {
  display: flex;
  align-items: center;
  gap: 7px;
  flex-wrap: wrap;
}

.quick-label {
  font-size: 12px;
  color: #aaa;
  white-space: nowrap;
}

.quick-btn {
  background: var(--bg-color);
  border: 1px solid var(--border-color);
  border-radius: 20px;
  padding: 4px 12px;
  font-size: 12px;
  color: var(--text-secondary);
  cursor: pointer;
  transition: all .2s;

  &:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
    background: rgba(192,57,43,.04);
  }
}

.send-btn {
  padding: 8px 24px;
  border-radius: 8px;
  font-size: 14px;
  flex-shrink: 0;
}

// ===== 规则卡片（开始页）=====
.start-screen {
  max-width: 680px;
  margin: 0 auto;

  .rules-card,
  .start-actions,
  .start-leaderboard {
    max-width: 680px;
    width: 100%;
  }
}

.rules-card {
  background: var(--bg-light);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  padding: 26px 28px;
  margin-bottom: 28px;
  box-shadow: var(--shadow-sm);
}

.rules-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
  margin: 0 0 18px;
  letter-spacing: 1px;
}

.rules-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 14px;

  li {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    font-size: 14px;
    color: var(--text-secondary);
    line-height: 1.65;

    strong { color: var(--primary-dark); }
  }
}

.rule-icon {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: rgba(200,48,43,0.08);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 1px;
}

.start-actions {
  text-align: center;
}

.start-btn {
  padding: 12px 52px;
  font-size: 15px;
  border-radius: 8px;
  letter-spacing: 2px;
  font-weight: 600;
}

.start-leaderboard {
  margin-top: 28px;
}

// ===== 结果页 =====
.result-chat {
  .result-chat-header {
    padding: 12px 20px;
    font-size: 13px;
    font-weight: 600;
    color: var(--text-secondary);
    border-bottom: 1px solid var(--border-color);
    background: var(--bg-color);
    letter-spacing: 0.5px;
  }
}

.result-msg-list {
  min-height: 280px;
  max-height: 400px;
}

.result-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 24px;
}

// ===== 响应式 =====
@media (max-width: 768px) {
  .bomb-page { padding: 20px 0 40px; }
  .page-title-text { font-size: 20px; }
  .target-card { flex-direction: column; align-items: flex-start; }
  .target-card-right { align-items: flex-start; }
  .char-badges { justify-content: flex-start; }
  .msg-body { max-width: 82%; }
  .title-actions { gap: 8px; }
}
</style>
