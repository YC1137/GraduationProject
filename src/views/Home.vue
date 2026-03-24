<template>
  <div class="home-page ink-wash-bg">
    <!-- 轮播图区域 -->
    <section class="hero-section">
      <el-carousel 
        :interval="5000" 
        height="500px" 
        arrow="hover"
        indicator-position="outside"
        :autoplay="true"
        :loop="true"
      >
        <el-carousel-item v-for="item in carouselItems" :key="item.id">
          <div class="carousel-item" :style="{ backgroundImage: `url(${item.thumbnail || 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1920&q=80'})` }">
            <div class="carousel-overlay"></div>
            <div class="carousel-content container">
              <h2 class="carousel-title fade-in">{{ item.name }}</h2>
              <p class="carousel-desc fade-in">{{ item.description || '传承千年的文化瑰宝，感受非遗魅力' }}</p>
              <el-button 
                type="primary" 
                size="large" 
                class="carousel-btn fade-in"
                @click="goToDetail(item.id)"
              >
                了解详情
                <el-icon class="el-icon--right"><ArrowRight /></el-icon>
              </el-button>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </section>

    <!-- 热门项目 + 公告栏 -->
    <section class="featured-section container">
      <div class="featured-layout">
        <!-- 左侧：热门项目 -->
        <div class="featured-main">
          <h2 class="section-title">
            <span>热门项目</span>
            <div class="title-decoration"></div>
          </h2>
          <div class="heritage-grid">
            <HeritageCard 
              v-for="item in featuredItems" 
              :key="item.id"
              :heritage="item"
            />
          </div>
          <div class="view-more">
            <el-button type="primary" size="large" @click="goToCategory()">
              查看更多
              <el-icon class="el-icon--right"><DArrowRight /></el-icon>
            </el-button>
          </div>
        </div>

        <!-- 右侧：公告栏 -->
        <div class="notice-board">
          <h2 class="section-title">
            <span>公告栏</span>
            <div class="title-decoration"></div>
          </h2>
          <div class="notice-list">
            <div class="notice-item" v-for="notice in notices" :key="notice.id">
              <div class="notice-tag" :class="notice.type">{{ notice.tag }}</div>
              <div class="notice-content">
                <p class="notice-title">{{ notice.title }}</p>
                <span class="notice-date">{{ notice.date }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 分类入口 -->
    <section class="category-section container">
      <h2 class="section-title">
        <span>分类浏览</span>
        <div class="title-decoration"></div>
      </h2>
      
      <div class="category-tabs">
        <el-tabs v-model="activeTab" @tab-click="handleTabClick">
          <el-tab-pane label="按类别" name="category">
            <div class="category-grid">
              <div 
                v-for="cat in categories" 
                :key="cat.name"
                class="category-card"
                @click="goToCategory('category', cat.name)"
              >
                <div class="category-icon">
                  <el-icon><component :is="cat.icon" /></el-icon>
                </div>
                <h3 class="category-name">{{ cat.name }}</h3>
                <p class="category-count">{{ cat.count }} 个项目</p>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="按地域" name="region">
            <div class="category-grid">
              <div 
                v-for="region in regions" 
                :key="region.name"
                class="category-card region-card"
                @click="goToCategory('region', region.name)"
              >
                <div class="region-art-text">
                  <span class="chinese">{{ region.name }}</span>
                  <span class="pinyin">{{ region.fullPinyin }}</span>
                </div>
                <p class="category-count">{{ region.count }} 个项目</p>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="按级别" name="level">
            <div class="category-grid">
              <div 
                v-for="level in levels" 
                :key="level.name"
                class="category-card level-card-minimal"
                :class="'level-' + level.name"
                @click="goToCategory('level', level.name)"
              >
                <div class="level-icon-minimal">
                  <el-icon><component :is="getLevelIcon(level.name)" /></el-icon>
                </div>
                <h3 class="category-name">{{ level.name }}</h3>
                <p class="category-count">{{ level.count }} 个项目</p>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </section>

    <!-- 平台特色 -->
    <section class="features-section ink-wash-bg">
      <div class="container">
        <h2 class="section-title">
          <span>平台特色</span>
          <div class="title-decoration"></div>
        </h2>
        
        <div class="features-grid">
          <div class="feature-card" v-for="feature in features" :key="feature.title">
            <div class="feature-icon">
              <el-icon><component :is="feature.icon" /></el-icon>
            </div>
            <h3 class="feature-title">{{ feature.title }}</h3>
            <p class="feature-desc">{{ feature.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 皮影装饰 -->
    <img src="@/img/piying.png" class="piying-decoration piying-right" alt="" aria-hidden="true" />
    <img src="@/img/piying.png" class="piying-decoration piying-left"  alt="" aria-hidden="true" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useHeritageStore } from '@/stores/heritage'
import HeritageCard from '@/components/heritage/HeritageCard.vue'
import { 
  Picture, 
  Film, 
  Brush, 
  Headset,
  Location,
  Medal,
  ArrowRight,
  DArrowRight,
  Search,
  Monitor,
  VideoCamera,
  ChatDotRound,
  TrophyBase,
  OfficeBuilding,
  School,
  Shop,
  House,
  Histogram,
  Star,
  Sunny,
  Moon,
  Cherry,
  Orange,
  Apple,
  Pear
} from '@element-plus/icons-vue'

const router = useRouter()
const heritageStore = useHeritageStore()

const searchKeyword = ref('')
const activeTab = ref('category')
const featuredItems = ref([])

// 公告栏数据
const notices = ref([
  { id: 1, tag: '通知', type: 'info',    title: '平台正式上线，欢迎广大非遗爱好者注册体验！', date: '2025-03-20' },
  { id: 2, tag: '活动', type: 'primary', title: '2025年非遗文化节线上知识竞答活动开始报名', date: '2025-03-18' },
  { id: 3, tag: '更新', type: 'success', title: '新增50余项国家级非遗项目数据，内容持续扩充中', date: '2025-03-15' },
  { id: 4, tag: '公告', type: 'warning', title: '关于非遗数字化保护成果展览征集工作的通知', date: '2025-03-10' },
  { id: 5, tag: '活动', type: 'primary', title: '非遗传承人线上直播讲堂第三期即将开播', date: '2025-03-08' },
  { id: 6, tag: '通知', type: 'info',    title: '平台数据库完成第二次整体更新，新增地域分类', date: '2025-03-01' },
  { id: 7, tag: '公告', type: 'warning', title: '诚邀各地非遗传承人入驻平台，共建数字非遗库', date: '2025-02-25' },
])

// 轮播图数据（动态）
const carouselItems = ref([])

// 分类数据（动态计算）
const categories = ref([])

const regions = ref([])

const levels = ref([])

// 验证图片URL是否安全
const validateImageUrl = (url) => {
  if (!url) return null
  
  // 检查是否为字符串
  if (typeof url !== 'string') return null
  
  // 检查URL格式
  try {
    const urlObj = new URL(url)
    
    // 只允许 http 和 https 协议
    if (!['http:', 'https:'].includes(urlObj.protocol)) {
      return null
    }
    
    // 检查是否包含可疑的javascript伪协议
    if (url.toLowerCase().includes('javascript:') || 
        url.toLowerCase().includes('data:') ||
        url.toLowerCase().includes('vbscript:')) {
      return null
    }
    
    // 可选：限制域名白名单
    const allowedDomains = [
      'images.unsplash.com',
      'via.placeholder.com',
      'localhost'
    ]
    // 如果需要严格限制，可以取消下面的注释
    // if (!allowedDomains.includes(urlObj.hostname)) return null
    
    return url
  } catch (e) {
    return null
  }
}

// 验证文本内容，防止XSS
const sanitizeText = (text) => {
  if (!text) return ''
  if (typeof text !== 'string') return ''
  
  // Vue的{{}}会自动转义，但这里做额外防御
  // 移除潜在的HTML标签
  return text
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/\//g, '&#x2F;')
}

// 验证ID是否为数字或安全的字符串
const validateId = (id) => {
  if (typeof id === 'number' && id > 0) return id
  if (typeof id === 'string' && /^\d+$/.test(id)) return parseInt(id, 10)
  return null
}

const getLevelIcon = (name) => {
  const iconMap = {
    '国家级': 'Trophy',
    '省级': 'Medal',
    '市级': 'CollectionTag'
  }
  return iconMap[name] || 'Medal'
}

// 随机打乱数组的函数
const shuffleArray = (array) => {
  const newArray = [...array]
  for (let i = newArray.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [newArray[i], newArray[j]] = [newArray[j], newArray[i]]
  }
  return newArray
}

// 获取城市全拼
const getFullPinyin = (cityName) => {
  const pinyinMap = {
    '北京': 'BEIJING', '上海': 'SHANGHAI', '天津': 'TIANJIN', '重庆': 'CHONGQING',
    '河北': 'HEBEI', '山西': 'SHANXI', '辽宁': 'LIAONING', '吉林': 'JILIN', '黑龙江': 'HEILONGJIANG',
    '江苏': 'JIANGSU', '浙江': 'ZHEJIANG', '安徽': 'ANHUI', '福建': 'FUJIAN', '江西': 'JIANGXI',
    '山东': 'SHANDONG', '河南': 'HENAN', '湖北': 'HUBEI', '湖南': 'HUNAN', '广东': 'GUANGDONG',
    '广西': 'GUANGXI', '海南': 'HAINAN', '四川': 'SICHUAN', '贵州': 'GUIZHOU', '云南': 'YUNNAN',
    '陕西': 'SHAANXI', '甘肃': 'GANSU', '青海': 'QINGHAI', '内蒙古': 'NEIMENGGU', '新疆': 'XINJIANG',
    '西藏': 'XIZANG', '宁夏': 'NINGXIA', '香港': 'HONGKONG', '澳门': 'MACAU', '台湾': 'TAIWAN'
  }
  
  // 验证城市名称是否为中文字符
  if (typeof cityName !== 'string' || !/^[\u4e00-\u9fa5]+$/.test(cityName)) {
    return 'UNKNOWN'
  }
  
  return pinyinMap[cityName] || cityName
}

// 平台特色
const features = ref([
  {
    title: '数字化展示',
    description: '运用数字技术，全方位呈现非遗项目的独特魅力',
    icon: 'Monitor'
  },
  {
    title: '多媒体体验',
    description: '图片、视频、音频、3D模型，多维度感受非遗文化',
    icon: 'VideoCamera'
  },
  {
    title: '互动交流',
    description: '点赞、收藏、评论，与非遗文化零距离接触',
    icon: 'ChatDotRound'
  },
  {
    title: '知识测验',
    description: '寓教于乐，在互动中学习和传承非遗知识',
    icon: 'TrophyBase'
  }
])

// 获取热门项目和统计数据
onMounted(async () => {
  try {
    const list = await heritageStore.fetchHeritageList()
    
    // 验证数据完整性
    if (!Array.isArray(list)) {
      console.error('Invalid heritage list data')
      return
    }
    
    // 热门项目：根据点赞数和收藏数排序，取前3个
    const validList = list.filter(item => {
      // 验证每个项目的必需字段
      return item && 
             validateId(item.id) !== null &&
             typeof item.name === 'string' &&
             item.name.trim().length > 0
    })
    
    const sortedByHot = [...validList].sort((a, b) => {
      const hotA = (a.likes || 0) + (a.favorites || 0)
      const hotB = (b.likes || 0) + (b.favorites || 0)
      return hotB - hotA
    })
    featuredItems.value = sortedByHot.slice(0, 3)
    
    // 轮播图：从剩余项目中随机选择3个（避免与热门项目重复，且保持刷新随机性）
    const remainingList = validList.filter(item => !featuredItems.value.find(f => f.id === item.id))
    const shuffledRemaining = shuffleArray(remainingList.length >= 3 ? remainingList : validList)
    
    // 对轮播图数据进行安全处理
    carouselItems.value = shuffledRemaining.slice(0, 3).map(item => ({
      ...item,
      thumbnail: validateImageUrl(item.thumbnail),
      name: sanitizeText(item.name || ''),
      description: sanitizeText(item.description || '')
    }))
    
    // 动态计算分类统计
    const categoryIcons = {
      '传统技艺': 'Brush',
      '传统戏剧': 'Film',
      '传统美术': 'Picture',
      '传统音乐': 'Headset',
      '民俗': 'Calendar',
      '传统医药': 'FirstAidKit'
    }
    
    const categoryCount = {}
    const regionCount = {}
    const levelCount = {}
    
    validList.forEach(item => {
      // 验证并统计类别
      if (item.category && typeof item.category === 'string') {
        categoryCount[item.category] = (categoryCount[item.category] || 0) + 1
      }
      // 验证并统计地域
      if (item.region && typeof item.region === 'string' && /^[\u4e00-\u9fa5]+$/.test(item.region)) {
        regionCount[item.region] = (regionCount[item.region] || 0) + 1
      }
      // 验证并统计级别
      if (item.level && typeof item.level === 'string' && ['国家级', '省级', '市级'].includes(item.level)) {
        levelCount[item.level] = (levelCount[item.level] || 0) + 1
      }
    })
    
    // 转换为数组格式
    categories.value = Object.keys(categoryCount).map(name => ({
      name: sanitizeText(name),
      count: categoryCount[name] || 0,
      icon: categoryIcons[name] || 'Star'
    }))
    
    regions.value = Object.keys(regionCount).map(name => ({
      name: sanitizeText(name),
      count: regionCount[name] || 0,
      fullPinyin: getFullPinyin(name)
    }))
    
    levels.value = Object.keys(levelCount).map(name => ({
      name: sanitizeText(name),
      count: levelCount[name] || 0
    }))
  } catch (error) {
    console.error('Error loading heritage data:', error)
    // 可以在这里添加错误处理，比如显示错误提示
  }
})

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    // 清理搜索关键词，防止XSS
    const cleanKeyword = sanitizeText(searchKeyword.value.trim()).slice(0, 100) // 限制长度
    router.push({
      path: '/category',
      query: { keyword: cleanKeyword }
    })
  }
}

