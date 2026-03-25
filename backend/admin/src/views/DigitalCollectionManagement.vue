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
        <el-table-column prop="serial" label="编号" width="110" />
        <el-table-column prop="rarity" label="稀有度" width="90" />
        <el-table-column prop="origin" label="来源" width="120" />
        <el-table-column prop="scoreMin" label="门槛分" width="90" />
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="760px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="名称" prop="name"><el-input v-model="form.name" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="编号" prop="serial"><el-input v-model="form.serial" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="类别" prop="category"><el-input v-model="form.category" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="来源" prop="origin"><el-input v-model="form.origin" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="年代" prop="era"><el-input v-model="form.era" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="稀有度" prop="rarity"><el-input v-model="form.rarity" placeholder="普通/稀有/史诗/传奇" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="稀有度样式" prop="rarityClass"><el-input v-model="form.rarityClass" placeholder="common/rare/epic/legendary" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="光效颜色"><el-input v-model="form.glowColor" placeholder="rgba(...)" /></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="封面图" prop="cover"><el-input v-model="form.cover" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="门槛分"><el-input-number v-model="form.scoreMin" :min="0" :max="100" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="总量"><el-input-number v-model="form.total" :min="0" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="剩余"><el-input-number v-model="form.left" :min="0" style="width: 100%" /></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="发售状态"><el-select v-model="form.saleStatus" style="width:100%"><el-option label="即将开售" value="upcoming" /><el-option label="正在发售" value="ongoing" /><el-option label="已结束" value="ended" /></el-select></el-form-item></el-col>
          <el-col :span="8"><el-form-item label="倒计时"><el-input v-model="form.countdown" placeholder="02天 12:00:00" /></el-form-item></el-col>
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

const BASE = 'http://localhost:8080/api'
const items = ref([])
const loading = ref(false)
const selectedRows = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref(null)

const defaultForm = () => ({
  id: null,
  name: '',
  serial: '',
  category: '',
  origin: '',
  era: '',
  rarity: '',
  rarityClass: 'common',
  cover: '',
  glowColor: 'rgba(100,100,100,0.3)',
  scoreMin: 60,
  total: 100,
  left: 100,
  saleStatus: 'ongoing',
  countdown: '',
  sortOrder: 0,
  enabled: true
})

const form = ref(defaultForm())

const rules = {
  name: [{ required: true, message: '请输入名称', trigger: 'blur' }],
  cover: [{ required: true, message: '请输入封面图地址', trigger: 'blur' }],
  rarityClass: [{ required: true, message: '请输入稀有度样式', trigger: 'blur' }],
  saleStatus: [{ required: true, message: '请选择发售状态', trigger: 'change' }]
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
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑数字藏品'
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSave = async () => {
  try {
    await formRef.value.validate()
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
    ElMessage.error('保存失败')
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
})
</script>

<style scoped>
.page { padding: 20px; }
.card-header { display:flex; align-items:center; justify-content:space-between; }
.actions { display:flex; gap:8px; flex-wrap: wrap; }
</style>
