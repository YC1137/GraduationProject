<template>
  <div class="page">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>数字藏品管理</span>
          <div class="actions">
            <el-button type="warning" :disabled="!selectedRows.length" @click="handleBatchEnable(false)">批量下架</el-button>
            <el-button type="success" :disabled="!selectedRows.length" @click="handleBatchEnable(true)">批量上架</el-button>
            <el-button type="danger" :disabled="!selectedRows.length" @click="handleBatchDelete">批量删除</el-button>
            <el-button type="primary" @click="handleAdd">新增藏品</el-button>
          </div>
        </div>
      </template>

      <el-table :data="items" v-loading="loading" @selection-change="handleSelectionChange" style="width: 100%">
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="enabled" label="状态" width="90">
          <template #default="scope">
            <el-tag :type="scope.row.enabled ? 'success' : 'info'">{{ scope.row.enabled ? '上架' : '下架' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="saleStatus" label="发售状态" width="110" />
        <el-table-column prop="name" label="名称" min-width="180" />
        <el-table-column prop="rarity" label="稀有度" width="90" />
        <el-table-column prop="origin" label="来源" width="120" />
        <el-table-column prop="topicName" label="绑定专题" width="130">
          <template #default="scope">
            <el-tag v-if="scope.row.topicName" type="warning" size="small">{{ scope.row.topicName }}</el-tag>
            <span v-else style="color:#999;font-size:12px">不限专题</span>
          </template>
        </el-table-column>
        <el-table-column prop="scoreMin" label="门槛正确率%" width="100" />
        <el-table-column prop="total" label="总量" width="90" />
        <el-table-column prop="left" label="剩余" width="90" />
        <el-table-column prop="sortOrder" label="排序" width="80" />
        <el-table-column label="操作" fixed="right" width="260">
          <template #default="scope">
            <el-button size="small" type="primary" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="small" type="success" :disabled="scope.row.enabled" @click="handleToggle(scope.row, true)">上架</el-button>
            <el-button size="small" type="warning" :disabled="!scope.row.enabled" @click="handleToggle(scope.row, false)">下架</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="800px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <!-- 名称 -->
          <el-col :span="12"><el-form-item label="名称" prop="name"><el-input v-model="form.name" /></el-form-item></el-col>
          <!-- 系列编号 -->
          <el-col :span="12"><el-form-item label="系列编号"><el-input v-model="form.serial" placeholder="如：HC-001（可选）" /></el-form-item></el-col>
          <!-- 类别 -->
          <el-col :span="12"><el-form-item label="类别"><el-input v-model="form.category" /></el-form-item></el-col>
          <!-- 来源 -->
          <el-col :span="12"><el-form-item label="来源"><el-input v-model="form.origin" /></el-form-item></el-col>
          <!-- 年代 -->
          <el-col :span="12"><el-form-item label="年代"><el-input v-model="form.era" /></el-form-item></el-col>
          <!-- 稀有度（联动） -->
          <el-col :span="12">
            <el-form-item label="稀有度" prop="rarityClass">
              <el-select v-model="form.rarityClass" style="width:100%" @change="onRarityChange">
                <el-option label="普通" value="common" />
                <el-option label="稀有" value="rare" />
                <el-option label="史诗" value="epic" />
                <el-option label="传奇" value="legendary" />
              </el-select>
            </el-form-item>
          </el-col>
          <!-- 稀有度中文（只读，联动） -->
          <el-col :span="12">
            <el-form-item label="稀有度名称">
              <el-input v-model="form.rarity" readonly placeholder="选择稀有度后自动填充" />
            </el-form-item>
          </el-col>
          <!-- 光效颜色（颜色选择器） -->
          <el-col :span="12">
            <el-form-item label="光效颜色">
              <div style="display:flex;align-items:center;gap:10px">
                <el-color-picker v-model="glowColorHex" show-alpha @change="onGlowColorChange" />
                <span style="font-size:12px;color:#999">{{ form.glowColor }}</span>
              </div>
            </el-form-item>
          </el-col>
          <!-- 封面图上传 -->
          <el-col :span="24">
            <el-form-item label="封面图" prop="cover">
              <div style="display:flex;flex-direction:column;gap:10px;width:100%">
                <div style="display:flex;gap:10px;align-items:center">
                  <el-input v-model="form.cover" placeholder="图片URL或上传本地图片" style="flex:1" />
                  <el-upload
                    :show-file-list="false"
                    :before-upload="beforeUpload"
                    :http-request="handleUpload"
                    accept="image/*"
                  >
                    <el-button type="primary" :loading="uploading">本地上传</el-button>
                  </el-upload>
                </div>
                <div v-if="form.cover" style="display:flex;align-items:center;gap:12px">
                  <img :src="form.cover" style="width:80px;height:80px;object-fit:cover;border-radius:6px;border:1px solid #ddd" />
                  <el-button type="danger" size="small" @click="form.cover=''">移除图片</el-button>
                </div>
              </div>
            </el-form-item>
          </el-col>
          <!-- 藏品描述 -->
          <el-col :span="24"><el-form-item label="藏品描述"><el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入藏品的基础信息描述，将展示在用户端详情弹窗中" /></el-form-item></el-col>
          <!-- 绑定专题 -->
          <el-col :span="24">
            <el-form-item label="绑定专题">
              <el-select
                v-model="form.topicName"
                clearable
                filterable
                allow-create
                placeholder="不选则不限专题（所有答题者可见）"
                style="width:100%"
              >
                <el-option v-for="t in topicOptions" :key="t" :label="t" :value="t" />
              </el-select>
              <div style="font-size:12px;color:#999;margin-top:4px">
                选择后仅在该专题答题时才展示此藏品；不选表示任何专题答题都可能获得
              </div>
            </el-form-item>
          </el-col>
          <!-- 数量设置 -->
          <el-col :span="8"><el-form-item label="门槛正确率%"><el-input-number v-model="form.scoreMin" :min="0" :max="100" style="width: 100%" /><div style="font-size:11px;color:#999;margin-top:2px">填 100 = 必须满分才可领取</div></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="总量"><el-input-number v-model="form.total" :min="0" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="剩余"><el-input-number v-model="form.left" :min="0" style="width: 100%" /></el-form-item></el-col>
          <!-- 发售配置 -->
          <el-col :span="8"><el-form-item label="发售状态"><el-select v-model="form.saleStatus" style="width:100%"><el-option label="即将开售" value="upcoming" /><el-option label="正在发售" value="ongoing" /><el-option label="已结束" value="ended" /></el-select></el-form-item></el-col>
          <el-col :span="8">
            <el-form-item label="开售时间">
              <el-date-picker
                v-model="form.saleTime"
                type="datetime"
                placeholder="选择开售日期和时间"
                format="YYYY-MM-DD HH:mm"
                value-format="YYYY-MM-DDTHH:mm:ss"
                style="width:100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8"><el-form-item label="排序"><el-input-number v-model="form.sortOrder" :min="0" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="是否上架"><el-switch v-model="form.enabled" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible=false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const BASE = '/api'
const items = ref([])
const loading = ref(false)
const selectedRows = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)
const uploading = ref(false)
const topicOptions = ref([])

// 稀有度映射
const rarityMap = {
  common:    { label: '普通', glow: 'rgba(156,163,175,0.3)' },
  rare:      { label: '稀有', glow: 'rgba(37,99,235,0.35)'  },
  epic:      { label: '史诗', glow: 'rgba(124,58,237,0.35)' },
  legendary: { label: '传奇', glow: 'rgba(217,119,6,0.4)'   },
}

// 颜色选择器用十六进制，存储时转 rgba
const glowColorHex = ref('#646464')

// rgba 字符串转 hex（用于回显颜色选择器）
const rgbaToHex = (rgba) => {
  if (!rgba) return '#646464'
  if (rgba.startsWith('#')) return rgba
  const m = rgba.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*([\d.]+))?\s*\)/)
  if (!m) return '#646464'
  const r = parseInt(m[1]).toString(16).padStart(2, '0')
  const g = parseInt(m[2]).toString(16).padStart(2, '0')
  const b = parseInt(m[3]).toString(16).padStart(2, '0')
  const a = m[4] !== undefined ? Math.round(parseFloat(m[4]) * 255).toString(16).padStart(2, '0') : 'ff'
  return `#${r}${g}${b}${a}`
}