const goToDetail = (id) => {
  // 验证ID
  const validId = validateId(id)
  if (validId !== null) {
    router.push(`/detail/${validId}`)
  } else {
    console.error('Invalid ID:', id)
  }
}

const goToCategory = (type, value) => {
  // 验证type和value
  const validTypes = ['category', 'region', 'level']
  
  if (type && value && validTypes.includes(type)) {
    // 清理value
    const cleanValue = sanitizeText(String(value).trim()).slice(0, 50)
    
    router.push({
      path: '/category',
      query: { [type]: cleanValue }
    })
  } else {
    router.push({
      path: '/category',
      query: {}
    })
  }
}

const handleTabClick = () => {
  // 处理标签页切换
}
</script>

<style lang="scss" scoped>
.home-page {
  min-height: 100vh;

}

// 轮播图区域
.hero-section {
  margin-top: -80px;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
  padding: 0 20px;
  
  :deep(.el-carousel) {
    .el-carousel__indicators {
      .el-carousel__button {
        background-color: rgba(200, 48, 43, 0.5);
      }
      
      .is-active .el-carousel__button {
        background-color: var(--primary-color);
      }
    }
  }
}

.carousel-item {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  position: relative;
  display: flex;
  align-items: center;
}

.carousel-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    to right,
    rgba(0, 0, 0, 0.6) 0%,
    rgba(0, 0, 0, 0.3) 50%,
    transparent 100%
  );
}

