<template>
  <transition name="fade-screen">
    <div v-if="visible" class="splash-screen">
      <!-- 动态背景：水墨晕染效果 -->
      <div class="ink-blobs">
        <div class="blob one"></div>
        <div class="blob two"></div>
        <div class="blob three"></div>
      </div>

      <!-- 装饰元素 -->
      <div class="decoration top-left"></div>
      <div class="decoration bottom-right"></div>

      <!-- 内容区域 -->
      <div class="content">
        <div class="title-container">
          <h1 class="main-title">
            <span class="word">非</span>
            <span class="word">遗</span>
            <span class="word">数</span>
            <span class="word">字</span>
          </h1>
          <div class="divider"></div>
          <h2 class="sub-title">你我共赏</h2>
        </div>
        <div class="footer-mark">传承 · 数字化 · 创新</div>
      </div>

      <!-- 跳过按钮 -->
      <div class="skip-btn" @click="skip">
        跳过 <span>{{ timeLeft }}s</span>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const visible = ref(true)
const timeLeft = ref(5)
let timer = null

const skip = () => {
  visible.value = false
  if (timer) clearInterval(timer)
}

onMounted(() => {
  timer = setInterval(() => {
    timeLeft.value--
    if (timeLeft.value <= 0) {
      skip()
    }
  }, 1000)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>

<style lang="scss" scoped>
.splash-screen {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: #fdfaf2; // 宣纸色
  z-index: 9999;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  font-family: "STKaiti", "KaiTi", serif;
}

// 跳过按钮
.skip-btn {
  position: absolute;
  top: env(safe-area-inset-top, 20px);
  right: 20px;
  background: rgba(0, 0, 0, 0.4);
  color: white;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 13px;
  backdrop-filter: blur(5px);
  z-index: 100;
  display: flex;
  align-items: center;
  gap: 4px;
  
  span {
    font-weight: bold;
    color: #ffd700;
  }
}

// 水墨背景动画
.ink-blobs {
  position: absolute;
  width: 100%;
  height: 100%;
  filter: blur(40px);
  opacity: 0.4;
  
  .blob {
    position: absolute;
    border-radius: 50%;
    background: #c8302b;
    animation: move 10s infinite alternate;
  }
  
  .one { width: 300px; height: 300px; top: -50px; left: -50px; background: #c8302b; opacity: 0.6; }
  .two { width: 400px; height: 400px; bottom: -100px; right: -50px; background: #3d4e5c; opacity: 0.3; animation-delay: -2s; }
  .three { width: 250px; height: 250px; top: 40%; left: 60%; background: #d4af37; opacity: 0.2; animation-delay: -5s; }
}

@keyframes move {
  from { transform: translate(0, 0) scale(1); }
  to { transform: translate(50px, 50px) scale(1.1); }
}

// 内容动画
.content {
  position: relative;
  z-index: 10;
  text-align: center;
}

.title-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.main-title {
  font-size: 3.5rem;
  color: #1a1a1a;
  margin: 0;
  display: flex;
  gap: 15px;
  
  .word {
    opacity: 0;
    transform: translateY(30px);
    animation: fadeInUp 0.8s forwards;
    
    @for $i from 1 through 4 {
      &:nth-child(#{$i}) { animation-delay: #{$i * 0.2}s; }
    }
  }
}

.divider {
  width: 40px;
  height: 4px;
  background: #c8302b;
  margin: 25px 0;
  opacity: 0;
  animation: scaleX 0.6s 1.2s forwards;
}

.sub-title {
  font-size: 2.2rem;
  color: #c8302b;
  letter-spacing: 8px;
  margin-left: 8px; // 补偿字间距
  opacity: 0;
  animation: fadeIn 1s 1.5s forwards;
}

.footer-mark {
  position: absolute;
  bottom: -150px;
  left: 50%;
  transform: translateX(-50%);
  width: 100%;
  font-size: 0.9rem;
  color: #888;
  letter-spacing: 4px;
  opacity: 0;
  animation: fadeIn 1s 2s forwards;
}

// 动画定义
@keyframes fadeInUp {
  to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeIn {
  to { opacity: 1; }
}
@keyframes scaleX {
  from { transform: scaleX(0); }
  to { opacity: 1; transform: scaleX(1); }
}

// 过渡效果
.fade-screen-leave-active {
  transition: all 0.8s cubic-bezier(0.645, 0.045, 0.355, 1);
}
.fade-screen-leave-to {
  opacity: 0;
  transform: scale(1.1);
}

.decoration {
  position: absolute;
  width: 150px;
  height: 150px;
  border: 1px solid rgba(200, 48, 43, 0.1);
  pointer-events: none;
  
  &.top-left {
    top: 40px;
    left: 40px;
    border-right: none;
    border-bottom: none;
  }
  
  &.bottom-right {
    bottom: 40px;
    right: 40px;
    border-left: none;
    border-top: none;
  }
}
</style>
