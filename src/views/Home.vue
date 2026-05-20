<template>
  <div class="home-page ink-wash-bg">
    <!-- 轮播图 + 公告栏横向布局 -->
    <section class="hero-wrapper container">
      <!-- 左侧：轮播图 -->
      <div class="hero-carousel-area">
        <el-carousel 
          :interval="5000" 
          :height="isMobile ? '220px' : '460px'"
          arrow="hover"
          indicator-position="inside"
          :autoplay="true"
          :loop="true"
        >
          <el-carousel-item v-for="(item, idx) in carouselItems" :key="item.id">
            <div
              class="carousel-item"
              :class="{ 'carousel-clickable': item.linkUrl }"
              @click="handleCarouselClick(item)"
            >
              <!-- 底层：模糊拉伸填充背景，消除黑边 -->
              <div
                class="carousel-bg-blur"
                :style="{ backgroundImage: `url(${item.imageUrl || 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1920&q=80'})` }"
              ></div>
              <!-- 前景：第一张高优先加载，其余懒加载 -->
              <img
                class="carousel-img"
                :src="item.imageUrl || 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1920&q=80'"
                :alt="item.title || ''"
                :fetchpriority="idx === 0 ? 'high' : 'low'"
                :loading="idx === 0 ? 'eager' : 'lazy'"
              />
            </div>
          </el-carousel-item>
        </el-carousel>
      </div>

      <!-- 右侧：书签式快捷导航 -->
      <div class="quick-nav-sidebar">
        <div class="bookmark-list">

          <div class="bookmark-item bookmark-quiz" @click="$router.push('/quiz')">
            <div class="bookmark-tab">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 2.38 1.19 4.47 3 5.74V17h8v-2.26A7 7 0 0 0 19 9c0-3.87-3.13-7-7-7zM9 21h6v-2H9v2zm2-6h2v-2.08A5 5 0 0 0 7 9a5 5 0 0 0 5-5 5 5 0 0 0 5 5 5.002 5.002 0 0 0-3.99 4.92H11v.08z" fill="currentColor"/>
                <circle cx="12" cy="9" r="3" fill="currentColor" opacity="0.5"/>
              </svg>
            </div>
            <div class="bookmark-body">
              <span class="bookmark-title">知识测验</span>
              <span class="bookmark-desc">挑战非遗知识，测测你知多少</span>
            </div>
            <div class="bookmark-corner"></div>
          </div>

          <div class="bookmark-item bookmark-ai" @click="$router.push('/ai-chat')">
            <div class="bookmark-tab">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z" fill="currentColor"/>
              </svg>
            </div>
            <div class="bookmark-body">
              <span class="bookmark-title">AI 问答</span>
              <span class="bookmark-desc">智能助手解答非遗相关问题</span>
            </div>
            <div class="bookmark-corner"></div>
          </div>

          <div class="bookmark-item bookmark-map" @click="$router.push('/category?tab=region')">
            <div class="bookmark-tab">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5S10.62 6.5 12 6.5s2.5 1.12 2.5 2.5S13.38 11.5 12 11.5z" fill="currentColor"/>
              </svg>
            </div>
            <div class="bookmark-body">
              <span class="bookmark-title">非遗地图</span>
              <span class="bookmark-desc">探索各地非遗项目的地域分布</span>
            </div>
            <div class="bookmark-corner"></div>
          </div>

          <div class="bookmark-item bookmark-collection" @click="$router.push('/digital-collection')">
            <div class="bookmark-tab">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M21 3H3c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h18c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H3V5h18v14zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z" fill="currentColor"/>
              </svg>
            </div>
            <div class="bookmark-body">
              <span class="bookmark-title">数字藏品</span>
              <span class="bookmark-desc">珍稀非遗文物数字化收藏展览</span>
            </div>
            <div class="bookmark-corner"></div>
          </div>

          <div class="bookmark-item bookmark-bomb" @click="$router.push('/bomb')">
            <div class="bookmark-tab">
              <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="11" cy="13" r="7" fill="currentColor" opacity="0.9"/>
                <path d="M14 6.5l2-3M16 6l2.5-1.5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                <circle cx="18.5" cy="4" r="1.5" fill="currentColor" opacity="0.7"/>
              </svg>
            </div>
            <div class="bookmark-body">
              <span class="bookmark-title">非遗炸弹 <span class="bookmark-badge">NEW</span></span>
              <span class="bookmark-desc">逼 AI 说出秘密项目名，5次机会</span>
            </div>
            <div class="bookmark-corner"></div>
          </div>

        </div>
      </div>
    </section>

    <!-- 横向滚动图片带 -->
    <template v-if="sidebarAllItems.length">
      <div class="marquee-section">
        <div class="marquee-label">
          <span class="marquee-label-line"></span>
          <span class="marquee-label-text">非遗风采</span>
          <span class="marquee-label-line"></span>
        </div>
        <div class="marquee-stage">
          <div class="marquee-fade marquee-fade-left"></div>
          <div class="marquee-fade marquee-fade-right"></div>
          <div class="marquee-row">
            <div class="marquee-track">
              <div
                v-for="item in sidebarAllItems"
                :key="'m1-' + item._fillIdx"
                class="marquee-item"
                @click="goToDetail(item.id)"
              >
                <div class="marquee-card">
                  <img :src="item.sideImageUrl" :alt="item.name" loading="lazy" />
                  <div class="marquee-card-overlay">
                    <span class="marquee-card-name">{{ item.name }}</span>
                  </div>
                </div>
              </div>
              <div
                v-for="item in sidebarAllItems"
                :key="'m1c-' + item._fillIdx"
                class="marquee-item"
                @click="goToDetail(item.id)"
              >
                <div class="marquee-card">
                  <img :src="item.sideImageUrl" :alt="item.name" loading="lazy" />
                  <div class="marquee-card-overlay">
                    <span class="marquee-card-name">{{ item.name }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- 热门项目 -->
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
        <div class="notice-board notice-board-featured">
          <!-- 标题栏 -->
          <div class="notice-board-header">
            <div class="notice-board-title-wrap">
              <span class="notice-board-line"></span>
              <h3 class="notice-board-title">平台公告</h3>
            </div>
            <span class="notice-count-badge">{{ notices.length }} 条</span>
          </div>
          <!-- 空状态 -->
          <div v-if="notices.length === 0" class="notice-empty">
            <span>暂无公告</span>
          </div>
          <!-- 公告列表 -->
          <div class="notice-list" v-else>
            <div
              class="notice-item"
              v-for="(notice, index) in notices"
              :key="notice.id"
              :class="{ 'notice-item-clickable': notice.content }"
              @click="notice.content && openNotice(notice)"
            >
              <span class="notice-index" :class="index < 3 ? 'notice-index-hot' : ''">{{ index + 1 }}</span>
              <div class="notice-main">
                <div class="notice-top-row">
                  <span class="notice-tag" :class="notice.type">{{ notice.tag }}</span>
                  <p class="notice-title">{{ notice.title }}</p>
                </div>
                <div class="notice-meta">
                  <span class="notice-date">{{ notice.date }}</span>
                  <span v-if="notice.content" class="notice-read-more">查看详情 ›</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 公告详情弹窗 -->
        <el-dialog
          v-model="noticeDialogVisible"
          width="580px"
          class="notice-detail-dialog"
          :show-close="true"
          :append-to-body="false"
          align-center
        >
          <template #header>
            <div class="notice-dialog-header">
              <div class="notice-dialog-tag-row">
                <el-tag :type="currentNotice.type" size="small" effect="light">{{ currentNotice.tag }}</el-tag>
                <span class="notice-dialog-date">
                  <el-icon style="margin-right:3px;vertical-align:-2px"><Calendar /></el-icon>{{ currentNotice.date }}
                </span>
              </div>
              <h2 class="notice-dialog-title">{{ currentNotice.title }}</h2>
            </div>
          </template>
          <div class="notice-detail-body">
            <div class="notice-detail-content">{{ currentNotice.content }}</div>
          </div>
          <template #footer>
            <el-button @click="noticeDialogVisible = false" style="width:100px">关 闭</el-button>
          </template>
        </el-dialog>
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
          <el-tab-pane label="按地域" name="region">
            <div class="region-map-container">
              <ChinaMap
                ref="homeMapRef"
                v-model="homeMapRegion"
                :region-count-map="geoRegionCountMap"
                @change="handleRegionMapSelect"
              />
            </div>
          </el-tab-pane>

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

  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import request from '@/api/request'
import { useHeritageStore } from '@/stores/heritage'
import HeritageCard from '@/components/heritage/HeritageCard.vue'
import ChinaMap from '@/components/common/ChinaMap.vue'
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
  Pear,
  Calendar
} from '@element-plus/icons-vue'

