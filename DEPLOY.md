# 部署指南

## 目录结构

```
heritage-platform/
├── dist/                    # 前端构建产物（部署到服务器）
├── src/                     # 前端源码
├── backend/
│   ├── target/
│   │   └── heritage-platform.jar  # 后端打包产物
│   └── src/
├── nginx.conf               # Nginx 配置文件
└── deploy.sh               # 部署脚本
```

---

## 一、本地开发

### 前端开发
```bash
npm install
npm run dev
# 访问 http://localhost:3000
```

### 后端开发
```bash
cd backend
# 修改 application.yml 中的数据库配置
mvn spring-boot:run
# 后端运行在 http://localhost:8080/api
```

### 数据库
确保 MySQL 运行中，创建数据库：
```sql
CREATE DATABASE heritage_platform DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## 二、阿里云服务器部署

### 1. 服务器环境要求

- CentOS 7+ / Ubuntu 20.04+
- Nginx
- JDK 8+
- MySQL 5.7+ / MySQL 8.0+
- Node.js 16+（用于构建前端）

### 2. 服务器配置

#### 2.1 安装 JDK
```bash
yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
# 或
apt install openjdk-8-jdk -y
```

#### 2.2 安装 MySQL
参考阿里云官方文档安装 MySQL 8.0

#### 2.3 安装 Nginx
```bash
yum install nginx -y  # CentOS
# 或
apt install nginx -y  # Ubuntu
```

#### 2.4 安装 Node.js（用于构建）
```bash
curl -fsSL https://rpm.nodesource.com/setup_16.x | bash -
yum install nodejs -y
```

### 3. 数据库配置

```sql
-- 登录 MySQL
mysql -u root -p

-- 创建数据库
CREATE DATABASE heritage_platform DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 设置用户权限
GRANT ALL PRIVILEGES ON heritage_platform.* TO 'root'@'%' IDENTIFIED BY '你的MySQL密码';
FLUSH PRIVILEGES;
```

### 4. 导入数据

将 `heritage_platform_final.sql` 导入服务器数据库：
```bash
mysql -u root -p heritage_platform < /path/to/heritage_platform_final.sql
```

### 5. 配置后端

#### 5.1 修改数据库密码
编辑 `backend/src/main/resources/application-prod.yml`：
```yaml
spring:
  datasource:
    password: 你的MySQL密码  # 修改这里
```

#### 5.2 修改公网地址
```yaml
app:
  address-base-url: http://你的服务器IP:8080/api
```

#### 5.3 打包后端
```bash
cd backend
mvn clean package -DskipTests
```
生成文件：`backend/target/heritage-platform.jar`

### 6. 配置前端

#### 6.1 修改服务器IP
编辑 `.env.production`：
```env
VITE_API_BASE_URL=http://你的服务器IP:8080/api
```

#### 6.2 打包前端
```bash
npm install
npm run build
```
生成目录：`dist/`

### 7. 部署文件

#### 7.1 创建目录
```bash
mkdir -p /www/heritage-platform
```

#### 7.2 上传文件
- 上传 `backend/target/heritage-platform.jar` 到 `/www/heritage-platform/`
- 上传 `dist/` 目录到 `/www/heritage-platform/`
- 上传 `nginx.conf` 到服务器

#### 7.3 配置 Nginx
```bash
cp nginx.conf /etc/nginx/conf.d/heritage.conf
# 修改 nginx.conf 中的 server_name 为你的服务器IP
nginx -t  # 测试配置
nginx -s reload  # 重载配置
```

#### 7.4 开放端口
在阿里云控制台安全组中开放：
- 80 (HTTP)
- 8080 (后端API)
- 443 (HTTPS，可选)

### 8. 启动服务

#### 8.1 启动后端
```bash
cd /www/heritage-platform
chmod +x start.sh
./start.sh start
```

#### 8.2 检查状态
```bash
./start.sh status  # 查看状态
./start.sh logs    # 查看日志
```

### 9. 访问测试

- 前台：http://你的服务器IP
- 后端API：http://你的服务器IP:8080/api

---

## 三、常用命令

### 服务器操作
```bash
# 后端
./start.sh start    # 启动
./start.sh stop     # 停止
./start.sh restart  # 重启
./start.sh status   # 状态
./start.sh logs     # 日志

# Nginx
nginx -t                    # 测试配置
nginx -s reload            # 重载配置
nginx -s stop              # 停止
```

### 常见问题

1. **前端访问502**：检查后端是否启动，Nginx配置是否正确
2. **API请求失败**：检查后端是否正常运行，端口是否开放
3. **数据库连接失败**：检查MySQL是否启动，密码是否正确
4. **上传文件失败**：检查uploads目录权限

---

## 四、更新部署

### 更新前端
```bash
# 本地重新打包
npm run build
# 上传 dist 目录覆盖服务器文件
```

### 更新后端
```bash
# 重新打包上传
cd backend
mvn clean package -DskipTests
# 上传 jar 包覆盖
./start.sh restart
```
