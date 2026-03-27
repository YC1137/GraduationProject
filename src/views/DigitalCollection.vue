<template>
  <div class="dc-page">

    <!-- ===== 顶部 Banner ===== -->
    <section class="dc-banner">
      <div class="dc-banner-bg"></div>
      <div class="dc-banner-particles">
        <span v-for="i in 18" :key="i" class="particle" :style="particleStyle(i)"></span>
      </div>
      <div class="container dc-banner-inner">
        <div class="dc-banner-left">
          <div class="dc-banner-eyebrow">NON-HERITAGE DIGITAL COLLECTION</div>
          <h1 class="dc-banner-title">非遗数字藏品</h1>
          <p class="dc-banner-sub">完成知识测验 · 铸造专属非遗数字藏品，让文化传承留存于指间</p>
          <div class="dc-banner-btns">
            <button class="dc-btn-primary" @click="scrollTo('market')">
              <span>藏品首发</span>
              <svg viewBox="0 0 20 20" fill="currentColor" width="16" height="16"><path fill-rule="evenodd" d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z" clip-rule="evenodd"/></svg>
            </button>
            <button class="dc-btn-ghost" @click="scrollTo('mine')">我的藏品</button>
          </div>
        </div>
        <div class="dc-banner-right">
          <!-- 旋转展示卡 -->
          <div class="showcase-wrap">
            <div class="showcase-card" v-for="(item, i) in showcaseItems" :key="item.id"
              :style="showcaseCardStyle(i)">
              <img :src="item.cover" :alt="item.name" />
              <div class="showcase-card-glow" :style="{ background: item.glowColor }"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 藏品首发市场 ===== -->
    <section class="dc-market container" id="market">
      <div class="dc-section-header">
        <h2 class="dc-section-title">藏品首发</h2>
        <div class="dc-tabs">
          <span :class="['dc-tab', { active: marketTab === 'upcoming' }]" @click="marketTab='upcoming'">即将开售</span>
          <span :class="['dc-tab', { active: marketTab === 'ongoing' }]" @click="marketTab='ongoing'">正在发售</span>
          <span :class="['dc-tab', { active: marketTab === 'ended' }]" @click="marketTab='ended'">已结束</span>
        </div>
      </div>

      <div class="dc-drops-grid">
        <div
          v-for="drop in currentDrops"
          :key="drop.id"
          class="dc-drop-card"
          :class="drop.rarityClass"
        >
          <div class="drop-img-wrap">
            <img :src="drop.cover" :alt="drop.name" class="drop-img" />
            <div class="drop-rarity-badge" :class="drop.rarityClass">{{ drop.rarity }}</div>
            <div class="drop-overlay"></div>
            <!-- 已获得遮罩 -->
            <div class="drop-owned-mask" v-if="isOwned(drop.id)">
              <span>✓ 已收藏</span>
            </div>
          </div>
          <div class="drop-body">
            <div class="drop-serial">系列编号：{{ drop.serial }}</div>

            <h3 class="drop-name">{{ drop.name }}</h3>
            <p class="drop-origin">{{ drop.origin }}</p>
            <div class="drop-meta">
              <div class="drop-supply">
                <span class="supply-label">发行量</span>
                <span class="supply-val">{{ drop.total }} 份</span>
              </div>
              <div class="drop-sold">
                <span class="supply-label">剩余</span>
                <span class="supply-val" :class="drop.left < 20 ? 'urgent' : ''">{{ drop.left }}</span>
              </div>
            </div>
            <!-- 进度条 -->
            <div class="drop-progress-track">
              <div class="drop-progress-fill" :class="drop.rarityClass"
                :style="{ width: ((drop.total - drop.left) / drop.total * 100) + '%' }"></div>
            </div>
            <div class="drop-footer">
              <template v-if="marketTab === 'upcoming'">
                <div class="drop-countdown">
                  <span class="countdown-label">距开售</span>
                  <span class="countdown-val">{{ drop.countdown }}</span>
                </div>
                <button class="drop-btn reminder-btn">提醒我</button>
              </template>
              <template v-else-if="marketTab === 'ongoing'">
                <button
                  class="drop-btn claim-btn"
                  :class="drop.rarityClass"
                  :disabled="isMinting || isOwned(drop.id) || !authStore.isLoggedIn"
                  @click="claimDrop(drop)"
                >
                  {{ isMinting ? '上链中...' : isOwned(drop.id) ? '已收藏' : authStore.isLoggedIn ? '立即收藏' : '登录后收藏' }}
                </button>
              </template>
              <template v-else>
                <span class="drop-ended-text">已售罄</span>
              </template>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 我的藏品 ===== -->
    <section class="dc-mine container" id="mine">
      <div class="dc-section-header">
        <h2 class="dc-section-title">我的藏品</h2>
        <div class="dc-mine-actions">
          <span class="dc-wallet-tag" v-if="authStore.isLoggedIn && authStore.currentUser?.walletAddress">
            链地址：{{ shortAddress(authStore.currentUser.walletAddress) }}
          </span>
          <span class="dc-mine-count" v-if="authStore.isLoggedIn">共 {{ myCollections.length }} 件</span>
        </div>
      </div>

      <!-- 未登录 -->
      <div class="dc-login-tip" v-if="!authStore.isLoggedIn">
        <div class="dc-login-tip-inner">
          <div class="dc-lock-icon">🔒</div>
          <p>登录后查看和管理你的数字藏品</p>
          <button class="dc-btn-primary sm" @click="$router.push('/')">立即登录</button>
        </div>
      </div>

      <!-- 空藏品 -->
      <div class="dc-empty" v-else-if="myCollections.length === 0">
        <div class="dc-empty-inner">
          <div class="dc-empty-icon">🎴</div>
          <p>还没有藏品，去完成测验或参与首发来获得吧！</p>
          <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap">
            <button class="dc-btn-primary sm" @click="$router.push('/quiz')">去做测验</button>
            <button class="dc-btn-ghost sm" @click="scrollTo('market')">首发市场</button>
          </div>
        </div>
      </div>

      <!-- 藏品列表 -->
      <div class="dc-mine-grid" v-else>
        <div
          v-for="item in myCollections"
          :key="item.itemId + '-' + item.id"
          class="dc-mine-card"
          :class="item.rarityClass"
        >
          <div class="mine-card-img-wrap">
            <img :src="item.cover" :alt="item.name" />
            <div class="mine-card-glow" :class="item.rarityClass"></div>
            <div class="mine-rarity-tag" :class="item.rarityClass">{{ item.rarity }}</div>
          </div>
          <div class="mine-card-body">
            <div class="mine-serial">份数编号：{{ item.serial }}</div>

            <h3 class="mine-name">{{ item.name }}</h3>
            <div class="mine-meta">
              <span>{{ item.origin }}</span>
              <span class="mine-source-tag" :class="item.source === 'quiz' ? 'quiz' : 'drop'">
                {{ item.source === 'quiz' ? '测验获得' : '首发收藏' }}
              </span>
            </div>
            <div class="mine-date">获得时间：{{ item.ownedAt }}</div>
            <div class="mine-chain" v-if="item.onChain">
              <span>已上链</span>
              <a :href="item.explorerUrl" target="_blank" rel="noopener noreferrer">查看交易</a>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ===== 铸造成功弹窗 ===== -->
    <transition name="dc-modal">
      <div class="dc-modal-mask" v-if="showMintModal" @click.self="showMintModal=false">
        <div class="dc-mint-modal" :class="mintedItem?.rarityClass">
          <div class="mint-bg-glow" :class="mintedItem?.rarityClass"></div>
          <div class="mint-particles">
            <span v-for="i in 20" :key="i" class="mint-particle" :style="mintParticleStyle(i)"></span>
          </div>
          <div class="mint-content">
            <div class="mint-label">🎉 恭喜获得数字藏品</div>
            <div class="mint-img-wrap">
              <img :src="mintedItem?.cover" :alt="mintedItem?.name" class="mint-img" />
              <div class="mint-img-glow" :class="mintedItem?.rarityClass"></div>
            </div>
            <div class="mint-rarity" :class="mintedItem?.rarityClass">{{ mintedItem?.rarity }}</div>
            <h2 class="mint-name">{{ mintedItem?.name }}</h2>
            <div class="mint-serial">份数编号：{{ mintedItem?.serial }}</div>

            <p class="mint-origin">{{ mintedItem?.origin }}</p>
            <div class="mint-chain" v-if="mintedItem?.onChain">
              <p>链上交易：{{ mintedItem?.txHash }}</p>
              <a :href="mintedItem?.explorerUrl" target="_blank" rel="noopener noreferrer">在 Etherscan 查看</a>
            </div>
            <button class="dc-btn-primary" @click="showMintModal=false">查看我的藏品</button>
          </div>
        </div>
      </div>
    </transition>

    <!-- ===== 测验结果触发铸造提示（从Quiz跳转带参） ===== -->
    <div class="dc-quiz-reward-tip" v-if="showQuizReward">
      <div class="qr-inner">
        <span class="qr-icon">🏆</span>
        <div>
          <strong>测验完成！</strong>
          <p>你的得分符合铸造条件，点击铸造你的专属藏品</p>
        </div>
        <button class="dc-btn-primary sm" :disabled="isMinting" @click="mintFromQuiz">{{ isMinting ? '上链中...' : '立即铸造' }}</button>
        <button class="qr-close" @click="showQuizReward=false">×</button>
      </div>
    </div>

  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { ElMessage } from 'element-plus'