// hex 转 rgba
const hexToRgba = (hex) => {
  if (!hex) return 'rgba(100,100,100,0.3)'
  // 如果传入的已经是 rgba/rgb 格式，直接返回
  if (hex.startsWith('rgba') || hex.startsWith('rgb')) return hex
  const h = hex.replace('#', '')
  if (h.length < 6) return 'rgba(100,100,100,0.3)'
  const r = parseInt(h.slice(0, 2), 16)
  const g = parseInt(h.slice(2, 4), 16)
  const b = parseInt(h.slice(4, 6), 16)
  if (isNaN(r) || isNaN(g) || isNaN(b)) return 'rgba(100,100,100,0.3)'
  const a = h.length === 8 ? (parseInt(h.slice(6, 8), 16) / 255).toFixed(2) : '1'
  return `rgba(${r},${g},${b},${a})`
}

const onGlowColorChange = (hex) => {
  if (!hex) return
  form.value.glowColor = hexToRgba(hex)
}

const onRarityChange = (val) => {
  const info = rarityMap[val]
  if (info) {
    form.value.rarity = info.label
    form.value.glowColor = info.glow
    glowColorHex.value = rgbaToHex(info.glow)
  }
}

const defaultForm = () => ({
  id: null,
  name: '',
  serial: '',
  category: '',
  origin: '',
  era: '',
  rarity: '普通',
  rarityClass: 'common',
  cover: '',
  glowColor: 'rgba(156,163,175,0.3)',
  description: '',
  topicName: '',
  scoreMin: 100,
  total: 100,
  left: 100,
  saleStatus: 'ongoing',
  saleTime: null,
  sortOrder: 0,
  enabled: true
})

const form = ref(defaultForm())

