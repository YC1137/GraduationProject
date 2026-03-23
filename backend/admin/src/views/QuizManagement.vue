<template>
  <div class="quiz-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>测验题目管理</span>
          <div class="header-buttons">
            <el-select 
              v-model="selectedTopic" 
              placeholder="筛选专题" 
              clearable 
              @change="handleTopicFilter"
              style="width: 200px; margin-right: 10px;"
            >
              <el-option label="全部专题" value="" />
              <el-option 
                v-for="topic in topics" 
                :key="topic" 
                :label="topic" 
                :value="topic" 
              />
            </el-select>
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
        <el-table-column prop="topicName" label="专题" width="150" show-overflow-tooltip />
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="800px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="专题" prop="topicName">
          <el-input v-model="form.topicName" placeholder="例如：非遗基础知识" />
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
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const questions = ref([])
const allQuestions = ref([])
const topics = ref([])
const selectedTopic = ref('')
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

const rules = {
  topicName: [{ required: true, message: '请输入专题名称', trigger: 'blur' }],
  question: [{ required: true, message: '请输入题目', trigger: 'blur' }],
  options: [{ required: true, message: '请输入选项', trigger: 'blur' }],
  answer: [{ required: true, message: '请输入答案', trigger: 'blur' }]
}

const fetchQuestions = async () => {
  loading.value = true
  try {
    const response = await axios.get('http://localhost:8080/api/quiz/questions')
    if (response.data.code === 200) {
      allQuestions.value = response.data.data
      updateTopicList()
      applyFilter()
    }
  } catch (error) {
    console.error('获取测验题目失败:', error)
    ElMessage.error('获取测验题目失败')
  } finally {
    loading.value = false
  }
}

const updateTopicList = () => {
  const topicSet = new Set()
  allQuestions.value.forEach(q => {
    if (q.topicName) {
      topicSet.add(q.topicName)
    }
  })
  topics.value = Array.from(topicSet).sort()
}

const applyFilter = () => {
  if (!selectedTopic.value) {
    questions.value = allQuestions.value
  } else {
    questions.value = allQuestions.value.filter(q => q.topicName === selectedTopic.value)
  }
}

const handleTopicFilter = () => {
  applyFilter()
}

const handleAdd = () => {
  dialogTitle.value = '添加测验题目'
  form.value = {
    id: null,
    topicName: '非遗基础知识',
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
      response = await axios.put(`http://localhost:8080/api/admin/quiz/${form.value.id}`, form.value)
    } else {
      response = await axios.post('http://localhost:8080/api/admin/quiz', form.value)
    }
    
    if (response.data.code === 200) {
      ElMessage.success('保存成功')
      dialogVisible.value = false
      fetchQuestions()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    console.error('保存失败:', error)
    ElMessage.error('保存失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除这道题目吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const response = await axios.delete(`http://localhost:8080/api/admin/quiz/${row.id}`)
      
      if (response.data.code === 200) {
        ElMessage.success('删除成功')
        fetchQuestions()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }).catch(() => {
    ElMessage.info('已取消删除')
  })
}

const handleSelectionChange = (val) => {
  selectedRows.value = val
}

const handleBatchDelete = () => {
  if (!selectedRows.value.length) return
  
  ElMessageBox.confirm(
    `确定要删除选中的 ${selectedRows.value.length} 道题目吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    loading.value = true
    try {
      const ids = selectedRows.value.map(row => row.id)
      const response = await axios.delete('http://localhost:8080/api/admin/quizzes/batch-delete', {
        data: { ids }
      })
      
      if (response.data.code === 200) {
        ElMessage.success('批量删除成功')
        selectedRows.value = []
        fetchQuestions()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    } finally {
      loading.value = false
    }
  }).catch(() => {
    ElMessage.info('已取消删除')
  })
}

const handleBatchEnable = (enabled) => {
  if (!selectedRows.value.length) return
  
  ElMessageBox.confirm(
    `确定要${enabled ? '启用' : '禁用'}选中的 ${selectedRows.value.length} 道题目吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    loading.value = true
    try {
      const ids = selectedRows.value.map(row => row.id)
      const response = await axios.put('http://localhost:8080/api/admin/quizzes/batch-enabled', {
        ids,
        enabled
      })
      
      if (response.data.code === 200) {
        ElMessage.success(`批量${enabled ? '启用' : '禁用'}成功`)
        selectedRows.value = []
        fetchQuestions()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      console.error(`批量${enabled ? '启用' : '禁用'}失败:`, error)
      ElMessage.error(`批量${enabled ? '启用' : '禁用'}失败`)
    } finally {
      loading.value = false
    }
  }).catch(() => {
    ElMessage.info('已取消操作')
  })
}

const handleToggleEnabled = (row) => {
  const newEnabled = !row.enabled
  
  ElMessageBox.confirm(
    `确定要${newEnabled ? '启用' : '禁用'}这道题目吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    loading.value = true
    try {
      const response = await axios.put(`http://localhost:8080/api/admin/quiz/${row.id}`, {
        ...row,
        enabled: newEnabled
      })
      
      if (response.data.code === 200) {
        ElMessage.success(`${newEnabled ? '启用' : '禁用'}成功`)
        fetchQuestions()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      console.error(`${newEnabled ? '启用' : '禁用'}失败:`, error)
      ElMessage.error(`${newEnabled ? '启用' : '禁用'}失败`)
    } finally {
      loading.value = false
    }
  }).catch(() => {
    ElMessage.info('已取消操作')
  })
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
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
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

.el-card {
  flex: 1;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.el-card__body {
  flex: 1;
  overflow: auto;
}

.el-table {
  width: 100%;
}

@media (min-width: 1200px) {
  .quiz-management {
    padding: 30px;
  }
  
  .card-header {
    font-size: 18px;
  }
}
</style>
