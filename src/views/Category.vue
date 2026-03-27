<template>
  <div class="category-page">
    <div class="container">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1 class="page-title">非遗项目浏览</h1>
        <p class="page-subtitle">探索中华文化瑰宝，感受非遗魅力</p>
      </div>

      <!-- 筛选器 -->
      <div class="filter-section">
        <div class="filter-row">
          <div class="filter-item">
            <label class="filter-label">类别：</label>
            <el-radio-group v-model="filters.category" @change="handleCategoryOrLevelChange">
              <el-radio-button value="">全部</el-radio-button>
              <el-radio-button 
                v-for="cat in categories" 
                :key="cat" 
                :value="cat"
              >
                {{ cat }}
              </el-radio-button>
            </el-radio-group>
          </div>
        </div>

        <!-- 地域筛选：地图 + 下拉 -->
        <div class="filter-row region-map-row">
          <div class="filter-item region-map-item">
            <label class="filter-label">地域：</label>
            <div class="region-map-wrap">
              <ChinaMap
                v-model="filters.region"
                :region-count-map="geoRegionCountMap"
                @change="handleRegionMapChange"
              />
            </div>
          </div>
        </div>

        <div class="filter-row">
          <div class="filter-item">
            <label class="filter-label">级别：</label>
            <el-radio-group v-model="filters.level" @change="handleCategoryOrLevelChange">
              <el-radio-button value="">全部</el-radio-button>
              <el-radio-button 
                v-for="level in levels" 
                :key="level" 
                :value="level"
              >
                {{ level }}
              </el-radio-button>
            </el-radio-group>
          </div>
        </div>

        <div class="filter-row">
          <div class="filter-item full-width">
            <label class="filter-label">搜索：</label>
            <el-input
              v-model="filters.keyword"
              placeholder="输入关键词搜索..."
              clearable
              @clear="handleKeywordChange"
              @keyup.enter="handleKeywordChange"
            >
              <template #suffix>
                <el-icon @click="handleKeywordChange" style="cursor: pointer;">
                  <Search />
                </el-icon>
              </template>
            </el-input>
          </div>
        </div>

        <div class="filter-actions">
          <el-button @click="resetFilters">重置筛选</el-button>
          <span class="result-count">找到 {{ filteredList.length }} 个项目</span>
        </div>
      </div>

      <!-- 项目列表 -->
      <div class="heritage-list" v-loading="loading">
        <transition-group 
          v-if="filteredList.length > 0" 
          name="list" 
          tag="div" 
          class="heritage-grid"
        >
          <HeritageCard 
            v-for="item in filteredList" 
            :key="item.id"
            :heritage="item"
          />
        </transition-group>

        <!-- 空状态 -->
        <el-empty 
          v-if="!loading && filteredList.length === 0"
          description="暂无符合条件的非遗项目"
        >
          <el-button type="primary" @click="resetFilters">重置筛选</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useHeritageStore } from '@/stores/heritage'
import HeritageCard from '@/components/heritage/HeritageCard.vue'
import ChinaMap from '@/components/common/ChinaMap.vue'

const route = useRoute()
const heritageStore = useHeritageStore()

const loading = ref(false)
const filteredList = ref([])

// 筛选条件
const filters = reactive({
  category: '',
  region: '',
  level: '',
  keyword: ''
})

const categories = heritageStore.categories
const levels = heritageStore.levels

// 地域统计数据（key=GeoJSON全名，供地图组件使用）
const geoRegionCountMap = ref({})

// 后端简称 → GeoJSON全名（与 ChinaMap 保持一致）
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

// 初始化筛选条件（从 URL 参数获取）
const initFilters = () => {
  filters.category = route.query.category || ''
  filters.region = route.query.region || ''
  filters.level = route.query.level || ''
  filters.keyword = route.query.keyword || ''
}

  // 获取项目列表
  const fetchList = async () => {
    loading.value = true
    try {
      // 先获取不含地区筛选的数据用于热力图统计
      const statsParams = {
        category: filters.category,
        level: filters.level
      }
      const statsData = await heritageStore.fetchHeritageList(statsParams)
      buildGeoCountMap(statsData)
      
      // 再根据完整筛选条件获取数据
      const params = {
        category: filters.category,
        region: filters.region,
        level: filters.level,
        keyword: filters.keyword
      }
      const list = await heritageStore.fetchHeritageList(params)
      filteredList.value = list
    } catch (error) {
      console.error('获取列表失败:', error)
    } finally {
      loading.value = false
    }
  }
  
  // 将后端简称统计转为 GeoJSON 全名 map 供地图热力使用
  const buildGeoCountMap = (list) => {
    const countMap = {}
    list.forEach(item => {
      if (item.region) {
        const fullName = REGION_NAME_MAP[item.region] || item.region
        countMap[fullName] = (countMap[fullName] || 0) + 1
      }
    })
    geoRegionCountMap.value = countMap
  }

// 处理类别或级别变化
const handleCategoryOrLevelChange = () => {
  filters.region = ''
  fetchList()
}

// 处理关键词搜索变化
const handleKeywordChange = () => {
  fetchList()
}

// 处理地图/下拉选择地区变化
const handleRegionMapChange = () => {
  fetchList()
}

// 重置筛选
const resetFilters = () => {
  filters.category = ''
  filters.region = ''
  filters.level = ''
  filters.keyword = ''
  fetchList()
}

// 监听路由变化
watch(() => route.query, () => {
  initFilters()
  fetchList()
})

onMounted(() => {
  initFilters()
  fetchList()
})
</script>

