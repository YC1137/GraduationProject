<template>
    <div class="quiz-page">
      <div class="container">
        <!-- 开始页面 -->
        <div class="quiz-start" v-if="!quizStarted && !showResult">
          <div class="start-card">
            <div class="quiz-icon">
              <el-icon :size="80"><TrophyBase /></el-icon>
            </div>
            <h1 class="quiz-title">非遗知识测验</h1>
            
            <!-- 专题选择 -->
            <div class="topic-selection" v-if="!loading && topics.length > 0">
              <h3>选择测验专题：</h3>
              <el-radio-group v-model="selectedTopic" size="large" class="topic-radio-group">
                <el-radio-button value="">全部专题</el-radio-button>
                <el-radio-button 
                  v-for="topic in topics" 
                  :key="topic" 
                  :value="topic"
                >
                  {{ topic }}
                </el-radio-button>
              </el-radio-group>
            </div>
            
            <p class="quiz-desc" v-if="!loading && questions.length > 0">
              <span v-if="selectedTopic">{{ selectedTopic }}专题 - </span>
              共 {{ questions.length }} 道题目，每题 {{ pointsPerQuestion }} 分
            </p>
            <p class="quiz-desc" v-if="loading">
              正在加载题目，请稍候...
            </p>
            <p class="quiz-desc" v-if="!loading && questions.length === 0">
              暂无题目数据
            </p>
            <div class="quiz-rules" v-if="!loading && questions.length > 0">
              <h3>测验规则：</h3>
              <ul>
                <li>每道题只有一个正确答案</li>
                <li>选择答案后不可更改</li>
                <li>完成所有题目后自动显示结果</li>
                <li>根据得分获得相应评级</li>
              </ul>
            </div>
            <el-button 
              type="primary" 
              size="large" 
              @click="startQuiz"
              class="start-btn"
              :disabled="loading || questions.length === 0"
              :loading="loading"
            >
              开始测验
              <el-icon class="el-icon--right"><Right /></el-icon>
            </el-button>
          </div>

          <!-- 新增：开始页面的排行榜展示 -->
          <div class="start-rankings" v-if="!loading && questions.length > 0">
            <div class="rankings-header">
              <h3><el-icon><Trophy /></el-icon> {{ selectedTopic || '全站' }}排行榜</h3>
              <el-radio-group v-model="rankingType" @change="switchRankingType" size="small">
                <el-radio-button value="topic" v-if="selectedTopic">专题榜</el-radio-button>
                <el-radio-button value="global">总榜</el-radio-button>
              </el-radio-group>
            </div>
            
            <div class="mini-rankings-table" v-loading="loadingRankings">
              <div class="table-header">
                <div class="col-rank">排名</div>
                <div class="col-user">用户</div>
                <div class="col-accuracy">正确率</div>
                <div class="col-time">用时</div>
                <div class="col-count">已答题目</div>
              </div>
              <div class="table-body">
                <div v-for="(item, index) in rankings.slice(0, 5)" :key="item.id" class="table-row">
                  <div class="col-rank">
                    <span class="rank-badge-sm" :class="getRankClass(index)">{{ index + 1 }}</span>
                  </div>
                  <div class="col-user">{{ item.username }}</div>
                  <div class="col-accuracy">{{ item.accuracy }}%</div>
                  <div class="col-time">{{ formatTime(item.timeSpent) }}</div>
                  <div class="col-count">{{ item.totalCount }} 题</div>
                </div>
                <div v-if="rankings.length === 0" class="empty-mini">暂无记录，快来挑战吧！</div>
              </div>
            </div>
          </div>
        </div>
  
        <!-- 答题页面 -->
        <div class="quiz-content" v-if="quizStarted && !showResult">
          <!-- 进度条 -->
          <div class="quiz-progress">
            <div class="progress-info">
              <span>第 {{ currentIndex + 1 }} / {{ questions.length }} 题</span>
              <span class="timer-display">
                <el-icon><Timer /></el-icon>
                {{ formatTime(timeSpent) }}
              </span>
              <span>已完成 {{ answeredCount }} 题</span>
            </div>
            <el-progress 
              :percentage="progressPercentage" 
              :color="progressColor"
              :stroke-width="8"
            />
          </div>
  
          <!-- 题目卡片 -->
          <div class="question-card">
            <h2 class="question-title">
              <span class="question-number">{{ currentIndex + 1 }}.</span>
              {{ currentQuestion.question }}
            </h2>
  
            <div class="options-list">
              <div 
                v-for="(option, index) in currentQuestion.options"
                :key="index"
                class="option-item"
                :class="{
                  'selected': selectedAnswer === index,
                  'correct': showAnswer && index === currentQuestion.answer,
                  'wrong': showAnswer && selectedAnswer === index && selectedAnswer !== currentQuestion.answer
                }"
                @click="selectOption(index)"
              >
                <div class="option-prefix">{{ getOptionPrefix(index) }}</div>
                <div class="option-text">{{ option }}</div>
                <div class="option-icon" v-if="showAnswer">
                  <el-icon v-if="index === currentQuestion.answer" color="#67c23a">
                    <CircleCheck />
                  </el-icon>
                  <el-icon v-else-if="selectedAnswer === index" color="#f56c6c">
                    <CircleClose />
                  </el-icon>
                </div>
              </div>
            </div>
  
            <!-- 答案解析 -->
            <transition name="fade">
              <div class="answer-explanation" v-if="showAnswer">
                <div class="explanation-header">
                  <el-icon :size="20"><InfoFilled /></el-icon>
                  <span>答案解析</span>
                </div>
                <p>{{ currentQuestion.explanation }}</p>
              </div>
            </transition>
  
            <!-- 操作按钮 -->
            <div class="question-actions">
              <el-button 
                @click="prevQuestion" 
                :disabled="currentIndex === 0"
              >
                <el-icon><ArrowLeft /></el-icon>
                上一题
              </el-button>
              
              <el-button 
                v-if="!showAnswer && selectedAnswer !== null"
                type="primary"
                @click="confirmAnswer"
              >
                确认答案
              </el-button>
  
              <el-button 
                v-if="currentIndex < questions.length - 1"
                type="primary"
                @click="nextQuestion"
                :disabled="!answers[currentIndex]"
              >
                下一题
                <el-icon><ArrowRight /></el-icon>
              </el-button>
  
              <el-button 
                v-if="currentIndex === questions.length - 1 && answeredCount === questions.length"
                type="success"
                @click="submitQuiz"
              >
                提交答卷
                <el-icon><Check /></el-icon>
              </el-button>
            </div>
          </div>
        </div>
  
        <!-- 结果页面 -->
        <div class="quiz-result" v-if="showResult">
          <div class="result-card">
            <div class="result-icon" :class="ratingClass">
              <el-icon :size="100"><Trophy /></el-icon>
            </div>
            <h1 class="result-title">测验完成！</h1>
            <div class="result-score">
              <div class="score-value">{{ score }}</div>
              <div class="score-total">/ {{ totalScore }} 分</div>
            </div>
            <div class="result-rating" :style="{ color: ratingColor }">
              {{ rating }}
            </div>
            <p class="result-message">{{ ratingMessage }}</p>
  
            <!-- 答题统计 -->
            <div class="result-stats">
              <div class="stat-item">
                <div class="stat-value">{{ correctCount }}</div>
                <div class="stat-label">答对</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ wrongCount }}</div>
                <div class="stat-label">答错</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ accuracy }}%</div>
                <div class="stat-label">正确率</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ formatTime(timeSpent) }}</div>
                <div class="stat-label">用时</div>
              </div>
            </div>
  
            <!-- 错题列表 -->
            <div class="wrong-questions" v-if="wrongQuestions.length > 0">
              <h3>错题回顾</h3>
              <div class="wrong-list">
                <div 
                  v-for="item in wrongQuestions" 
                  :key="item.index"
                  class="wrong-item"
                >
                  <div class="wrong-header">
                    <span class="wrong-number">第 {{ item.index + 1 }} 题</span>
                    <el-tag type="danger" size="small">答错</el-tag>
                    <el-button
                      size="small"
                      class="ai-analyze-btn"
                      :loading="aiAnalysis[item.index]?.loading"
                      @click="askAI(item)"
                    >
                      <el-icon v-if="!aiAnalysis[item.index]?.loading"><ChatDotRound /></el-icon>
                      {{ aiAnalysis[item.index]?.loading ? '遗遗思考中...' : '问遗遗' }}
                    </el-button>
                  </div>
                  <p class="wrong-question">{{ item.question.question }}</p>
                  <div class="wrong-answer">
                    <span class="answer-label">你的答案：</span>
                    <span class="answer-value wrong">
                      {{ item.question.options[item.userAnswer] }}
                    </span>
                  </div>
                  <div class="correct-answer">
                    <span class="answer-label">正确答案：</span>
                    <span class="answer-value correct">
                      {{ item.question.options[item.question.answer] }}
                    </span>
                  </div>
                  <!-- AI 解析 + 追问 -->
                  <transition name="ai-slide">
                    <div class="ai-analysis" v-if="aiAnalysis[item.index]?.content || aiAnalysis[item.index]?.loading">
                      <!-- 等待动画 -->
                      <div class="ai-thinking" v-if="aiAnalysis[item.index]?.loading">
                        <div class="thinking-avatar">
                          <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                            <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                          </svg>
                        </div>
                        <div class="thinking-dots">
                          <span></span><span></span><span></span>
                        </div>
                        <span class="thinking-text">遗遗思考中</span>
                      </div>

                      <!-- 解析内容 -->
                      <template v-if="aiAnalysis[item.index]?.content">
                        <div class="ai-analysis-header">
                          <div class="ai-avatar">
                            <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor">
                              <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                            </svg>
                          </div>
                          <span>遗遗解析</span>
                        </div>
                        <p class="ai-analysis-content">{{ aiAnalysis[item.index].content }}</p>

                        <!-- 追问对话区 -->
                        <div class="ai-followup">
                          <!-- 追问历史 -->
                          <div class="followup-history" v-if="aiFollowup[item.index]?.messages?.length">
                            <div
                              v-for="(msg, mi) in aiFollowup[item.index].messages"
                              :key="mi"
                              class="followup-bubble"
                              :class="msg.role === 'user' ? 'bubble-user' : 'bubble-bot'"
                            >
                              <div class="bubble-avatar" v-if="msg.role === 'assistant'">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor">
                                  <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                                </svg>
                              </div>
                              <div class="bubble-content" :style="msg.role === 'user' ? 'text-align: right' : ''">{{ msg.content }}</div>
                              <div class="bubble-user-icon" v-if="msg.role === 'user'">
                                <el-avatar :src="authStore.currentUser?.avatar" :size="26" />
                              </div>
                            </div>
                            <!-- 追问等待动画 -->
                            <div class="followup-bubble bubble-bot" v-if="aiFollowup[item.index]?.loading">
                              <div class="bubble-avatar">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor">
                                  <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                                </svg>
                              </div>
                              <div class="bubble-content bubble-loading">
                                <span></span><span></span><span></span>
                              </div>
                            </div>
                          </div>
                          <!-- 没有追问历史但正在等待 -->
                          <div class="followup-history" v-else-if="aiFollowup[item.index]?.loading">
                            <div class="followup-bubble bubble-bot">
                              <div class="bubble-avatar">
                                <svg viewBox="0 0 24 24" width="12" height="12" fill="currentColor">
                                  <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2z"/>
                                </svg>
                              </div>
                              <div class="bubble-content bubble-loading">
                                <span></span><span></span><span></span>
                              </div>
                            </div>
                          </div>

                          <!-- 输入框 -->
                          <div class="followup-input-row">
                            <el-input
                              v-model="aiFollowup[item.index].input"
                              placeholder="还有疑问？继续问遗遗～"
                              :disabled="aiFollowup[item.index]?.loading"
                              @keyup.enter="sendFollowup(item)"
                              class="followup-input"
                            >
                              <template #prefix>
                                <el-icon style="color:#bbb"><ChatDotRound /></el-icon>
                              </template>
                            </el-input>
                            <button
                              class="followup-send-btn"
                              :class="{ loading: aiFollowup[item.index]?.loading }"
                              :disabled="!aiFollowup[item.index]?.input?.trim() || aiFollowup[item.index]?.loading"
                              @click="sendFollowup(item)"
                            >
                              <svg v-if="!aiFollowup[item.index]?.loading" viewBox="0 0 24 24" width="16" height="16" fill="currentColor">
                                <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/>
                              </svg>
                              <span v-else class="btn-dots"><i></i><i></i><i></i></span>
                            </button>
                          </div>
                        </div>
                      </template>
                    </div>
                  </transition>
                </div>
              </div>
            </div>
  
            <!-- 操作按钮 -->
            <div class="result-actions">
              <el-button size="large" @click="retryQuiz">
                <el-icon><RefreshRight /></el-icon>
                重新测验
              </el-button>
              <el-button type="primary" size="large" @click="goHome">
                <el-icon><HomeFilled /></el-icon>
                返回首页
              </el-button>
            </div>

            <!-- 铸造藏品入口 -->
            <div class="mint-entry" v-if="accuracy >= 60">
              <div class="mint-entry-tip">
                <span class="mint-tip-icon">🎴</span>
                <div>
                  <strong>恭喜！你的成绩符合铸造条件</strong>
                  <p>正确率 {{ accuracy }}%，可铸造
                    <span :class="mintRarityClass">{{ mintRarityLabel }}</span>
                    级数字藏品
                  </p>
                </div>
              </div>
              <el-button type="warning" size="large" class="mint-btn" @click="goMintCollection">
                🏆 立即铸造藏品
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
<script setup>
import { ref, computed, onMounted, watch, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { getQuizQuestions, getQuizTopics, getQuestionsByTopic, submitQuizRecord, getTopRankings, getTopicRanking } from '@/api/quiz'
import { useAuthStore } from '@/stores/auth'
import { ElMessage, ElLoading } from 'element-plus'
import {
  TrophyBase,
  Trophy,
  Right,
  ArrowLeft,
  ArrowRight,
  Check,
  CircleCheck,
  CircleClose,
  InfoFilled,
  RefreshRight,
  HomeFilled,
  Timer,
  ChatDotRound
} from '@element-plus/icons-vue'
import { sendChatMessage } from '@/api/ai'

// ===== 错题 AI 解析 =====
// key: item.index，value: { loading: bool, content: string }
const aiAnalysis = ref({})

// 追问对话：key: item.index，value: { input: string, loading: bool, messages: [{role, content}] }
const aiFollowup = ref({})

// 确保某道题的追问对象已初始化
const ensureFollowup = (idx) => {
  if (!aiFollowup.value[idx]) {
    aiFollowup.value[idx] = { input: '', loading: false, messages: [] }
  }
}

const sendFollowup = async (item) => {
  const idx = item.index
  ensureFollowup(idx)
  const text = aiFollowup.value[idx].input.trim()
  if (!text || aiFollowup.value[idx].loading) return

  aiFollowup.value[idx].messages.push({ role: 'user', content: text })
  aiFollowup.value[idx].input = ''
  aiFollowup.value[idx].loading = true

  // 构建历史：初始解析作为第一条 assistant 消息
  const q = item.question.question
  const opts = item.question.options.join('、')
  const correct = item.question.options[item.question.answer]
  const mine = item.question.options[item.userAnswer]
  const initPrompt = `这是一道关于中国非物质文化遗产的测验题，请帮我解析一下：\n题目：${q}\n选项：${opts}\n正确答案：${correct}\n我的答案（错误）：${mine}\n\n请用活泼友好的语气简要解释为什么正确答案是"${correct}"，以及这道题考查了哪方面的非遗知识，100字以内。`
  const history = [
    { role: 'user', content: initPrompt },
    { role: 'assistant', content: aiAnalysis.value[idx]?.content || '' },
    ...aiFollowup.value[idx].messages.slice(0, -1)
  ]

  try {
    const reply = await sendChatMessage(text, history)
    aiFollowup.value[idx].messages.push({ role: 'assistant', content: reply })
  } catch (e) {
    aiFollowup.value[idx].messages.push({ role: 'assistant', content: '哎呀，出错了，请稍后再试～' })
  } finally {
    aiFollowup.value[idx].loading = false
  }
}

const askAI = async (item) => {
  const idx = item.index
  if (aiAnalysis.value[idx]?.content) return   // 已有结果不重复请求
  aiAnalysis.value[idx] = { loading: true, content: '' }
  ensureFollowup(idx)

  const q = item.question.question
  const opts = item.question.options.join('、')
  const correct = item.question.options[item.question.answer]
  const mine = item.question.options[item.userAnswer]

  const prompt = `这是一道关于中国非物质文化遗产的测验题，请帮我解析一下：
题目：${q}
选项：${opts}
正确答案：${correct}
我的答案（错误）：${mine}

请用活泼友好的语气简要解释为什么正确答案是"${correct}"，以及这道题考查了哪方面的非遗知识，100字以内。`

  try {
    const reply = await sendChatMessage(prompt, [])
    aiAnalysis.value[idx] = { loading: false, content: reply }
  } catch (e) {
    aiAnalysis.value[idx] = { loading: false, content: '哎呀，解析失败了，请稍后再试～' }
  }
}

const router = useRouter()
const authStore = useAuthStore()

const questions = ref([])
const topics = ref([])
const selectedTopic = ref('')
const quizStarted = ref(false)
const showResult = ref(false)
const currentIndex = ref(0)
const answers = ref({}) // 存储用户答案
const selectedAnswer = ref(null)
const showAnswer = ref(false)
const pointsPerQuestion = 10
const loading = ref(false)

// 计时器相关
const startTime = ref(null)
const timeSpent = ref(0) // 用时(秒)
const timerInterval = ref(null)

// 排行榜相关
const showRankings = ref(false)
const rankingType = ref('topic') // 'topic' 或 'global'
const rankings = ref([])
const loadingRankings = ref(false)
  
  // 加载专题列表
  const loadTopics = async () => {
    try {
      const data = await getQuizTopics()
      if (data && Array.isArray(data)) {
        topics.value = data
      }
    } catch (error) {
      console.error('加载专题列表失败:', error)
    }
  }
  
  // 加载题目数据
  const loadQuestions = async () => {
    let loadingInstance = null
    try {
      loading.value = true
      loadingInstance = ElLoading.service({
        lock: true,
        text: '正在加载题目...',
        background: 'rgba(0, 0, 0, 0.7)'
      })
      
      let data
      if (selectedTopic.value) {
        // 加载指定专题的题目
        data = await getQuestionsByTopic(selectedTopic.value)
      } else {
        // 加载所有题目
        data = await getQuizQuestions()
      }
      
      console.log('获取到的题目数据:', data)
      
      if (data && Array.isArray(data)) {
        // 将后端数据转换为前端格式
        questions.value = data.map(item => {
          console.log('处理题目:', item.question)
          console.log('options 原始数据:', item.options)
          console.log('options 类型:', typeof item.options)
          
          // 如果 options 已经是数组,直接使用;否则解析
          let options = item.options
          if (typeof options === 'string') {
            options = options.trim()
            // 先尝试 JSON 解析（格式如 ["A.xx","B.xx",...]）
            if (options.startsWith('[')) {
              try { options = JSON.parse(options) } catch (e) { options = null }
            }
            // 非 JSON 格式：按中英文逗号分隔（如 "A. 惊蛰,B. 雨水,C. 春分,D. 立春"）
            if (!Array.isArray(options)) {
              options = options.split(/[,，]+/).map(s => s.trim()).filter(Boolean)
            }
          }
          
          return {
            question: item.question,
            options: options,
            answer: item.answer,
            explanation: item.explanation,
            topicName: item.topicName
          }
        })
        
        if (questions.value.length === 0) {
          ElMessage.warning('该专题暂无题目')
        } else {
          const topicInfo = selectedTopic.value ? `${selectedTopic.value}专题` : '全部'
          ElMessage.success(`成功加载${topicInfo} ${questions.value.length} 道题目`)
        }
      } else {
        ElMessage.error('加载题目失败：数据格式错误')
      }
      
    } catch (error) {
      console.error('加载题目失败:', error)
      ElMessage.error('加载题目失败，请稍后重试')
    } finally {
      if (loadingInstance) {
        loadingInstance.close()
      }
      loading.value = false
    }
  }
  
  // 监听专题变化,重新加载题目
  watch(selectedTopic, () => {
    loadQuestions()
    loadRankings() // 切换专题时同步加载该专题的排行榜
  })
  
  // 组件挂载时加载专题列表和题目
  onMounted(async () => {
    await loadTopics()
    await loadQuestions()
    await loadRankings() // 初始加载排行榜
  })
  
  const currentQuestion = computed(() => questions.value[currentIndex.value])
  
  const answeredCount = computed(() => Object.keys(answers.value).length)
  
  const progressPercentage = computed(() => {
    return Math.round((answeredCount.value / questions.value.length) * 100)
  })
  
  const progressColor = computed(() => {
    const percentage = progressPercentage.value
    if (percentage < 30) return '#f56c6c'
    if (percentage < 70) return '#e6a23c'
    return '#67c23a'
  })
  
  // 计算得分
  const score = computed(() => {
    let correct = 0
    Object.keys(answers.value).forEach(index => {
      if (answers.value[index] === questions.value[index].answer) {
        correct++
      }
    })
    return correct * pointsPerQuestion
  })
  
  const totalScore = computed(() => questions.value.length * pointsPerQuestion)
  
  const correctCount = computed(() => {
    let count = 0
    Object.keys(answers.value).forEach(index => {
      if (answers.value[index] === questions.value[index].answer) {
        count++
      }
    })
    return count
  })
  
  const wrongCount = computed(() => answeredCount.value - correctCount.value)
  
  const accuracy = computed(() => {
    if (answeredCount.value === 0) return 0
    return Math.round((correctCount.value / answeredCount.value) * 100)
  })
  
  // 评级
  const rating = computed(() => {
    const percent = (score.value / totalScore.value) * 100
    if (percent >= 90) return '非遗文化专家'
    if (percent >= 80) return '非遗知识达人'
    if (percent >= 70) return '非遗文化爱好者'
    if (percent >= 60) return '非遗文化探索者'
    return '继续加油学习'
  })
  
  const ratingClass = computed(() => {
    const percent = (score.value / totalScore.value) * 100
    if (percent >= 80) return 'excellent'
    if (percent >= 60) return 'good'
    return 'normal'
  })
  
  const ratingColor = computed(() => {
    const percent = (score.value / totalScore.value) * 100
    if (percent >= 80) return '#67c23a'
    if (percent >= 60) return '#e6a23c'
    return '#f56c6c'
  })
  
  const ratingMessage = computed(() => {
    const percent = (score.value / totalScore.value) * 100
    if (percent >= 90) return '太棒了！你对非遗文化有深入的了解！'
    if (percent >= 80) return '非常好！继续保持对非遗文化的热爱！'
    if (percent >= 70) return '不错！你对非遗文化有一定的了解！'
    if (percent >= 60) return '还可以！建议多了解非遗文化知识！'
    return '加油！多学习非遗知识，传承中华文化！'
  })
  
  // 错题列表
  const wrongQuestions = computed(() => {
    const wrongs = []
    Object.keys(answers.value).forEach(index => {
      const numIndex = Number(index)
      if (answers.value[index] !== questions.value[numIndex].answer) {
        wrongs.push({
          index: numIndex,
          question: questions.value[numIndex],
          userAnswer: answers.value[index]
        })
      }
    })
    return wrongs
  })
  
  // 开始测验
  const startQuiz = () => {
    quizStarted.value = true
    currentIndex.value = 0
    answers.value = {}
    selectedAnswer.value = null
    showAnswer.value = false
    
    // 开始计时
    startTime.value = Date.now()
    timeSpent.value = 0
    timerInterval.value = setInterval(() => {
      timeSpent.value = Math.floor((Date.now() - startTime.value) / 1000)
    }, 1000)
  }
  
  // 选择答案
  const selectOption = (index) => {
    if (!showAnswer.value) {
      selectedAnswer.value = index
    }
  }
  
  // 确认答案
  const confirmAnswer = () => {
    if (selectedAnswer.value !== null) {
      answers.value[currentIndex.value] = selectedAnswer.value
      showAnswer.value = true
    }
  }
  
  // 上一题
  const prevQuestion = () => {
    if (currentIndex.value > 0) {
      currentIndex.value--
      loadQuestionState()
    }
  }
  
  // 下一题
  const nextQuestion = () => {
    if (currentIndex.value < questions.value.length - 1) {
      currentIndex.value++
      loadQuestionState()
    }
  }
  
  // 跳转到指定题目
  const goToQuestion = (index) => {
    currentIndex.value = index
    loadQuestionState()
  }
  
  // 加载题目状态
  const loadQuestionState = () => {
    const answer = answers.value[currentIndex.value]
    if (answer !== undefined) {
      selectedAnswer.value = answer
      showAnswer.value = true
    } else {
      selectedAnswer.value = null
      showAnswer.value = false
    }
  }
  
  // 提交答卷
  const submitQuiz = async () => {
    // 停止计时器
    if (timerInterval.value) {
      clearInterval(timerInterval.value)
      timerInterval.value = null
    }
    
    showResult.value = true
    
    // 提交答题记录到后端
    try {
      const record = {
        userId: authStore.currentUser.userId,
        username: authStore.currentUser.username,
        topicName: selectedTopic.value || '全部专题',
        score: totalScore.value,
        totalScore: questions.value.length * pointsPerQuestion,
        correctCount: correctCount.value,
        totalCount: questions.value.length,
        accuracy: parseFloat(accuracy.value),
        timeSpent: timeSpent.value
      }
      
      await submitQuizRecord(record)
      ElMessage.success('答卷提交成功！')
      
      // 自动加载排行榜
      loadRankings()
    } catch (error) {
      console.error('提交答题记录失败:', error)
      ElMessage.warning('答题完成，但记录提交失败')
    }
  }
  
  // 加载排行榜
  const loadRankings = async () => {
    try {
      loadingRankings.value = true
      const topicName = selectedTopic.value || null
      
      if (topicName) {
        // 加载专题排行榜
        rankingType.value = 'topic'
        const data = await getTopicRanking(topicName, 100)
        rankings.value = data || []
      } else {
        // 加载总排行榜
        rankingType.value = 'global'
        const data = await getTopRankings(100)
        rankings.value = data || []
      }
      
      showRankings.value = true
    } catch (error) {
      console.error('加载排行榜失败:', error)
      ElMessage.error('加载排行榜失败')
    } finally {
      loadingRankings.value = false
    }
  }
  
  // 切换排行榜类型
  const switchRankingType = async (type) => {
    rankingType.value = type
    try {
      loadingRankings.value = true
      
      if (type === 'global') {
        const data = await getTopRankings(100)
        rankings.value = data || []
      } else {
        const topicName = selectedTopic.value || '非遗基础知识'
        const data = await getTopicRanking(topicName, 100)
        rankings.value = data || []
      }
    } catch (error) {
      console.error('切换排行榜失败:', error)
      ElMessage.error('加载排行榜失败')
    } finally {
      loadingRankings.value = false
    }
  }
  
  // 格式化时间显示
  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }
  
  // 清理定时器
  onBeforeUnmount(() => {
    if (timerInterval.value) {
      clearInterval(timerInterval.value)
    }
  })
  
  // 重新测验
  const retryQuiz = () => {
    quizStarted.value = false
    showResult.value = false
    showRankings.value = false
    currentIndex.value = 0
    answers.value = {}
    selectedAnswer.value = null
    showAnswer.value = false
    timeSpent.value = 0
    if (timerInterval.value) {
      clearInterval(timerInterval.value)
      timerInterval.value = null
    }
  }
  
  // 返回首页
  const goHome = () => {
    router.push('/')
  }

  // 跳转铸造藏品（携带正确率分数）
  const mintRarityLabel = computed(() => {
    if (accuracy.value >= 100) return '传奇'
    if (accuracy.value >= 90)  return '史诗'
    if (accuracy.value >= 80)  return '稀有'
    return '普通'
  })
  const mintRarityClass = computed(() => {
    if (accuracy.value >= 100) return 'rarity-legendary'
    if (accuracy.value >= 90)  return 'rarity-epic'
    if (accuracy.value >= 80)  return 'rarity-rare'
    return 'rarity-common'
  })
  const goMintCollection = () => {
    router.push({ path: '/digital-collection', query: { score: accuracy.value } })
  }
  
  // 获取选项前缀
  const getOptionPrefix = (index) => {
    return String.fromCharCode(65 + index) // A, B, C, D
  }
  
  // 获取排名样式
  const getRankClass = (index) => {
    if (index === 0) return 'rank-first'
    if (index === 1) return 'rank-second'
    if (index === 2) return 'rank-third'
    return ''
  }
  </script>
  
  <style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap');

