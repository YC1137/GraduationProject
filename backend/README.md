# 非遗数字化展示平台 - 后端系统

## 📖 项目介绍

这是一个基于 Spring Boot 3.2 + MySQL 的非遗数字化展示平台后端系统，为前端 Vue3 应用提供 RESTful API 接口。

## 🛠️ 技术栈

- **框架**: Spring Boot 3.2.0
- **数据库**: MySQL 8.0+
- **ORM**: Spring Data JPA + Hibernate
- **构建工具**: Maven
- **Java 版本**: JDK 17

## 📁 项目结构

```
backend/
├── src/main/java/com/heritage/
│   ├── HeritagePlatformApplication.java  # 启动类
│   ├── config/                           # 配置类
│   │   ├── CorsConfig.java              # 跨域配置
│   │   └── GlobalExceptionHandler.java  # 全局异常处理
│   ├── controller/                       # 控制器层
│   │   ├── HeritageController.java      # 非遗项目接口
│   │   ├── UserController.java          # 用户接口
│   │   ├── CommentController.java       # 评论接口
│   │   └── QuizController.java          # 测验接口
│   ├── service/                          # 服务层
│   │   ├── HeritageService.java
│   │   ├── UserService.java
│   │   ├── CommentService.java
│   │   └── QuizService.java
│   ├── repository/                       # 数据访问层
│   │   ├── HeritageRepository.java
│   │   ├── UserRepository.java
│   │   ├── CommentRepository.java
│   │   ├── UserFavoriteRepository.java
│   │   ├── UserLikeRepository.java
│   │   └── QuizQuestionRepository.java
│   ├── entity/                           # 实体类
│   │   ├── Heritage.java
│   │   ├── User.java
│   │   ├── Comment.java
│   │   ├── UserFavorite.java
│   │   ├── UserLike.java
│   │   └── QuizQuestion.java
│   └── dto/                              # 数据传输对象
│       ├── ApiResponse.java
│       ├── LoginRequest.java
│       ├── RegisterRequest.java
│       └── CommentRequest.java
├── src/main/resources/
│   └── application.yml                   # 配置文件
├── database/
│   └── init.sql                          # 数据库初始化脚本
└── pom.xml                               # Maven 配置
```

## 🚀 快速开始

### 1. 环境要求

- JDK 17+
- MySQL 8.0+
- Maven 3.6+

### 2. 创建数据库

执行 `database/init.sql` 脚本创建数据库和初始数据：

```bash
# 登录 MySQL
mysql -u root -p

# 执行脚本
source d:/Desktop/bysj3 - 副本/backend/database/init.sql
```

或者使用可视化工具（Navicat、MySQL Workbench等）导入脚本。

### 3. 修改数据库配置

编辑 `src/main/resources/application.yml`，修改数据库连接信息：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/heritage_platform?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root        # 修改为你的数据库用户名
    password: root        # 修改为你的数据库密码
```

### 4. 编译运行

```bash
# 进入后端目录
cd backend

# 清理编译
mvn clean install

# 启动项目
mvn spring-boot:run
```

或者使用 IDE（IDEA、Eclipse）直接运行 `HeritagePlatformApplication` 主类。

### 5. 验证运行

启动成功后访问: http://localhost:8080/api

后端服务运行在 `http://localhost:8080/api` 端口。

## 📡 API 接口文档

### 基础路径

```
http://localhost:8080/api
```

### 1. 非遗项目接口

#### 获取项目列表
```
GET /heritage/list
参数: category, region, level, keyword (可选)
```

#### 获取项目详情
```
GET /heritage/detail/{id}
```

### 2. 用户接口

#### 用户注册
```
POST /user/register
Body: { username, password, email }
```

#### 用户登录
```
POST /user/login
Body: { username, password }
```

#### 切换收藏
```
POST /user/favorite/{heritageId}
参数: userId
```

#### 切换点赞
```
POST /user/like/{heritageId}
参数: userId
```

#### 获取用户收藏列表
```
GET /user/favorites/{userId}
```

#### 获取用户点赞列表
```
GET /user/likes/{userId}
```

### 3. 评论接口

#### 获取评论列表
```
GET /comment/{heritageId}
```

#### 发布评论
```
POST /comment
Body: { heritageId, content }
参数: userId
```

### 4. 知识测验接口

#### 获取题目列表
```
GET /quiz/questions
```

## 📊 数据库表结构

### heritage - 非遗项目表
- 存储非遗项目的基本信息、详细介绍、多媒体资源等

### user - 用户表
- 存储用户账号信息

### comment - 评论表
- 存储用户对非遗项目的评论

### user_favorite - 用户收藏表
- 记录用户收藏的非遗项目

### user_like - 用户点赞表
- 记录用户点赞的非遗项目

### quiz_question - 知识测验题目表
- 存储测验题目和答案

## 🔧 配置说明

### application.yml

- **服务器端口**: 8080
- **上下文路径**: /api
- **数据库连接池**: HikariCP
- **JPA配置**: 自动更新表结构、显示SQL
- **文件上传**: 最大10MB

## 🎯 测试账号

初始化脚本已创建测试账号：

| 用户名 | 密码 | 说明 |
|--------|------|------|
| admin | admin123 | 管理员账号 |
| testuser | 123456 | 测试用户 |

## 📝 注意事项

1. **密码安全**: 当前版本密码为明文存储，生产环境请使用加密（BCrypt）
2. **跨域配置**: 已配置允许所有来源访问，生产环境请限制
3. **JWT认证**: 当前使用简化版token，建议完善JWT实现
4. **数据库**: 首次运行会自动创建表结构（ddl-auto: update）

## 🔄 与前端对接

1. 修改前端 `src/api/request.js` 中的 `baseURL`:
```javascript
baseURL: 'http://localhost:8080/api'
```

2. 启动后端服务（端口 8080）
3. 启动前端服务（端口 5173）
4. 前端将通过 axios 调用后端 API

## 🐛 常见问题

### 1. 启动失败 - 端口占用
```bash
# 修改 application.yml 中的 server.port
```

### 2. 数据库连接失败
- 检查 MySQL 服务是否启动
- 确认数据库名、用户名、密码是否正确
- 检查 MySQL 时区设置

### 3. 编译错误
```bash
# 清理并重新编译
mvn clean install -U
```

## 📞 技术支持

如有问题，请检查：
1. JDK 版本是否为 17+
2. MySQL 服务是否正常运行
3. 数据库是否正确创建和初始化
4. Maven 依赖是否完整下载
