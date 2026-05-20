<template>
  <div class="quiz-management">
    <!-- 未选专题：显示专题卡片列表 -->
    <div v-if="!activeTopic" class="topic-grid-view">
      <div class="page-header">
        <span class="page-title">测验题目管理</span>
        <div style="display:flex;gap:10px">
          <el-button type="success" @click="handleCreateTopic">+ 新建专题</el-button>
          <el-button type="primary" @click="handleAdd">+ 添加题目</el-button>
        </div>
      </div>

      <div v-loading="loading" class="topic-cards">
        <div
          v-for="topic in topicStats"
          :key="topic.name"
          class="topic-card"
          @click="enterTopic(topic.name)"
        >
          <div class="topic-icon">
            <el-icon size="32"><Collection /></el-icon>
          </div>
          <div class="topic-info">
            <div class="topic-name">{{ topic.name }}</div>
            <div class="topic-meta">
              <span class="count-badge total">共 {{ topic.total }} 题</span>
              <span class="count-badge enabled">启用 {{ topic.enabled }}</span>
              <span v-if="topic.disabled" class="count-badge disabled">禁用 {{ topic.disabled }}</span>
            </div>
          </div>
          <el-icon class="arrow-icon"><ArrowRight /></el-icon>
        </div>

        <div v-if="!loading && topicStats.length === 0" class="empty-tip">
          <el-empty description="暂无专题，点击右上角添加题目" />
        </div>
      </div>
    </div>

    <!-- 已选专题：显示题目列表 -->
    <el-card v-else class="question-card">
      <template #header>
        <div class="card-header">
          <div class="breadcrumb">
            <el-button text @click="backToTopics" class="back-btn">
              <el-icon><ArrowLeft /></el-icon> 返回专题列表
            </el-button>
            <el-divider direction="vertical" />
            <span class="current-topic">{{ activeTopic }}</span>
            <el-tag type="info" size="small" style="margin-left:8px">{{ questions.length }} 题</el-tag>
          </div>
          <div class="header-buttons">
            <el-button type="warning" @click="handleBatchEnable(true)" :disabled="!selectedRows.length">
              批量启用 ({{ selectedRows.length }})
            </el-button>
            <el-button type="info" @click="handleBatchEnable(false)" :disabled="!selectedRows.length">
              批量禁用 ({{ selectedRows.length }})
            </el-button>
            <el-button type="danger" @click="handleBatchDelete" :disabled="!selectedRows.length">
              批量删除 ({{ selectedRows.length }})
            </el-button>
            <el-button type="primary" @click="handleAdd">添加题目</el-button>
          </div>
        </div>
      </template>

      <el-table
        :data="questions"
        style="width: 100%"
        v-loading="loading"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="enabled" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.enabled ? 'success' : 'danger'">
              {{ scope.row.enabled ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="question" label="题目" min-width="400" show-overflow-tooltip />
        <el-table-column prop="options" label="选项" min-width="300" show-overflow-tooltip />
        <el-table-column prop="answer" label="答案" width="100">
          <template #default="scope">
            <el-tag>{{ ['A', 'B', 'C', 'D'][scope.row.answer] }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="explanation" label="解析" min-width="300" show-overflow-tooltip />
        <el-table-column label="操作" fixed="right" width="260">
          <template #default="scope">
            <el-button type="success" size="small" @click="handleToggleEnabled(scope.row)" :disabled="scope.row.enabled">
              启用
            </el-button>
            <el-button type="warning" size="small" @click="handleToggleEnabled(scope.row)" :disabled="!scope.row.enabled">
              禁用
            </el-button>
            <el-button type="primary" size="small" @click="handleEdit(scope.row)">
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDelete(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 添加/编辑弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="800px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="专题" prop="topicName">
          <el-select
            v-model="form.topicName"
            filterable
            allow-create
            default-first-option
            placeholder="选择或输入专题名称（输入后按Enter确认）"
            style="width:100%"
            @change="(val) => { form.topicName = val }"
          >
            <el-option v-for="t in topics" :key="t" :label="t" :value="t" />
          </el-select>
        </el-form-item>
        <el-form-item label="题目" prop="question">
          <el-input v-model="form.question" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="选项" prop="options">
          <el-input v-model="form.options" type="textarea" :rows="4" placeholder="请输入选项，用逗号分隔，例如：A.选项1,B.选项2,C.选项3,D.选项4" />
        </el-form-item>
        <el-form-item label="答案" prop="answer">
          <el-select v-model="form.answer" placeholder="请选择答案">
            <el-option label="A" :value="0" />
            <el-option label="B" :value="1" />
            <el-option label="C" :value="2" />
            <el-option label="D" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="解析" prop="explanation">
          <el-input v-model="form.explanation" type="textarea" :rows="4" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmSave">确定</el-button>
      </template>
    </el-dialog>

    <!-- 新建专题弹窗 -->
    <el-dialog v-model="topicDialogVisible" title="新建专题" width="400px">
      <el-form :model="topicForm" :rules="topicRules" ref="topicFormRef" label-width="80px">
        <el-form-item label="专题名称" prop="name">
          <el-input v-model="topicForm.name" placeholder="请输入专题名称" clearable />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="topicDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmCreateTopic">确定并添加题目</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Collection, ArrowRight, ArrowLeft } from '@element-plus/icons-vue'
import axios from 'axios'

const allQuestions = ref([])
const topics = ref([])
const activeTopic = ref('')   // 当前进入的专题，空字符串 = 显示专题列表
const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const selectedRows = ref([])
const form = ref({
  id: null,
  topicName: '',
  question: '',
  options: '',
  answer: 0,
  explanation: '',
  enabled: true
})

// 新建专题
const topicDialogVisible = ref(false)
const topicFormRef = ref(null)
const topicForm = ref({ name: '' })
const topicRules = {
  name: [
    { required: true, message: '请输入专题名称', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (topics.value.includes(value.trim())) {
          callback(new Error('该专题已存在'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

const handleCreateTopic = () => {
  topicForm.value = { name: '' }
  topicDialogVisible.value = true
}

const confirmCreateTopic = async () => {
  try {
    await topicFormRef.value.validate()
    const newTopicName = topicForm.value.name.trim()
    topicDialogVisible.value = false
    // 打开添加题目弹窗，并预填新专题名
    dialogTitle.value = '添加测验题目'
    form.value = {
      id: null,
      topicName: newTopicName,
      question: '',
      options: '',
      answer: 0,
      explanation: '',
      enabled: true
    }
    dialogVisible.value = true
  } catch (e) {
    // 校验失败
  }
}

const rules = {
  topicName: [{ required: true, message: '请输入专题名称', trigger: ['blur', 'change'] }],
  question: [{ required: true, message: '请输入题目', trigger: 'blur' }],
  options: [{ required: true, message: '请输入选项', trigger: 'blur' }],
  answer: [{ required: true, message: '请选择答案', trigger: 'change' }]
}

// 当前专题的题目列表
const questions = computed(() => {
  if (!activeTopic.value) return []
  return allQuestions.value.filter(q => q.topicName === activeTopic.value)
})

// 专题统计（卡片列表）
const topicStats = computed(() => {
  const map = {}
  allQuestions.value.forEach(q => {
    const t = q.topicName || '未分类'
    if (!map[t]) map[t] = { name: t, total: 0, enabled: 0, disabled: 0 }
    map[t].total++
    if (q.enabled) map[t].enabled++
    else map[t].disabled++
  })
  return Object.values(map).sort((a, b) => a.name.localeCompare(b.name, 'zh'))
})

const fetchQuestions = async () => {
  loading.value = true
  try {
    const response = await axios.get('/api/quiz/questions')
    if (response.data.code === 200) {
      allQuestions.value = response.data.data
      const set = new Set()
      allQuestions.value.forEach(q => { if (q.topicName) set.add(q.topicName) })
      topics.value = Array.from(set).sort()
    }
  } catch (error) {
    console.error('获取测验题目失败:', error)
    ElMessage.error('获取测验题目失败')
  } finally {
    loading.value = false
  }
}

const enterTopic = (topicName) => {
  activeTopic.value = topicName
  selectedRows.value = []
}

const backToTopics = () => {
  activeTopic.value = ''
  selectedRows.value = []
}

const handleAdd = () => {
  dialogTitle.value = '添加测验题目'
  form.value = {
    id: null,
    topicName: activeTopic.value || (topics.value[0] || ''),
    question: '',
    options: '',
    answer: 0,
    explanation: '',
    enabled: true
  }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑测验题目'
  form.value = { ...row }
  dialogVisible.value = true
}

const confirmSave = async () => {
  try {
    await formRef.value.validate()
    let response
    if (form.value.id) {
      response = await axios.put(`/api/admin/quiz/${form.value.id}`, form.value)
    } else {
      response = await axios.post('/api/admin/quiz', form.value)
    }
    if (response.data.code === 200) {
      ElMessage.success('保存成功')
      dialogVisible.value = false
      await fetchQuestions()
      // 如果新增题目的专题与当前不同，自动跳转
      if (form.value.topicName && form.value.topicName !== activeTopic.value) {
        activeTopic.value = form.value.topicName
      }
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    if (error?.message) ElMessage.error('保存失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除这道题目吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const response = await axios.delete(`/api/admin/quiz/${row.id}`)
      if (response.data.code === 200) {
        ElMessage.success('删除成功')
        await fetchQuestions()
        // 如果该专题下已无题目，返回列表
        if (questions.value.length === 0) backToTopics()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

const handleSelectionChange = (val) => {
  selectedRows.value = val
}

const handleBatchDelete = () => {
  if (!selectedRows.value.length) return
  ElMessageBox.confirm(
    `确定要删除选中的 ${selectedRows.value.length} 道题目吗？`,
    '提示',
    { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
  ).then(async () => {
    loading.value = true
    try {
      const ids = selectedRows.value.map(row => row.id)
      const response = await axios.delete('/api/admin/quizzes/batch-delete', { data: { ids } })
      if (response.data.code === 200) {
        ElMessage.success('批量删除成功')
        selectedRows.value = []
        await fetchQuestions()
        if (questions.value.length === 0) backToTopics()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      ElMessage.error('批量删除失败')
    } finally {
      loading.value = false
    }
  }).catch(() => {})
}

const handleBatchEnable = (enabled) => {
  if (!selectedRows.value.length) return
  ElMessageBox.confirm(
    `确定要${enabled ? '启用' : '禁用'}选中的 ${selectedRows.value.length} 道题目吗？`,
    '提示',
    { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
  ).then(async () => {
    loading.value = true
    try {
      const ids = selectedRows.value.map(row => row.id)
      const response = await axios.put('/api/admin/quizzes/batch-enabled', { ids, enabled })
      if (response.data.code === 200) {
        ElMessage.success(`批量${enabled ? '启用' : '禁用'}成功`)
        selectedRows.value = []
        fetchQuestions()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      ElMessage.error(`批量${enabled ? '启用' : '禁用'}失败`)
    } finally {
      loading.value = false
    }
  }).catch(() => {})
}

const handleToggleEnabled = (row) => {
  const newEnabled = !row.enabled
  ElMessageBox.confirm(
    `确定要${newEnabled ? '启用' : '禁用'}这道题目吗？`,
    '提示',
    { confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning' }
  ).then(async () => {
    loading.value = true
    try {
      const response = await axios.put(`/api/admin/quiz/${row.id}`, { ...row, enabled: newEnabled })
      if (response.data.code === 200) {
        ElMessage.success(`${newEnabled ? '启用' : '禁用'}成功`)
        fetchQuestions()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      ElMessage.error(`${newEnabled ? '启用' : '禁用'}失败`)
    } finally {
      loading.value = false
    }
  }).catch(() => {})
}

onMounted(() => {
  fetchQuestions()
})
</script>

<style scoped>
.quiz-management {
  padding: 20px;
  width: 100%;
  height: 100%;
  overflow: auto;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}

/* -------- 专题卡片视图 -------- */
.topic-grid-view {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-title {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.topic-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
}

.topic-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: #fff;
  border: 1px solid #e4e7ed;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}

.topic-card:hover {
  border-color: #409eff;
  box-shadow: 0 4px 16px rgba(64,158,255,0.15);
  transform: translateY(-2px);
}

.topic-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  background: linear-gradient(135deg, #409eff22, #409eff44);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #409eff;
  flex-shrink: 0;
}

.topic-info {
  flex: 1;
  min-width: 0;
}

.topic-name {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.topic-meta {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.count-badge {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 10px;
  font-weight: 500;
}

.count-badge.total {
  background: #f0f2f5;
  color: #606266;
}

.count-badge.enabled {
  background: #f0f9eb;
  color: #67c23a;
}

.count-badge.disabled {
  background: #fef0f0;
  color: #f56c6c;
}

.arrow-icon {
  color: #c0c4cc;
  font-size: 18px;
  flex-shrink: 0;
  transition: color 0.2s;
}

.topic-card:hover .arrow-icon {
  color: #409eff;
}

.empty-tip {
  grid-column: 1 / -1;
  padding: 60px 0;
}

/* -------- 题目列表视图 -------- */
.question-card {
  flex: 1;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 4px;
}

.back-btn {
  font-size: 14px;
  color: #409eff;
  padding: 0;
}

.current-topic {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.header-buttons {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
}
</style>
