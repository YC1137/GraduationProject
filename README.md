# 🏛️ 非遗数字化展示平台

> 一个完整的前后端分离项目，用于展示和传承中国传统非物质文化遗产

## 📚 项目简介

本平台提供非遗项目的数字化展示、互动体验、知识测验等功能，帮助用户更好地了解和传承中华传统文化。采用中国传统文化元素（水墨风格、传统纹样、中式配色），支持PC端和移动端响应式访问。

### ✨ 主要功能

- 🎨 **非遗展示**: 图文视频展示非遗项目详情
- 📱 **响应式设计**: 支持PC端和移动端
- 👤 **用户系统**: 注册、登录、个人中心
- ❤️ **互动功能**: 点赞、收藏、评论
- 📝 **知识测验**: 趣味答题学习非遗知识
- 🔍 **智能筛选**: 按类别、地域、级别筛选
- 🎬 **多媒体**: 支持图片、视频、音频展示

## 🛠️ 技术栈

### 前端
- **框架**: Vue 3.4 + Vite 5.0
- **路由**: Vue Router 4.2
- **状态管理**: Pinia 2.1
- **UI 组件**: Element Plus 2.5
- **HTTP 请求**: Axios 1.6
- **3D 效果**: Three.js 0.160

### 后端
- **框架**: Spring Boot 3.2.0
- **数据库**: MySQL 8.0+
- **ORM**: Spring Data JPA + Hibernate
- **构建工具**: Maven
- **Java 版本**: JDK 17

## 🚀 快速开始

### 方式一：仅运行前端（使用 Mock 数据）

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 访问 http://localhost:5173
```

### 方式二：完整运行（前后端联调）

#### 1️⃣ 启动后端

**详细步骤请查看**: 📗 [**BACKEND_SETUP.md**](./BACKEND_SETUP.md)

```bash
# 进入后端目录
cd backend

# 编译运行
mvn clean install
mvn spring-boot:run

# 后端运行在 http://localhost:8080/api
```

#### 2️⃣ 启动前端

```bash
# 在项目根目录
npm install
npm run dev

# 前端运行在 http://localhost:5173
```

## 📁 项目结构

```
bysj3 - 副本/
├── backend/                      # 后端项目
│   ├── src/main/java/           # Java 源代码
│   │   └── com/heritage/
│   │       ├── controller/      # 控制器层
│   │       ├── service/         # 服务层
│   │       ├── repository/      # 数据访问层
│   │       ├── entity/          # 实体类
│   │       ├── dto/             # 数据传输对象
│   │       └── config/          # 配置类
│   ├── src/main/resources/      # 配置文件
│   │   └── application.yml      # 应用配置
│   ├── database/                # 数据库脚本
│   │   └── init.sql            # 初始化SQL
│   ├── pom.xml                  # Maven 配置
│   └── README.md                # 后端文档
├── src/                         # 前端源代码
│   ├── api/                     # API 接口层
│   │   ├── heritage.js         # 非遗接口（已对接后端）
│   │   ├── user.js             # 用户接口（已对接后端）
│   │   ├── quiz.js             # 测验接口（已对接后端）
│   │   ├── request.js          # Axios 配置
│   │   └── mock.js             # Mock 数据（备用）
│   ├── views/                   # 页面组件
│   │   ├── Home.vue            # 首页
│   │   ├── Category.vue        # 分类页
│   │   ├── Detail.vue          # 详情页
│   │   └── Quiz.vue            # 测验页
│   ├── stores/                  # 状态管理
│   │   ├── auth.js             # 认证状态（已对接后端）
│   │   ├── user.js             # 用户状态（已对接后端）
│   │   └── heritage.js         # 非遗数据
│   ├── components/              # 公共组件
│   ├── router/                  # 路由配置
│   ├── styles/                  # 样式文件
│   ├── App.vue                  # 根组件
│   └── main.js                  # 入口文件
├── public/                      # 静态资源
├── package.json                 # 前端依赖
├── vite.config.js              # Vite 配置
├── README.md                    # 项目说明（本文件）
└── BACKEND_SETUP.md            # 后端部署指南 ⭐
```

## 🗄️ 数据库说明

### 创建数据库

执行 `backend/database/init.sql` 脚本即可自动创建：
- ✅ 数据库: `heritage_platform`
- ✅ 6张数据表
- ✅ 5条非遗项目初始数据
- ✅ 7道测验题目
- ✅ 2个测试账号

### 测试账号

| 用户名 | 密码 | 说明 |
|--------|------|------|
| admin | admin123 | 管理员 |
| testuser | 123456 | 普通用户 |

**详细步骤请查看**: [**BACKEND_SETUP.md**](./BACKEND_SETUP.md)

## 📡 API 接口

### 基础路径
```
http://localhost:8080/api
```

### 主要接口

| 接口 | 方法 | 说明 |
|-----|------|------|
| `/heritage/list` | GET | 获取非遗项目列表 |
| `/heritage/detail/{id}` | GET | 获取项目详情 |
| `/user/register` | POST | 用户注册 |
| `/user/login` | POST | 用户登录 |
| `/user/favorite/{id}` | POST | 切换收藏 |
| `/user/like/{id}` | POST | 切换点赞 |
| `/comment/{id}` | GET | 获取评论列表 |
| `/comment` | POST | 发布评论 |
| `/quiz/questions` | GET | 获取测验题目 |

完整 API 文档请查看: [backend/README.md](./backend/README.md)

## 🎯 开发指南

### 前端开发

```bash
# 安装依赖
npm install