.carousel-content {
  position: relative;
  z-index: 1;
  color: #ffffff;
  max-width: 600px;
}

.carousel-title {
  font-size: 3rem;
  font-weight: bold;
  margin-bottom: 20px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
  animation-delay: 0.2s;
}

.carousel-desc {
  font-size: 1.2rem;
  margin-bottom: 30px;
  line-height: 1.8;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
  animation-delay: 0.4s;
}

.carousel-btn {
  animation-delay: 0.6s;
}

// 分类区域
.category-section {
  padding: 60px 0;
}

.section-title {
  text-align: center;
  font-size: 2rem;
  margin-bottom: 50px;
  position: relative;
  
  span {
    position: relative;
    z-index: 1;
    background: var(--bg-color);
    padding: 0 20px;
  }
  
  .title-decoration {
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 2px;
    background: linear-gradient(
      to right,
      transparent,
      var(--border-color) 20%,
      var(--border-color) 80%,
      transparent
    );
  }
}

.category-tabs {
  :deep(.el-tabs__item) {
    font-size: 16px;
    font-weight: 500;
  }
}

.category-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr); // 固定4列
  gap: 30px;
  margin-top: 30px;
}

.category-card {
  background: var(--bg-light);
  border: 2px solid var(--border-color);
  border-radius: 12px;
  padding: 30px 20px; // 统一为 30px，与地域对齐
  text-align: center;
  cursor: pointer;
  transition: var(--transition);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%; // 确保网格内高度一致
  min-height: 220px; // 以地域卡片的高度为基准设置最小高度
  
  &:hover {
    border-color: var(--primary-color);
    box-shadow: var(--shadow-md);
    transform: translateY(-5px);
    
    .category-icon {
      color: var(--primary-color);
      transform: scale(1.1);
    }
  }
}

