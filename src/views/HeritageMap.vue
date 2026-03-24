<template>
  <div class="heritage-map-page">
    <!-- 页头 -->
    <section class="hm-hero">
      <div class="hm-hero-bg"></div>
      <div class="container hm-hero-content">
        <div class="hm-hero-tag">HERITAGE MAP</div>
        <h1 class="hm-hero-title">非遗地图</h1>
        <p class="hm-hero-sub">探索中华大地上非物质文化遗产的地域分布与传承脉络</p>
      </div>
    </section>

    <div class="container hm-main">
      <!-- 左侧：省份列表 -->
      <aside class="hm-sidebar">
        <div class="hm-sidebar-title">按地区查找</div>
        <div class="hm-region-list">
          <div
            v-for="region in regions"
            :key="region.name"
            class="hm-region-item"
            :class="{ active: activeRegion === region.name }"
            @click="activeRegion = region.name"
          >
            <span class="hm-region-name">{{ region.name }}</span>
            <span class="hm-region-count">{{ region.count }}</span>
          </div>
        </div>
      </aside>

      <!-- 右侧：内容区 -->
      <div class="hm-content">
        <!-- 地图占位 -->
        <div class="hm-map-wrap">
          <div class="hm-map-placeholder">
            <div class="hm-map-svg-wrap">
              <!-- 简化地图装饰 SVG -->
              <svg viewBox="0 0 600 440" class="hm-map-svg" xmlns="http://www.w3.org/2000/svg">
                <rect width="600" height="440" fill="none"/>
                <!-- 装饰网格线 -->
                <g stroke="#c8b99a" stroke-width="0.5" opacity="0.4">
                  <line v-for="i in 10" :key="'h'+i" :x1="0" :y1="i*44" :x2="600" :y2="i*44"/>
                  <line v-for="i in 12" :key="'v'+i" :x1="i*50" :y1="0" :x2="i*50" :y2="440"/>
                </g>
                <!-- 热点标记 -->
                <g v-for="dot in mapDots" :key="dot.name">
                  <circle :cx="dot.x" :cy="dot.y" :r="dot.r" :fill="dot.color" opacity="0.3"/>
                  <circle :cx="dot.x" :cy="dot.y" r="5" :fill="dot.color"/>
                  <text :x="dot.x+8" :y="dot.y+4" font-size="11" fill="#5a3a1a" font-family="sans-serif">{{ dot.name }}</text>
                </g>
              </svg>
              <div class="hm-map-tip">
                <span>🗺️</span>
                <p>交互式地图即将上线<br>当前展示非遗项目分布示意图</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 当前地区非遗列表 -->
        <div class="hm-items-section">
          <h3 class="hm-items-title">
            {{ activeRegion }} · 代表性非遗项目
            <span class="hm-items-count">共 {{ currentRegionData.count }} 项</span>
          </h3>
          <div class="hm-items-grid">
            <div
              v-for="item in currentItems"
              :key="item.name"
              class="hm-item-card"
            >
              <div class="hm-item-icon">{{ item.icon }}</div>
              <div class="hm-item-body">
                <span class="hm-item-name">{{ item.name }}</span>
                <span class="hm-item-level" :class="item.levelClass">{{ item.level }}</span>
              </div>
              <span class="hm-item-type">{{ item.type }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部分类统计 -->
    <section class="hm-stats container">
      <h2 class="hm-stats-title">全国非遗分类统计</h2>
      <div class="hm-stats-grid">
        <div class="hm-stat-bar" v-for="cat in categoryStats" :key="cat.name">
          <div class="hm-stat-bar-header">
            <span class="hm-stat-icon">{{ cat.icon }}</span>
            <span class="hm-stat-name">{{ cat.name }}</span>
            <span class="hm-stat-val">{{ cat.count }}</span>
          </div>
          <div class="hm-stat-track">
            <div class="hm-stat-fill" :style="{ width: cat.pct + '%', background: cat.color }"></div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const activeRegion = ref('浙江')

const regions = [
  { name: '浙江', count: 217 },
  { name: '江苏', count: 189 },
  { name: '四川', count: 163 },
  { name: '广东', count: 158 },
  { name: '北京', count: 142 },
  { name: '山东', count: 138 },
  { name: '云南', count: 201 },
  { name: '陕西', count: 127 },
  { name: '湖南', count: 145 },
  { name: '河南', count: 122 },
  { name: '福建', count: 116 },
  { name: '贵州', count: 178 }
]

const regionItems = {
  浙江: [
    { name: '龙泉青瓷', level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🏺' },
    { name: '越剧',     level: '国家级', levelClass: 'national', type: '传统戏剧', icon: '🎭' },
    { name: '西湖绸伞', level: '国家级', levelClass: 'national', type: '传统技艺', icon: '☂️' },
    { name: '泥金彩漆', level: '省级',   levelClass: 'province', type: '传统美术', icon: '🎨' },
    { name: '嵊州竹编', level: '省级',   levelClass: 'province', type: '传统技艺', icon: '🎋' },
    { name: '余杭滚灯', level: '国家级', levelClass: 'national', type: '民俗',     icon: '🏮' }
  ],
  江苏: [
    { name: '苏绣',     level: '国家级', levelClass: 'national', type: '传统美术', icon: '🧵' },
    { name: '昆曲',     level: '国家级', levelClass: 'national', type: '传统戏剧', icon: '🎭' },
    { name: '扬州漆器', level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🪬' },
    { name: '宜兴紫砂', level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🫖' },
    { name: '云锦',     level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🧶' },
    { name: '扬州剪纸', level: '国家级', levelClass: 'national', type: '传统美术', icon: '✂️' }
  ],
  云南: [
    { name: '傣族织锦',   level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🧵' },
    { name: '白族扎染',   level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🎨' },
    { name: '纳西古乐',   level: '国家级', levelClass: 'national', type: '传统音乐', icon: '🎵' },
    { name: '傣族孔雀舞', level: '国家级', levelClass: 'national', type: '传统舞蹈', icon: '🦚' },
    { name: '彝族刺绣',   level: '省级',   levelClass: 'province', type: '传统美术', icon: '🧶' },
    { name: '藏族唐卡',   level: '国家级', levelClass: 'national', type: '传统美术', icon: '🖼️' }
  ]
}

const defaultItems = [
  { name: '传统技艺代表', level: '国家级', levelClass: 'national', type: '传统技艺', icon: '🏺' },
  { name: '传统戏曲艺术', level: '省级',   levelClass: 'province', type: '传统戏剧', icon: '🎭' },
  { name: '民间音乐',     level: '省级',   levelClass: 'province', type: '传统音乐', icon: '🎵' },
  { name: '传统舞蹈',     level: '市级',   levelClass: 'city',     type: '传统舞蹈', icon: '💃' }
]

const currentRegionData = computed(() =>
  regions.find(r => r.name === activeRegion.value) || { count: 0 }
)

const currentItems = computed(() =>
  regionItems[activeRegion.value] || defaultItems
)

const mapDots = [
  { name: '北京', x: 360, y: 100, r: 20, color: '#e67e22' },
  { name: '浙江', x: 420, y: 230, r: 25, color: '#c0392b' },
  { name: '江苏', x: 400, y: 195, r: 22, color: '#8e44ad' },
  { name: '四川', x: 240, y: 240, r: 20, color: '#27ae60' },
  { name: '云南', x: 220, y: 310, r: 24, color: '#2980b9' },
  { name: '山东', x: 390, y: 150, r: 18, color: '#d35400' },
  { name: '广东', x: 360, y: 310, r: 20, color: '#16a085' },
  { name: '陕西', x: 300, y: 185, r: 16, color: '#8b6914' }
]

const categoryStats = [
  { name: '传统技艺', count: 1557, pct: 92, icon: '⚒️', color: '#e67e22' },
  { name: '传统美术', count: 987,  pct: 58, icon: '🎨', color: '#8e44ad' },
  { name: '民间文学', count: 856,  pct: 51, icon: '📖', color: '#2980b9' },
  { name: '传统音乐', count: 743,  pct: 44, icon: '🎵', color: '#27ae60' },
  { name: '传统戏剧', count: 698,  pct: 41, icon: '🎭', color: '#c0392b' },
  { name: '民俗',     count: 634,  pct: 38, icon: '🏮', color: '#d35400' },
  { name: '传统舞蹈', count: 521,  pct: 31, icon: '💃', color: '#16a085' },
  { name: '传统体育', count: 368,  pct: 22, icon: '🥋', color: '#7f8c8d' }
]
</script>

<style scoped lang="scss">
.heritage-map-page {
  background: #f5f3ee;
  min-height: 100vh;
  padding-bottom: 60px;
}

// 页头
.hm-hero {
  position: relative;
  height: 280px;
  display: flex;
  align-items: center;
  overflow: hidden;
}

.hm-hero-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #0d2137 0%, #1a3a5c 45%, #2d6a4f 100%);

  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background-image:
      radial-gradient(circle at 20% 50%, rgba(255,255,255,0.04) 0%, transparent 40%),
      radial-gradient(circle at 80% 30%, rgba(255,255,255,0.03) 0%, transparent 40%);
  }
}

.hm-hero-content {
  position: relative;
  z-index: 1;
  color: #fff;
}

.hm-hero-tag {
  font-size: 0.72rem;
  letter-spacing: 4px;
  color: rgba(255,255,255,0.55);
  margin-bottom: 10px;
}

.hm-hero-title {
  font-size: 2.6rem;
  font-weight: 700;
  margin: 0 0 12px;
  letter-spacing: 0.1em;
}

.hm-hero-sub {
  font-size: 1rem;
  color: rgba(255,255,255,0.7);
  margin: 0;
}

// 主体布局
.hm-main {
  display: grid;
  grid-template-columns: 180px 1fr;
  gap: 20px;
  padding-top: 28px;
}

// 侧边栏
.hm-sidebar {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
  height: fit-content;
  position: sticky;
  top: 80px;
}

.hm-sidebar-title {
  font-size: 0.8rem;
  font-weight: 600;
  color: #999;
  letter-spacing: 1px;
  margin-bottom: 12px;
  text-transform: uppercase;
}

.hm-region-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 10px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 2px;

  &:hover { background: #f5f0eb; }

  &.active {
    background: #8b3a0f;
    .hm-region-name { color: #fff; }
    .hm-region-count { background: rgba(255,255,255,0.25); color: #fff; }
  }
}

.hm-region-name {
  font-size: 0.88rem;
  color: #333;
}

.hm-region-count {
  font-size: 0.7rem;
  background: #f0ece6;
  color: #888;
  padding: 1px 7px;
  border-radius: 999px;
}

// 地图区域
.hm-content { min-width: 0; }

.hm-map-wrap {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
  margin-bottom: 20px;
}

.hm-map-placeholder {
  position: relative;
  height: 300px;
  background: linear-gradient(135deg, #e8f4e8 0%, #e8eef4 50%, #f4e8e8 100%);
  display: flex;
  align-items: center;
  justify-content: center;
}

.hm-map-svg-wrap {
  position: relative;
  width: 100%;
  height: 100%;
}

.hm-map-svg {
  width: 100%;
  height: 100%;
}

.hm-map-tip {
  position: absolute;
  bottom: 16px;
  right: 16px;
  background: rgba(255,255,255,0.9);
  border-radius: 8px;
  padding: 10px 14px;
  text-align: center;
  font-size: 0.75rem;
  color: #888;
  line-height: 1.5;
  backdrop-filter: blur(4px);

  span { font-size: 1.4rem; display: block; margin-bottom: 4px; }
  p { margin: 0; }
}

// 非遗列表
.hm-items-section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}

.hm-items-title {
  font-size: 1rem;
  font-weight: 600;
  color: #333;
  margin: 0 0 16px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.hm-items-count {
  font-size: 0.75rem;
  font-weight: 400;
  color: #aaa;
}

.hm-items-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
}

.hm-item-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px;
  background: #faf8f5;
  border-radius: 8px;
  border: 1px solid #f0ece6;
  transition: border-color 0.2s;

  &:hover { border-color: #8b3a0f; }
}

.hm-item-icon { font-size: 1.4rem; flex-shrink: 0; }

.hm-item-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.hm-item-name {
  font-size: 0.88rem;
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.hm-item-level {
  font-size: 0.68rem;
  padding: 1px 7px;
  border-radius: 999px;
  width: fit-content;

  &.national { background: rgba(192,57,43,0.1);  color: #c0392b; }
  &.province { background: rgba(41,128,185,0.1); color: #2980b9; }
  &.city     { background: rgba(39,174,96,0.1);  color: #27ae60; }
}

.hm-item-type {
  font-size: 0.68rem;
  color: #bbb;
  white-space: nowrap;
}

// 统计图
.hm-stats {
  padding: 32px 0 0;
}

.hm-stats-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin: 0 0 20px;
}

.hm-stats-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}

.hm-stat-bar { }

.hm-stat-bar-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}

.hm-stat-icon { font-size: 1rem; }

.hm-stat-name {
  flex: 1;
  font-size: 0.85rem;
  color: #444;
}

.hm-stat-val {
  font-size: 0.82rem;
  font-weight: 600;
  color: #555;
}

.hm-stat-track {
  height: 6px;
  background: #f0ece6;
  border-radius: 999px;
  overflow: hidden;
}

.hm-stat-fill {
  height: 100%;
  border-radius: 999px;
  transition: width 0.8s ease;
}

// 响应式
@media (max-width: 768px) {
  .hm-hero { height: 200px; }
  .hm-hero-title { font-size: 1.8rem; }

  .hm-main {
    grid-template-columns: 1fr;
    padding-top: 16px;
  }

  .hm-sidebar {
    position: static;
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    padding: 12px;
  }

  .hm-sidebar-title { width: 100%; margin-bottom: 4px; }

  .hm-region-item {
    padding: 5px 12px;
    margin: 0;
    border: 1px solid #e0dbd4;
    flex-direction: row;
    gap: 6px;
  }

  .hm-items-grid { grid-template-columns: 1fr 1fr; }
  .hm-stats-grid { grid-template-columns: 1fr; }
}
</style>