import { getDigitalCollectionList, getUserDigitalAssets, mintDigitalAsset } from '../api/digitalAsset'

const route  = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const isMinting = ref(false)

const shortAddress = (address) => {
  if (!address) return ''
  return `${address.slice(0, 6)}...${address.slice(-4)}`
}

const buildTokenURI = (item) => {
  const metadata = {
    name: item.name,
    description: `${item.origin} · ${item.category} · ${item.rarity}`,
    image: item.cover,
    attributes: [
      { trait_type: '稀有度', value: item.rarity },
      { trait_type: '来源', value: item.source === 'quiz' ? '测验获得' : '首发收藏' },
      { trait_type: '编号', value: item.serial }
    ]
  }
  const json = JSON.stringify(metadata)
  return `data:application/json;base64,${window.btoa(unescape(encodeURIComponent(json)))}`
}

const mintOnChainForItem = async (item) => {
  const tokenUri = buildTokenURI(item)
  return await mintDigitalAsset({
    userId: authStore.currentUser?.userId,
    itemId: item.id,
    name: item.name,
    serial: item.serial,
    origin: item.origin,
    cover: item.cover,
    rarity: item.rarity,
    rarityClass: item.rarityClass,
    source: item.source,
    ownedAt: new Date().toLocaleDateString('zh-CN'),
    tokenUri
  })
}

