<template>
  <div class="comment-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>评论管理</span>
        </div>
      </template>
      
      <el-table :data="comments" style="width: 100%" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="heritageId" label="非遗项目ID" width="120" />
        <el-table-column prop="username" label="用户名" width="150" />
        <el-table-column prop="content" label="评论内容" show-overflow-tooltip />
        <el-table-column prop="likes" label="点赞数" width="100" />
        <el-table-column prop="createTime" label="创建时间" width="180">
          <template #default="scope">
            {{ formatDate(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" width="100">
          <template #default="scope">
            <el-button type="danger" size="small" @click="handleDelete(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const comments = ref([])
const loading = ref(false)

const fetchComments = async () => {
  loading.value = true
  try {
    const heritageRes = await axios.get('http://localhost:8080/api/heritage/list')
    if (heritageRes.data.code === 200 && heritageRes.data.data.length > 0) {
      const heritageId = heritageRes.data.data[0].id
      const response = await axios.get(`http://localhost:8080/api/comment/${heritageId}`)
      if (response.data.code === 200) {
        comments.value = response.data.data
      }
    }
  } catch (error) {
    console.error('获取评论列表失败:', error)
    ElMessage.error('获取评论列表失败')
  } finally {
    loading.value = false
  }
}

const formatDate = (dateString) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN')
}

const handleDelete = (row) => {
  ElMessageBox.confirm(
    `确定要删除这条评论吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const response = await axios.delete(`http://localhost:8080/api/admin/comment/${row.id}`)
      
      if (response.data.code === 200) {
        ElMessage.success('删除成功')
        fetchComments()
      } else {
        ElMessage.error(response.data.message)
      }
    } catch (error) {
      console.error('删除评论失败:', error)
      ElMessage.error('删除评论失败')
    }
  }).catch(() => {
    ElMessage.info('已取消删除')
  })
}

onMounted(() => {
  fetchComments()
})
</script>

<style scoped>
.comment-management {
  padding: 20px;
}

.card-header {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}
</style>
