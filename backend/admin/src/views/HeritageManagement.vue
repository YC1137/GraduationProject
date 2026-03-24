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
          <div class="image-upload-field">
            <el-input v-model="form.thumbnail" placeholder="粘贴图片URL，或点击右侧上传" class="url-input" />
            <el-upload
              :show-file-list="false"
              :http-request="(opt) => uploadImage(opt, 'thumbnail')"
              accept="image/*"
              class="upload-btn"
            >
              <el-button type="primary" :loading="uploadingThumbnail">上传图片</el-button>
            </el-upload>
          </div>
          <div v-if="form.thumbnail" class="img-preview">
            <img :src="form.thumbnail" alt="缩略图预览" />
          </div>
        </el-form-item>
        <el-form-item label="图片" prop="images">
          <div class="image-upload-field">
            <el-input v-model="form.images" type="textarea" :rows="2"
              placeholder='粘贴URL或JSON数组，如 ["url1","url2"]，也可点击上传' class="url-input" />
            <el-upload
              :show-file-list="false"
              :http-request="(opt) => uploadImage(opt, 'images')"
              accept="image/*"
              multiple
              class="upload-btn"
            >
              <el-button type="primary" :loading="uploadingImages">上传图片</el-button>
            </el-upload>
          </div>
          <div v-if="parsedImages.length" class="imgs-preview">
            <div v-for="(url, idx) in parsedImages" :key="idx" class="img-preview-item">
              <img :src="url" :alt="'图片' + (idx+1)" />
              <el-button type="danger" size="small" circle @click="removeImage(idx)">×</el-button>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="视频" prop="video">
          <el-input v-model="form.video" />
        </el-form-item>
        <el-form-item label="音频" prop="audio">
          <el-input v-model="form.audio" />
        </el-form-item>
        <el-form-item label="侧栏图" prop="sidebarImage">
          <div class="image-upload-field">
            <el-input v-model="form.sidebarImage" placeholder="粘贴图片URL，或点击右侧上传（留空则不设置）" class="url-input" />
            <el-upload
              :show-file-list="false"
              :http-request="(opt) => uploadImage(opt, 'sidebarImage')"
              accept="image/*"
              class="upload-btn"
            >
              <el-button type="primary" :loading="uploadingSidebarItem">上传图片</el-button>
            </el-upload>
            <el-button v-if="form.sidebarImage" type="danger" @click="form.sidebarImage = ''">清除</el-button>
          </div>
          <div v-if="form.sidebarImage" class="img-preview sidebar-item-preview">
            <a :href="'http://localhost:5173/detail/' + form.id" target="_blank" title="点击跳转项目详情页">
              <img :src="form.sidebarImage" alt="侧栏图预览" />
              <span class="preview-tip">点击可跳转详情页</span>
            </a>
          </div>
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
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const BASE = 'http://localhost:8080/api'
const UPLOAD_URL = `${BASE}/admin/upload`

// ===== 非遗项目 =====
const heritages = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const selectedRows = ref([])
const uploadingThumbnail = ref(false)
const uploadingImages = ref(false)
const uploadingSidebarItem = ref(false)

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
  sidebarImage: '',
  timeline: ''
})

// 解析 images 字段为数组（支持 JSON 数组、数组对象、或单个 URL 字符串）
const parsedImages = computed(() => {
  const val = form.value.images
  if (!val) return []
  // 已经是数组（后端直接返回 List）
  if (Array.isArray(val)) return val.filter(Boolean)
  // 字符串：尝试 JSON 解析
  if (typeof val === 'string') {
    try {
      const parsed = JSON.parse(val)
      if (Array.isArray(parsed)) return parsed.filter(Boolean)
    } catch (_) {}
    return val.trim() ? [val.trim()] : []
  }
  return []
})

// 删除某张图
const removeImage = (idx) => {
  const arr = [...parsedImages.value]
  arr.splice(idx, 1)
  form.value.images = arr.length ? JSON.stringify(arr) : ''
}

