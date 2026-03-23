# 🚀 后端部署完整指南

## 📋 目录
1. [环境准备](#环境准备)
2. [数据库配置](#数据库配置)
3. [后端启动](#后端启动)
4. [前端配置](#前端配置)
5. [测试验证](#测试验证)
6. [常见问题](#常见问题)

---

## 🔧 环境准备

### 1. 安装 JDK 17

**Windows:**
1. 下载 JDK 17: https://www.oracle.com/java/technologies/downloads/#java17
2. 安装并配置环境变量 `JAVA_HOME`
3. 验证安装:
```bash
java -version
```

### 2. 安装 Maven

**Windows:**
1. 下载 Maven: https://maven.apache.org/download.cgi
2. 解压到本地目录（如 `C:\apache-maven-3.9.0`）
3. 配置环境变量 `MAVEN_HOME`
4. 将 `%MAVEN_HOME%\bin` 添加到 Path
5. 验证安装:
```bash
mvn -version
```

### 3. 安装 MySQL 8.0+

**Windows:**
1. 下载 MySQL: https://dev.mysql.com/downloads/installer/
2. 运行安装程序，选择 "Developer Default"
3. 设置 root 密码（建议: `root`）
4. 完成安装

---

## 🗄️ 数据库配置

### 方法一: 使用 MySQL 命令行

1. 打开命令提示符（CMD），登录 MySQL:
```bash
mysql -u root -p
# 输入密码: root
```

2. 执行初始化脚本:
```sql
source d:/Desktop/bysj3 - 副本/backend/database/init.sql
```

3. 验证数据库:
```sql
USE heritage_platform;
SHOW TABLES;
SELECT COUNT(*) FROM heritage;  -- 应该返回 5 条记录
```

4. 退出:
```sql
exit;
```

### 方法二: 使用 Navicat/MySQL Workbench

1. 打开工具，连接到本地 MySQL（root/root）
2. 右键点击 "执行SQL文件"
3. 选择 `d:/Desktop/bysj3 - 副本/backend/database/init.sql`
4. 执行脚本
5. 刷新，查看 `heritage_platform` 数据库

### 验证数据

执行以下查询验证数据是否正确导入:

```sql
-- 查看非遗项目
SELECT id, name, category, region FROM heritage;

-- 查看测试用户
SELECT id, username, email FROM user;

-- 查看测验题目
SELECT id, question FROM quiz_question;
```

---

## 🚀 后端启动

### 方法一: 使用 Maven 命令（推荐）

1. 打开命令提示符，进入后端目录:
```bash
cd "d:/Desktop/bysj3 - 副本/backend"
```

2. 清理并编译:
```bash
mvn clean install
```

3. 启动应用:
```bash
mvn spring-boot:run
```

4. 看到以下信息表示启动成功:
```
========================================
非遗数字化展示平台后端启动成功！
访问地址: http://localhost:8080/api
========================================
```

### 方法二: 使用 IntelliJ IDEA

1. 打开 IDEA，导入项目:
   - File -> Open -> 选择 `d:/Desktop/bysj3 - 副本/backend`
   - 选择 "Maven Project"

2. 等待 Maven 下载依赖

3. 修改数据库配置（如需要）:
   - 打开 `src/main/resources/application.yml`
   - 修改 `username` 和 `password`

4. 运行主类:
   - 找到 `HeritagePlatformApplication.java`
   - 右键 -> Run 'HeritagePlatformApplication'

### 方法三: 打包为 JAR 运行

```bash
# 打包
mvn clean package

# 运行
java -jar target/heritage-platform-1.0.0.jar
```

---

## 🎨 前端配置

### 1. 验证 API 地址

检查 `src/api/request.js` 文件，确认 baseURL 正确:

```javascript
const request = axios.create({
    baseURL: 'http://localhost:8080/api',  // ✅ 已更新
    timeout: 10000
})
```

### 2. 启动前端

```bash
# 在项目根目录
npm run dev
```

### 3. 访问应用

打开浏览器访问: http://localhost:5173

---

## ✅ 测试验证

### 1. 测试后端接口

使用浏览器或 Postman 测试:

**获取非遗项目列表:**
```
GET http://localhost:8080/api/heritage/list
```

**获取项目详情:**
```
GET http://localhost:8080/api/heritage/detail/1
```

**用户登录:**
```
POST http://localhost:8080/api/user/login
Content-Type: application/json

{
    "username": "admin",
    "password": "admin123"
}
```

### 2. 测试前后端联调

1. 启动后端（端口 8080）
2. 启动前端（端口 5173）
3. 打开浏览器 http://localhost:5173
4. 测试功能:
   - ✅ 首页显示非遗项目列表
   - ✅ 点击项目查看详情
   - ✅ 用户登录（admin/admin123）
   - ✅ 点赞和收藏功能
   - ✅ 发布评论
   - ✅ 知识测验

### 3. 查看浏览器控制台

按 F12 打开开发者工具，查看 Network 标签:
- 应该看到 API 请求发送到 `http://localhost:8080/api`
- 状态码应该是 200
- 响应数据格式: `{ code: 200, message: "success", data: ... }`

---

## 🐛 常见问题

### 1. 后端启动失败 - 端口占用

**错误信息:**
```
Port 8080 was already in use.
```

**解决方案:**
```bash
# 方法1: 杀掉占用端口的进程
netstat -ano | findstr :8080
taskkill /F /PID <进程ID>

# 方法2: 修改端口
编辑 application.yml 中的 server.port: 8081
同时修改前端 request.js 中的端口
```

### 2. 数据库连接失败

**错误信息:**
```
java.sql.SQLException: Access denied for user 'root'@'localhost'
```

**解决方案:**
1. 检查 MySQL 服务是否启动:
```bash
net start MySQL
```

2. 确认用户名密码:
```yaml
# application.yml
spring:
  datasource:
    username: root
    password: root  # 改为你的实际密码
```

3. 检查数据库是否存在:
```sql
SHOW DATABASES LIKE 'heritage_platform';
```

### 3. Maven 依赖下载失败

**错误信息:**
```
Could not resolve dependencies
```

**解决方案:**
```bash
# 清理并重新下载
mvn clean install -U

# 或配置国内镜像（阿里云）
编辑 %MAVEN_HOME%/conf/settings.xml
添加镜像配置
```

### 4. 前端请求跨域错误

**错误信息:**
```
Access to XMLHttpRequest has been blocked by CORS policy
```

**解决方案:**
- 后端已配置跨域，重启后端服务
- 确认 `CorsConfig.java` 配置正确

### 5. 前端无法获取数据

**检查步骤:**
1. 确认后端已启动（http://localhost:8080/api/heritage/list 可访问）
2. 检查浏览器控制台网络请求
3. 确认 `request.js` 中 baseURL 正确
4. 检查数据库中是否有数据

### 6. 登录后 token 失效

**原因:** 当前实现为简化版 token

**解决方案:** 
- 重新登录即可
- 或升级为完整 JWT 实现（需修改代码）

---

## 📊 数据库表说明

| 表名 | 说明 | 记录数 |
|-----|------|--------|
| heritage | 非遗项目 | 5条初始数据 |
| user | 用户账号 | 2个测试账号 |
| comment | 评论 | 空表 |
| user_favorite | 收藏记录 | 空表 |
| user_like | 点赞记录 | 空表 |
| quiz_question | 测验题目 | 7条题目 |

---

## 🔑 测试账号

| 用户名 | 密码 | 说明 |
|--------|------|------|
| admin | admin123 | 管理员 |
| testuser | 123456 | 测试用户 |

---

## 📞 技术支持

### 开发工具推荐
- **IDE**: IntelliJ IDEA Community（免费）
- **数据库工具**: Navicat / MySQL Workbench
- **API 测试**: Postman / Apifox

### 日志查看

查看后端日志以排查问题:
```bash
# 控制台会实时显示日志
# 或查看日志文件（如果配置了）
```

### 修改配置

主要配置文件:
- `application.yml` - 应用配置
- `pom.xml` - Maven 依赖

---

## 🎯 下一步

1. ✅ 完成基础功能测试
2. ✅ 熟悉项目结构
3. 🔄 根据需求扩展功能
4. 🔒 完善安全机制（密码加密、JWT等）
5. 📝 添加更多测试数据
6. 🚀 部署到生产环境

---

## 📄 项目结构总览

```
bysj3 - 副本/
├── backend/                    # 后端项目
│   ├── src/main/java/          # Java 源代码
│   ├── src/main/resources/     # 配置文件
│   ├── database/               # 数据库脚本
│   ├── pom.xml                 # Maven 配置
│   └── README.md               # 后端文档
├── src/                        # 前端源代码
│   ├── api/                    # API 接口（已对接后端）
│   ├── views/                  # 页面组件
│   └── stores/                 # 状态管理（已对接后端）
├── package.json                # 前端依赖
└── BACKEND_SETUP.md            # 本文档
```

完成！🎉
