<template>
    <header class="app-header">
      <div class="container">
        <!-- 顶部标题栏 -->
        <div class="header-top">
          <!-- Logo 和标题 -->
          <div class="logo-section" @click="goHome">
            <div class="logo-icon">非遗</div>
            <div class="logo-text">
              <h1 class="site-title">非遗数字化展示平台</h1>
              <p class="site-slogan">百闻不如遗见</p>
            </div>
          </div>
          
          <!-- 移动端菜单按钮 -->
          <div class="mobile-menu-btn" @click="toggleMobileMenu" v-if="isMobile">
            <el-icon :size="24">
              <Expand v-if="!mobileMenuOpen" />
              <Fold v-else />
            </el-icon>
          </div>
          
          <!-- PC端导航和搜索 -->
          <div class="desktop-actions" v-if="!isMobile">
            <!-- 导航菜单 -->
            <nav class="nav-menu">
              <router-link to="/" class="nav-item">
                <el-icon><HomeFilled /></el-icon>
                <span>首页</span>
              </router-link>
              <router-link to="/category" class="nav-item">
                <el-icon><Menu /></el-icon>
                <span>分类浏览</span>
              </router-link>
              <router-link to="/quiz" class="nav-item">
                <el-icon><QuestionFilled /></el-icon>
                <span>知识测验</span>
              </router-link>
              <router-link to="/ai-chat" class="nav-item">
                <el-icon><ChatDotRound /></el-icon>
                <span>遗遗问答</span>
              </router-link>
            </nav>
            
            <!-- 搜索框 -->
            <div class="search-box">
              <el-input
                v-model="searchKeyword"
                placeholder="搜索非遗项目..."
                :prefix-icon="Search"
                @keyup.enter="handleSearch"
                clearable
              />
            </div>
            
            <!-- 用户信息/登录注册 -->
            <div class="user-section">
              <!-- 未登录状态 -->
              <div v-if="!authStore.isLoggedIn" class="auth-buttons">
                <button class="auth-btn login-btn" @click="showLogin">登录</button>
                <button class="auth-btn register-btn" @click="showRegister">注册</button>
              </div>
              
              <!-- 已登录状态 -->
              <div v-else class="user-dropdown-wrap" @click="toggleUserMenu" v-click-outside="closeUserMenu">
                <div class="user-info" :class="{ open: userMenuOpen }">
                  <el-avatar :src="authStore.currentUser.avatar" :size="32" />
                  <span class="username">{{ authStore.currentUser.username }}</span>
                  <svg class="arrow-icon" :class="{ rotated: userMenuOpen }" viewBox="0 0 24 24" width="14" height="14"><path d="M7 10l5 5 5-5z" fill="currentColor"/></svg>
                </div>
                <!-- 自定义下拉面板 -->
                <div class="user-panel" v-show="userMenuOpen">
                  <!-- 用户信息头部 -->
                  <div class="panel-header">
                    <el-avatar :src="authStore.currentUser.avatar" :size="48" class="panel-avatar" />
                    <div class="panel-user-info">
                      <div class="panel-username">{{ authStore.currentUser.username }}</div>
                      <div class="panel-email">{{ authStore.currentUser.email || '暂无邮箱' }}</div>
                    </div>
                  </div>
                  <!-- 菜单项 -->
                  <div class="panel-menu">
                    <button class="panel-item" @click.stop="handleUserCommand('profile')">
                      <span class="panel-item-icon profile-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                      </span>
                      <span class="panel-item-text">个人中心</span>
                      <svg class="panel-item-arrow" viewBox="0 0 24 24" width="14" height="14"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z" fill="currentColor"/></svg>
                    </button>
                    <button class="panel-item" @click.stop="handleUserCommand('favorites')">
                      <span class="panel-item-icon fav-icon">
                        <svg viewBox="0 0 24 24"><path d="M17 3H7c-1.1 0-2 .9-2 2v16l7-3 7 3V5c0-1.1-.9-2-2-2z"/></svg>
                      </span>
                      <span class="panel-item-text">我的收藏</span>
                      <svg class="panel-item-arrow" viewBox="0 0 24 24" width="14" height="14"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z" fill="currentColor"/></svg>
                    </button>
                    <button class="panel-item" @click.stop="handleUserCommand('likes')">
                      <span class="panel-item-icon like-icon">
                        <svg viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                      </span>
                      <span class="panel-item-text">我的点赞</span>
                      <svg class="panel-item-arrow" viewBox="0 0 24 24" width="14" height="14"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z" fill="currentColor"/></svg>
                    </button>
                  </div>
                  <div class="panel-divider"></div>
                  <button class="panel-item logout-item" @click.stop="handleUserCommand('logout')">
                    <span class="panel-item-icon logout-icon">
                      <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    </span>
                    <span class="panel-item-text">退出登录</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 移动端菜单展开区域 -->
        <div class="mobile-menu-panel" v-if="isMobile" :class="{ active: mobileMenuOpen }">
          <!-- 导航菜单 -->
          <nav class="nav-menu">
            <router-link to="/" class="nav-item" @click="closeMobileMenu">
              <el-icon><HomeFilled /></el-icon>
              <span>首页</span>
            </router-link>
            <router-link to="/category" class="nav-item" @click="closeMobileMenu">
              <el-icon><Menu /></el-icon>
              <span>分类浏览</span>
            </router-link>
            <router-link to="/quiz" class="nav-item" @click="closeMobileMenu">
              <el-icon><QuestionFilled /></el-icon>
              <span>知识测验</span>
            </router-link>
            <router-link to="/ai-chat" class="nav-item" @click="closeMobileMenu">
              <el-icon><ChatDotRound /></el-icon>
              <span>遗遗问答</span>
            </router-link>
          </nav>
          
          <!-- 搜索框 -->
          <div class="mobile-search">
            <el-input
              v-model="searchKeyword"
              placeholder="搜索非遗项目..."
              :prefix-icon="Search"
              @keyup.enter="handleSearch"
              clearable
            />
          </div>
          
          <!-- 移动端用户信息 -->
          <div class="mobile-user-section">
            <!-- 未登录状态 -->
            <div v-if="!authStore.isLoggedIn" class="mobile-auth-buttons">
              <button class="auth-btn login-btn" @click="showLogin">登录</button>
              <button class="auth-btn register-btn" @click="showRegister">注册</button>
            </div>
            
            <!-- 已登录状态 -->
            <div v-else class="mobile-user-info">
              <div class="user-profile">
                <el-avatar :src="authStore.currentUser.avatar" :size="40" />
                <div class="user-details">
                  <div class="username">{{ authStore.currentUser.username }}</div>
                  <div class="user-email">{{ authStore.currentUser.email }}</div>
                </div>
              </div>
              <div class="user-actions">
                <el-button text @click="handleUserCommand('profile')">
                  <el-icon><User /></el-icon>
                  个人中心
                </el-button>
                <el-button text @click="handleUserCommand('favorites')">
                  <el-icon><Star /></el-icon>
                  我的收藏
                </el-button>
                <el-button text @click="handleUserCommand('likes')">
                  <el-icon><CollectionTag /></el-icon>
                  我的点赞
                </el-button>
                <el-button text type="danger" @click="handleUserCommand('logout')">
                  <el-icon><SwitchButton /></el-icon>
                  退出登录
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 登录注册对话框 -->
      <LoginDialog
        v-model="loginDialogVisible"
        :default-mode="loginMode"
        @success="handleLoginSuccess"
      />
    </header>
  </template>
  
  <script setup>
  import { ref, computed, onMounted, onUnmounted } from 'vue'
  import { useRouter } from 'vue-router'
  import { ElMessage } from 'element-plus'
  import { 
    Search, 
    User, 
    Star, 
    CollectionTag, 
    SwitchButton,
    HomeFilled,
    Menu,
    QuestionFilled,
    Expand,
    Fold,
    ChatDotRound
  } from '@element-plus/icons-vue'
  import { useAuthStore } from '@/stores/auth'
  import LoginDialog from '@/components/auth/LoginDialog.vue'
  
  const router = useRouter()
  const authStore = useAuthStore()
  
  const searchKeyword = ref('')
  const mobileMenuOpen = ref(false)
  const userMenuOpen = ref(false)
  const windowWidth = ref(window.innerWidth)
  const loginDialogVisible = ref(false)
  const loginMode = ref('login')
  
  const isMobile = computed(() => windowWidth.value <= 768)

  const toggleUserMenu = () => { userMenuOpen.value = !userMenuOpen.value }
  const closeUserMenu = () => { userMenuOpen.value = false }

  // v-click-outside 指令
  const vClickOutside = {
    mounted(el, binding) {
      el.__clickOutside__ = (e) => { if (!el.contains(e.target)) binding.value() }
      document.addEventListener('click', el.__clickOutside__)
    },
    unmounted(el) {
      document.removeEventListener('click', el.__clickOutside__)
      delete el.__clickOutside__
    }
  }
  
  const goHome = () => {
    router.push('/')
    closeMobileMenu()
  }
  
  const handleSearch = () => {
    if (searchKeyword.value.trim()) {
      router.push({
        path: '/category',
        query: { keyword: searchKeyword.value }
      })
      closeMobileMenu()
    }
  }
  
  const toggleMobileMenu = () => {
    mobileMenuOpen.value = !mobileMenuOpen.value
  }
  
  const closeMobileMenu = () => {
    mobileMenuOpen.value = false
  }
  
  const showLogin = () => {
    loginMode.value = 'login'
    loginDialogVisible.value = true
    closeMobileMenu()
    console.log('showLogin called, loginDialogVisible:', loginDialogVisible.value)
  }
  
  const showRegister = () => {
    loginMode.value = 'register'
    loginDialogVisible.value = true
    closeMobileMenu()
    console.log('showRegister called, loginDialogVisible:', loginDialogVisible.value)
  }
  
  const handleLoginSuccess = () => {
    ElMessage.success('欢迎回来！')
  }
  
  const handleUserCommand = (command) => {
    closeMobileMenu()
    closeUserMenu()
    
    switch (command) {
      case 'profile':
        router.push('/profile')
        break
      case 'favorites':
        router.push({ path: '/profile', query: { tab: 'favorites' } })
        break
      case 'likes':
        router.push({ path: '/profile', query: { tab: 'likes' } })
        break
      case 'logout':
        authStore.logout()
        ElMessage.success('已退出登录')
        break
    }
  }
  
  const handleResize = () => {
    windowWidth.value = window.innerWidth
    if (windowWidth.value > 768) {
      mobileMenuOpen.value = false
    }
  }
  
  onMounted(() => {
    window.addEventListener('resize', handleResize)
    window.addEventListener('show-login', showLogin)
  })
  
  onUnmounted(() => {
    window.removeEventListener('resize', handleResize)
    window.removeEventListener('show-login', showLogin)
  })
  </script>
  
  <style lang="scss" scoped>
  .app-header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    background: rgba(248, 244, 230, 0.95);
    backdrop-filter: blur(10px);
    border-bottom: 2px solid var(--border-color);
    z-index: 1000;
    box-shadow: var(--shadow-sm);
  }
  
  .header-top {
    height: 80px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 30px;
  }
  
  .logo-section {
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    transition: var(--transition);
    
    &:hover {
      opacity: 0.8;
    }
  }
  
  .logo-icon {
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
    color: #ffffff;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    font-weight: bold;
    letter-spacing: 2px;
    box-shadow: var(--shadow-sm);
    flex-shrink: 0;
  }
  
  .logo-text {
    display: flex;
    flex-direction: column;
    gap: 2px;
  }

  .site-title {
    font-size: 1.5rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
    letter-spacing: 0.08em;
    white-space: nowrap;
  }

  .site-slogan {
    font-size: 1rem;
    color: #000;
    margin: 0;
    font-family: 'STLiti', '隶书', 'LiSu', serif;
    width: 100%;
    text-align: justify;
    text-align-last: justify;
  }
  
  .desktop-actions {
    display: flex;
    align-items: center;
    gap: 30px;
    flex: 1;
  }
  
  .nav-menu {
    display: flex;
    gap: 30px;
  }
  
  .nav-item {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    color: var(--text-primary);
    font-size: 15px;
    font-weight: 500;
    border-radius: 6px;
    transition: var(--transition);
    white-space: nowrap;
    
    &:hover {
      background: var(--bg-dark);
      color: var(--primary-color);
    }
    
    &.router-link-active {
      background: var(--primary-color);
      color: #ffffff;
    }
  }
  
  .search-box {
    flex: 1;
    max-width: 300px;
    
    :deep(.el-input__wrapper) {
      border-radius: 20px;
    }
  }
  
  .user-section {
    display: flex;
    align-items: center;
    margin-left: 20px;
  }
  
  .auth-buttons {
    display: flex;
    gap: 12px;
  }
  
  .auth-btn {
    padding: 8px 24px;
    border: 2px solid var(--primary-color);
    border-radius: 20px;
    font-size: 14px;
    font-weight: 500;
    letter-spacing: 0.05em;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    
    &::before {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      width: 0;
      height: 0;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.3);
      transform: translate(-50%, -50%);
      transition: width 0.6s, height 0.6s;
    }
    
    &:hover::before {
      width: 300px;
      height: 300px;
    }
    
    &:active {
      transform: scale(0.95);
    }
  }
  
  .login-btn {
    background: transparent;
    color: var(--primary-color);
    
    &:hover {
      background: var(--primary-color);
      color: #ffffff;
      box-shadow: 0 4px 12px rgba(200, 48, 43, 0.3);
    }
  }
  
  .register-btn {
    background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
    color: #ffffff;
    border-color: transparent;
    box-shadow: 0 2px 8px rgba(200, 48, 43, 0.2);
    
    &:hover {
      box-shadow: 0 4px 16px rgba(200, 48, 43, 0.4);
      transform: translateY(-2px);
    }
    
    &:active {
      transform: translateY(0) scale(0.95);
    }
  }
  
  .user-dropdown-wrap {
    position: relative;
  }

  .user-info {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    padding: 5px 10px 5px 5px;
    border-radius: 24px;
    border: 1.5px solid transparent;
    transition: all 0.25s;

    &:hover, &.open {
      background: var(--bg-dark);
      border-color: var(--border-color);
    }

    .username {
      font-size: 14px;
      font-weight: 500;
      color: var(--text-primary);
      max-width: 90px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .arrow-icon {
      color: var(--text-light);
      transition: transform 0.25s;
      flex-shrink: 0;
      &.rotated { transform: rotate(180deg); }
    }

    :deep(.el-avatar) {
      background: #F5E6C8;
    }
  }

  // 下拉面板
  .user-panel {
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    width: 240px;
    background: var(--bg-light);
    border: 1px solid var(--border-color);
    border-radius: 16px;
    box-shadow: 0 12px 40px rgba(0,0,0,0.12);
    z-index: 999;
    overflow: hidden;
    animation: panel-in 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  @keyframes panel-in {
    from { opacity: 0; transform: translateY(-8px) scale(0.96); }
    to   { opacity: 1; transform: translateY(0) scale(1); }
  }

  .panel-header {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 18px 16px 14px;
    background: linear-gradient(135deg, rgba(200,48,43,0.06), rgba(200,48,43,0.02));
    border-bottom: 1px solid var(--border-color);

    .panel-avatar {
      border: 2px solid var(--primary-color);
      flex-shrink: 0;
      background: #F5E6C8;
    }

    .panel-user-info {
      flex: 1;
      min-width: 0;
    }

    .panel-username {
      font-size: 15px;
      font-weight: 600;
      color: var(--text-primary);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .panel-email {
      font-size: 12px;
      color: var(--text-light);
      margin-top: 2px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }

  .panel-menu {
    padding: 8px 0;
  }

  .panel-item {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 11px 16px;
    border: none;
    background: none;
    cursor: pointer;
    font-size: 14px;
    color: var(--text-primary);
    transition: all 0.18s;
    text-align: left;

    &:hover {
      background: var(--bg-dark);
      .panel-item-arrow { opacity: 1; transform: translateX(3px); }
    }

    .panel-item-icon {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;

      svg { width: 17px; height: 17px; }
    }

    .profile-icon { background: rgba(99,102,241,0.1); svg { fill: #6366f1; } }
    .fav-icon     { background: rgba(245,158,11,0.1);  svg { fill: #f59e0b; } }
    .like-icon    { background: rgba(232,62,62,0.1);   svg { fill: #e83e3e; } }
    .logout-icon  { background: rgba(107,114,128,0.1); svg { fill: #6b7280; } }

    .panel-item-text { flex: 1; font-weight: 500; }

    .panel-item-arrow {
      opacity: 0;
      transition: all 0.18s;
      color: var(--text-light);
    }

    &.logout-item {
      color: #e83e3e;
      .panel-item-text { color: #e83e3e; }
      &:hover { background: rgba(232,62,62,0.06); }
    }
  }

  .panel-divider {
    height: 1px;
    background: var(--border-color);
    margin: 4px 0;
  }
  
  .mobile-menu-btn {
    display: none;
    cursor: pointer;
    padding: 8px;
    color: var(--text-primary);
    transition: var(--transition);
    flex-shrink: 0;
    
    &:hover {
      color: var(--primary-color);
    }
    
    &:active {
      transform: scale(0.95);
    }
  }
  
  .mobile-menu-panel {
    max-height: 0;
    overflow-y: auto; // 允许在手机端滚动菜单内容
    transition: max-height 0.3s ease;
    background: var(--bg-light);
    border-top: 1px solid var(--border-color);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    
    &.active {
      max-height: 90vh; // 增加最大高度，确保显示完整
    }
    
    .nav-menu {
      flex-direction: column;
      gap: 0;
      padding: 10px 0;
    }
    
    .nav-item {
      width: 100%;
      padding: 15px 20px;
      border-radius: 0;
      justify-content: flex-start;
      
      &:hover {
        background: var(--bg-dark);
      }
    }
  }
  
  .mobile-search {
    padding: 15px 20px;
    border-top: 1px solid var(--border-color);
  }
  
  .mobile-user-section {
    padding: 15px 20px;
    border-top: 1px solid var(--border-color);
    background: var(--bg-dark);
  }
  
  .mobile-auth-buttons {
    display: flex;
    gap: 12px;
    
    .auth-btn {
      flex: 1;
      padding: 12px 20px;
      font-size: 15px;
    }
  }
  
  .mobile-user-info {
    .user-profile {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 15px;
      padding-bottom: 15px;
      border-bottom: 1px solid var(--border-color);

      :deep(.el-avatar) {
        background: #F5E6C8;
      }

      .user-details {
        flex: 1;

        .username {
          font-size: 16px;
          font-weight: 600;
          color: var(--text-primary);
          margin-bottom: 4px;
        }

        .user-email {
          font-size: 12px;
          color: var(--text-secondary);
        }
      }
    }
    
    .user-actions {
      display: flex;
      flex-direction: column;
      gap: 5px;
      
      .el-button {
        justify-content: flex-start;
        padding: 10px 12px;
        
        .el-icon {
          margin-right: 8px;
        }
      }
    }
  }
  
  // 响应式设计
  @media (max-width: 768px) {
    .header-top {
      height: 60px;
      padding: 0 15px;
    }
    
    .logo-icon {
      width: 40px;
      height: 40px;
      font-size: 16px;
    }
    
    .site-title {
      font-size: 1.1rem;
    }
    
    .desktop-actions {
      display: none;
    }
    
    .mobile-menu-btn {
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
  
  @media (max-width: 480px) {
    .site-title {
      font-size: 1rem;
    }
    
    .logo-icon {
      width: 36px;
      height: 36px;
      font-size: 14px;
    }
  }
  </style>
  