<style lang="scss" scoped>
.category-page {
  padding: 40px 0 80px;
  min-height: calc(100vh - 80px - 200px);
}

.page-header {
  text-align: center;
  margin-bottom: 50px;
}

.page-title {
  font-size: 2.5rem;
  color: var(--text-primary);
  margin-bottom: 15px;
}

.page-subtitle {
  font-size: 1.1rem;
  color: var(--text-secondary);
}

// 筛选器样式
.filter-section {
  background: #fef8ec; // 米黄色底色
  border: 1px solid #e8dfc5;
  border-radius: 12px;
  padding: 30px 35px;
  margin-bottom: 40px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.filter-row {
  margin-bottom: 24px;
  
  &:last-child {
    margin-bottom: 0;
  }
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 16px;
  
  &.full-width {
    .el-input {
      flex: 1;
      max-width: 500px;
    }
  }
  
  &.region-filter-item {
    align-items: flex-start;
  }
}

.region-filter {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
  flex: 1;
  
  .el-radio-group {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  .more-regions-select {
    width: 160px;
  }
}

// 地图筛选行
.region-map-row {
  margin-bottom: 10px;
}

.region-map-item {
  align-items: flex-start !important;
  gap: 12px !important;

  .filter-label {
    padding-top: 6px;
  }
}

.region-map-wrap {
  flex: 1;
  background: #fff;
  border: 1px solid #e8dfc5;
  border-radius: 10px;
  padding: 10px 14px 8px;
}

.filter-label {
  font-weight: 600;
  color: #2c3e50;
  min-width: 70px;
  font-size: 15px;
}

// 美化 Radio Button
:deep(.el-radio-button) {
  .el-radio-button__inner {
    border: 1px solid #d4c5a0;
    border-radius: 6px;
    padding: 6px 16px;
    font-size: 14px;
    font-weight: 500;
    color: #666;
    background: #fff;
    transition: all 0.2s ease;
    margin: 0; // 确保没有额外间距
    
    &:hover {
      border-color: #c8302b;
      color: #c8302b;
      background: #fff;
    }
  }
  
  &.is-active .el-radio-button__inner {
    border-color: #c8302b !important;
    background: #c8302b !important; // 纯红色背景
    color: #fff !important;
    font-weight: 600;
    box-shadow: none !important;
  }
  
  // 去除默认的边框样式
  &:first-child .el-radio-button__inner {
    border-left: 1px solid #d4c5a0;
    border-radius: 6px;
  }
  
  &:last-child .el-radio-button__inner {
    border-radius: 6px;
  }
  
  &.is-active:first-child .el-radio-button__inner {
    border-left-color: #c8302b;
  }
}

// 统一所有 radio-group 的间距
:deep(.el-radio-group) {
  display: flex;
  flex-wrap: wrap;
  gap: 10px; // 统一的间距
}

// 美化 Select
:deep(.el-select) {
  .el-input__wrapper {
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    border: 1px solid #d4c5a0;
    background: #fff;
    transition: all 0.2s ease;
    
    &:hover {
      border-color: #c8302b;
    }
    
    &.is-focus {
      border-color: #c8302b;
      box-shadow: 0 0 0 2px rgba(200, 48, 43, 0.1);
    }
  }
  
  .el-input__inner {
    font-size: 14px;
    font-weight: 500;
    color: #333;
  }
}

// 美化搜索框
:deep(.el-input) {
  .el-input__wrapper {
    border-radius: 6px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
    border: 1px solid #d4c5a0;
    padding: 2px 16px;
    transition: all 0.2s ease;
    background: #fff;
    
    &:hover {
      border-color: #c8302b;
    }
    
    &.is-focus {
      border-color: #c8302b;
      box-shadow: 0 0 0 2px rgba(200, 48, 43, 0.1);
    }
  }
  
  .el-input__inner {
    font-size: 14px;
    color: #333;
    
    &::placeholder {
      color: #999;
      font-weight: 400;
    }
  }
  
  .el-input__suffix {
    .el-icon {
      color: #c8302b;
      font-size: 16px;
      transition: all 0.2s ease;
      
      &:hover {
        transform: scale(1.1);
      }
    }
  }
}

.filter-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #e8dfc5;
  
  .el-button {
    border-radius: 6px;
    padding: 8px 20px;
    font-weight: 600;
    border: 1px solid #d4c5a0;
    transition: all 0.2s ease;
    
    &:hover {
      border-color: #c8302b;
      color: #c8302b;
      background: #fff;
    }
  }
}

.result-count {
  color: #c8302b;
  font-size: 15px;
  font-weight: 600;
}

// 项目列表
.heritage-list {
  min-height: 400px;
}

.heritage-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 30px;
}

// 列表动画
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

.list-leave-to {
  opacity: 0;
  transform: scale(0.9);
}

.list-move {
  transition: transform 0.5s ease;
}

// 响应式设计
@media (max-width: 768px) {
  .page-title {
    font-size: 1.8rem;
  }
  
  .filter-section {
    padding: 20px;
  }
  
  .filter-row {
    margin-bottom: 20px;
  }
  
  .filter-item {
    flex-direction: column;
    align-items: flex-start;
    
    &.full-width .el-input {
      max-width: 100%;
    }
  }
  
  .filter-label {
    min-width: auto;
  }
  
  :deep(.el-radio-group) {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  .filter-actions {
    flex-direction: column;
    gap: 15px;
    align-items: stretch;
  }
  
  .heritage-grid {
    grid-template-columns: 1fr;
  }
}
</style>
