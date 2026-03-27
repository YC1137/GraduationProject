<template>
  <div class="china-map-widget">
    <!-- 地图画布 -->
    <div ref="mapRef" class="map-canvas"></div>

    <!-- 省份下拉选择 -->
    <div class="region-select-row">
      <span class="select-label">请选择地区：</span>
      <el-select
        :model-value="modelValue"
        placeholder="全部地区"
        clearable
        filterable
        @update:model-value="onSelect"
        @clear="onClear"
        class="region-select"
      >
        <el-option
          v-for="r in allRegions"
          :key="r.name"
          :label="`${r.name}${regionCountMap[REGION_NAME_MAP[r.name] || r.name] ? ' (' + regionCountMap[REGION_NAME_MAP[r.name] || r.name] + ')' : ''}`"
          :value="r.name"
        />
      </el-select>
      <el-button v-if="modelValue" text @click="onClear" class="clear-btn">
        <el-icon><Close /></el-icon> 清除
      </el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue'
import * as echarts from 'echarts'
import axios from 'axios'
import { Close } from '@element-plus/icons-vue'

const props = defineProps({
  /** 当前选中的省份简称 */
  modelValue: { type: String, default: '' },
  /** 各省份数量 key=GeoJSON全名 value=数量 */
  regionCountMap: { type: Object, default: () => ({}) }
})

const emit = defineEmits(['update:modelValue', 'change'])

// 后端简称 → GeoJSON全名
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
const REGION_NAME_REVERSE = Object.fromEntries(
  Object.entries(REGION_NAME_MAP).map(([k, v]) => [v, k])
)

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

const mapRef = ref(null)
let mapChart = null
let resizeObserver = null
let geoRegistered = false

const initMap = async () => {
  if (!mapRef.value) return
  if (mapRef.value.offsetWidth === 0) return  // 容器不可见，跳过初始化
  let geoJson
  try {
    const res = await axios.get('/china.json')
    geoJson = res.data
  } catch (e) {
    console.error('加载地图数据失败', e)
    return
  }

  if (!geoRegistered) {
    echarts.registerMap('china', geoJson)
    geoRegistered = true
  }

  mapChart = echarts.init(mapRef.value)

  const option = {
    backgroundColor: 'transparent',
    tooltip: {
      trigger: 'item',
      formatter: (params) => {
        const count = props.regionCountMap[params.name]
        if (!count) return `<b>${params.name}</b><br/><span style="color:#aaa">暂无数据</span>`
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
      bottom: 10,
      text: ['多', '少'],
      calculable: true,
      inRange: { color: ['#fde8c8', '#e8903a', '#8b3a0f'] },
      outOfRange: { color: ['#ececec'] },
      textStyle: { color: '#666', fontSize: 11 }
    },
    series: [{
      name: '非遗项目',
      type: 'map',
      map: 'china',
      roam: false,
      selectedMode: 'single',
      select: {
        itemStyle: { areaColor: '#8b3a0f', borderColor: '#fff', borderWidth: 1.5 },
        label: { show: true, color: '#fff', fontSize: 11, fontWeight: 600 }
      },
      emphasis: {
        itemStyle: { areaColor: '#c0622a', borderColor: '#fff', borderWidth: 1.5 },
        label: { show: true, color: '#fff', fontSize: 11 }
      },
      itemStyle: { areaColor: '#ececec', borderColor: '#d8d0c8', borderWidth: 0.8 },
      label: { show: false, fontSize: 10, color: '#5a3a1a' },
      data: []
    }]
  }

  mapChart.setOption(option)

  mapChart.on('click', (params) => {
    if (params.componentType === 'series') {
      const shortName = REGION_NAME_REVERSE[params.name] || params.name
      // 点击已选中的省份 → 取消选中
      if (shortName === props.modelValue) {
        emit('update:modelValue', '')
        emit('change', '')
      } else {
        emit('update:modelValue', shortName)
        emit('change', shortName)
      }
    }
  })

  resizeObserver = new ResizeObserver(() => mapChart?.resize())
  resizeObserver.observe(mapRef.value)

  // 初始渲染数据
  updateMapData()
  // 初始选中高亮
  if (props.modelValue) {
    highlightRegion(props.modelValue)
  }
}

const updateMapData = () => {
  if (!mapChart) return
  const data = allRegions.map(r => {
    const fullName = REGION_NAME_MAP[r.name] || r.name
    const count = props.regionCountMap[fullName]
    return { name: fullName, value: count > 0 ? count : null }
  })
  const maxCount = Math.max(1, ...Object.values(props.regionCountMap).filter(v => v > 0))
  mapChart.setOption({
    visualMap: { min: 1, max: maxCount },
    series: [{ data }]
  })
}

const highlightRegion = (shortName) => {
  if (!mapChart) return
  // 先取消所有选中
  mapChart.dispatchAction({ type: 'unselect', seriesIndex: 0, name: allRegions.map(r => REGION_NAME_MAP[r.name] || r.name) })
  if (shortName) {
    const fullName = REGION_NAME_MAP[shortName] || shortName
    mapChart.dispatchAction({ type: 'select', seriesIndex: 0, name: fullName })
  }
}

const onSelect = (val) => {
  emit('update:modelValue', val || '')
  emit('change', val || '')
}

const onClear = () => {
  emit('update:modelValue', '')
  emit('change', '')
}

// 监听外部 modelValue 变化，同步地图高亮
watch(() => props.modelValue, (val) => {
  highlightRegion(val)
})

// 监听数量数据变化，更新热力
watch(() => props.regionCountMap, () => {
  updateMapData()
}, { deep: true })

// 暴露 resize 方法，供父组件在 tab 切换后手动调用
defineExpose({
  resize: () => {
    if (!mapChart) {
      // 地图尚未初始化（容器之前为隐藏），现在补初始化
      initMap()
    } else {
      mapChart.resize()
    }
  }
})

onMounted(async () => {
  // 等待 DOM 布局稳定后再初始化，确保容器有实际尺寸
  await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)))

  // 若容器尺寸仍为 0（父容器隐藏/tab 未激活），轮询等待最多 3 秒
  let waited = 0
  while (mapRef.value && mapRef.value.offsetWidth === 0 && waited < 3000) {
    await new Promise(r => setTimeout(r, 100))
    waited += 100
  }
  initMap()
})

onUnmounted(() => {
  resizeObserver?.disconnect()
  mapChart?.dispose()
})
</script>

<style scoped lang="scss">
.china-map-widget {
  width: 100%;
}

.map-canvas {
  width: 100%;
  height: 340px;
}

.region-select-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 4px 4px;
  flex-wrap: wrap;
}

.select-label {
  font-size: 13px;
  color: #555;
  white-space: nowrap;
}

.region-select {
  width: 200px;
}

.clear-btn {
  font-size: 13px;
  color: #aaa;
  padding: 0 4px;
}
</style>
