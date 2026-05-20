<template>
  <div class="announcement-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>平台公告管理</span>
          <el-button type="primary" @click="handleAdd">新增公告</el-button>
        </div>
      </template>

      <el-table :data="list" v-loading="loading" border style="width:100%">
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column label="标签" width="90" align="center">
          <template #default="{ row }">
            <el-tag :type="row.type">{{ row.tag }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="240" show-overflow-tooltip />
        <el-table-column prop="pubDate" label="发布日期" width="130" align="center" />
        <el-table-column prop="sortOrder" label="排序" width="80" align="center" />
        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="row.enabled ? 'success' : 'info'">
              {{ row.enabled ? '已启用' : '已禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="220" align="center">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" :type="row.enabled ? 'warning' : 'success'" @click="handleToggle(row)">
              {{ row.enabled ? '禁用' : '启用' }}
            </el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑公告' : '新增公告'"
      width="560px"
      destroy-on-close
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入公告标题" />
        </el-form-item>

        <el-form-item label="标签" prop="tag">
          <el-input v-model="form.tag" placeholder="如：通知、活动、更新、公告" style="width:160px" />
        </el-form-item>

        <el-form-item label="标签类型" prop="type">
          <el-select v-model="form.type" style="width:160px">
            <el-option label="蓝色-通知 (info)" value="info" />
            <el-option label="蓝色-主要 (primary)" value="primary" />
            <el-option label="绿色-成功 (success)" value="success" />
            <el-option label="橙色-警告 (warning)" value="warning" />
            <el-option label="红色-危险 (danger)" value="danger" />
          </el-select>
          <span style="margin-left:10px">
            <el-tag :type="form.type">{{ form.tag || '预览' }}</el-tag>
          </span>
        </el-form-item>

        <el-form-item label="公告正文">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="5"
            placeholder="请输入公告详细内容（可选，填写后前台可点击查看详情）"
          />
        </el-form-item>

        <el-form-item label="发布日期">
          <el-date-picker
            v-model="form.pubDate"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="选择日期"
            style="width:160px"
          />
        </el-form-item>

        <el-form-item label="排序">
          <el-input-number v-model="form.sortOrder" :min="0" :max="999" />
          <span style="margin-left:8px;color:#999;font-size:12px">数字越小越靠前</span>
        </el-form-item>

        <el-form-item label="状态">
          <el-switch v-model="form.enabled" active-text="启用" inactive-text="禁用" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../api/request'

const list = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref(null)

const defaultForm = () => ({
  id: null,
  tag: '通知',
  type: 'info',
  title: '',
  content: '',
  pubDate: new Date().toISOString().slice(0, 10),
  sortOrder: 0,
  enabled: true
})

const form = ref(defaultForm())

const rules = {
  title: [{ required: true, message: '请输入公告标题', trigger: 'blur' }],
  tag:   [{ required: true, message: '请输入标签文字', trigger: 'blur' }],
  type:  [{ required: true, message: '请选择标签类型', trigger: 'change' }]
}

const loadList = async () => {
  loading.value = true
  try {
    const res = await request.get('/announcement/admin/list')
    list.value = Array.isArray(res?.data) ? res.data : (Array.isArray(res) ? res : [])
  } catch {
    ElMessage.error('加载失败')
  } finally {
    loading.value = false
  }
}

onMounted(loadList)

const handleAdd = () => {
  isEdit.value = false
  form.value = defaultForm()
  dialogVisible.value = true
}

const handleEdit = (row) => {
  isEdit.value = true
  form.value = { ...row }
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  submitting.value = true
  try {
    if (isEdit.value) {
      await request.put('/announcement/admin/update', form.value)
      ElMessage.success('修改成功')
    } else {
      await request.post('/announcement/admin/add', form.value)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadList()
  } catch {
    ElMessage.error('操作失败')
  } finally {
    submitting.value = false
  }
}

const handleToggle = async (row) => {
  try {
    await request.put(`/announcement/admin/${row.id}/toggle`)
    ElMessage.success(row.enabled ? '已禁用' : '已启用')
    loadList()
  } catch {
    ElMessage.error('操作失败')
  }
}

const handleDelete = async (id) => {
  await ElMessageBox.confirm('确定删除该公告？', '提示', { type: 'warning' })
  try {
    await request.delete(`/announcement/admin/${id}`)
    ElMessage.success('删除成功')
    loadList()
  } catch {
    ElMessage.error('删除失败')
  }
}
</script>

<style scoped>
.announcement-management { padding: 20px; }
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  font-size: 16px;
}
</style>
