<template>
  <div class="dashboard">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon user-icon">
              <el-icon :size="40"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.userCount || 0 }}</div>
              <div class="stat-label">用户总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon heritage-icon">
              <el-icon :size="40"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.heritageCount || 0 }}</div>
              <div class="stat-label">非遗项目</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon comment-icon">
              <el-icon :size="40"><ChatDotRound /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.commentCount || 0 }}</div>
              <div class="stat-label">评论总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon quiz-icon">
              <el-icon :size="40"><Edit /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.quizCount || 0 }}</div>
              <div class="stat-label">测验题目</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="24">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>欢迎来到非遗数字化展示平台后台管理系统</span>
            </div>
          </template>
          <div class="welcome-content">
            <p>本系统用于管理非遗数字化展示平台的各种数据，包括：</p>
            <ul>
              <li>用户管理：查看、编辑用户信息，管理用户角色</li>
              <li>非遗管理：添加、编辑、删除非遗项目</li>
              <li>评论管理：审核和管理用户评论</li>
              <li>测验管理：管理知识测验题目</li>
            </ul>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { User, Document, ChatDotRound, Edit } from '@element-plus/icons-vue'
import axios from 'axios'

const stats = ref({
  userCount: 0,
  heritageCount: 0,
  commentCount: 0,
  quizCount: 0
})

const fetchStats = async () => {
  try {
    const [usersRes, heritageRes, quizRes] = await Promise.all([
      axios.get('http://localhost:8080/api/admin/users'),
      axios.get('http://localhost:8080/api/heritage/list'),
      axios.get('http://localhost:8080/api/quiz/questions')
    ])
    
    stats.value.userCount = usersRes.data.data?.length || 0
    stats.value.heritageCount = heritageRes.data.data?.length || 0
    stats.value.quizCount = quizRes.data.data?.length || 0
    
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

onMounted(() => {
  fetchStats()
})
</script>

<style scoped>
.dashboard {
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.stat-card {
  margin-bottom: 20px;
  height: 100%;
}

.stat-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 120px;
}

.stat-icon {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.user-icon {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.heritage-icon {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.comment-icon {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.quiz-icon {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-info {
  text-align: right;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.card-header {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.welcome-content {
  line-height: 1.8;
  color: #606266;
}

.welcome-content ul {
  margin-top: 10px;
  padding-left: 20px;
}

.welcome-content li {
  margin-bottom: 8px;
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .stat-value {
    font-size: 28px;
  }
  
  .stat-icon {
    width: 70px;
    height: 70px;
  }
}

@media (max-width: 992px) {
  .el-row:first-child .el-col {
    margin-bottom: 20px;
  }
  
  .stat-value {
    font-size: 24px;
  }
  
  .stat-icon {
    width: 60px;
    height: 60px;
  }
}
</style>
