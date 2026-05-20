<template>
  <div class="heritage-map-page">
    <!-- 页头 -->
    <section class="hm-hero">
      <div class="hm-hero-bg"></div>
      <div class="hm-hero-decor-left"></div>
      <div class="hm-hero-decor-right"></div>
      <div class="container hm-hero-content">
        <div class="hm-hero-badge">地域传承</div>
        <h1 class="hm-hero-title">非遗地图</h1>
        <div class="hm-hero-divider"><span></span><span class="dot"></span><span></span></div>
        <p class="hm-hero-sub">探索中华大地上非物质文化遗产的地域分布与传承脉络</p>
      </div>
    </section>

    <div class="container hm-main">
      <!-- 左侧：省份列表 -->
      <aside class="hm-sidebar">
        <div class="hm-sidebar-title">按地区查找</div>
        <div class="hm-region-list">
          <div
            v-for="region in allRegions"
            :key="region.name"
            class="hm-region-item"
            :class="{
              active: activeRegion === region.name,
              'no-data': !regionCountMap[REGION_NAME_MAP[region.name] || region.name]
            }"
            @click="selectRegion(region.name)"
          >
            <span class="hm-region-name">{{ region.name }}</span>
            <span class="hm-region-count" :class="{ 'has-data': (regionCountMap[REGION_NAME_MAP[region.name] || region.name] || 0) > 0 }">
              {{ regionCountMap[REGION_NAME_MAP[region.name] || region.name] || 0 }}
            </span>
          </div>
        </div>
      </aside>

      <!-- 右侧：内容区 -->
      <div class="hm-content">
        <!-- ECharts 中国地图 -->
        <div class="hm-map-wrap">
          <div ref="mapRef" class="hm-map-canvas"></div>
        </div>

        <!-- 当前地区非遗列表 -->
        <div class="hm-items-section">
          <div class="hm-items-header">
            <h3 class="hm-items-title">
              <span class="region-badge">{{ activeRegion || '请选择地区' }}</span>
              <template v-if="activeRegion">代表性非遗项目</template>
            </h3>
            <span v-if="activeRegion" class="hm-items-count">共 {{ regionItems.length }} 项</span>
          </div>

          <div v-if="!activeRegion" class="hm-empty">
            <el-empty description="请点击地图或左侧列表选择地区" :image-size="80" />
          </div>

          <div v-else-if="itemsLoading" class="hm-loading">
            <el-skeleton :rows="3" animated />
          </div>

          <div v-else-if="regionItems.length === 0" class="hm-empty">
            <el-empty description="暂无该地区非遗数据" :image-size="80" />
          </div>

          <div v-else class="hm-items-grid">
            <div
              v-for="item in regionItems"
              :key="item.id"
              class="hm-item-card"
              @click="goToDetail(item.id)"
            >
              <div class="hm-item-thumb">
                <img v-if="item.thumbnail" :src="item.thumbnail" :alt="item.name" />
                <div v-else class="hm-item-thumb-placeholder">{{ item.category?.charAt(0) }}</div>
              </div>
              <div class="hm-item-body">
                <span class="hm-item-name">{{ item.name }}</span>
                <div class="hm-item-meta">
                  <span class="hm-item-level" :class="getLevelClass(item.level)">{{ item.level }}</span>
                  <span class="hm-item-type">{{ item.category }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部分类统计 -->
    <section class="hm-stats container">
      <h2 class="hm-stats-title">全国非遗分类统计</h2>
      <div v-if="categoryStats.length === 0" class="hm-stats-empty">暂无数据</div>
      <div v-else class="hm-stats-grid">
        <div class="hm-stat-bar" v-for="cat in categoryStats" :key="cat.name">
          <div class="hm-stat-bar-header">
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
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import axios from 'axios'
import request from '@/api/request'

const router = useRouter()
const mapRef = ref(null)
let mapChart = null
let resizeObserver = null

// 后端简称 → GeoJSON全名 映射
const REGION_NAME_MAP = {
  '北京': '北京市', '天津': '天津市', '上海': '上海市', '重庆': '重庆市',
  '河北': '河北省', '山西': '山西省', '辽宁': '辽宁省', '吉林': '吉林省',
  '黑龙江': '黑龙江省', '江苏': '江苏省', '浙江': '浙江省', '安徽': '安徽省',
  '福建': '福建省', '江西': '江西省', '山东': '山东省', '河南': '河南省',
  '湖北': '湖北省', '湖南': '湖南省', '广东': '广东省', '海南': '海南省',
  '四川': '四川省', '贵州': '贵州省', '云南': '云南省', '陕西': '陕西省',
  '甘肃': '甘肃省', '青海': '青海省', '台湾': '台湾省',
  '内蒙古': '内蒙古自治区', '广西': '广西壮族自治区', '西藏': '西藏自治区',
  '宁夏': '宁夏回族自治区', '新疆': '新疆维吾尔自治区',
  '香港': '香港特别行政区', '澳门': '澳门特别行政区',
}
// GeoJSON全名 → 后端简称 反向映射
const REGION_NAME_REVERSE = Object.fromEntries(
  Object.entries(REGION_NAME_MAP).map(([k, v]) => [v, k])
)

// ── 省份列表（34个省级行政区，显示用简称）──────────────────
const allRegions = [
  { name: '北京' }, { name: '天津' }, { name: '河北' }, { name: '山西' },
  { name: '内蒙古' }, { name: '辽宁' }, { name: '吉林' }, { name: '黑龙江' },
  { name: '上海' }, { name: '江苏' }, { name: '浙江' }, { name: '安徽' },
  { name: '福建' }, { name: '江西' }, { name: '山东' }, { name: '河南' },
  { name: '湖北' }, { name: '湖南' }, { name: '广东' }, { name: '广西' },
  { name: '海南' }, { name: '重庆' }, { name: '四川' }, { name: '贵州' },
  { name: '云南' }, { name: '西藏' }, { name: '陕西' }, { name: '甘肃' },
  { name: '青海' }, { name: '宁夏' }, { name: '新疆' },
  { name: '香港' }, { name: '澳门' }, { name: '台湾' }
]

const activeRegion = ref('')
const regionItems = ref([])
const itemsLoading = ref(false)
// 各省份项目数量映射
const regionCountMap = ref({})

// ── 从后端加载指定省份的非遗数据 ─────────────────────────
const loadRegionItems = async (region) => {
  itemsLoading.value = true
  try {
    const res = await request.get('/heritage/list', {
      params: { region }
    })
    regionItems.value = (Array.isArray(res) ? res : (res?.data || [])).filter(item => item.enabled !== false)
  } catch (e) {
    regionItems.value = []
  } finally {
    itemsLoading.value = false
  }
}

// ── 加载所有省份数量（一次性全量加载统计） ───────────────
const loadAllRegionCounts = async () => {
  try {
    const res = await request.get('/heritage/list')
    const list = Array.isArray(res) ? res : (res?.data || [])
    const countMap = {}
    list.forEach(item => {
      if (item.region) {
        // 转换为 GeoJSON 全名作为 key
        const fullName = REGION_NAME_MAP[item.region] || item.region
        countMap[fullName] = (countMap[fullName] || 0) + 1
      }
    })
    regionCountMap.value = countMap
    // 同步更新地图热度
    updateMapData()
    // 构建分类统计
    buildCategoryStats(list)
  } catch (e) {
    // 静默处理
  }
}

// ── 省份点击（侧边栏，传入简称） ──────────────────────────
const selectRegion = (name) => {
  activeRegion.value = name
  // 同步高亮地图省份（需要用 GeoJSON 全名）
  if (mapChart) {
    const fullName = REGION_NAME_MAP[name] || name
    mapChart.dispatchAction({ type: 'select', seriesIndex: 0, name: fullName })
  }
}

const goToDetail = (id) => {
  router.push(`/detail/${id}`)
}

const getLevelClass = (level) => {
  if (!level) return 'city'
  if (level.includes('国家')) return 'national'
  if (level.includes('省') || level.includes('自治区') || level.includes('直辖')) return 'province'
  return 'city'
}

// ── ECharts 地图 ─────────────────────────────────────────
const initMap = async () => {
  // 加载 GeoJSON
  let geoJson
  try {
    const res = await axios.get('/china.json')
    geoJson = res.data
  } catch (e) {
    console.error('加载地图数据失败', e)
    return
  }

  echarts.registerMap('china', geoJson)

  mapChart = echarts.init(mapRef.value)

  const option = {
    backgroundColor: 'transparent',
    tooltip: {
      trigger: 'item',
      formatter: (params) => {
        const count = regionCountMap.value[params.name]
        if (count === undefined || count === 0) {
          return `<b>${params.name}</b><br/><span style="color:#aaa">暂无非遗数据</span>`
        }
        return `<b>${params.name}</b><br/>非遗项目：<span style="color:#8b3a0f;font-weight:600">${count} 项</span>`
      },
      backgroundColor: 'rgba(255,255,255,0.97)',
      borderColor: '#e8ddd0',
      borderWidth: 1,
      padding: [8, 12],
      textStyle: { color: '#333', fontSize: 13 }
    },
    visualMap: {
      min: 1,
      max: 20,
      left: 'left',
      bottom: 20,
      text: ['多', '少'],
      calculable: true,
      inRange: {
        color: ['#fde8c8', '#e8903a', '#8b3a0f']
      },
      outOfRange: {
        color: ['#ececec']
      },
      textStyle: { color: '#666', fontSize: 11 }
    },
    series: [{
      name: '非遗项目',
      type: 'map',
      map: 'china',
      roam: false,
      selectedMode: 'single',
      select: {
        itemStyle: {
          areaColor: '#8b3a0f',
          borderColor: '#fff',
          borderWidth: 1.5
        },
        label: { show: true, color: '#fff', fontSize: 11, fontWeight: 600 }
      },
      emphasis: {
        itemStyle: {
          areaColor: '#c0622a',
          borderColor: '#fff',
          borderWidth: 1.5
        },
        label: { show: true, color: '#fff', fontSize: 11 }
      },
      itemStyle: {
        areaColor: '#ececec',
        borderColor: '#d8d0c8',
        borderWidth: 0.8
      },
      label: {
        show: false,
        fontSize: 10,
        color: '#5a3a1a'
      },
      data: []
    }]
  }

  mapChart.setOption(option)

  // 点击省份：GeoJSON 全名 → 后端简称
  mapChart.on('click', (params) => {
    if (params.componentType === 'series') {
      const shortName = REGION_NAME_REVERSE[params.name] || params.name
      activeRegion.value = shortName
    }
  })

  // 用 ResizeObserver 监听容器尺寸变化，地图跟随放大缩小
  resizeObserver = new ResizeObserver(() => {
    mapChart?.resize()
  })
  resizeObserver.observe(mapRef.value)
}

// 更新地图热度数据：有数据的省份显示热力色，无数据显示灰色
const updateMapData = () => {
  if (!mapChart) return
  const data = allRegions.map(r => {
    const fullName = REGION_NAME_MAP[r.name] || r.name
    const count = regionCountMap.value[fullName]
    return {
      name: fullName,
      value: count > 0 ? count : null
    }
  })
  // 动态计算最大值（至少为1避免 min===max）
  const maxCount = Math.max(1, ...Object.values(regionCountMap.value))
  mapChart.setOption({
    visualMap: { min: 1, max: maxCount },
    series: [{ data }]
  })
}

onUnmounted(() => {
  resizeObserver?.disconnect()
  mapChart?.dispose()
})
watch(activeRegion, (val) => {
  loadRegionItems(val)
  // 更新地图选中状态（ECharts 需要 GeoJSON 全名）
  if (mapChart) {
    const fullName = REGION_NAME_MAP[val] || val
    mapChart.dispatchAction({ type: 'select', seriesIndex: 0, name: fullName })
  }
})

onMounted(async () => {
  await initMap()
  await loadAllRegionCounts()
})

// ── 分类统计（从后端数据动态计算） ──────────────────────
const CATEGORY_COLORS = {
  '传统技艺': '#e67e22',
  '传统美术': '#8e44ad',
  '传统戏剧': '#c0392b',
  '传统音乐': '#27ae60',
  '民俗':     '#d35400',
  '传统医药': '#16a085',
  '传统舞蹈': '#2980b9',
  '民间文学': '#7f8c8d',
}
const DEFAULT_COLORS = ['#5d7a8a', '#a0522d', '#4a6fa5', '#6b8e23', '#8b6f47', '#cd853f']

const categoryStats = ref([])

const buildCategoryStats = (list) => {
  const countMap = {}
  list.forEach(item => {
    if (item.category) {
      countMap[item.category] = (countMap[item.category] || 0) + 1
    }
  })
  const entries = Object.entries(countMap).sort((a, b) => b[1] - a[1])
  const maxCount = entries.length ? entries[0][1] : 1
  let colorIdx = 0
  categoryStats.value = entries.map(([name, count]) => ({
    name,
    count,
    pct: Math.round((count / maxCount) * 100),
    color: CATEGORY_COLORS[name] || DEFAULT_COLORS[colorIdx++ % DEFAULT_COLORS.length]
  }))
}
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
  height: 260px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  margin-top: 80px;
  background: #faf6ef;
  border-bottom: 1px solid #e8ddd0;
}

