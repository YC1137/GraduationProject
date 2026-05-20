<template>
  <el-container class="layout-container">
    <el-aside width="200px" class="aside">
      <div class="logo">非遗管理平台</div>
      <el-menu
        :default-active="activeMenu"
        router
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
      >
        <el-menu-item index="/dashboard">
          <el-icon><HomeFilled /></el-icon>
          <span>首页</span>
        </el-menu-item>
        <el-menu-item index="/users">
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item index="/heritage">
          <el-icon><Document /></el-icon>
          <span>非遗管理</span>
        </el-menu-item>
        <el-menu-item index="/comments">
          <el-icon><ChatDotRound /></el-icon>
          <span>评论管理</span>
        </el-menu-item>
        <el-menu-item index="/quiz">
          <el-icon><Edit /></el-icon>
          <span>测验管理</span>
        </el-menu-item>
        <el-menu-item index="/digital-collection">
          <el-icon><CollectionTag /></el-icon>
          <span>数字藏品管理</span>
        </el-menu-item>
        <el-menu-item index="/banner">
          <el-icon><PictureFilled /></el-icon>
          <span>轮播图管理</span>
        </el-menu-item>
        <el-menu-item index="/announcement">
          <el-icon><Bell /></el-icon>
          <span>公告管理</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <div class="header-content">
          <span class="title">遗见 - 后台管理系统</span>
          <div class="user-info">
            <el-dropdown @command="handleCommand">
              <span class="el-dropdown-link">
                {{ adminUser?.username }}
                <el-icon class="el-icon--right"><arrow-down /></el-icon>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </div>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { HomeFilled, User, Document, ChatDotRound, Edit, ArrowDown, CollectionTag, PictureFilled, Bell } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const adminUser = ref(null)

const activeMenu = computed(() => route.path)

const handleCommand = (command) => {
  if (command === 'logout') {
    localStorage.removeItem('adminToken')
    localStorage.removeItem('adminUser')
    ElMessage.success('退出登录成功')
    router.push('/login')
  }
}

onMounted(() => {
  const user = localStorage.getItem('adminUser')
  if (user) {
    adminUser.value = JSON.parse(user)
  }
})
</script>

<style scoped>
.layout-container {
  height: 100vh;
  width: 100vw;
  min-width: 100vw;
  max-width: 100vw;
  overflow: hidden;
}

.aside {
  background-color: #304156;
  height: 100%;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  color: #fff;
  font-size: 18px;
  font-weight: bold;
  background-color: #2b3a4a;
}

.header {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  padding: 0 20px;
  height: 60px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
}

.title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.user-info {
  cursor: pointer;
}

.el-dropdown-link {
  display: flex;
  align-items: center;
  color: #606266;
}

.main {
  background-color: #f0f2f5;
  padding: 20px;
  height: calc(100vh - 60px);
  overflow-y: auto;
}
</style>
