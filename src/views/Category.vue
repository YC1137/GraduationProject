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

        <div class="filter-row">
          <div class="filter-item region-filter-item">
            <label class="filter-label">城市：</label>
            <div class="region-filter">
              <el-radio-group v-model="filters.region" @change="handleRegionRadioChange">
                <el-radio-button value="">全部</el-radio-button>
                <el-radio-button 
                  v-for="region in topRegions" 
                  :key="region.name" 
                  :value="region.name"
                >
                  {{ region.name }} ({{ region.count }})
                </el-radio-button>
              </el-radio-group>
              <el-select 
                v-if="otherRegions.length > 0"
                v-model="selectRegion" 
                placeholder="更多城市"
                clearable
                @change="handleSelectChange"
                @clear="handleSelectClear"
                class="more-regions-select"
              >
                <el-option
                  v-for="region in otherRegions"
                  :key="region.name"
                  :label="`${region.name} (${region.count})`"
                  :value="region.name"
                />
              </el-select>
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
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useHeritageStore } from '@/stores/heritage'
import HeritageCard from '@/components/heritage/HeritageCard.vue'

const route = useRoute()
const heritageStore = useHeritageStore()

const loading = ref(false)
const filteredList = ref([])

// 下拉框单独的绑定值
const selectRegion = ref('')

// 筛选条件
const filters = reactive({
  category: '',
  region: '',
  level: '',
  keyword: ''
})

const categories = heritageStore.categories
const levels = heritageStore.levels

// 地域统计数据
const regionStats = ref([])

// 热门地域（项目数最多的前5个）
const topRegions = computed(() => {
  return regionStats.value.slice(0, 5)
})

// 其他地域
const otherRegions = computed(() => {
  return regionStats.value.slice(5)
})

// 初始化筛选条件（从 URL 参数获取）
const initFilters = () => {
  filters.category = route.query.category || ''
  filters.region = route.query.region || ''
  filters.level = route.query.level || ''
  filters.keyword = route.query.keyword || ''
  
  // 如果初始地域在其他地域列表中，设置下拉框的值
  if (filters.region && otherRegions.value.some(r => r.name === filters.region)) {
    selectRegion.value = filters.region
  }
}

  // 获取项目列表
  const fetchList = async () => {
    loading.value = true
    try {
      // 根据当前的类别和级别筛选条件获取数据用于城市统计（不包含城市和关键词）
      const statsParams = {
        category: filters.category,
        level: filters.level
      }
      const statsData = await heritageStore.fetchHeritageList(statsParams)
      calculateRegionStats(statsData)
      
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
  
  // 计算城市统计（基于当前类别和级别筛选条件）
  const calculateRegionStats = (list) => {
    const regionCount = {}
    list.forEach(item => {
      regionCount[item.region] = (regionCount[item.region] || 0) + 1
    })
    
    // 转换为数组并按数量降序排序
    regionStats.value = Object.keys(regionCount)
      .map(name => ({ name, count: regionCount[name] }))
      .sort((a, b) => b.count - a.count)
  }

// 处理类别或级别变化（需要重置城市选择并重新计算城市统计）
const handleCategoryOrLevelChange = () => {
  filters.region = ''
  selectRegion.value = ''
  fetchList()
}

// 处理关键词搜索变化（不重置城市选择）
const handleKeywordChange = () => {
  fetchList()
}

// 处理 Radio 按钮变化（热门城市）
const handleRegionRadioChange = () => {
  // 当点击热门城市时，清空下拉框的值
  selectRegion.value = ''
  fetchList()
}

// 处理下拉框变化（其他城市）
const handleSelectChange = (value) => {
  // 当选择下拉框中的城市时，更新 filters.region
  filters.region = value
  fetchList()
}

// 处理下拉框清空
const handleSelectClear = () => {
  filters.region = ''
  selectRegion.value = ''
  fetchList()
}

// 重置筛选
const resetFilters = () => {
  filters.category = ''
  filters.region = ''
  filters.level = ''
  filters.keyword = ''
  selectRegion.value = ''
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