.hm-hero-bg {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 60% 80% at 50% 110%, rgba(139,58,15,0.08) 0%, transparent 70%),
    radial-gradient(ellipse 40% 60% at 10% 50%, rgba(200,160,100,0.06) 0%, transparent 60%),
    radial-gradient(ellipse 40% 60% at 90% 50%, rgba(200,160,100,0.06) 0%, transparent 60%);

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image:
      repeating-linear-gradient(0deg, transparent, transparent 39px, rgba(139,58,15,0.04) 40px),
      repeating-linear-gradient(90deg, transparent, transparent 39px, rgba(139,58,15,0.04) 40px);
  }
}

// 左右装饰纹样
.hm-hero-decor-left,
.hm-hero-decor-right {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 120px;
  height: 120px;
  border: 1.5px solid rgba(139,58,15,0.15);
  border-radius: 50%;
  pointer-events: none;

  &::before {
    content: '';
    position: absolute;
    inset: 12px;
    border: 1px solid rgba(139,58,15,0.1);
    border-radius: 50%;
  }

  &::after {
    content: '';
    position: absolute;
    inset: 26px;
    border: 1px dashed rgba(139,58,15,0.12);
    border-radius: 50%;
  }
}
.hm-hero-decor-left { left: 60px; }
.hm-hero-decor-right { right: 60px; }