.category-icon {
  color: var(--secondary-color);
  margin-bottom: 20px;
  transition: var(--transition);
  
  .el-icon {
    font-size: 40px;
  }
}

// 地域卡片艺术字样式
.region-card {
  .region-art-text {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 15px;
    
    .chinese {
      font-size: 2.2rem;
      font-weight: 900;
      color: #1a1a1a;
      font-family: "Microsoft YaHei", "SimHei", sans-serif;
      letter-spacing: 4px;
      line-height: 1.2;
      position: relative;
      
      &::after {
        content: "";
        position: absolute;
        bottom: -2px;
        left: 50%;
        transform: translateX(-50%);
        width: 40%;
        height: 3px;
        background: #c8302b;
        border-radius: 2px;
        opacity: 0;
        transition: var(--transition);
      }
    }
    
    .pinyin {
      font-size: 0.85rem;
      font-weight: 500;
      color: #666;
      letter-spacing: 2px;
      margin-top: 5px;
      text-transform: uppercase;
      font-family: Georgia, serif;
    }
  }
  
  &:hover {
    .chinese {
      color: #c8302b;
      &::after {
        opacity: 1;
        width: 80%;
      }
    }
    .pinyin {
      color: #999;
    }
  }
}

.category-name {
  font-size: 1.2rem;
  margin-bottom: 10px;
  color: var(--text-primary);
}