const router = useRouter()
const heritageStore = useHeritageStore()

const searchKeyword = ref('')
const activeTab = ref('region')
const featuredItems = ref([])

// 公告栏数据（从后端接口加载）
const notices = ref([])
const noticeDialogVisible = ref(false)
const currentNotice = ref({})

const openNotice = (notice) => {
  currentNotice.value = notice
  noticeDialogVisible.value = true
}

const loadNotices = async () => {
  try {
    const backendBase = `${window.location.origin}/api`
    const res = await axios.get(`${backendBase}/announcement/list`)
    if (res.data?.code === 200 && Array.isArray(res.data.data)) {
      notices.value = res.data.data.map(item => ({
        id: item.id,
        tag: item.tag,
        type: item.type,
        title: item.title,
        content: item.content || '',
        date: item.pubDate || ''
      }))
    }
  } catch {
    // 接口失败时保持空列表，不影响页面
  }
}

// 轮播图数据（优先从 Banner 接口读取，失败则用非遗项目）
const carouselItems = ref([])

// 轮播图缓存 key 与 TTL（30 分钟）
const BANNER_CACHE_KEY      = 'banner_list_cache'
const BANNER_CACHE_TIME_KEY = 'banner_list_cache_time'
const BANNER_CACHE_TTL      = 30 * 60 * 1000

