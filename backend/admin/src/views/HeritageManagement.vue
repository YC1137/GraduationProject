<template>
  <div class="heritage-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>非遗项目管理</span>
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
            <el-button type="primary" @click="handleAdd">添加项目</el-button>
          </div>
        </div>
      </template>
      
      <el-table 
        :data="heritages" 
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
        <el-table-column prop="name" label="项目名称" width="200" />
        <el-table-column prop="category" label="类别" width="120" />
        <el-table-column prop="region" label="地区" width="120" />
        <el-table-column prop="level" label="级别" width="120" />
        <el-table-column prop="inheritor" label="传承人" width="120" />
        <el-table-column prop="likes" label="点赞数" width="100" />
        <el-table-column prop="favorites" label="收藏数" width="100" />
        <el-table-column prop="views" label="浏览数" width="100" />
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="项目名称" prop="name">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="类别" prop="category">
          <el-input v-model="form.category" />
        </el-form-item>
        <el-form-item label="地区" prop="region">
          <el-input v-model="form.region" />
        </el-form-item>
        <el-form-item label="级别" prop="level">
          <el-input v-model="form.level" />
        </el-form-item>
        <el-form-item label="传承人" prop="inheritor">
          <el-input v-model="form.inheritor" />
        </el-form-item>
        <el-form-item label="简介" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="详细介绍" prop="detailDescription">
          <el-input v-model="form.detailDescription" type="textarea" :rows="5" />
        </el-form-item>
        <el-form-item label="缩略图" prop="thumbnail">
          <el-input v-model="form.thumbnail" />
        </el-form-item>
        <el-form-item label="图片" prop="images">
          <el-input v-model="form.images" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="视频" prop="video">
          <el-input v-model="form.video" />
        </el-form-item>
        <el-form-item label="音频" prop="audio">
          <el-input v-model="form.audio" />
        </el-form-item>
        <el-form-item label="时间线" prop="timeline">
          <el-input v-model="form.timeline" type="textarea" :rows="3" />
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

const heritages = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const selectedRows = ref([])
const form = ref({
  id: null,
  name: '',
  category: '',
  region: '',
  level: '',
  inheritor: '',
  description: '',
  detailDescription: '',
  thumbnail: '',
  images: '',
  video: '',
  audio: '',
  timeline: ''
})

const rules = {
  name: [{ required: true, message: '请输入项目名称', trigger: 'blur' }],
  category: [{ required: true, message: '请输入类别', trigger: 'blur' }],
  region: [{ required: true, message: '请输入地区', trigger: 'blur' }],
  level: [{ required: true, message: '请输入级别', trigger: 'blur' }]
}

const fetchHeritages = async () => {
  loading.value = true
  try {
    const response = await axios.get('http://localhost:8080/api/heritage/list')
    if (response.data.code === 200) {
      heritages.value = response.data.data
    }
  } catch (error) {
    console.error('获取非遗项目列表失败:', error)
    ElMessage.error('获取非遗项目列表失败')
  } finally {
    loading.value = false
  }
}

const handleAdd = () => {
  dialogTitle.value = '添加非遗项目'
  form.value = {
    id: null,
    name: '',
    category: '',
    region: '',
    level: '',
    inheritor: '',
    description: '',
    detailDescription: '',
    thumbnail: '',
    images: '',
    video: '',
    audio: '',
    timeline: ''
  }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑非遗项目'
  form.value = { ...row }
  dialogVisible.value = true
}

const confirmSave = async () => {
  try {
    await formRef.value.validate()
    
    let response
    if (form.value.id) {
      response = await axios.put(`http://localhost:8080/api/admin/heritage/${form.value.id}`, form.value)
    } else {
      response = await axios.post('http://localhost:8080/api/admin/heritage', form.value)
    }
    
    if (response.data.code === 200) {
      ElMessage.success('保存成功')
      dialogVisible.value = false
      fetchHeritages()
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
    `确定要删除非遗项目 "${row.name}" 吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const response = await axios.delete(`http://localhost:8080/api/admin/heritage/${row.id}`)
      
      if (response.data.code === 200) {
        ElMessage.success('删除成功')
        fetchHeritages()
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
    `确定要删除选中的 ${selectedRows.value.length} 个项目吗？`,
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
      const response = await axios.delete('http://localhost:8080/api/admin/heritages/batch-delete', {
        data: { ids }
      })
      
      if (response.data.code === 200) {
        ElMessage.success('批量删除成功')
        selectedRows.value = []
        fetchHeritages()
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
    `确定要${enabled ? '启用' : '禁用'}选中的 ${selectedRows.value.length} 个项目吗？`,
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
      const response = await axios.put('http://localhost:8080/api/admin/heritages/batch-enabled', {
        ids,
        enabled
      })
      
      if (response.data.code === 200) {
        ElMessage.success(`批量${enabled ? '启用' : '禁用'}成功`)
        selectedRows.value = []
        fetchHeritages()
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
    `确定要${newEnabled ? '启用' : '禁用'}非遗项目 "${row.name}" 吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    loading.value = true
    try {
      const response = await axios.put(`http://localhost:8080/api/admin/heritage/${row.id}`, {
        ...row,
        enabled: newEnabled
      })
      
      if (response.data.code === 200) {
        ElMessage.success(`${newEnabled ? '启用' : '禁用'}成功`)
        fetchHeritages()
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
  fetchHeritages()
})
</script>

<style scoped>
.heritage-management {
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
</style>