const marketItems = ref([])

const loadMarketCollections = async () => {
  try {
    const list = await getDigitalCollectionList()
    marketItems.value = (list || []).map(item => ({
      ...item,
      source: 'drop'
    }))
  } catch {
    marketItems.value = []
  }
}

// ── 首发市场分组 ──────────────────────────────────────────────
const drops = computed(() => ({
  upcoming: marketItems.value.filter(i => i.saleStatus === 'upcoming'),
  ongoing: marketItems.value.filter(i => i.saleStatus === 'ongoing'),
  ended: marketItems.value.filter(i => i.saleStatus === 'ended')
}))

const marketTab = ref('ongoing')
const currentDrops = computed(() => drops.value[marketTab.value] || [])

// ── Banner 旋转展示 ─────────────────────────────────────────
const showcaseItems = computed(() =>
  marketItems.value.filter(i => ['legendary', 'epic'].includes(i.rarityClass)).slice(0, 3)
)

const showcaseCardStyle = (i) => {
  const angles = [-18, 4, 22]
  const zs     = [0, 10, 5]
  const xs     = [-30, 0, 28]
  return {
    transform: `rotate(${angles[i]}deg) translateX(${xs[i]}px)`,
    zIndex: zs[i],
    transition: `transform 0.6s ease ${i * 0.1}s`
  }
}

// ── 我的藏品（后端接口）──────────────────────────────────────
const myCollections = ref([])

const loadMyCollections = async () => {
  if (!authStore.isLoggedIn || !authStore.currentUser?.userId) {
    myCollections.value = []
    return
  }
  try {
    myCollections.value = await getUserDigitalAssets(authStore.currentUser.userId)
  } catch {
    myCollections.value = []
  }
}

const isOwned = (id) => myCollections.value.some(c => c.itemId === id)

// ── 首发收藏 ────────────────────────────────────────────────
const showMintModal = ref(false)
const mintedItem    = ref(null)

const claimDrop = async (drop) => {
  if (!authStore.isLoggedIn) { ElMessage.warning('请先登录'); return }
  if (isOwned(drop.id)) { ElMessage.info('你已拥有此藏品'); return }
  if (isMinting.value) { ElMessage.info('正在上链中，请稍候'); return }

  isMinting.value = true
  try {
    ElMessage.info('正在提交上链交易...')
    const minted = await mintOnChainForItem({ ...drop, source: 'drop' })

    myCollections.value.unshift(minted)
    mintedItem.value = minted
    showMintModal.value = true
    await loadMarketCollections()
    ElMessage.success('上链成功，已收藏')
  } catch (error) {
    ElMessage.error(error?.message || '上链失败，请稍后重试')
  } finally {
    isMinting.value = false
  }
}

// ── 测验结果触发铸造 ────────────────────────────────────────
const showQuizReward = ref(false)
const quizScore      = ref(0)