const readBannerCache = () => {
  try {
    const time = parseInt(localStorage.getItem(BANNER_CACHE_TIME_KEY) || '0', 10)
    if (Date.now() - time > BANNER_CACHE_TTL) return null
    const raw = localStorage.getItem(BANNER_CACHE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

const writeBannerCache = (data) => {
  try {
    localStorage.setItem(BANNER_CACHE_KEY, JSON.stringify(data))
    localStorage.setItem(BANNER_CACHE_TIME_KEY, String(Date.now()))
  } catch {
    // 容量不足时忽略
  }
}

const loadBanners = async () => {
  // 先读缓存
  const cached = readBannerCache()
  if (cached && cached.length > 0) {
    carouselItems.value = cached
    return true
  }
  try {
    const res = await request.get('/banner/list')
    const list = Array.isArray(res) ? res : (res?.data || [])
    if (list.length > 0) {
      const mapped = list.map(b => ({
        id: b.id,
        imageUrl: b.imageUrl,
        linkUrl: b.linkUrl || null,
        title: b.title || '',
        slideInterval: b.interval || 5000
      }))
      carouselItems.value = mapped
      writeBannerCache(mapped)
      return true
    }
  } catch (e) {
    // Banner 接口不可用，静默降级
  }
  return false
}

// 分类数据（动态计算）
const categories = ref([])

const regions = ref([])

const levels = ref([])

// 响应式：是否手机端
const isMobile = ref(window.innerWidth <= 768)
const onResize = () => { isMobile.value = window.innerWidth <= 768 }
window.addEventListener('resize', onResize)
onUnmounted(() => window.removeEventListener('resize', onResize))

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

// 修复图片 URL：将 localhost:port 替换为当前访问的主机（含端口），解决手机端/远程访问无法加载的问题
const fixImageUrl = (url) => {
  if (!url || typeof url !== 'string') return url
  try {
    const parsed = new URL(url)
    const currentHost = window.location.hostname
    const isLocalPage = ['localhost', '127.0.0.1'].includes(currentHost)
    if (parsed.hostname === 'localhost' && !isLocalPage) {
      return `${window.location.origin}${parsed.pathname}${parsed.search}`
    }
  } catch {
    return url
  }
  return url
}

const getSidebarImageUrl = (item) => {
  const image = item?.sidebarImage || item?.sidebar_image
  return image ? fixImageUrl(image) : null
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
    description: '图片、视频、音频、多维度AI化，立体化感受非遗文化',
    icon: 'VideoCamera'
  },
  {
    title: '互动交流',
    description: '点赞、收藏、评论，与非遗文化零距离接触',
    icon: 'ChatDotRound'
  },
  {
    title: '知识测验',
    description: '寓教于乐，在互动中学习和传承非遗知识，并获取非遗数字藏品',
    icon: 'TrophyBase'
  }
])

// 侧栏图项目列表
const sidebarAllItems = ref([])

// ─── 首页计算结果缓存（热门项目 + 非遗风采），TTL 30 分钟 ────────────────────
const HOME_CACHE_KEY      = 'home_computed_cache_v3'
const HOME_CACHE_TIME_KEY = 'home_computed_cache_time_v3'
const HOME_CACHE_TTL      = 30 * 60 * 1000

const readHomeCache = () => {
  try {
    const time = parseInt(localStorage.getItem(HOME_CACHE_TIME_KEY) || '0', 10)
    if (Date.now() - time > HOME_CACHE_TTL) return null
    const raw = localStorage.getItem(HOME_CACHE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

const writeHomeCache = (data) => {
  try {
    localStorage.setItem(HOME_CACHE_KEY, JSON.stringify(data))
    localStorage.setItem(HOME_CACHE_TIME_KEY, String(Date.now()))
  } catch {
    // 容量不足时忽略
  }
}

// 从列表数据计算首页展示内容，并写入缓存
const computeAndCacheHomeData = (list, bannerLoaded) => {
  const categoryIcons = {
    '传统技艺': 'Brush', '传统戏剧': 'Film', '传统美术': 'Picture',
    '传统音乐': 'Headset', '民俗': 'Calendar', '传统医药': 'FirstAidKit'
  }
  const validList = list.filter(item =>
    item && validateId(item.id) !== null &&
    typeof item.name === 'string' && item.name.trim().length > 0
  )
  const sortedByHot = [...validList].sort((a, b) => (b.views || 0) - (a.views || 0))
  const featured = sortedByHot.slice(0, 6)

  if (!bannerLoaded && featured.length > 0) {
    const remainingList = validList.filter(item => !featured.find(f => f.id === item.id))
    const shuffled = shuffleArray(remainingList.length >= 3 ? remainingList : validList)
    carouselItems.value = shuffled.slice(0, 3).map(item => ({
      id: item.id,
      imageUrl: fixImageUrl(validateImageUrl(item.thumbnail)),
      linkUrl: `/heritage/${item.id}`,
      title: sanitizeText(item.name || '')
    }))
  }

  const categoryCount = {}, regionCount = {}, levelCount = {}
  validList.forEach(item => {
    if (item.category && typeof item.category === 'string')
      categoryCount[item.category] = (categoryCount[item.category] || 0) + 1
    if (item.region && typeof item.region === 'string' && /^[\u4e00-\u9fa5]+$/.test(item.region))
      regionCount[item.region] = (regionCount[item.region] || 0) + 1
    if (item.level && typeof item.level === 'string' && ['国家级', '省级', '市级'].includes(item.level))
      levelCount[item.level] = (levelCount[item.level] || 0) + 1
  })

  const categoriesData = Object.keys(categoryCount).map(name => ({
    name: sanitizeText(name), count: categoryCount[name] || 0, icon: categoryIcons[name] || 'Star'
  }))
  const regionsData = Object.keys(regionCount).map(name => ({
    name: sanitizeText(name), count: regionCount[name] || 0, fullPinyin: getFullPinyin(name)
  }))
  const levelsData = Object.keys(levelCount).map(name => ({
    name: sanitizeText(name), count: levelCount[name] || 0
  }))

  const rawSidebar = validList
    .map(item => {
      const sideImageUrl = getSidebarImageUrl(item)
      return { ...item, sidebarImage: sideImageUrl, sideImageUrl }
    })
    .filter(item => item.sideImageUrl)
  const minCount = 20
  const sidebarData = []
  if (rawSidebar.length > 0) {
    for (let i = 0; i < Math.max(minCount, rawSidebar.length); i++) {
      const src = rawSidebar[i % rawSidebar.length]
      sidebarData.push({ ...src, _fillIdx: i })
    }
  }

  // 写入响应式数据
  featuredItems.value  = featured
  categories.value     = categoriesData
  regions.value        = regionsData
  levels.value         = levelsData
  sidebarAllItems.value = sidebarData

  // 写入 localStorage 缓存
  writeHomeCache({ featured, categoriesData, regionsData, levelsData, sidebarData })
}

// 获取热门项目和统计数据
onMounted(async () => {
  loadNotices()

  // ① 优先从 Banner 管理接口加载轮播图（含 localStorage 缓存）
  const bannerLoaded = await loadBanners()

  // 对第一张轮播图动态注入 <link rel="preload">，让浏览器提前下载大图
  if (carouselItems.value.length > 0 && carouselItems.value[0].imageUrl) {
    const existingPreload = document.querySelector('link[data-carousel-preload]')
    if (!existingPreload) {
      const link = document.createElement('link')
      link.rel = 'preload'
      link.as = 'image'
      link.href = carouselItems.value[0].imageUrl
      link.setAttribute('data-carousel-preload', '1')
      document.head.appendChild(link)
    }
  }

  // ② 尝试从 localStorage 读取首页计算结果缓存（热门项目 + 非遗风采）
  const homeCache = readHomeCache()
  if (homeCache) {
    featuredItems.value   = homeCache.featured       || []
    categories.value      = homeCache.categoriesData || []
    regions.value         = homeCache.regionsData    || []
    levels.value          = homeCache.levelsData     || []
    sidebarAllItems.value = homeCache.sidebarData    || []
  } else {
    try {
      const list = await heritageStore.fetchHeritageList()
      if (!Array.isArray(list)) return
      computeAndCacheHomeData(list, bannerLoaded)
    } catch (error) {
      console.error('Error loading heritage data:', error)
    }
  }

  // 默认激活"按地域"Tab，页面加载后触发地图 resize 确保正常渲染
  nextTick(() => {
    homeMapRef.value?.resize()
  })
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
  }
}

// 轮播图点击跳转：支持自定义 linkUrl 或降级到详情页
const handleCarouselClick = (item) => {
  if (!item.linkUrl) return
  // 站内路由（/开头）
  if (item.linkUrl.startsWith('/')) {
    router.push(item.linkUrl)
  } else {
    // 外链
    window.open(item.linkUrl, '_blank')
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

// 地图热力数据（GeoJSON全名 → 数量）
const geoRegionCountMap = computed(() => {
  const map = {}
  regions.value.forEach(r => {
    const fullName = REGION_NAME_MAP[r.name] || r.name
    map[fullName] = r.count
  })
  return map
})

// 当前选中的地域（仅用于地图高亮，不影响其他筛选）
const homeMapRegion = ref('')
const homeMapRef = ref(null)

const handleRegionMapSelect = (regionShort) => {
  if (regionShort) {
    goToCategory('region', regionShort)
  }
}

const handleTabClick = (tab) => {
  if ((tab.paneName ?? tab?.props?.name) === 'region') {
    nextTick(() => {
      homeMapRef.value?.resize()
    })
  }
}



</script>

<style lang="scss" scoped>
.home-page {
  min-height: 100vh;

}

// 轮播图 + 快捷导航横向区域
.hero-wrapper {
  padding: 0 0 10px;
  display: flex;
  gap: 20px;
  align-items: stretch;
}

.hero-carousel-area {
  flex: 1 1 0;
  min-width: 0;
  border-radius: 12px;
  overflow: hidden;
}

// 轮播图右侧：快捷导航侧栏
.quick-nav-sidebar {
  width: 280px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

// 轮播图区域
.hero-section {
  margin-top: 0px; 
  height: 100%;
  
  :deep(.el-carousel) {
    height: 100% !important;
    .el-carousel__container {
      height: 460px !important;
    }
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
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  cursor: pointer;
}

// 底层模糊背景已无需显示
.carousel-bg-blur {
  display: none;
}

// 前景：图片强制填满轮播区域
.carousel-img {
  position: absolute;
  inset: 0;
  z-index: 1;
  width: 100%;
  height: 100%;
  object-fit: fill;
  display: block;
}

.carousel-overlay {
  display: none;
}

.carousel-content {
  display: none;
}

.carousel-title {
  display: none;
}

.carousel-desc {
  display: none;
}

.carousel-btn {
  display: none;
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

.region-map-container {
  background: #fff;
  border: 1px solid #e8dfc5;
  border-radius: 10px;
  padding: 16px 20px;
  height: 520px;
  display: flex;
  flex-direction: column;
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

// 书签式快捷导航
.bookmark-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  height: 100%;
  justify-content: center;
}

.bookmark-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0;
  cursor: pointer;
  border-radius: 0 10px 10px 0;
  overflow: visible;
  transition: transform 0.22s cubic-bezier(.34,1.56,.64,1), box-shadow 0.2s;
  box-shadow: 2px 4px 14px rgba(0,0,0,0.10);

  &:hover {
    transform: translateX(6px);
    box-shadow: 4px 8px 24px rgba(0,0,0,0.18);

    .bookmark-corner {
      opacity: 1;
    }
  }
}

// 左侧彩色书签标签（折角竖条）
.bookmark-tab {
  width: 52px;
  min-width: 52px;
  align-self: stretch;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 6px 0 0 6px;
  padding: 10px 0;

  svg {
    width: 26px;
    height: 26px;
    color: #fff;
  }
}

// 主体内容区
.bookmark-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 4px;
  padding: 14px 16px 14px 14px;
  background: #fff;
  border-radius: 0 10px 10px 0;
  border-top: 1px solid rgba(0,0,0,0.06);
  border-right: 1px solid rgba(0,0,0,0.06);
  border-bottom: 1px solid rgba(0,0,0,0.06);
  min-height: 68px;
}

// 右上角折角装饰
.bookmark-corner {
  position: absolute;
  top: 0;
  right: 0;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 16px 16px 0;
  border-color: transparent rgba(0,0,0,0.06) transparent transparent;
  border-radius: 0 10px 0 0;
  opacity: 0;
  transition: opacity 0.2s;
}

.bookmark-title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1.2;
}

.bookmark-desc {
  font-size: 0.72rem;
  color: var(--text-light);
  line-height: 1.5;
}

// 各书签颜色
.bookmark-quiz .bookmark-tab       { background: linear-gradient(160deg, #f39c12, #e67e22); }
.bookmark-ai .bookmark-tab         { background: linear-gradient(160deg, #9b59b6, #8e44ad); }
.bookmark-map .bookmark-tab        { background: linear-gradient(160deg, #2ecc71, #27ae60); }
.bookmark-collection .bookmark-tab { background: linear-gradient(160deg, #e74c3c, #c0392b); }
.bookmark-bomb .bookmark-tab       { background: linear-gradient(160deg, #2c3e50, #1a1a2e); }

// hover 时主体顶部边框变色呼应
.bookmark-quiz:hover .bookmark-body       { border-top-color: #e67e22; border-left: 2px solid #e67e22; }
.bookmark-ai:hover .bookmark-body         { border-top-color: #8e44ad; border-left: 2px solid #8e44ad; }
.bookmark-map:hover .bookmark-body        { border-top-color: #27ae60; border-left: 2px solid #27ae60; }
.bookmark-collection:hover .bookmark-body { border-top-color: #c0392b; border-left: 2px solid #c0392b; }
.bookmark-bomb:hover .bookmark-body       { border-top-color: #2c3e50; border-left: 2px solid #2c3e50; }

// NEW 徽章
.bookmark-badge {
  display: inline-block;
  font-size: 0.6rem;
  font-weight: 700;
  background: linear-gradient(135deg, #ff6b35, #f7c59f);
  color: #fff;
  padding: 1px 5px;
  border-radius: 4px;
  vertical-align: middle;
  margin-left: 4px;
  letter-spacing: 0.5px;
}

// 热门项目
.featured-section {
  padding: 60px 0;
}

.featured-layout {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 24px;
  align-items: start;
}

.featured-main {
  min-width: 0;
}

// 热门项目右侧公告栏
.notice-board-featured {
  position: sticky;
  top: 80px;
}

.notice-board-title {
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 4px;
  padding-bottom: 12px;
  border-bottom: 2px solid var(--primary-color);
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
  padding: 0;
  box-shadow: var(--shadow-sm);
  border: 1px solid rgba(0,0,0,.07);
  overflow: hidden;
}

.notice-board-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 18px 13px;
  background: #fafafa;
  border-bottom: 1px solid rgba(0,0,0,.07);
}

.notice-board-title-wrap {
  display: flex;
  align-items: center;
  gap: 10px;
}

.notice-board-line {
  width: 3px;
  height: 16px;
  border-radius: 2px;
  background: var(--primary-color);
  display: inline-block;
}

.notice-board-title {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
  letter-spacing: 0.3px;
}

.notice-count-badge {
  background: #f5f5f5;
  color: #888;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 999px;
  border: 1px solid #e8e8e8;
}

.notice-empty {
  padding: 40px 0;
  text-align: center;
  color: #bbb;
  font-size: 13px;
}

.notice-list {
  display: flex;
  flex-direction: column;
}

.notice-item {
  display: flex;
  align-items: flex-start;
  gap: 11px;
  padding: 11px 18px;
  border-bottom: 1px solid rgba(0,0,0,.05);
  cursor: default;
  transition: background .15s;

  &:last-child { border-bottom: none; }
  &:hover { background: #fafafa; }
}

.notice-item-clickable {
  cursor: pointer;
  &:hover {
    background: rgba(192,57,43,.04) !important;
    .notice-read-more { color: var(--primary-color); }
  }
}

.notice-index {
  flex-shrink: 0;
  width: 18px;
  height: 18px;
  border-radius: 3px;
  background: #f0f0f0;
  color: #aaa;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 3px;
}

.notice-index-hot {
  background: var(--primary-color);
  color: #fff;
}

.notice-main { flex: 1; min-width: 0; }

.notice-top-row {
  display: flex;
  align-items: flex-start;
  gap: 7px;
  margin-bottom: 4px;
}

.notice-tag {
  flex-shrink: 0;
  font-size: 10px;
  font-weight: 600;
  padding: 1px 5px;
  border-radius: 3px;
  margin-top: 2px;

  &.info    { background: #eff6ff; color: #3b82f6; }
  &.primary { background: #fff1f0; color: #c0392b; }
  &.success { background: #f0fdf4; color: #16a34a; }
  &.warning { background: #fffbeb; color: #d97706; }
  &.danger  { background: #fff1f0; color: #dc2626; }
}

.notice-title {
  font-size: 13px;
  color: var(--text-primary);
  line-height: 1.55;
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.notice-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.notice-date {
  font-size: 11px;
  color: #bbb;
}

.notice-read-more {
  font-size: 11px;
  color: #ccc;
  transition: color .15s;
  white-space: nowrap;
}

// 弹窗：详情页精细化
:deep(.notice-detail-dialog) {
  .el-dialog {
    background: #fdf6e3;
    border-radius: 4px;
    overflow: hidden;
    box-shadow: 4px 8px 28px rgba(120, 90, 40, 0.20), 0 1px 4px rgba(0,0,0,0.08);
  }
  .el-dialog__header {
    padding: 0;
    margin: 0;
    background: #fdf6e3;
  }
  .el-dialog__body {
    padding: 0;
    background: #fdf6e3;
  }
  .el-dialog__footer {
    padding: 8px 28px 22px;
    text-align: center;
    background: #fdf6e3;
    border-top: 1px dashed #d9c89a;
  }
  .el-dialog__headerbtn .el-icon {
    color: #9a7c4f;
    &:hover { color: #6b4f2a; }
  }
  .el-tag {
    border: none;
  }
}

.notice-dialog-header {
  padding: 26px 28px 18px;
  border-bottom: 1px dashed #d9c89a;
  background: transparent;
  position: relative;

  // 左侧书签竖线
  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    background: linear-gradient(to bottom, #b5883a, #d4a85c);
    border-radius: 0 2px 2px 0;
  }
}

.notice-dialog-tag-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.notice-dialog-date {
  font-size: 12px;
  color: #a08050;
  display: flex;
  align-items: center;
}

.notice-dialog-title {
  font-size: 18px;
  font-weight: 700;
  color: #3d2c0e;
  line-height: 1.6;
  margin: 0;
  letter-spacing: 0.5px;
  font-family: "SimSun", "STSong", serif;
}

.notice-detail-body {
  padding: 22px 28px 26px;
  background: #fdf6e3;
}

.notice-detail-content {
  font-size: 14px;
  line-height: 2;
  color: #4a3520;
  white-space: pre-wrap;
  word-break: break-word;
  max-height: 52vh;
  overflow-y: auto;
  font-family: "SimSun", "STSong", serif;
  position: relative;
  z-index: 1;

  &::-webkit-scrollbar { width: 4px; }
  &::-webkit-scrollbar-thumb { background: #c9a96e; border-radius: 2px; }
  &::-webkit-scrollbar-track { background: transparent; }
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
    margin-top: 60px; /* 移动端 header 高度 */
    padding: 0;
    
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
  
  // 书签导航（手机端）
  .bookmark-list {
    gap: 8px;
    justify-content: flex-start;
  }

  .bookmark-tab {
    width: 42px;
    min-width: 42px;
    svg { width: 20px; height: 20px; }
  }

  .bookmark-body {
    min-height: 56px;
    padding: 10px 12px 10px 12px;
  }

  .bookmark-title { font-size: 0.9rem; }
  .bookmark-desc  { display: none; }



  // 热门项目
  .featured-section {
    padding: 30px 0;
  }

  .hero-wrapper {
    flex-direction: column;
    gap: 12px;
  }

  .quick-nav-sidebar {
    width: 100%;
    justify-content: flex-start;
  }

  .notice-board {
    position: static;
  }

  .featured-layout {
    display: block;
  }

  .notice-board-featured {
    position: static;
    margin-top: 24px;
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





// 横向滚动图片带
@keyframes marqueeLeft {
  0%   { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

.marquee-section {
  width: 100%;
  padding: 32px 0 28px;
  background: linear-gradient(135deg, #fdf6ee 0%, #f5ede0 50%, #fdf6ee 100%);
  border-top: 1px solid rgba(192,57,43,0.1);
  border-bottom: 1px solid rgba(192,57,43,0.1);
}

// 标题行
.marquee-label {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-bottom: 20px;
}

.marquee-label-text {
  font-size: 0.85rem;
  font-weight: 600;
  letter-spacing: 6px;
  color: #c0392b;
  text-transform: uppercase;
  white-space: nowrap;
}

.marquee-label-line {
  flex: 1;
  max-width: 120px;
  height: 1px;
  background: linear-gradient(to right, transparent, rgba(192,57,43,0.35));

  &:last-child {
    background: linear-gradient(to left, transparent, rgba(192,57,43,0.35));
  }
}

// 滚动舞台（含渐变遮罩）
.marquee-stage {
  position: relative;
  overflow: hidden;
}

.marquee-fade {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 80px;
  z-index: 2;
  pointer-events: none;

  &.marquee-fade-left {
    left: 0;
    background: linear-gradient(to right, #fdf6ee, transparent);
  }
  &.marquee-fade-right {
    right: 0;
    background: linear-gradient(to left, #fdf6ee, transparent);
  }
}

.marquee-row {
  overflow: hidden;
  width: 100%;
}

.marquee-track {
  display: flex;
  flex-direction: row;
  gap: 12px;
  will-change: transform;
  width: max-content;
  animation: marqueeLeft 50s linear infinite;
  padding: 8px 0 12px;

  &:hover {
    animation-play-state: paused;
  }
}

.marquee-item {
  cursor: pointer;
  flex-shrink: 0;
}

.marquee-card {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 4px 14px rgba(0,0,0,0.12);
  transition: transform 0.28s cubic-bezier(.34,1.56,.64,1), box-shadow 0.25s;

  img {
    width: 110px;
    height: 90px;
    object-fit: cover;
    display: block;
    transition: transform 0.35s ease;
  }

  &:hover {
    transform: translateY(-6px) scale(1.04);
    box-shadow: 0 12px 28px rgba(0,0,0,0.22);

    img { transform: scale(1.08); }

    .marquee-card-overlay { opacity: 1; }
  }
}

// 悬浮名称遮罩
.marquee-card-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.65) 0%, transparent 55%);
  display: flex;
  align-items: flex-end;
  padding: 8px 7px;
  opacity: 0;
  transition: opacity 0.25s;
}

.marquee-card-name {
  font-size: 0.68rem;
  color: #fff;
  font-weight: 600;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

@media (max-width: 768px) {
  .marquee-section {
    padding: 20px 0 16px;
  }

  .marquee-card img {
    width: 80px;
    height: 68px;
  }

  .marquee-fade {
    width: 40px;
  }
}
</style>