// 主色调：沿用站点红（--primary-color），辅以米色和墨色
:global(:root) {
  --paper-bg: #f7f3ea;
  --ink: #1d1f24;
  --ink-light: #4a4f5a;
  --line: #e2d6c1;
}

.quiz-page {
  font-family: 'Inter', 'Noto Serif SC', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  padding: 56px 0 96px;
  min-height: 100vh;
  background:
    radial-gradient(circle at 20% 20%, rgba(200,48,43,0.05), transparent 30%),
    radial-gradient(circle at 80% 0%, rgba(0,0,0,0.04), transparent 35%),
    var(--paper-bg);
}

.container {
  max-width: 1040px;
  margin: 0 auto;
  padding: 0 20px;
}

// 纸质卡片风格
.glass-card {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid var(--line);
  border-radius: 18px;
  box-shadow: 0 18px 36px rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;

  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, rgba(200,48,43,0.06), transparent 35%);
    pointer-events: none;
  }
}

@keyframes floatIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

// 开始页面
.quiz-start {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.start-card {
  @extend .glass-card;
  width: 100%;
  max-width: 760px;
  padding: 48px 40px 52px;
  text-align: center;
  animation: floatIn 0.5s ease;

  .quiz-icon {
    color: var(--primary-color);
    margin-bottom: 12px;
  }

  .quiz-title {
    font-family: 'Noto Serif SC', serif;
    font-size: 2.4rem;
    letter-spacing: 0.02em;
    color: var(--ink);
    margin-bottom: 8px;
  }

  .quiz-desc {
    color: var(--ink-light);
    margin-bottom: 28px;
    font-size: 1rem;
  }
}

.topic-selection {
  margin-bottom: 28px;
  h3 { font-size: 1.05rem; color: var(--ink); margin-bottom: 16px; }
}

.topic-radio-group {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 10px;
  
  :deep(.el-radio-button__inner) {
    border-radius: 12px !important;
    border: 1px solid var(--line) !important;
    background: #fff;
    padding: 10px 20px;
    font-weight: 600;
    color: var(--ink);
    transition: all 0.2s ease;
  }
  
  :deep(.is-active .el-radio-button__inner) {
    background: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
    color: #fff !important;
    box-shadow: 0 8px 20px rgba(200,48,43,0.2);
  }
}

.quiz-rules {
  background: #fff;
  border: 1px dashed var(--line);
  border-radius: 14px;
  padding: 18px 20px;
  text-align: left;
  color: var(--ink-light);
  margin-bottom: 26px;

  h3 {
    font-size: 1rem;
    color: var(--ink);
    margin-bottom: 10px;
  }

  ul { padding-left: 16px; margin: 0; }
  li { line-height: 1.8; }
}

.start-btn {
  height: 56px;
  padding: 0 44px;
  font-size: 1.05rem;
  font-weight: 700;
  border-radius: 28px;
  background: linear-gradient(135deg, var(--primary-color), #d94c43);
  border: none;
  box-shadow: 0 12px 24px rgba(200,48,43,0.18);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 16px 32px rgba(200,48,43,0.25);
  }
}

// 开始页排行榜
.start-rankings {
  @extend .glass-card;
  width: 100%;
  max-width: 760px;
  padding: 22px 24px 26px;
  animation: floatIn 0.55s ease;

  .rankings-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;

    h3 {
      display: flex;
      align-items: center;
      gap: 8px;
      margin: 0;
      color: var(--ink);
      font-weight: 700;
      font-size: 1.05rem;
    }
  }
}