const mintFromQuiz = async () => {
  if (!authStore.isLoggedIn) { ElMessage.warning('请先登录'); return }
  if (isMinting.value) { ElMessage.info('正在上链中，请稍候'); return }

  let candidates = []
  if (quizScore.value >= 100)     candidates = marketItems.value.filter(i => i.rarityClass === 'legendary')
  else if (quizScore.value >= 90) candidates = marketItems.value.filter(i => i.rarityClass === 'epic')
  else if (quizScore.value >= 80) candidates = marketItems.value.filter(i => i.rarityClass === 'rare')
  else                             candidates = marketItems.value.filter(i => i.rarityClass === 'common')

  if (candidates.length === 0) { ElMessage.warning('当前暂无可铸造藏品，请联系管理员配置'); return }

  const unowned = candidates.filter(i => !isOwned(i.id))
  if (unowned.length === 0) { ElMessage.success('该稀有度藏品已全部收集！'); showQuizReward.value = false; return }

  const item = unowned[Math.floor(Math.random() * unowned.length)]

  isMinting.value = true
  try {
    ElMessage.info('正在提交上链交易...')
    const minted = await mintOnChainForItem({ ...item, source: 'quiz' })

    myCollections.value.unshift(minted)
    mintedItem.value = minted
    showMintModal.value = true
    showQuizReward.value = false
    await loadMarketCollections()
    ElMessage.success('上链成功，藏品已铸造')
  } catch (error) {
    ElMessage.error(error?.message || '上链失败，请稍后重试')
  } finally {
    isMinting.value = false
  }
}

// ── 粒子样式 ────────────────────────────────────────────────
const particleStyle = (i) => ({
  left:            `${(i * 37 + 11) % 100}%`,
  top:             `${(i * 53 + 7)  % 100}%`,
  width:           `${4 + (i % 5)}px`,
  height:          `${4 + (i % 5)}px`,
  animationDelay:  `${(i * 0.4) % 4}s`,
  animationDuration:`${3 + (i % 3)}s`,
  opacity:          0.15 + (i % 4) * 0.08
})

const mintParticleStyle = (i) => ({
  left:             `${(i * 37 + 5) % 100}%`,
  top:              `${(i * 53 + 3) % 100}%`,
  width:            `${3 + (i % 4)}px`,
  height:           `${3 + (i % 4)}px`,
  animationDelay:   `${(i * 0.15) % 1.5}s`,
})