# 开发模式（热更新）
npm run dev

# 构建生产版本
npm run build

# 预览生产版本
npm run preview
```

### 后端开发

```bash
cd backend

# 编译
mvn clean install

# 运行
mvn spring-boot:run

# 打包
mvn clean package
```

### 修改配置

**前端 API 地址** (`src/api/request.js`):
```javascript
baseURL: 'http://localhost:8080/api'
```

**后端数据库配置** (`backend/src/main/resources/application.yml`):
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/heritage_platform
    username: root
    password: root
```

## 🔧 环境要求

### 前端
- Node.js 16+
- npm 7+

### 后端
- JDK 17+
- Maven 3.6+
- MySQL 8.0+

## 📦 部署

### 前端部署

```bash
# 构建
npm run build

# dist 目录部署到静态服务器（Nginx/Apache）
```

### 后端部署

```bash
# 打包
mvn clean package

# 运行 JAR
java -jar target/heritage-platform-1.0.0.jar
```

## 🐛 常见问题

### 1. 前端无法连接后端？
- 确认后端已启动（http://localhost:8080/api）
- 检查 `src/api/request.js` 中的 `baseURL`

### 2. 数据库连接失败？
- 确认 MySQL 服务已启动
- 检查 `application.yml` 中的数据库配置
- 确认已执行 `init.sql` 脚本

### 3. 端口被占用？
- 修改后端端口: `application.yml` 的 `server.port`
- 修改前端端口: `vite.config.js` 的 `server.port`

**更多问题请查看**: [**BACKEND_SETUP.md**](./BACKEND_SETUP.md)

## 📄 文档索引

- 📘 [项目说明](./README.md) - 本文件
- 📗 [后端部署指南](./BACKEND_SETUP.md) - 详细的后端配置和部署步骤 ⭐
- 📙 [后端接口文档](./backend/README.md) - API 接口详细说明

## 🎓 学习资源

- [Vue 3 官方文档](https://cn.vuejs.org/)
- [Spring Boot 官方文档](https://spring.io/projects/spring-boot)
- [Element Plus 组件库](https://element-plus.org/)
- [MySQL 教程](https://www.mysql.com/cn/)

## 📝 开发规范

### 代码风格
- 使用 ESLint + Prettier 格式化代码
- 组件名使用 PascalCase
- 文件名使用 kebab-case
- 详细的代码注释

### Git 提交规范
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 重构代码
- `test`: 测试相关
- `chore`: 构建/工具相关

## 📝 License

MIT License

## 👥 贡献

欢迎提交 Issue 和 Pull Request！

---

**快速链接:**
- 🚀 [快速开始](#快速开始)
- 📚 [完整部署指南](./BACKEND_SETUP.md) ⭐
- 🗄️ [数据库配置](#数据库说明)
- 📡 [API 接口文档](./backend/README.md)

**传承非遗文化，守护民族瑰宝** 🎭