.category-count {
  font-size: 14px;
  color: var(--text-secondary);
}

// 热门项目
.featured-section {
  padding: 60px 0;
}

.featured-layout {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 36px;
  align-items: start;
}

.featured-main {
  min-width: 0;
}

.heritage-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 24px;
  margin-top: 30px;
}

.view-more {
  text-align: center;
  margin-top: 40px;
}

// 公告栏
.notice-board {
  background: #fff;
  border-radius: 16px;
  padding: 28px 24px;
  box-shadow: var(--shadow-sm);
  border: 1px solid rgba(0,0,0,.06);
  position: sticky;
  top: 80px;
}

.notice-list {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 0;
}

.notice-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 14px 0;
  border-bottom: 1px dashed rgba(0,0,0,.08);
  cursor: default;
  transition: background .2s;

  &:last-child { border-bottom: none; }
  &:hover { background: rgba(192,57,43,.03); border-radius: 8px; padding-left: 6px; }
}

.notice-tag {
  flex-shrink: 0;
  font-size: 11px;
  font-weight: 600;
  padding: 2px 7px;
  border-radius: 4px;
  margin-top: 2px;

  &.info    { background: #e8f4fd; color: #2980b9; }
  &.primary { background: #fdeaea; color: var(--primary-color); }
  &.success { background: #eafaf1; color: #27ae60; }
  &.warning { background: #fef9e7; color: #e67e22; }
}

.notice-content {
  flex: 1;
  min-width: 0;
}

.notice-title {
  font-size: 13px;
  color: var(--text-primary);
  line-height: 1.6;
  margin: 0 0 4px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.notice-date {
  font-size: 11px;
  color: var(--text-secondary);
}

// 平台特色
.features-section {
  padding: 80px 0;
  background: linear-gradient(to bottom, transparent, rgba(61, 78, 92, 0.03));
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
  margin-top: 40px;
}

.feature-card {
  text-align: center;
  padding: 40px 20px;
  background: var(--bg-light);
  border-radius: 12px;
  border: 1px solid var(--border-color);
  transition: var(--transition);
  
  &:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-5px);
    
    .feature-icon {
      color: var(--primary-color);
      transform: scale(1.1);
    }
  }
}

.feature-icon {
  color: var(--secondary-color);
  margin-bottom: 20px;
  transition: var(--transition);
  
  .el-icon {
    font-size: 50px;
  }
}

.feature-title {
  font-size: 1.3rem;
  margin-bottom: 15px;
  color: var(--text-primary);
}

.feature-desc {
  color: var(--text-secondary);
  line-height: 1.8;
}

// 响应式显示控制
// 响应式设计
@media (max-width: 768px) {
  .hero-section {
    margin-top: -60px;
    padding: 0 15px;
    
    :deep(.el-carousel) {
      height: 245px !important; // 350px * 0.7 = 245px
    }
    
    :deep(.el-carousel__arrow) {
      width: 36px;
      height: 36px;
    }
    
    :deep(.el-carousel__indicators) {
      padding: 10px;
    }
  }
  
  .carousel-item {
    align-items: flex-start; // 改为顶部对齐
    padding-top: 60px; // 添加顶部内边距
  }
  
  .carousel-content {
    padding: 0 20px; // 增加左右内边距
    max-width: 100%; // 移动端占满宽度
  }
  
  .carousel-title {
    font-size: 1.4rem; // 减小标题字号
    margin-bottom: 8px; // 减少底部间距
  }
  
  .carousel-desc {
    font-size: 0.8rem; // 减小描述字号
    margin-bottom: 12px; // 减少底部间距
    line-height: 1.4; // 减少行高
  }
  
  .carousel-btn {
    font-size: 12px;
    padding: 6px 14px; // 减小按钮
  }
  
  // 分类区域 - 更紧凑
  .category-section {
    padding: 30px 0 20px; // 减少上下内边距
  }
  
  .section-title {
    font-size: 1.3rem;
    margin-bottom: 20px; // 减少底部间距
  }
  
  // 标签页优化
  .category-tabs {
    :deep(.el-tabs__header) {
      margin: 0 0 15px; // 减少标签页底部间距
    }
    
    :deep(.el-tabs__nav-scroll) {
      display: flex;
      justify-content: center; // 标签导航居中
    }
    
    :deep(.el-tabs__item) {
      font-size: 18px; // 加大字号
      font-weight: 600;
      padding: 0 20px;
    }
    
    :deep(.el-tabs__content) {
      padding: 0;
    }
  }
  
  // 分类网格 - 更紧凑
  .category-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 12px; // 稍微增加间距
    margin-top: 15px; // 减少顶部间距
    max-width: 100%; // 移动端占满宽度
  }
  
  // 分类卡片 - 进一步缩小高度（在二分之一基础上再减20%）
  .category-card {
    padding: 10px 8px; // 进一步减少内边距
    min-height: 88px; // 110px * 0.8 = 88px
    border-radius: 6px;
    
    .category-icon {
      margin-bottom: 5px;
      .el-icon {
        font-size: 24px; // 进一步减小图标
      }
    }

    .category-name {
      font-size: 0.85rem; // 稍微减小字体
      margin-bottom: 2px;
    }

    .category-count {
      font-size: 10px;
      transform: scale(0.9); // 让数字更精细
    }
  }

  // 地域卡片手机端特殊处理
  .region-card {
    .region-art-text {
      margin-bottom: 4px;
      .chinese {
        font-size: 1.3rem; // 进一步减小艺术字
        letter-spacing: 2px;
      }
      .pinyin {
        font-size: 0.6rem;
        letter-spacing: 0.5px;
      }
    }
  }

  // 级别卡片手机端特殊处理
  .level-card-minimal {
    .level-icon-minimal {
      font-size: 24px;
      margin-bottom: 5px;
    }
  }
  
  // 热门项目
  .featured-section {
    padding: 30px 0;
  }

  .featured-layout {
    grid-template-columns: 1fr;
  }

  .notice-board {
    position: static;
  }
  
  .heritage-grid {
    grid-template-columns: 1fr;
    gap: 15px; // 减少间距
    margin-top: 20px;
  }
  
  .view-more {
    margin-top: 30px; // 减少间距
  }
  
  // 平台特色 - 一行显示
  .features-section {
    padding: 30px 0; // 减少内边距
  }
  
  .features-grid {
    grid-template-columns: repeat(4, 1fr); // 4列一行
    gap: 8px; // 减少间距
    margin-top: 20px;
  }
  
  .feature-card {
    padding: 15px 8px; // 大幅减少内边距
    border-radius: 8px;
  }
  
  .feature-icon {
    margin-bottom: 8px; // 减少图标间距
    
    .el-icon {
      font-size: 28px; // 减小图标
    }
  }
  
  .feature-title {
    font-size: 0.85rem; // 减小标题
    margin-bottom: 5px;
    white-space: nowrap; // 不换行
  }
  
  .feature-desc {
    display: none; // 隐藏描述文字
  }
}

// 简约级别卡片样式 - 已统一底色与Hover
.level-card-minimal {
  .level-icon-minimal {
    font-size: 40px;
    margin-bottom: 20px;
    color: var(--secondary-color);
    transition: var(--transition);
  }
  
  // 针对不同级别的细微区分
  &.level-国家级 {
    .level-icon-minimal { color: #d4af37; } // 金色
  }
  &.level-省级 {
    .level-icon-minimal { color: #a8a8a8; } // 银色
  }
  &.level-市级 {
    .level-icon-minimal { color: #b08d57; } // 铜色
  }

  &:hover {
    .level-icon-minimal {
      transform: scale(1.1);
      color: var(--primary-color);
    }
  }
}

// 超小屏幕优化
@media (max-width: 480px) {
  .features-grid {
    gap: 6px;
  }
  
  .feature-card {
    padding: 12px 6px;
  }
  
  .feature-icon .el-icon {
    font-size: 24px;
  }
  
  .feature-title {
    font-size: 0.75rem;
  }
}

// 皮影装饰
.piying-decoration {
  position: fixed;
  bottom: 0;
  width: 160px;
  height: auto;
  opacity: 0.82;
  pointer-events: none;
  z-index: 10;
  filter: drop-shadow(2px 4px 8px rgba(0,0,0,0.18));
}

.piying-right {
  right: 24px;
}

.piying-left {
  left: 24px;
  transform: scaleX(-1);
}

@media (max-width: 768px) {
  .piying-decoration {
    width: 100px;
  }
  .piying-right { right: 12px; }
  .piying-left  { left: 12px; }
}
</style>