const scrollTo = (id) => {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

watch(() => authStore.currentUser?.userId, () => {
  loadMyCollections()
}, { immediate: true })

// ── 初始化：检查从 Quiz 跳转带参 ────────────────────────────
onMounted(async () => {
  await loadMarketCollections()
  const score = parseInt(route.query.score)
  if (!isNaN(score) && score >= 60) {
    quizScore.value = score
    showQuizReward.value = true
    router.replace({ path: '/digital-collection' })
  }
})
</script>

<style scoped lang="scss">
// ═══════════════════════════════════════════
// 稀有度变量
// ═══════════════════════════════════════════
$rarity-colors: (
  common:    (#9ca3af, #f3f4f6, rgba(156,163,175,0.15)),
  rare:      (#2563eb, #dbeafe, rgba(37,99,235,0.18)),
  epic:      (#7c3aed, #ede9fe, rgba(124,58,237,0.2)),
  legendary: (#d97706, #fef3c7, rgba(217,119,6,0.22)),
);

@mixin rarity($name) {
  $c: map-get($rarity-colors, $name);
  color: nth($c, 1);
  background: nth($c, 2);
  border-color: nth($c, 1);
}

.dc-page {
  background: #0e0e14;
  min-height: 100vh;
  color: #e8e4dd;
  padding-bottom: 80px;
}

// ═══════════════════════════════════════════
// Banner
// ═══════════════════════════════════════════
.dc-banner {
  position: relative;
  min-height: 520px;
  display: flex;
  align-items: center;
  overflow: hidden;
}

.dc-banner-bg {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(ellipse 80% 60% at 20% 50%, rgba(139,58,15,0.35) 0%, transparent 60%),
    radial-gradient(ellipse 60% 80% at 80% 30%, rgba(124,58,237,0.2) 0%, transparent 55%),
    linear-gradient(160deg, #0e0e14 0%, #1a0f05 50%, #0d0d1a 100%);
}

.dc-banner-particles {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.particle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255,200,100,0.5);
  animation: floatUp 4s ease-in-out infinite;
}

@keyframes floatUp {
  0%, 100% { transform: translateY(0) scale(1); opacity: 0.2; }
  50%       { transform: translateY(-20px) scale(1.3); opacity: 0.5; }
}

.dc-banner-inner {
  position: relative;
  z-index: 2;
  display: grid;
  grid-template-columns: 1fr 420px;
  gap: 40px;
  align-items: center;
  padding: 80px 0 60px;
}

.dc-banner-eyebrow {
  font-size: 0.68rem;
  letter-spacing: 4px;
  color: rgba(255,200,100,0.6);
  margin-bottom: 14px;
}

.dc-banner-title {
  font-size: 3.2rem;
  font-weight: 800;
  background: linear-gradient(135deg, #ffd580, #ff9a3c, #c0392b);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 0 0 16px;
  line-height: 1.15;
}

.dc-banner-sub {
  font-size: 1rem;
  color: rgba(255,255,255,0.55);
  margin: 0 0 32px;
  line-height: 1.7;
}

.dc-banner-btns {
  display: flex;
  gap: 14px;
  flex-wrap: wrap;
}

// ── showcase 卡片 ──
.showcase-wrap {
  position: relative;
  height: 340px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.showcase-card {
  position: absolute;
  width: 190px;
  height: 260px;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0,0,0,0.6);
  border: 1px solid rgba(255,255,255,0.1);

  img { width: 100%; height: 100%; object-fit: cover; }
}

.showcase-card-glow {
  position: absolute;
  inset: 0;
  opacity: 0.4;
  mix-blend-mode: screen;
  pointer-events: none;
}

// ═══════════════════════════════════════════
// 通用按钮
// ═══════════════════════════════════════════
.dc-btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 28px;
  background: linear-gradient(135deg, #c0392b, #e67e22);
  color: #fff;
  border: none;
  border-radius: 999px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.2s;

  &:hover { opacity: 0.88; transform: translateY(-1px); }
  &:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }
  &.sm    { padding: 8px 20px; font-size: 0.85rem; }
}

.dc-btn-ghost {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 28px;
  background: transparent;
  color: rgba(255,255,255,0.7);
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 999px;
  font-size: 0.95rem;
  cursor: pointer;
  transition: all 0.2s;

  &:hover { border-color: rgba(255,255,255,0.5); color: #fff; }
  &.sm    { padding: 8px 20px; font-size: 0.85rem; }
}

// ═══════════════════════════════════════════
// Section 通用
// ═══════════════════════════════════════════
.dc-section-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #f5f0e8;
  margin: 0;
}

.dc-section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 12px;
}

.dc-tabs {
  display: flex;
  gap: 4px;
  background: rgba(255,255,255,0.06);
  border-radius: 999px;
  padding: 4px;
}

.dc-tab {
  padding: 6px 18px;
  border-radius: 999px;
  font-size: 0.85rem;
  color: rgba(255,255,255,0.5);
  cursor: pointer;
  transition: all 0.2s;

  &.active {
    background: rgba(255,255,255,0.12);
    color: #fff;
  }
}

// ═══════════════════════════════════════════
// 获取途径
// ═══════════════════════════════════════════
.dc-how {
  padding: 60px 0 40px;
}

.dc-how-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-top: 24px;
}

.dc-how-card {
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 16px;
  padding: 28px 24px;
  display: flex;
  gap: 20px;
  cursor: pointer;
  transition: background 0.2s, border-color 0.2s;
  position: relative;

  &:hover {
    background: rgba(255,255,255,0.07);
    border-color: rgba(255,255,255,0.18);

    .dc-how-arrow { opacity: 1; }
  }
}

.dc-how-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 1.6rem;

  svg { width: 36px; height: 36px; }

  &.quiz-icon { color: #e67e22; background: rgba(230,126,34,0.12); }
  &.drop-icon { color: #7c3aed; background: rgba(124,58,237,0.12); }
}

.dc-how-body {
  flex: 1;
  min-width: 0;

  h3 {
    font-size: 1.05rem;
    font-weight: 600;
    color: #f0ece4;
    margin: 6px 0 8px;
  }

  p {
    font-size: 0.82rem;
    color: rgba(255,255,255,0.45);
    line-height: 1.6;
    margin: 0 0 12px;
  }
}

.dc-how-badge {
  display: inline-block;
  font-size: 0.7rem;
  padding: 2px 10px;
  border-radius: 999px;
  font-weight: 600;

  &.quiz-badge { background: rgba(230,126,34,0.15); color: #e67e22; }
  &.drop-badge { background: rgba(124,58,237,0.15); color: #9b59b6; }
}

.dc-how-rewards {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.reward-tag {
  font-size: 0.7rem;
  padding: 2px 10px;
  border-radius: 999px;
  font-weight: 600;

  &.common    { background: rgba(156,163,175,0.15); color: #9ca3af; }
  &.rare      { background: rgba(37,99,235,0.15);   color: #60a5fa; }
  &.epic      { background: rgba(124,58,237,0.15);  color: #a78bfa; }
  &.legendary { background: rgba(217,119,6,0.15);   color: #fbbf24; }
}

.dc-how-arrow {
  position: absolute;
  bottom: 20px;
  right: 20px;
  font-size: 0.8rem;
  color: rgba(255,255,255,0.3);
  opacity: 0;
  transition: opacity 0.2s;
}

// ═══════════════════════════════════════════
// 首发市场
// ═══════════════════════════════════════════
.dc-market {
  padding: 20px 0 50px;
}

.dc-drops-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
}

.dc-drop-card {
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 14px;
  overflow: hidden;
  transition: transform 0.25s, border-color 0.25s;

  &:hover { transform: translateY(-4px); }

  &.rare      { border-color: rgba(37,99,235,0.25); }
  &.epic      { border-color: rgba(124,58,237,0.25); }
  &.legendary { border-color: rgba(217,119,6,0.3); }
}

.drop-img-wrap {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.drop-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s;

  .dc-drop-card:hover & { transform: scale(1.06); }
}

.drop-rarity-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  font-size: 0.68rem;
  font-weight: 700;
  padding: 3px 10px;
  border-radius: 999px;
  backdrop-filter: blur(8px);

  &.common    { background: rgba(50,50,50,0.7);   color: #d1d5db; }
  &.rare      { background: rgba(30,58,138,0.7);  color: #93c5fd; }
  &.epic      { background: rgba(76,29,149,0.7);  color: #c4b5fd; }
  &.legendary { background: rgba(120,53,15,0.7);  color: #fcd34d; }
}

.drop-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(14,14,20,0.7) 0%, transparent 50%);
}

.drop-owned-mask {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(2px);

  span {
    font-size: 1rem;
    font-weight: 700;
    color: #4ade80;
    border: 2px solid #4ade80;
    padding: 6px 20px;
    border-radius: 999px;
  }
}

.drop-body {
  padding: 14px;
}

.drop-serial {
  font-size: 0.65rem;
  color: rgba(255,255,255,0.3);
  font-family: monospace;
  margin-bottom: 4px;
}

.drop-name {
  font-size: 0.98rem;
  font-weight: 600;
  color: #f0ece4;
  margin: 0 0 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.drop-origin {
  font-size: 0.75rem;
  color: rgba(255,255,255,0.35);
  margin: 0 0 10px;
}

.drop-meta {
  display: flex;
  gap: 16px;
  margin-bottom: 8px;
}

.supply-label {
  font-size: 0.65rem;
  color: rgba(255,255,255,0.3);
  display: block;
}

.supply-val {
  font-size: 0.85rem;
  font-weight: 600;
  color: rgba(255,255,255,0.8);

  &.urgent { color: #f87171; }
}

.drop-progress-track {
  height: 4px;
  background: rgba(255,255,255,0.08);
  border-radius: 999px;
  overflow: hidden;
  margin-bottom: 12px;
}

.drop-progress-fill {
  height: 100%;
  border-radius: 999px;
  transition: width 0.6s ease;

  &.common    { background: #6b7280; }
  &.rare      { background: #2563eb; }
  &.epic      { background: #7c3aed; }
  &.legendary { background: linear-gradient(90deg, #d97706, #f59e0b); }
}

.drop-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.drop-countdown {
  display: flex;
  flex-direction: column;
  gap: 1px;
}

.countdown-label { font-size: 0.65rem; color: rgba(255,255,255,0.3); }
.countdown-val   { font-size: 0.85rem; font-weight: 600; color: #fb923c; font-family: monospace; }

.drop-btn {
  padding: 7px 16px;
  border-radius: 999px;
  font-size: 0.8rem;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: all 0.2s;

  &.reminder-btn {
    background: rgba(255,255,255,0.1);
    color: rgba(255,255,255,0.7);
    &:hover { background: rgba(255,255,255,0.18); }
  }

  &.claim-btn {
    color: #fff;
    &.common    { background: #4b5563; }
    &.rare      { background: #1d4ed8; }
    &.epic      { background: #6d28d9; }
    &.legendary { background: linear-gradient(135deg, #b45309, #d97706); }
    &:hover:not(:disabled) { filter: brightness(1.15); transform: scale(1.02); }
    &:disabled  { opacity: 0.45; cursor: not-allowed; }
  }
}

.drop-ended-text {
  font-size: 0.8rem;
  color: rgba(255,255,255,0.25);
}

// ═══════════════════════════════════════════
// 我的藏品
// ═══════════════════════════════════════════
.dc-mine {
  padding: 20px 0 40px;
}

.dc-mine-actions {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.dc-wallet-tag {
  font-size: 0.72rem;
  color: #93c5fd;
  background: rgba(37, 99, 235, 0.15);
  border: 1px solid rgba(37, 99, 235, 0.35);
  border-radius: 999px;
  padding: 3px 10px;
}

.dc-mine-count {
  font-size: 0.85rem;
  color: rgba(255,255,255,0.35);
}

.dc-login-tip, .dc-empty {
  border: 1px dashed rgba(255,255,255,0.1);
  border-radius: 16px;
  padding: 60px 20px;
  text-align: center;
}

.dc-lock-icon, .dc-empty-icon {
  font-size: 3rem;
  margin-bottom: 16px;
}

.dc-login-tip p, .dc-empty p {
  color: rgba(255,255,255,0.4);
  margin: 0 0 20px;
}

.dc-mine-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 16px;
}

.dc-mine-card {
  border-radius: 12px;
  overflow: hidden;
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.08);
  transition: transform 0.2s;

  &:hover { transform: translateY(-3px); }

  &.rare      { border-color: rgba(37,99,235,0.3); }
  &.epic      { border-color: rgba(124,58,237,0.3); }
  &.legendary { border-color: rgba(217,119,6,0.35); }
}

.mine-card-img-wrap {
  position: relative;
  height: 160px;
  overflow: hidden;

  img { width: 100%; height: 100%; object-fit: cover; }
}

.mine-card-glow {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 50%;
  pointer-events: none;

  &.rare      { background: linear-gradient(to top, rgba(37,99,235,0.3), transparent); }
  &.epic      { background: linear-gradient(to top, rgba(124,58,237,0.35), transparent); }
  &.legendary { background: linear-gradient(to top, rgba(217,119,6,0.4), transparent); }
}

.mine-rarity-tag {
  position: absolute;
  bottom: 8px;
  left: 8px;
  font-size: 0.65rem;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 999px;

  &.common    { background: rgba(50,50,50,0.8);  color: #d1d5db; }
  &.rare      { background: rgba(30,58,138,0.8); color: #93c5fd; }
  &.epic      { background: rgba(76,29,149,0.8); color: #c4b5fd; }
  &.legendary { background: rgba(120,53,15,0.8); color: #fcd34d; }
}

.mine-card-body {
  padding: 12px;
}

.mine-serial {
  font-size: 0.62rem;
  color: rgba(255,255,255,0.25);
  font-family: monospace;
  margin-bottom: 3px;
}

.mine-name {
  font-size: 0.9rem;
  font-weight: 600;
  color: #f0ece4;
  margin: 0 0 5px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.mine-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 0.72rem;
  color: rgba(255,255,255,0.35);
  margin-bottom: 5px;
}

.mine-source-tag {
  font-size: 0.65rem;
  padding: 1px 7px;
  border-radius: 999px;

  &.quiz { background: rgba(230,126,34,0.15); color: #fb923c; }
  &.drop { background: rgba(124,58,237,0.15); color: #a78bfa; }
}

.mine-date {
  font-size: 0.65rem;
  color: rgba(255,255,255,0.2);
}

.mine-chain {
  margin-top: 6px;
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.68rem;

  span {
    color: #22c55e;
  }

  a {
    color: #93c5fd;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }
}

// ═══════════════════════════════════════════
// 铸造成功弹窗
// ═══════════════════════════════════════════
.dc-modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.75);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  backdrop-filter: blur(6px);
}

.dc-mint-modal {
  position: relative;
  width: 360px;
  background: #1a1422;
  border-radius: 24px;
  overflow: hidden;
  border: 1px solid rgba(255,255,255,0.1);
  box-shadow: 0 30px 80px rgba(0,0,0,0.6);

  &.legendary { border-color: rgba(217,119,6,0.4); }
  &.epic      { border-color: rgba(124,58,237,0.3); }
  &.rare      { border-color: rgba(37,99,235,0.3); }
}

.mint-bg-glow {
  position: absolute;
  top: -80px;
  left: 50%;
  transform: translateX(-50%);
  width: 300px;
  height: 300px;
  border-radius: 50%;
  filter: blur(60px);
  pointer-events: none;

  &.legendary { background: radial-gradient(rgba(217,119,6,0.4), transparent 70%); }
  &.epic      { background: radial-gradient(rgba(124,58,237,0.4), transparent 70%); }
  &.rare      { background: radial-gradient(rgba(37,99,235,0.4),  transparent 70%); }
  &.common    { background: radial-gradient(rgba(100,100,100,0.3),transparent 70%); }
}

.mint-particles {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
}

.mint-particle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255,200,80,0.6);
  animation: mintFloat 2s ease-out forwards;
}

@keyframes mintFloat {
  0%   { transform: translateY(0) scale(0); opacity: 1; }
  100% { transform: translateY(-120px) scale(1); opacity: 0; }
}

.mint-content {
  position: relative;
  z-index: 1;
  padding: 32px 28px;
  text-align: center;
}

.mint-label {
  font-size: 0.85rem;
  color: rgba(255,255,255,0.6);
  margin-bottom: 20px;
}

.mint-img-wrap {
  position: relative;
  display: inline-block;
  margin-bottom: 16px;
}

.mint-img {
  width: 180px;
  height: 180px;
  object-fit: cover;
  border-radius: 16px;
  border: 2px solid rgba(255,255,255,0.15);
}

.mint-img-glow {
  position: absolute;
  inset: -10px;
  border-radius: 24px;
  filter: blur(18px);
  z-index: -1;

  &.legendary { background: rgba(217,119,6,0.5); }
  &.epic      { background: rgba(124,58,237,0.5); }
  &.rare      { background: rgba(37,99,235,0.5); }
  &.common    { background: rgba(100,100,100,0.3); }
}

.mint-rarity {
  font-size: 0.75rem;
  font-weight: 700;
  padding: 3px 14px;
  border-radius: 999px;
  display: inline-block;
  margin-bottom: 10px;

  &.common    { background: rgba(156,163,175,0.15); color: #9ca3af; }
  &.rare      { background: rgba(37,99,235,0.15);   color: #60a5fa; }
  &.epic      { background: rgba(124,58,237,0.15);  color: #c4b5fd; }
  &.legendary { background: rgba(217,119,6,0.2);    color: #fcd34d; }
}

.mint-name {
  font-size: 1.4rem;
  font-weight: 700;
  color: #f5f0e8;
  margin: 0 0 6px;
}

.mint-serial {
  font-size: 0.7rem;
  color: rgba(255,255,255,0.3);
  font-family: monospace;
  margin-bottom: 6px;
}

.mint-origin {
  font-size: 0.8rem;
  color: rgba(255,255,255,0.4);
  margin: 0 0 12px;
}

.mint-chain {
  margin-bottom: 18px;

  p {
    margin: 0 0 6px;
    font-size: 0.72rem;
    color: rgba(255,255,255,0.72);
    word-break: break-all;
  }

  a {
    font-size: 0.78rem;
    color: #93c5fd;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }
}

// ═══════════════════════════════════════════
// 测验奖励提示条
// ═══════════════════════════════════════════
.dc-quiz-reward-tip {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 999;
  width: min(600px, calc(100vw - 32px));
}

.qr-inner {
  display: flex;
  align-items: center;
  gap: 14px;
  background: linear-gradient(135deg, #1e1432, #2d1a05);
  border: 1px solid rgba(217,119,6,0.4);
  border-radius: 14px;
  padding: 16px 20px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.5);
  backdrop-filter: blur(10px);

  strong { color: #fcd34d; font-size: 0.95rem; display: block; margin-bottom: 2px; }
  p      { font-size: 0.8rem; color: rgba(255,255,255,0.5); margin: 0; }
}

.qr-icon { font-size: 2rem; flex-shrink: 0; }

.qr-close {
  margin-left: auto;
  background: none;
  border: none;
  color: rgba(255,255,255,0.35);
  font-size: 1.2rem;
  cursor: pointer;
  padding: 4px 8px;
  flex-shrink: 0;
  &:hover { color: rgba(255,255,255,0.7); }
}

// ═══════════════════════════════════════════
// 弹窗动画
// ═══════════════════════════════════════════
.dc-modal-enter-active, .dc-modal-leave-active { transition: opacity 0.3s; }
.dc-modal-enter-from,  .dc-modal-leave-to      { opacity: 0; }

.dc-modal-enter-active .dc-mint-modal,
.dc-modal-leave-active .dc-mint-modal  { transition: transform 0.3s; }
.dc-modal-enter-from   .dc-mint-modal  { transform: scale(0.8) translateY(20px); }
.dc-modal-leave-to     .dc-mint-modal  { transform: scale(0.8) translateY(20px); }

// ═══════════════════════════════════════════
// 响应式
// ═══════════════════════════════════════════
@media (max-width: 1024px) {
  .dc-drops-grid { grid-template-columns: repeat(3, 1fr); }
  .dc-mine-grid  { grid-template-columns: repeat(4, 1fr); }
}

@media (max-width: 768px) {
  .dc-banner-inner {
    grid-template-columns: 1fr;
    padding: 60px 0 40px;
  }
  .dc-banner-right { display: none; }
  .dc-banner-title { font-size: 2.2rem; }

  .dc-how-grid    { grid-template-columns: 1fr; }
  .dc-drops-grid  { grid-template-columns: repeat(2, 1fr); }
  .dc-mine-grid   { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 480px) {
  .dc-drops-grid { grid-template-columns: 1fr 1fr; gap: 10px; }
  .dc-mine-grid  { grid-template-columns: 1fr 1fr; gap: 10px; }
  .dc-banner-title { font-size: 1.8rem; }
}
</style>