.hm-hero-content {
  position: relative;
  z-index: 1;
  text-align: center;
}

.hm-hero-badge {
  display: block;
  width: fit-content;
  margin: 0 auto;
  font-size: 0.7rem;
  letter-spacing: 4px;
  color: #8b3a0f;
  background: rgba(139,58,15,0.08);
  border: 1px solid rgba(139,58,15,0.2);
  padding: 3px 14px;
  border-radius: 999px;
  margin-bottom: 14px;
}

.hm-hero-title {
  font-size: 2.8rem;
  font-weight: 700;
  color: #2c1a0e;
  margin: 0 0 14px;
  letter-spacing: 0.15em;
  font-family: 'Noto Serif SC', serif;
}

.hm-hero-divider {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 14px;

  span {
    display: block;
    width: 48px;
    height: 1px;
    background: linear-gradient(to right, transparent, rgba(139,58,15,0.4));

    &:last-child {
      background: linear-gradient(to left, transparent, rgba(139,58,15,0.4));
    }
  }

  .dot {
    width: 5px !important;
    height: 5px !important;
    border-radius: 50%;
    background: #8b3a0f !important;
    flex-shrink: 0;
  }
}

.hm-hero-sub {
  font-size: 0.92rem;
  color: #7a5c40;
  margin: 0;
  letter-spacing: 0.05em;
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
  padding: 16px 10px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
  height: fit-content;
  position: sticky;
  top: 90px;
  max-height: calc(100vh - 120px);
  overflow-y: auto;

  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-thumb { background: #e0d8ce; border-radius: 2px; }
}

.hm-sidebar-title {
  font-size: 0.75rem;
  font-weight: 600;
  color: #999;
  letter-spacing: 1px;
  margin-bottom: 10px;
  padding: 0 4px;
  text-transform: uppercase;
}

.hm-region-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 7px 8px;
  border-radius: 7px;
  cursor: pointer;
  transition: all 0.2s;
  margin-bottom: 1px;

  &:hover { background: #f5f0eb; }

  &.active {
    background: #8b3a0f;
    .hm-region-name { color: #fff; }
    .hm-region-count { background: rgba(255,255,255,0.2); color: #fff; }
  }

  &.no-data {
    .hm-region-name { color: #bbb; }
    .hm-region-count { color: #ccc; background: #f5f5f5; }
    &:hover { background: #fafafa; }
  }
}

.hm-region-name {
  font-size: 0.84rem;
  color: #333;
}

.hm-region-count {
  font-size: 0.68rem;
  background: #f0ece6;
  color: #888;
  padding: 1px 6px;
  border-radius: 999px;
  min-width: 20px;
  text-align: center;

  &.has-data {
    background: rgba(139,58,15,0.1);
    color: #8b3a0f;
    font-weight: 600;
  }
}

// 右侧内容
.hm-content { min-width: 0; }

// 地图容器
.hm-map-wrap {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
  margin-bottom: 20px;
  // 用 aspect-ratio 让高度随宽度自动缩放
  aspect-ratio: 16 / 9;
  position: relative;
}

.hm-map-canvas {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

// 非遗列表
.hm-items-section {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}

.hm-items-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.hm-items-title {
  font-size: 1rem;
  font-weight: 600;
  color: #333;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.region-badge {
  background: #8b3a0f;
  color: #fff;
  padding: 2px 10px;
  border-radius: 999px;
  font-size: 0.82rem;
}

.hm-items-count {
  font-size: 0.78rem;
  color: #aaa;
  white-space: nowrap;
}

.hm-loading {
  padding: 10px 0;
}

.hm-empty {
  padding: 20px 0;
  text-align: center;
}

.hm-items-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.hm-item-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px;
  background: #faf8f5;
  border-radius: 10px;
  border: 1px solid #f0ece6;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    border-color: #8b3a0f;
    box-shadow: 0 2px 8px rgba(139,58,15,0.1);
    transform: translateY(-1px);
  }
}

.hm-item-thumb {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
  background: #f0ece6;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.hm-item-thumb-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.3rem;
  color: #c8a87a;
  font-weight: 600;
}

.hm-item-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.hm-item-name {
  font-size: 0.86rem;
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.hm-item-meta {
  display: flex;
  align-items: center;
  gap: 5px;
  flex-wrap: wrap;
}

.hm-item-level {
  font-size: 0.65rem;
  padding: 1px 6px;
  border-radius: 999px;
  white-space: nowrap;

  &.national { background: rgba(192,57,43,0.1);  color: #c0392b; }
  &.province { background: rgba(41,128,185,0.1); color: #2980b9; }
  &.city     { background: rgba(39,174,96,0.1);  color: #27ae60; }
}

.hm-item-type {
  font-size: 0.65rem;
  color: #bbb;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
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

.hm-stat-bar-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}

.hm-stats-empty {
  text-align: center;
  color: #aaa;
  padding: 20px 0;
  font-size: 0.85rem;
}

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
  .hm-hero { height: 200px; margin-top: 60px; }
  .hm-hero-title { font-size: 1.9rem; }
  .hm-hero-decor-left, .hm-hero-decor-right { display: none; }

  .hm-main {
    grid-template-columns: 1fr;
    padding-top: 16px;
  }

  .hm-sidebar {
    position: static;
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    padding: 12px;
    max-height: none;
    overflow-y: visible;
  }

  .hm-sidebar-title { width: 100%; margin-bottom: 4px; }

  .hm-region-item {
    padding: 4px 10px;
    margin: 0;
    border: 1px solid #e0dbd4;
    flex-direction: row;
    gap: 5px;
  }

  .hm-map-canvas { height: unset; }

  .hm-items-grid { grid-template-columns: 1fr 1fr; }
  .hm-stats-grid { grid-template-columns: 1fr; }
}
</style>
