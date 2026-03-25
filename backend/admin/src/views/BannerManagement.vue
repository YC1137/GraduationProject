<template>
  <div class="banner-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>轮播图管理</span>
          <el-button type="primary" @click="handleAdd">添加轮播图</el-button>
        </div>
      </template>

      <el-table :data="banners" v-loading="loading" border style="width:100%">
        <el-table-column label="预览" width="160">
          <template #default="{ row }">
            <el-image
              :src="row.imageUrl"
              style="width:140px;height:60px;border-radius:4px"
              fit="cover"
            />
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="120" show-overflow-tooltip />
        <el-table-column prop="linkUrl" label="跳转链接" min-width="160" show-overflow-tooltip />
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
      :title="isEdit ? '编辑轮播图' : '添加轮播图'"
      width="600px"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="90px"
      >
        <el-form-item label="图片URL" prop="imageUrl">
          <div style="display:flex;gap:8px;width:100%">
            <el-input v-model="form.imageUrl" placeholder="请输入图片地址，或点击右侧上传" style="flex:1" />
            <el-upload
              action=""
              :show-file-list="false"
              accept="image/jpeg,image/png,image/gif,image/webp"
              :before-upload="handleImageUpload"
            >
              <el-button type="primary" :loading="uploading">
                <el-icon><Upload /></el-icon>
                上传图片
              </el-button>
            </el-upload>
          </div>
        </el-form-item>

        <el-form-item label="图片预览">
          <el-image
            v-if="form.imageUrl"
            :src="form.imageUrl"
            style="width:100%;max-height:180px;object-fit:cover;border-radius:6px"
            fit="cover"
          />
          <span v-else style="color:#bbb;font-size:13px">输入图片 URL 或上传图片后预览</span>
        </el-form-item>

        <el-form-item label="标题">
          <el-input v-model="form.title" placeholder="可选" />
        </el-form-item>

        <el-form-item label="副标题">
          <el-input v-model="form.subtitle" placeholder="可选" />
        </el-form-item>

        <el-form-item label="跳转链接">
          <el-input v-model="form.linkUrl" placeholder="如 /heritage/1（站内路由）或 https://…（外链）" />
        </el-form-item>

        <el-form-item label="按钮文字">
          <el-input v-model="form.btnText" placeholder="如：了解详情（可选）" />
        </el-form-item>

        <el-form-item label="排序">
          <el-input-number v-model="form.sortOrder" :min="0" :max="999" />
          <span style="margin-left:8px;color:#999;font-size:12px">数字越小越靠前</span>
        </el-form-item>

        <el-form-item label="切换间隔">
          <el-input-number v-model="form.interval" :min="1000" :max="30000" :step="500" />
          <span style="margin-left:8px;color:#999;font-size:12px">毫秒（默认 5000）</span>
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
import { Upload } from '@element-plus/icons-vue'
import request from '../api/request'

const banners = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const uploading = ref(false)
const formRef = ref(null)

const defaultForm = () => ({
  id: null,
  imageUrl: '',
  title: '',
  subtitle: '',
  linkUrl: '',
  btnText: '',
  sortOrder: 0,
  interval: 5000,
  enabled: true
})

const form = ref(defaultForm())

const rules = {
  imageUrl: [{ required: true, message: '请填写或上传图片', trigger: 'blur' }]
}

const loadBanners = async () => {
  loading.value = true
  try {
    const res = await request.get('/banner/admin/list')
    banners.value = res.data || []
  } catch (e) {
    ElMessage.error('加载失败：' + (e.message || '服务器错误'))
  } finally {
    loading.value = false
  }
}

onMounted(loadBanners)

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
      await request.put('/banner/admin/update', form.value)
      ElMessage.success('修改成功')
    } else {
      await request.post('/banner/admin/add', form.value)
      ElMessage.success('添加成功')
    }
    dialogVisible.value = false
    loadBanners()
  } catch (e) {
    ElMessage.error('操作失败')
  } finally {
    submitting.value = false
  }
}

const handleToggle = async (row) => {
  try {
    await request.put(`/banner/admin/${row.id}/toggle`)
    ElMessage.success(row.enabled ? '已禁用' : '已启用')
    loadBanners()
  } catch (e) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = async (id) => {
  await ElMessageBox.confirm('确定删除该轮播图？', '提示', { type: 'warning' })
  try {
    await request.delete(`/banner/admin/${id}`)
    ElMessage.success('删除成功')
    loadBanners()
  } catch (e) {
    ElMessage.error('删除失败')
  }
}

// 上传图片
const handleImageUpload = async (file) => {
  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', file)
    const res = await request.post('/upload/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    form.value.imageUrl = res.data || res
    ElMessage.success('上传成功')
  } catch (e) {
    ElMessage.error('上传失败，请检查后端服务')
  } finally {
    uploading.value = false
  }
  return false
}
</script>

<style scoped>
.banner-management {
  padding: 20px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  font-size: 16px;
}
</style>