// 通用上传函数
const uploadImage = async (options, target) => {
  const file = options.file
  const fd = new FormData()
  fd.append('file', file)

  if (target === 'thumbnail') uploadingThumbnail.value = true
  else if (target === 'sidebarImage') uploadingSidebarItem.value = true
  else uploadingImages.value = true

  try {
    const res = await axios.post(UPLOAD_URL, fd, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    if (res.data.code === 200) {
      const url = res.data.data
      if (target === 'thumbnail') {
        form.value.thumbnail = url
      } else if (target === 'sidebarImage') {
        form.value.sidebarImage = url
      } else {
        // 追加到 images 数组
        const arr = [...parsedImages.value, url]
        form.value.images = JSON.stringify(arr)
      }
      ElMessage.success('图片上传成功')
    } else {
      ElMessage.error(res.data.message || '上传失败')
    }
  } catch (e) {
    ElMessage.error('上传失败：' + (e.message || '网络错误'))
  } finally {
    if (target === 'thumbnail') uploadingThumbnail.value = false
    else if (target === 'sidebarImage') uploadingSidebarItem.value = false
    else uploadingImages.value = false
  }
}

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
    sidebarImage: '',
    timeline: ''
  }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑非遗项目'
  const data = { ...row }
  // 后端返回的 images 可能是数组，统一转成 JSON 字符串
  if (Array.isArray(data.images)) {
    data.images = JSON.stringify(data.images)
  }
  form.value = data
  dialogVisible.value = true
}

const confirmSave = async () => {
  try {
    await formRef.value.validate()

    // 确保数组类型字段序列化为 JSON 字符串再提交
    const payload = { ...form.value }
    if (Array.isArray(payload.images)) {
      payload.images = JSON.stringify(payload.images)
    }
    if (Array.isArray(payload.timeline)) {
      payload.timeline = JSON.stringify(payload.timeline)
    }

    let response
    if (payload.id) {
      response = await axios.put(`http://localhost:8080/api/admin/heritage/${payload.id}`, payload)
    } else {
      response = await axios.post('http://localhost:8080/api/admin/heritage', payload)
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
      const payload = { ...row, enabled: newEnabled }
      if (Array.isArray(payload.images))   payload.images   = JSON.stringify(payload.images)
      if (Array.isArray(payload.timeline)) payload.timeline = JSON.stringify(payload.timeline)
      const response = await axios.put(`http://localhost:8080/api/admin/heritage/${row.id}`, payload)
      
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

/* 图片上传字段 */
.image-upload-field {
  display: flex;
  gap: 8px;
  align-items: flex-start;
  width: 100%;
  .url-input {
    flex: 1;
  }
  .upload-btn {
    flex-shrink: 0;
  }
}

.img-preview {
  margin-top: 8px;
  img {
    max-width: 120px;
    max-height: 90px;
    border: 1px solid #dcdfe6;
    border-radius: 4px;
    object-fit: cover;
  }
}

.imgs-preview {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 8px;
  .img-preview-item {
    position: relative;
    img {
      width: 80px;
      height: 60px;
      border: 1px solid #dcdfe6;
      border-radius: 4px;
      object-fit: cover;
      display: block;
    }
    .el-button {
      position: absolute;
      top: -6px;
      right: -6px;
      width: 18px;
      height: 18px;
      font-size: 12px;
      padding: 0;
      line-height: 1;
    }
  }
}

.sidebar-item-preview {
  a {
    display: inline-block;
    position: relative;
    text-decoration: none;
    &:hover img {
      opacity: 0.85;
      outline: 2px solid #409eff;
    }
    &:hover .preview-tip {
      opacity: 1;
    }
  }
  img {
    max-width: 160px;
    max-height: 120px;
    border: 1px solid #dcdfe6;
    border-radius: 4px;
    object-fit: cover;
    cursor: pointer;
    transition: opacity 0.2s;
    display: block;
  }
  .preview-tip {
    position: absolute;
    bottom: 4px;
    left: 0;
    right: 0;
    text-align: center;
    font-size: 11px;
    color: #fff;
    background: rgba(0,0,0,0.5);
    border-radius: 0 0 4px 4px;
    padding: 2px 0;
    opacity: 0;
    transition: opacity 0.2s;
    pointer-events: none;
  }
}
</style>
