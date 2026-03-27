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
        <el-form-item label="图片">
          <div class="list-editor">
            <div v-for="(url, idx) in imageList" :key="idx" class="list-editor-row">
              <div class="row-index">{{ idx + 1 }}</div>
              <el-input v-model="imageList[idx]" placeholder="输入或粘贴图片URL" class="row-input" />
              <el-upload
                :show-file-list="false"
                :http-request="(opt) => uploadImageToRow(opt, idx)"
                accept="image/*"
                class="upload-btn-inline"
              >
                <el-button size="small" type="primary" :loading="uploadingImageIdx === idx">上传</el-button>
              </el-upload>
              <div v-if="url" class="row-preview">
                <img :src="url" alt="预览" />
              </div>
              <el-button size="small" type="danger" @click="removeImageRow(idx)">删除</el-button>
            </div>
            <el-button size="small" type="primary" plain @click="addImageRow">+ 添加图片</el-button>
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
        <el-form-item label="时间线">
          <div class="list-editor">
            <div v-for="(_, idx) in timelineList" :key="idx" class="list-editor-row timeline-row">
              <div class="row-index">{{ idx + 1 }}</div>
              <el-input v-model="timelineList[idx].year" placeholder="年代" style="width: 120px; flex-shrink: 0;" />
              <el-input v-model="timelineList[idx].event" placeholder="事件描述" class="row-input" />
              <el-button size="small" type="danger" @click="removeTimelineRow(idx)">删除</el-button>
            </div>
            <el-button size="small" type="primary" plain @click="addTimelineRow">+ 添加时间节点</el-button>
          </div>
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
const uploadingSidebarItem = ref(false)
const uploadingImageIdx = ref(-1)

// 图片列表（逐行编辑）
const imageList = ref([])

// 时间线列表（逐行编辑）
const timelineList = ref([])

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
  video: '',
  audio: '',
  sidebarImage: ''
})

// ─── 图片行操作 ──────────────────────────────────────────
const addImageRow = () => { imageList.value.push('') }
const removeImageRow = (idx) => { imageList.value.splice(idx, 1) }

const uploadImageToRow = async (options, idx) => {
  const fd = new FormData()
  fd.append('file', options.file)
  uploadingImageIdx.value = idx
  try {
    const res = await axios.post(UPLOAD_URL, fd, { headers: { 'Content-Type': 'multipart/form-data' } })
    if (res.data.code === 200) {
      imageList.value[idx] = res.data.data
      ElMessage.success('图片上传成功')
    } else {
      ElMessage.error(res.data.message || '上传失败')
    }
  } catch (e) {
    ElMessage.error('上传失败：' + (e.message || '网络错误'))
  } finally {
    uploadingImageIdx.value = -1
  }
}

// ─── 时间线行操作 ─────────────────────────────────────────
const addTimelineRow = () => { timelineList.value.push({ year: '', event: '' }) }
const removeTimelineRow = (idx) => { timelineList.value.splice(idx, 1) }

// 缩略图 / 侧栏图上传
const uploadImage = async (options, target) => {
  const fd = new FormData()
  fd.append('file', options.file)
  if (target === 'thumbnail') uploadingThumbnail.value = true
  else uploadingSidebarItem.value = true
  try {
    const res = await axios.post(UPLOAD_URL, fd, { headers: { 'Content-Type': 'multipart/form-data' } })
    if (res.data.code === 200) {
      form.value[target] = res.data.data
      ElMessage.success('图片上传成功')
    } else {
      ElMessage.error(res.data.message || '上传失败')
    }
  } catch (e) {
    ElMessage.error('上传失败：' + (e.message || '网络错误'))
  } finally {
    if (target === 'thumbnail') uploadingThumbnail.value = false
    else uploadingSidebarItem.value = false
  }
}

// 解析 images 字段为数组
const parseImages = (val) => {
  if (!val) return []
  if (Array.isArray(val)) return val.filter(Boolean)
  try { const p = JSON.parse(val); if (Array.isArray(p)) return p.filter(Boolean) } catch (_) {}
  return val.trim() ? [val.trim()] : []
}

// 解析 timeline 字段为数组
const parseTimeline = (val) => {
  if (!val) return []
  if (Array.isArray(val)) return val.filter(v => v.year || v.event)
  try { const p = JSON.parse(val); if (Array.isArray(p)) return p } catch (_) {}
  return []
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
    video: '',
    audio: '',
    sidebarImage: ''
  }
  imageList.value = []
  timelineList.value = []
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑非遗项目'
  const data = { ...row }
  // images 和 timeline 单独用 imageList/timelineList 管理，从 form 中移除
  const { images, timeline, ...rest } = data
  form.value = rest
  imageList.value = parseImages(images)
  timelineList.value = parseTimeline(timeline).length
    ? parseTimeline(timeline)
    : []
  dialogVisible.value = true
}

const confirmSave = async () => {
  try {
    await formRef.value.validate()

    const payload = {
      ...form.value,
      images: JSON.stringify(imageList.value.filter(Boolean)),
      timeline: JSON.stringify(timelineList.value.filter(v => v.year || v.event))
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
    const payload = {
      ...row,
      enabled: newEnabled,
      images: Array.isArray(row.images) ? JSON.stringify(row.images) : (row.images || '[]'),
      timeline: Array.isArray(row.timeline) ? JSON.stringify(row.timeline) : (row.timeline || '[]')
    }
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

/* 行式列表编辑器 */
.list-editor {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.list-editor-row {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  padding: 6px 10px;
  background: #f9fafc;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  transition: border-color 0.2s;

  &:hover {
    border-color: #c0c4cc;
  }

  .row-index {
    width: 20px;
    flex-shrink: 0;
    text-align: center;
    color: #fff;
    background: #409eff;
    border-radius: 50%;
    font-size: 11px;
    line-height: 20px;
    height: 20px;
    font-weight: bold;
  }

  .row-input {
    flex: 1;
    min-width: 0;
  }

  .upload-btn-inline {
    flex-shrink: 0;
  }

  .row-preview {
    flex-shrink: 0;
    img {
      width: 60px;
      height: 45px;
      object-fit: cover;
      border: 1px solid #dcdfe6;
      border-radius: 4px;
      display: block;
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
