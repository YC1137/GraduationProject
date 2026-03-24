<template>
  <canvas
    ref="canvasRef"
    :width="width"
    :height="height"
    class="verify-canvas"
    :title="'点击刷新验证码'"
    @click="refresh"
  />
</template>

<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps({
  width:  { type: Number, default: 110 },
  height: { type: Number, default: 40 },
  length: { type: Number, default: 4 }
})

const emit = defineEmits(['update:code'])

const canvasRef = ref(null)
const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789'

function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min
}
function randomColor(min, max) {
  return `rgb(${randomInt(min,max)},${randomInt(min,max)},${randomInt(min,max)})`
}

function draw() {
  const canvas = canvasRef.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  const { width, height, length } = props

  // 背景
  ctx.fillStyle = '#f5f0e8'
  ctx.fillRect(0, 0, width, height)

  // 生成随机字符
  let code = ''
  for (let i = 0; i < length; i++) {
    code += chars[randomInt(0, chars.length - 1)]
  }

  // 绘制干扰线
  for (let i = 0; i < 4; i++) {
    ctx.strokeStyle = randomColor(150, 220)
    ctx.lineWidth = 1
    ctx.beginPath()
    ctx.moveTo(randomInt(0, width), randomInt(0, height))
    ctx.lineTo(randomInt(0, width), randomInt(0, height))
    ctx.stroke()
  }

  // 绘制干扰点
  for (let i = 0; i < 30; i++) {
    ctx.fillStyle = randomColor(150, 220)
    ctx.beginPath()
    ctx.arc(randomInt(0, width), randomInt(0, height), 1, 0, Math.PI * 2)
    ctx.fill()
  }

  // 绘制字符
  const charWidth = width / (length + 1)
  for (let i = 0; i < length; i++) {
    ctx.font = `bold ${randomInt(22, 28)}px Arial`
    ctx.fillStyle = randomColor(20, 120)
    ctx.save()
    const x = charWidth * (i + 0.8)
    const y = height / 2 + randomInt(-4, 4)
    ctx.translate(x, y)
    ctx.rotate((randomInt(-25, 25) * Math.PI) / 180)
    ctx.fillText(code[i], 0, 8)
    ctx.restore()
  }

  emit('update:code', code)
}

function refresh() {
  draw()
}

onMounted(() => draw())

defineExpose({ refresh })
</script>

<style scoped>
.verify-canvas {
  cursor: pointer;
  border-radius: 6px;
  border: 1px solid #e0d8cc;
  display: block;
  transition: opacity 0.2s;
  flex-shrink: 0;
}
.verify-canvas:hover {
  opacity: 0.85;
}
</style>
