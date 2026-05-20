# 服务器部署脚本

# 1. 打包前端
npm run build

# 2. 将 dist 目录上传到服务器 /www/heritage-platform/

# 3. 配置 Nginx
# 将以下配置保存为 /etc/nginx/conf.d/heritage.conf

# 4. 启动后端
# java -jar heritage-platform.jar --spring.profiles.active=prod
