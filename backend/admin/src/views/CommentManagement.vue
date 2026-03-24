<template>
  <div class="comment-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>评论管理</span>
          <div class="header-right">
            <el-radio-group v-model="filterStatus" @change="applyFilter" size="small">
              <el-radio-button label="all">全部 ({{ allComments.length }})</el-radio-button>
              <el-radio-button label="0">
                待审核
                <el-badge v-if="pendingCount > 0" :value="pendingCount" class="badge-inline" />
              </el-radio-button>
              <el-radio-button label="1">已通过</el-radio-button>
              <el-radio-button label="2">已拒绝</el-radio-button>
            </el-radio-group>
            <el-button size="small" @click="fetchComments" :loading="loading" style="margin-left:12px">
              刷新
            </el-button>
          </div>
        </div>
      </template>

      <el-table :data="comments" style="width: 100%" v-loading="loading" row-key="id">
        <el-table-column prop="id" label="ID" width="70" />
        <el-table-column prop="heritageId" label="遗产ID" width="90" />
        <el-table-column label="用户" width="130">
          <template #default="scope">
            <div class="user-cell">
              <el-avatar :src="scope.row.avatar" :size="28" />
              <span>{{ scope.row.username }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="评论内容" show-overflow-tooltip min-width="200" />
        <el-table-column prop="likes" label="点赞" width="70" align="center" />
        <el-table-column label="状态" width="100" align="center">
          <template #default="scope">
            <el-tag
              :type="statusTagType(scope.row.status)"
              size="small"
              effect="light"
            >
              {{ statusLabel(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="发布时间" width="165">
          <template #default="scope">
            {{ formatDate(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" width="200">
          <template #default="scope">
            <template v-if="scope.row.status === 0">
              <el-button type="success" size="small" @click="handleReview(scope.row, 1)">通过</el-button>
              <el-button type="warning" size="small" @click="handleReview(scope.row, 2)">拒绝</el-button>
            </template>
            <el-button type="danger" size="small" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const allComments = ref([])
const loading = ref(false)
const filterStatus = ref('all')

const pendingCount = computed(() => allComments.value.filter(c => c.status === 0).length)

const comments = computed(() => {
  if (filterStatus.value === 'all') return allComments.value
  return allComments.value.filter(c => c.status === Number(filterStatus.value))
})

const applyFilter = () => { /* computed 自动响应 */ }

const fetchComments = async () => {
  loading.value = true
  try {
    const res = await axios.get('http://localhost:8080/api/comment/admin/all')
    if (res.data.code === 200) {
      allComments.value = res.data.data || []
    } else {
      ElMessage.error(res.data.message || '获取评论失败')
    }
  } catch (error) {
    console.error('获取评论列表失败:', error)
    ElMessage.error('获取评论列表失败')
  } finally {
    loading.value = false
  }
}

const statusLabel = (status) => {
  return { 0: '待审核', 1: '已通过', 2: '已拒绝' }[status] ?? '未知'
}

const statusTagType = (status) => {
  return { 0: 'warning', 1: 'success', 2: 'danger' }[status] ?? 'info'
}

const formatDate = (dateString) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleString('zh-CN')
}

const handleReview = async (row, status) => {
  const action = status === 1 ? '通过' : '拒绝'
  try {
    await ElMessageBox.confirm(`确认${action}该评论？`, '审核确认', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: status === 1 ? 'success' : 'warning'
    })
    const res = await axios.put(
      `http://localhost:8080/api/comment/admin/${row.id}/review`,
      null,
      { params: { status } }
    )
    if (res.data.code === 200) {
      ElMessage.success(status === 1 ? '已通过审核' : '已拒绝')
      row.status = status  // 直接更新本地数据，无需重新请求
    } else {
      ElMessage.error(res.data.message || '操作失败')
    }
  } catch (e) {
    if (e !== 'cancel') console.error(e)
  }
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定删除这条评论吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const res = await axios.delete(`http://localhost:8080/api/comment/admin/${row.id}`)
    if (res.data.code === 200) {
      ElMessage.success('删除成功')
      allComments.value = allComments.value.filter(c => c.id !== row.id)
    } else {
      ElMessage.error(res.data.message || '删除失败')
    }
  } catch (e) {
    if (e !== 'cancel') console.error(e)
  }
}

onMounted(fetchComments)
</script>

<style scoped>
.comment-management {
  padding: 20px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.header-right {
  display: flex;
  align-items: center;
}

.badge-inline {
  margin-left: 4px;
  vertical-align: middle;
}

.user-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}
</style>
