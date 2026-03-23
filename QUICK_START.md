# ⚡ 快速开始指南

> 5分钟快速启动非遗数字化展示平台（前后端完整版）

## 📋 前置检查

在开始之前，确保已安装：
- ✅ JDK 17+
- ✅ Maven 3.6+
- ✅ MySQL 8.0+
- ✅ Node.js 16+

## 🚀 三步启动

### Step 1: 创建数据库（2分钟）

```bash
# 1. 打开命令提示符，登录 MySQL
mysql -u root -p
# 输入密码: root（或你的密码）

# 2. 执行初始化脚本
source d:/Desktop/bysj3 - 副本/backend/database/init.sql

# 3. 验证数据
USE heritage_platform;
SELECT COUNT(*) FROM heritage;  # 应该返回 5

# 4. 退出
exit;
```

### Step 2: 启动后端（2分钟）

```bash
# 1. 打开新的命令提示符
cd "d:/Desktop/bysj3 - 副本/backend"

# 2. 启动（首次运行会下载依赖，需要几分钟）
mvn spring-boot:run

# 看到以下信息表示成功：
# ========================================
# 非遗数字化展示平台后端启动成功！
# 访问地址: http://localhost:8080/api
# ========================================
```

**注意**: 不要关闭这个窗口，让后端保持运行

### Step 3: 启动前端（1分钟）

```bash
# 1. 打开另一个新的命令提示符
cd "d:/Desktop/bysj3 - 副本"

# 2. 安装依赖（首次运行）
npm install

# 3. 启动前端
npm run dev

# 看到以下信息：
# VITE v5.0.11  ready in xxx ms
# ➜  Local:   http://localhost:5173/
```

### Step 4: 访问应用

打开浏览器访问: **http://localhost:5173**

## ✅ 验证功能

登录测试账号：
- 用户名: `admin`
- 密码: `admin123`

测试以下功能：
1. ✅ 浏览非遗项目列表
2. ✅ 查看项目详情
3. ✅ 点赞和收藏
4. ✅ 发布评论
5. ✅ 参加知识测验

## 🐛 遇到问题？

### 问题1: 后端启动失败 - 数据库连接错误

**修改数据库密码:**
编辑 `backend/src/main/resources/application.yml`:
```yaml
spring:
  datasource:
    password: 你的实际密码
```

### 问题2: 端口被占用

**后端端口被占用:**
```bash
# 查找并杀掉占用 8080 端口的进程
netstat -ano | findstr :8080
taskkill /F /PID <进程ID>
```

**前端端口被占用:**
修改 `vite.config.js`:
```javascript
server: {
  port: 5174  // 改为其他端口
}
```

### 问题3: Maven 依赖下载慢

配置阿里云镜像，编辑 `%MAVEN_HOME%/conf/settings.xml`：
```xml
<mirrors>
  <mirror>
    <id>aliyun</id>
    <mirrorOf>central</mirrorOf>
    <url>https://maven.aliyun.com/repository/public</url>
  </mirror>
</mirrors>
```

## 📚 详细文档

遇到其他问题？查看完整文档：
- 📗 [完整部署指南](./BACKEND_SETUP.md)
- 📙 [后端接口文档](./backend/README.md)
- 📘 [项目说明](./README.md)

## 🎯 下一步

1. 熟悉项目功能
2. 查看代码结构
3. 尝试修改和扩展功能
4. 添加自己的非遗项目数据

---

🎉 **恭喜！你已经成功运行了完整的前后端项目！**
