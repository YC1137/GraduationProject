<template>
    <el-dialog
      v-model="visible"
      :title="isLogin ? '登录' : '注册'"
      width="440px"
      :close-on-click-modal="false"
      append-to-body
      class="auth-dialog"
      align-center
    >
      <!-- 添加装饰元素 -->
      <div class="dialog-decoration">
        <div class="decoration-left"></div>
        <div class="decoration-right"></div>
      </div>
      
      <el-form
        ref="formRef"
        :model="formData"
        :rules="rules"
        label-width="0"
        @submit.prevent="handleSubmit"
      >
        <el-form-item prop="username">
          <el-input
            v-model="formData.username"
            placeholder="用户名"
            size="large"
            :prefix-icon="User"
            clearable
          />
        </el-form-item>
        
        <el-form-item v-if="!isLogin" prop="nickname">
          <el-input
            v-model="formData.nickname"
            placeholder="昵称（选填，评论时显示此名称）"
            size="large"
            :prefix-icon="EditPen"
            clearable
          />
        </el-form-item>

        <el-form-item v-if="!isLogin" prop="email">
          <el-input
            v-model="formData.email"
            placeholder="邮箱（选填）"
            size="large"
            :prefix-icon="Message"
            clearable
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="formData.password"
            type="password"
            placeholder="密码"
            size="large"
            :prefix-icon="Lock"
            show-password
            clearable
          />
        </el-form-item>
        
        <el-form-item v-if="!isLogin" prop="confirmPassword">
          <el-input
            v-model="formData.confirmPassword"
            type="password"
            placeholder="确认密码"
            size="large"
            :prefix-icon="Lock"
            show-password
            clearable
          />
        </el-form-item>

        <!-- 图形验证码 -->
        <el-form-item>
          <div class="verify-row">
            <el-input
              v-model="inputCode"
              placeholder="请输入验证码"
              size="large"
              clearable
              class="verify-input"
              @keyup.enter="handleSubmit"
            />
            <VerifyCode ref="verifyCodeRef" v-model:code="realCode" :width="110" :height="40" />
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button 
            type="primary" 
            size="large" 
            @click="handleSubmit"
            :loading="loading"
            style="width: 100%"
          >
            {{ isLogin ? '登录' : '注册' }}
          </el-button>
          
          <div class="switch-mode">
            <span v-if="isLogin">还没有账号？</span>
            <span v-else>已有账号？</span>
            <el-link 
              type="primary" 
              underline="never"
              @click="toggleMode"
            >
              {{ isLogin ? '立即注册' : '去登录' }}
            </el-link>
          </div>
        </div>
      </template>
    </el-dialog>
  </template>
  
  <script setup>
  import { ref, reactive, watch, computed } from 'vue'
  import { ElMessage } from 'element-plus'
  import { User, Lock, Message, EditPen } from '@element-plus/icons-vue'
  import { useAuthStore } from '@/stores/auth'
  import VerifyCode from './VerifyCode.vue'
  
  const props = defineProps({
    modelValue: {
      type: Boolean,
      default: false
    },
    defaultMode: {
      type: String,
      default: 'login' // 'login' or 'register'
    }
  })
  
  const emit = defineEmits(['update:modelValue', 'success'])
  
  const authStore = useAuthStore()
  const formRef = ref(null)
  const loading = ref(false)
  const isLogin = ref(props.defaultMode === 'login')

  // 验证码
  const verifyCodeRef = ref(null)
  const realCode = ref('')       // canvas 生成的真实验证码
  const inputCode = ref('')      // 用户输入的验证码
  
  // 使用 computed 来同步 visible
  const visible = computed({
    get: () => props.modelValue,
    set: (val) => emit('update:modelValue', val)
  })
  
  // 表单数据
  const formData = reactive({
    username: '',
    nickname: '',
    email: '',
    password: '',
    confirmPassword: ''
  })
  
  // 表单验证规则
  const rules = reactive({
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
    ],
    email: [
      { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, message: '密码长度不能少于 6 个字符', trigger: 'blur' }
    ],
    confirmPassword: [
      { required: true, message: '请确认密码', trigger: 'blur' },
      {
        validator: (rule, value, callback) => {
          if (value !== formData.password) {
            callback(new Error('两次输入的密码不一致'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ]
  })
  
  // 监听 defaultMode 变化
  watch(() => props.defaultMode, (val) => {
    isLogin.value = val === 'login'
  })

  // 监听对话框关闭时重置表单
  watch(visible, (val) => {
    if (!val) {
      resetForm()
    }
  })
  
  // 切换登录/注册模式
  const toggleMode = () => {
    isLogin.value = !isLogin.value
    resetForm()
  }
  
  // 重置表单
  const resetForm = () => {
    formRef.value?.resetFields()
    formData.username = ''
    formData.nickname = ''
    formData.email = ''
    formData.password = ''
    formData.confirmPassword = ''
    inputCode.value = ''
    verifyCodeRef.value?.refresh()
  }
  
  // 提交表单
  const handleSubmit = async () => {
    if (!formRef.value) return

    // validate() 验证失败时会 throw，需要 try-catch 捕获
    try {
      await formRef.value.validate()
    } catch {
      return  // 表单校验不通过，element-plus 已自动显示错误提示
    }

    // 验证码校验（不区分大小写）
    if (inputCode.value.trim().toLowerCase() !== realCode.value.toLowerCase()) {
      ElMessage.error('验证码错误，请重新输入')
      inputCode.value = ''
      verifyCodeRef.value?.refresh()
      return
    }
    
    loading.value = true
    
    try {
      if (isLogin.value) {
        // 登录逻辑
        const success = await authStore.login({
          username: formData.username,
          password: formData.password
        })
        if (success) {
          // 成功消息已在 authStore 中显示，这里不需要重复显示
          visible.value = false
          emit('success', true)
        } else {
          verifyCodeRef.value?.refresh()
          inputCode.value = ''
        }
      } else {
        // 注册逻辑
        const success = await authStore.register({
          username: formData.username,
          nickname: formData.nickname,
          email: formData.email,
          password: formData.password
        })
        if (success) {
          // 成功消息已在 authStore 中显示，这里不需要重复显示
          visible.value = false
          emit('success', false)
        } else {
          verifyCodeRef.value?.refresh()
          inputCode.value = ''
        }
      }
    } catch (error) {
      // 错误消息已在 authStore 中显示，这里不需要重复显示
      verifyCodeRef.value?.refresh()
      inputCode.value = ''
    } finally {
      loading.value = false
    }
  }
  </script>
  
  <style lang="scss" scoped>
  .auth-dialog {
    :deep(.el-dialog) {
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 12px 48px rgba(200, 48, 43, 0.15);
      background: linear-gradient(to bottom, var(--bg-light), var(--bg-color));
      position: relative;
    }
    
    :deep(.el-dialog__header) {
      text-align: center;
      border-bottom: 2px solid var(--border-color);
      padding: 30px 40px 20px;
      margin: 0;
      background: var(--bg-light);
      position: relative;
      
      &::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 50%;
        transform: translateX(-50%);
        width: 60px;
        height: 4px;
        background: linear-gradient(to right, var(--primary-color), var(--primary-light));
        border-radius: 2px;
      }
    }
    
    :deep(.el-dialog__title) {
      font-size: 1.8rem;
      font-weight: 600;
      color: var(--text-primary);
      letter-spacing: 0.1em;
      position: relative;
      
      &::before {
        content: '◆';
        color: var(--primary-color);
        margin-right: 12px;
        font-size: 0.8em;
      }
      
      &::after {
        content: '◆';
        color: var(--primary-color);
        margin-left: 12px;
        font-size: 0.8em;
      }
    }
    
    :deep(.el-dialog__headerbtn) {
      top: 20px;
      right: 20px;
      width: 36px;
      height: 36px;
      border-radius: 50%;
      transition: all 0.3s ease;
      
      &:hover {
        background: rgba(200, 48, 43, 0.1);
        
        .el-dialog__close {
          color: var(--primary-color);
        }
      }
      
      .el-dialog__close {
        font-size: 20px;
        font-weight: bold;
        transition: all 0.3s ease;
      }
    }
    
    :deep(.el-dialog__body) {
      padding: 40px 40px 30px;
      background: var(--bg-color);
    }
    
    :deep(.el-form-item) {
      margin-bottom: 24px;
    }
    
    :deep(.el-input) {
      .el-input__wrapper {
        padding: 14px 18px;
        border-radius: 10px;
        box-shadow: 0 0 0 1px var(--border-color) inset;
        background: var(--bg-light);
        transition: all 0.3s ease;
        
        &:hover {
          box-shadow: 0 0 0 1px var(--primary-light) inset;
        }
        
        &.is-focus {
          box-shadow: 0 0 0 2px var(--primary-color) inset;
          background: #fffcf0;
        }
      }
      
      .el-input__inner {
        font-size: 15px;
        color: var(--text-primary);
        font-family: 'Garamond', 'Times New Roman', serif;
        font-weight: 600;
        
        &::placeholder {
          color: var(--text-light);
          font-family: "Source Han Serif SC", "Noto Serif SC", "STSong", "SimSun", serif;
          font-weight: normal;
        }
      }
      
      .el-input__prefix {
        color: var(--secondary-color);
        font-size: 18px;
      }
    }
    
    // 移除默认的 focus 蓝色边框
    :deep(.el-input__wrapper.is-focus) {
      box-shadow: 0 0 0 2px var(--primary-color) inset !important;
    }
    
    // 移除浏览器默认的 outline
    :deep(.el-input__inner:focus) {
      outline: none;
    }
    
    :deep(.el-input__inner:focus-visible) {
      outline: none;
    }
    
    :deep(.el-form-item__error) {
      font-size: 13px;
      padding-top: 4px;
    }
  }
  
  .dialog-decoration {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 100%;
    pointer-events: none;
    overflow: hidden;
    z-index: 0;
    
    .decoration-left {
      position: absolute;
      top: -50px;
      left: -50px;
      width: 150px;
      height: 150px;
      background: radial-gradient(circle, rgba(200, 48, 43, 0.05) 0%, transparent 70%);
      border-radius: 50%;
    }
    
    .decoration-right {
      position: absolute;
      bottom: -50px;
      right: -50px;
      width: 150px;
      height: 150px;
      background: radial-gradient(circle, rgba(61, 78, 92, 0.05) 0%, transparent 70%);
      border-radius: 50%;
    }
  }
  
  .verify-row {
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;

    .verify-input {
      flex: 1;
    }
  }

  .dialog-footer {
    padding: 0 40px 40px;
    position: relative;
    z-index: 1;
    
    :deep(.el-button) {
      width: 100%;
      height: 48px;
      border-radius: 24px;
      font-size: 16px;
      font-weight: 600;
      letter-spacing: 0.1em;
      border: none;
      background: linear-gradient(135deg, var(--primary-color), var(--primary-light));
      box-shadow: 0 4px 12px rgba(200, 48, 43, 0.3);
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
      
      &:hover {
        box-shadow: 0 6px 20px rgba(200, 48, 43, 0.4);
        transform: translateY(-2px);
        
        &::before {
          width: 400px;
          height: 400px;
        }
      }
      
      &:active {
        transform: translateY(0);
      }
    }
    
    .switch-mode {
      margin-top: 24px;
      text-align: center;
      font-size: 14px;
      color: var(--text-secondary);
      
      span {
        margin-right: 8px;
      }
      
      :deep(.el-link) {
        font-weight: 600;
        font-size: 14px;
        color: var(--primary-color);
        transition: all 0.3s ease;
        
        &:hover {
          color: var(--primary-light);
          transform: translateX(2px);
        }
      }
    }
  }
  
  @media (max-width: 768px) {
    .auth-dialog {
      :deep(.el-dialog) {
        width: 90% !important;
        margin: 0 auto;
        border-radius: 12px;
      }
      
      :deep(.el-dialog__header) {
        padding: 24px 20px 16px;
      }
      
      :deep(.el-dialog__title) {
        font-size: 1.4rem;
      }
      
      :deep(.el-dialog__body) {
        padding: 30px 20px 20px;
      }
    }
    
    .dialog-footer {
      padding: 0 20px 30px;
      
      :deep(.el-button) {
        height: 44px;
        font-size: 15px;
      }
    }
  }
  </style>
  