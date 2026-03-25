# 非遗数字化展示平台

前后端分离的非物质文化遗产数字化展示系统，采用 Vue 3 + Spring Boot 构建，以中式传统风格呈现非遗文化内容。

## 功能模块

- **非遗浏览**：按类别、地区、级别筛选，支持关键词搜索
- **非遗地图**：全国省份分布热力图，可视化各地非遗数量及分类统计
- **项目详情**：图文、视频、音频多媒体展示，历史时间轴，传承人信息
- **用户系统**：注册/登录，点赞、收藏、评论互动
- **知识测验**：分专题答题，排行榜，答题历史记录
- **AI 问答**：基于 DeepSeek-V3 的非遗知识助手
- **数字藏品**：区块链 NFT 数字藏品展示与铸造
- **管理后台**：非遗项目、评论审核、藏品管理

## 技术栈

| 层次 | 技术 |
|------|------|
| 前端框架 | Vue 3.4 + Vite 5.0 |
| 状态管理 | Pinia 2.1 |
| UI 组件 | Element Plus 2.5 |
| 图表/地图 | ECharts 6.0 |
| HTTP | Axios 1.6 |
| 后端框架 | Spring Boot 3.2 |
| 数据库 | MySQL 8.0 + Spring Data JPA |
| 构建工具 | Maven / JDK 17 |

## 项目结构

```
├── backend/                        # 后端（Spring Boot）
│   ├── src/main/java/com/heritage/
│   │   ├── controller/             # 控制器
│   │   ├── service/                # 业务层
│   │   ├── repository/             # 数据访问层
│   │   ├── entity/                 # 实体类
│   │   ├── dto/                    # 数据传输对象
│   │   └── config/                 # 配置类
│   ├── src/main/resources/
│   │   └── application.yml         # 应用配置
│   └── database/
│       └── init.sql                # 数据库初始化脚本
├── src/                            # 前端（Vue 3）
│   ├── api/                        # 接口层
│   │   ├── heritage.js             # 非遗、评论接口
│   │   ├── user.js                 # 用户接口
│   │   ├── quiz.js                 # 测验接口
│   │   ├── digitalAsset.js         # 数字藏品接口
│   │   ├── ai.js                   # AI 问答接口
│   │   └── request.js              # Axios 实例
│   ├── views/                      # 页面
│   │   ├── Home.vue                # 首页
│   │   ├── Category.vue            # 分类浏览
│   │   ├── Detail.vue              # 项目详情
│   │   ├── HeritageMap.vue         # 非遗地图
│   │   ├── Quiz.vue                # 知识测验
│   │   ├── AiChat.vue              # AI 问答
│   │   ├── DigitalCollection.vue   # 数字藏品
│   │   ├── UserCenter.vue          # 个人中心
│   │   └── Comments.vue            # 评论管理
│   ├── components/                 # 公共组件
│   ├── stores/                     # Pinia 状态管理
│   ├── router/                     # 路由配置
│   └── main.js                     # 入口文件
├── chain/                          # 区块链合约（Hardhat）
├── vite.config.js
└── package.json
```

## 快速开始

### 环境要求

- Node.js 16+
- JDK 17+
- Maven 3.6+
- MySQL 8.0+

### 1. 初始化数据库

```bash
mysql -u root -p
source backend/database/init.sql
```

数据库 `heritage_platform` 会自动创建，包含初始非遗数据、测验题目和测试账号。

### 2. 启动后端

```bash
cd backend
mvn spring-boot:run
# 启动后监听 http://localhost:8080
```

如需修改数据库连接，编辑 `backend/src/main/resources/application.yml`：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/heritage_platform
    username: root
    password: root
```

### 3. 启动前端

```bash
npm install
npm run dev
# 访问 http://localhost:5173
```

## 测试账号

| 用户名 | 密码 | 权限 |
|--------|------|------|
| admin | admin123 | 管理员 |
| testuser | 123456 | 普通用户 |

## 主要 API 接口

| 接口 | 方法 | 说明 |
|------|------|------|
| `/api/heritage/list` | GET | 非遗项目列表（支持筛选） |
| `/api/heritage/detail/{id}` | GET | 项目详情 |
| `/api/user/login` | POST | 用户登录 |
| `/api/user/register` | POST | 用户注册 |
| `/api/comment/{heritageId}` | GET | 获取评论 |
| `/api/comment` | POST | 发布评论 |
| `/api/quiz/topics` | GET | 测验专题列表 |
| `/api/quiz/questions/topic/{name}` | GET | 专题题目 |
| `/api/quiz/records` | POST | 提交答题记录 |
| `/api/quiz/rankings/top` | GET | 排行榜 |

## 常见问题

**后端启动失败（数据库连接错误）**
- 确认 MySQL 服务已启动：`net start MySQL`
- 检查 `application.yml` 中用户名和密码是否正确

**端口被占用**
- 后端：修改 `application.yml` 中的 `server.port`
- 前端：修改 `vite.config.js` 中的 `server.port`，同步更新 `src/api/request.js` 的 `baseURL`

**前端跨域报错**
- 后端已配置 CORS，重启后端服务即可
