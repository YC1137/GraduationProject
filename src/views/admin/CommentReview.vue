<template>
  <div class="comment-review-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1 class="page-title">评论管理</h1>
      </div>

      <!-- 评论表格 -->
      <div class="table-container">
        <el-table :data="filteredComments" v-loading="loading" stripe border style="width: 100%">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="heritageId" label="非遗项目ID" width="120" />
          <el-table-column prop="username" label="用户名" width="150" />
          <el-table-column prop="content" label="评论内容" min-width="250" show-overflow-tooltip />
          <el-table-column prop="likes" label="点赞数" width="100" />
          <el-table-column label="创建时间" width="180">
            <template #default="{ row }">
              {{ formatTime(row.createTime) }}
            </template>
          </el-table-column>
          <el-table-column label="审核状态" width="120">
            <template #default="{ row }">
              <el-tag :type="getStatusType(row.status)" size="small">
                {{ getStatusText(row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="320" fixed="right">
            <template #default="{ row }">
              <div class="action-buttons">
                <el-button
                  type="success"
                  size="small"
                  @click="handleApprove(row)"
                  :loading="approving === row.id"
                  :disabled="row.status === 1"
                >
                  通过
                </el-button>
                <el-button
                  type="danger"
                  size="small"
                  @click="handleReject(row)"
                  :loading="rejecting === row.id"
                  :disabled="row.status === 2"
                >
                  拒绝
                </el-button>
                <el-button
                  type="primary"
                  size="small"
                  plain
                  @click="handleReset(row)"
                  :loading="resetting === row.id"
                  :disabled="row.status === 0"
                >
                  重置
                </el-button>
                <el-button
                  type="info"
                  size="small"
                  @click="handleDelete(row)"
                  :loading="deleting === row.id"
                >
                  删除
                </el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { getAllComments, reviewComment, deleteComment } from '@/api/heritage'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const approving = ref(null)
const rejecting = ref(null)
const deleting = ref(null)
const resetting = ref(null)
const filterStatus = ref(null)
const comments = ref([])

const stats = computed(() => {
  return {
    pending: comments.value.filter(c => c.status === 0).length,
    approved: comments.value.filter(c => c.status === 1).length,
    rejected: comments.value.filter(c => c.status === 2).length
  }
})

const filteredComments = computed(() => {
  if (filterStatus.value === null) {
    return comments.value
  }
  return comments.value.filter(c => c.status === filterStatus.value)
})

// 加载评论列表
const loadComments = async () => {
  loading.value = true
  try {
    const data = await getAllComments()
    comments.value = data || []
  } catch (error) {
    ElMessage.error('加载评论失败')
    console.error(error)
  } finally {
    loading.value = false
  }
}

// 通过评论
const handleApprove = async (comment) => {
  try {
    await ElMessageBox.confirm(`确认通过这条评论吗？`, '审核确认', {
      confirmButtonText: '通过',
      cancelButtonText: '取消',
      type: 'success'
    })

    approving.value = comment.id
    await reviewComment(comment.id, 1)

    comment.status = 1
    ElMessage.success('评论已通过审核')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('审核失败')
    }
  } finally {
    approving.value = null
  }
}

// 拒绝评论
const handleReject = async (comment) => {
  try {
    await ElMessageBox.confirm(`确认拒绝这条评论吗？`, '审核确认', {
      confirmButtonText: '拒绝',
      cancelButtonText: '取消',
      type: 'warning'
    })

    rejecting.value = comment.id
    await reviewComment(comment.id, 2)

    comment.status = 2
    ElMessage.success('评论已拒绝')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('审核失败')
    }
  } finally {
    rejecting.value = null
  }
}

// 删除评论
const handleDelete = async (comment) => {
  try {
    await ElMessageBox.confirm(`确认删除这条评论吗？删除后无法恢复。`, '删除确认', {
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      type: 'error'
    })

    deleting.value = comment.id
    await deleteComment(comment.id)

    comments.value = comments.value.filter(c => c.id !== comment.id)
    ElMessage.success('评论已删除')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  } finally {
    deleting.value = null
  }
}

// 重置评论状态
const handleReset = async (comment) => {
  try {
    await ElMessageBox.confirm(`确认将这条评论重置为待审核状态吗？`, '重置确认', {
      confirmButtonText: '重置',
      cancelButtonText: '取消',
      type: 'info'
    })

    resetting.value = comment.id
    await reviewComment(comment.id, 0)

    comment.status = 0
    ElMessage.success('评论已重置')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('重置失败')
    }
  } finally {
    resetting.value = null
  }
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  try {
    const date = new Date(time)
    return date.toLocaleString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit'
    })
  } catch (error) {
    return time
  }
}

// 获取状态文本
const getStatusText = (status) => {
  const statusMap = {
    0: '待审核',
    1: '已通过',
    2: '已拒绝'
  }
  return statusMap[status] || '未知'
}

// 获取状态标签类型
const getStatusType = (status) => {
  const typeMap = {
    0: 'warning',
    1: 'success',
    2: 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取空状态文本
const getEmptyText = () => {
  if (filterStatus.value === 0) return '没有待审核的评论'
  if (filterStatus.value === 1) return '没有已通过的评论'
  if (filterStatus.value === 2) return '没有已拒绝的评论'
  return '暂无评论数据'
}

onMounted(() => {
  loadComments()
})
</script>

<style lang="scss" scoped>
.comment-review-page {
  padding: 40px 0 80px;
  min-height: calc(100vh - 80px);
}

.page-header {
  margin-bottom: 30px;

  .page-title {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--text-primary);
    margin: 0;
  }
}

.table-container {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.action-buttons {
  display: flex;
  gap: 8px;
}
</style>