.mini-rankings-table {
  .table-header, .table-row {
    display: grid;
    grid-template-columns: 60px 1fr 80px 80px 100px;
    padding: 10px 6px;
    align-items: center;
    font-size: 0.95rem;
  }
  .table-header {
    color: var(--ink-light);
    font-weight: 700;
    border-bottom: 1px solid var(--line);
  }
  .table-row {
    border-bottom: 1px dashed var(--line);
    color: var(--ink);
  }
  .empty-mini {
    text-align: center;
    padding: 16px 0;
    color: var(--ink-light);
  }
  .col-count {
    text-align: right;
    padding-right: 10px;
    color: var(--ink-light);
  }
}

.rank-badge-sm {
  width: 24px;
  height: 24px;
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  background: #f1e9dc;
  color: var(--ink);
  &.rank-first { background: #fbe6b5; color: #8a5a00; }
  &.rank-second { background: #e8ecf3; color: #4b5563; }
  &.rank-third { background: #f6d9c2; color: #8a3b12; }
}

// 答题页面
.quiz-progress {
  @extend .glass-card;
  padding: 20px 28px;
  margin-bottom: 20px;

  .progress-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    font-weight: 600;
    color: var(--ink-light);
  }

  .timer-display {
    background: rgba(200,48,43,0.08);
    padding: 6px 14px;
    border-radius: 18px;
    color: var(--primary-color);
    display: flex;
    align-items: center;
    gap: 6px;
  }
}

.question-card {
  @extend .glass-card;
  padding: 40px 38px;
  margin-bottom: 22px;

  .question-title {
    font-size: 1.5rem;
    font-weight: 700;
    line-height: 1.6;
    color: var(--ink);
    margin-bottom: 30px;
    display: flex;
    gap: 12px;
    align-items: flex-start;

    .question-number {
      flex-shrink: 0;
      width: 36px;
      height: 36px;
      background: rgba(200,48,43,0.08);
      color: var(--primary-color);
      border-radius: 10px;
      text-align: center;
      line-height: 36px;
      font-weight: 800;
      margin-top: 4px;
    }
  }
}

.option-item {
  padding: 16px 18px;
  margin-bottom: 14px;
  background: #fff;
  border: 1px solid var(--line);
  border-radius: 12px;
  transition: all 0.18s ease;
  display: flex;
  align-items: center;
  gap: 16px;
  color: var(--ink);
  
  &:hover:not(.disabled) {
    border-color: #d8c7b0;
    background: #fdfbf6;
    transform: translateX(4px);
  }
  
  &.selected {
    border-color: var(--primary-color);
    background: rgba(200,48,43,0.04);
    box-shadow: 0 6px 16px rgba(200,48,43,0.08);

    .option-prefix {
      background: var(--primary-color);
      color: #fff;
    }
  }

  &.correct {
    border-color: #2ba471 !important;
    background: rgba(43,164,113,0.06) !important;
    .option-prefix { background: #2ba471 !important; color: #fff; }
  }

  &.wrong {
    border-color: #e24a4a !important;
    background: rgba(226,74,74,0.06) !important;
    .option-prefix { background: #e24a4a !important; color: #fff; }
  }
}

.option-prefix {
  width: 30px;
  height: 30px;
  border-radius: 8px;
  background: #f1e9dc;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
}

// 结果页面
.quiz-result {
  @extend .glass-card;
  max-width: 860px;
  margin: 0 auto;
  padding: 52px 48px;
  text-align: center;
  animation: floatIn 0.5s ease;

  .result-icon { margin-bottom: 18px; color: var(--primary-color); }
  .score-value {
    font-size: 5.6rem;
    font-weight: 900;
    color: var(--primary-color);
    line-height: 1;
  }
}

.result-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin: 32px 0;
  background: #fff;
  padding: 20px;
  border-radius: 16px;
  border: 1px solid var(--line);

  .stat-item {
    .stat-value { font-size: 1.6rem; font-weight: 800; color: var(--ink); }
    .stat-label { font-size: 0.9rem; color: var(--ink-light); margin-top: 4px; }
  }
}

// 排行榜
.rankings-section {
  margin-top: 40px;
  background: #fff;
  border-radius: 18px;
  padding: 26px 24px;
  border: 1px solid var(--line);
}

.rankings-table {
  .table-header {
    background: #f9f5ee;
    border-radius: 10px;
    font-weight: 700;
    color: var(--ink-light);
    margin-bottom: 10px;
    padding: 10px 8px;
  }

  .table-row {
    border-radius: 10px;
    margin-bottom: 6px;
    border: 1px solid transparent;
    padding: 10px 8px;
    transition: all 0.18s ease;
    
    &:hover { background: #fdfbf6; border-color: var(--line); }
    &.is-current-user { background: rgba(43,164,113,0.08); border-color: rgba(43,164,113,0.3); }
  }
}

.rank-badge {
  width: 34px;
  height: 34px;
  border-radius: 10px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  
  &.rank-first { background: #fbe6b5; color: #8a5a00; }
  &.rank-second { background: #e8ecf3; color: #4b5563; }
  &.rank-third { background: #f6d9c2; color: #8a3b12; }
}


// 问遗遗按钮
.ai-analyze-btn {
  margin-left: auto;
  border-radius: 20px;
  font-size: 12px;
  height: 28px;
  padding: 0 14px;
  color: var(--primary-color);
  border-color: rgba(200,48,43,.35);
  background: rgba(200,48,43,.04);
  font-weight: 600;
  transition: all 0.2s;

  &:hover {
    background: rgba(200,48,43,.1);
    border-color: var(--primary-color);
    transform: translateY(-1px);
    box-shadow: 0 4px 10px rgba(200,48,43,.15);
  }
}

// 入场动画
.ai-slide-enter-active { transition: all 0.35s cubic-bezier(0.34,1.56,0.64,1); }
.ai-slide-enter-from { opacity: 0; transform: translateY(-8px) scale(0.98); }

// AI 解析块
.ai-analysis {
  margin-top: 16px;
  background: linear-gradient(145deg, #fffaf4, #fff6ef);
  border: 1px solid rgba(200,48,43,.18);
  border-radius: 14px;
  padding: 16px 18px 14px;
  box-shadow: 0 4px 16px rgba(200,48,43,.06);
}

// 等待动画容器
.ai-thinking {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 4px 0;
  color: var(--primary-color);
  font-size: 13px;
  font-weight: 600;

  .thinking-avatar {
    width: 28px; height: 28px;
    border-radius: 50%;
    background: rgba(200,48,43,.1);
    display: flex; align-items: center; justify-content: center;
    color: var(--primary-color);
    flex-shrink: 0;
  }

  .thinking-text { color: #999; font-weight: 400; font-size: 12px; }
}

// 三个跳动点（全局等待 & 气泡等待复用）
.thinking-dots, .bubble-loading {
  display: flex; align-items: center; gap: 4px;
  span, i {
    width: 6px; height: 6px; border-radius: 50%;
    background: var(--primary-color);
    display: inline-block;
    animation: dotBounce 1.2s infinite ease-in-out;
    &:nth-child(2) { animation-delay: 0.2s; }
    &:nth-child(3) { animation-delay: 0.4s; }
  }
}

@keyframes dotBounce {
  0%, 80%, 100% { transform: scale(0.6); opacity: 0.5; }
  40%           { transform: scale(1.1); opacity: 1; }
}

// 解析头部
.ai-analysis-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  font-weight: 700;
  color: var(--primary-color);
  margin-bottom: 10px;

  .ai-avatar {
    width: 24px; height: 24px;
    border-radius: 50%;
    background: rgba(200,48,43,.12);
    display: flex; align-items: center; justify-content: center;
    color: var(--primary-color);
    flex-shrink: 0;
  }
}

.ai-analysis-content {
  font-size: 13.5px;
  color: #3a3a3a;
  line-height: 1.85;
  margin: 0 0 4px;
  white-space: pre-wrap;
}

// 追问区
.ai-followup {
  margin-top: 14px;
  border-top: 1px dashed rgba(200,48,43,.2);
  padding-top: 12px;
}

.followup-history {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 12px;
  max-height: 280px;
  overflow-y: auto;
  padding-right: 2px;

  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-track { background: transparent; }
  &::-webkit-scrollbar-thumb { background: rgba(200,48,43,.2); border-radius: 4px; }
}

// 气泡
.followup-bubble {
  display: flex;
  align-items: flex-end;
  gap: 8px;
  animation: bubbleIn 0.25s ease;
}

@keyframes bubbleIn {
  from { opacity: 0; transform: translateY(6px); }
  to   { opacity: 1; transform: translateY(0); }
}

.bubble-avatar {
  width: 26px; height: 26px; border-radius: 50%;
  background: rgba(200,48,43,.12);
  display: flex; align-items: center; justify-content: center;
  color: var(--primary-color);
  flex-shrink: 0;
}

.bubble-user-icon {
  width: 26px; height: 26px; border-radius: 50%;
  background: #F5E6C8;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
  overflow: hidden;

  :deep(.el-avatar) {
    background: #F5E6C8;
  }
}

.bubble-content {
  max-width: 85%;
  padding: 8px 12px;
  border-radius: 14px;
  font-size: 13px;
  line-height: 1.75;
  white-space: pre-wrap;
}

.bubble-bot {
  flex-direction: row;
}

.bubble-bot .bubble-content {
  background: #fff;
  border: 1px solid rgba(200,48,43,.15);
  color: #333;
  border-bottom-left-radius: 4px;
}

.bubble-user {
  justify-content: flex-end;
}

.bubble-user .bubble-content {
  background: linear-gradient(135deg, var(--primary-color), #d94c43);
  color: #fff;
  text-align: right;
  border-bottom-right-radius: 4px;
  box-shadow: 0 4px 12px rgba(200,48,43,.2);
}

// 输入行
.followup-input-row {
  display: flex;
  gap: 8px;
  align-items: center;

  .followup-input {
    flex: 1;
    :deep(.el-input__wrapper) {
      border-radius: 20px;
      background: #fff;
      box-shadow: none;
      border: 1px solid #e0d5c8;
      padding: 0 14px;
      transition: all 0.2s;
      &:hover { border-color: rgba(200,48,43,.4); }
      &.is-focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(200,48,43,.1); }
    }
    :deep(.el-input__inner) { font-size: 13px; height: 36px; }
  }
}

.followup-send-btn {
  width: 36px; height: 36px;
  border-radius: 50%;
  border: none;
  background: linear-gradient(135deg, var(--primary-color), #d94c43);
  color: #fff;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  flex-shrink: 0;
  transition: all 0.2s;
  box-shadow: 0 4px 10px rgba(200,48,43,.25);

  &:hover:not(:disabled) {
    transform: scale(1.08);
    box-shadow: 0 6px 16px rgba(200,48,43,.35);
  }

  &:disabled {
    background: #ddd;
    box-shadow: none;
    cursor: not-allowed;
  }

  &.loading { background: #ddd; cursor: not-allowed; }

  .btn-dots {
    display: flex; gap: 3px; align-items: center;
    i {
      width: 4px; height: 4px; border-radius: 50%;
      background: #999; display: inline-block;
      animation: dotBounce 1.2s infinite ease-in-out;
      &:nth-child(2) { animation-delay: 0.2s; }
      &:nth-child(3) { animation-delay: 0.4s; }
    }
  }
}

@media (max-width: 768px) {
  .start-card, .start-rankings, .question-card { padding: 28px 22px; }
  .result-stats { grid-template-columns: repeat(2, 1fr); }
  .question-card .question-title { font-size: 1.2rem; }

  // 排行榜手机端适配
  .mini-rankings-table {
    .table-header, .table-row {
      grid-template-columns: 44px 1fr 60px 60px; // 手机端隐藏“用时”列，缩减宽度
      font-size: 0.85rem;
      padding: 8px 4px;
    }
    .col-time { display: none; } // 隐藏用时
    .col-count { width: 60px; padding-right: 0; text-align: center; }
    .col-accuracy { width: 60px; text-align: center; }
    .col-user {
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      padding-right: 5px;
    }
  }
}

// 铸造藏品入口
.mint-entry {
  margin-top: 20px;
  background: linear-gradient(135deg, #1a0f05, #2d1505);
  border: 1px solid rgba(217,119,6,0.35);
  border-radius: 16px;
  padding: 20px 22px;
  display: flex;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
}

.mint-entry-tip {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 240px;

  strong {
    display: block;
    font-size: 0.95rem;
    color: #fcd34d;
    margin-bottom: 4px;
  }

  p {
    font-size: 0.82rem;
    color: rgba(255,255,255,0.5);
    margin: 0;
  }
}

.mint-tip-icon { font-size: 2rem; flex-shrink: 0; }

.mint-btn {
  border-radius: 999px !important;
  font-weight: 700 !important;
  background: linear-gradient(135deg, #b45309, #d97706) !important;
  border-color: transparent !important;
  padding: 0 28px !important;
}

.rarity-common    { color: #9ca3af; font-weight: 700; }
.rarity-rare      { color: #60a5fa; font-weight: 700; }
.rarity-epic      { color: #a78bfa; font-weight: 700; }
.rarity-legendary { color: #fcd34d; font-weight: 700; }

</style>