const rules = {
  name:       [{ required: true, message: '请输入名称', trigger: 'blur' }],
  cover:      [{ required: true, message: '请上传封面图', trigger: 'blur' }],
  rarityClass:[{ required: true, message: '请选择稀有度', trigger: 'change' }],
  saleStatus: [{ required: true, message: '请选择发售状态', trigger: 'change' }]
}

// 图片上传
const beforeUpload = (file) => {
  const ok = ['image/jpeg','image/jpg','image/png','image/gif','image/webp'].includes(file.type)
  if (!ok) { ElMessage.error('仅支持 jpg/png/gif/webp 格式'); return false }
  if (file.size > 10 * 1024 * 1024) { ElMessage.error('图片不能超过 10MB'); return false }
  return true
}

const handleUpload = async ({ file }) => {
  uploading.value = true
  try {
    const fd = new FormData()
    fd.append('file', file)
    const res = await axios.post(`${BASE}/upload/image`, fd, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    if (res.data.code === 200) {
      form.value.cover = res.data.data
      ElMessage.success('上传成功')
    } else {
      ElMessage.error(res.data.message || '上传失败')
    }
  } catch {
    ElMessage.error('上传失败')
  } finally {
    uploading.value = false
  }
}

const loadItems = async () => {
  loading.value = true
  try {
    const res = await axios.get(`${BASE}/admin/digital-collection/list`)
    if (res.data.code === 200) items.value = res.data.data || []
    else ElMessage.error(res.data.message || '加载失败')
  } catch (e) {
    ElMessage.error('加载失败')
  } finally {
    loading.value = false
  }
}

const handleSelectionChange = (rows) => {
  selectedRows.value = rows
}

const handleAdd = () => {
  dialogTitle.value = '新增数字藏品'
  form.value = defaultForm()
  glowColorHex.value = rgbaToHex(form.value.glowColor)
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑数字藏品'
  form.value = { ...row }
  glowColorHex.value = rgbaToHex(row.glowColor)
  dialogVisible.value = true
}

const handleSave = async () => {
  // 先做表单验证，验证不通过直接返回（Element Plus 会高亮字段）
  let valid = false
  try {
    valid = await formRef.value.validate()
  } catch {
    return
  }
  if (!valid) return

  try {
    const payload = { ...form.value }
    const req = payload.id
      ? axios.put(`${BASE}/admin/digital-collection/${payload.id}`, payload)
      : axios.post(`${BASE}/admin/digital-collection`, payload)

    const res = await req
    if (res.data.code === 200) {
      ElMessage.success('保存成功')
      dialogVisible.value = false
      loadItems()
    } else {
      ElMessage.error(res.data.message || '保存失败')
    }
  } catch (e) {
    ElMessage.error('保存失败：' + (e?.response?.data?.message || e?.message || '网络错误'))
  }
}

const handleToggle = async (row, enabled) => {
  try {
    const payload = { ...row, enabled }
    const res = await axios.put(`${BASE}/admin/digital-collection/${row.id}`, payload)
    if (res.data.code === 200) {
      ElMessage.success(enabled ? '上架成功' : '下架成功')
      loadItems()
    } else {
      ElMessage.error(res.data.message || '操作失败')
    }
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定删除「${row.name}」吗？`, '提示', { type: 'warning' })
    .then(async () => {
      const res = await axios.delete(`${BASE}/admin/digital-collection/${row.id}`)
      if (res.data.code === 200) {
        ElMessage.success('删除成功')
        loadItems()
      } else {
        ElMessage.error(res.data.message || '删除失败')
      }
    })
    .catch(() => {})
}

const handleBatchDelete = () => {
  ElMessageBox.confirm(`确定删除选中的 ${selectedRows.value.length} 条数据吗？`, '提示', { type: 'warning' })
    .then(async () => {
      const reqs = selectedRows.value.map(row => axios.delete(`${BASE}/admin/digital-collection/${row.id}`))
      await Promise.all(reqs)
      ElMessage.success('批量删除成功')
      selectedRows.value = []
      loadItems()
    })
    .catch(() => {})
}

const handleBatchEnable = async (enabled) => {
  try {
    const ids = selectedRows.value.map(row => row.id)
    const res = await axios.put(`${BASE}/admin/digital-collection/batch-enabled`, { ids, enabled })
    if (res.data.code === 200) {
      ElMessage.success('批量操作成功')
      selectedRows.value = []
      loadItems()
    } else {
      ElMessage.error(res.data.message || '批量操作失败')
    }
  } catch (e) {
    ElMessage.error('批量操作失败')
  }
}

onMounted(() => {
  loadItems()
  loadTopics()
})

const loadTopics = async () => {
  try {
    const res = await axios.get(`${BASE}/quiz/questions`)
    if (res.data.code === 200) {
      const set = new Set()
      res.data.data.forEach(q => { if (q.topicName) set.add(q.topicName) })
      topicOptions.value = Array.from(set).sort()
    }
  } catch {
    // 加载失败不影响使用，用户可手动输入
  }
}
</script>

<style scoped>
.page { padding: 20px; }
.card-header { display:flex; align-items:center; justify-content:space-between; }
.actions { display:flex; gap:8px; flex-wrap: wrap; }
</style>
