#!/bin/bash

# 非遗平台服务器启动脚本

# 项目名称
APP_NAME="heritage-platform"

# Jar包路径
JAR_PATH="/www/heritage-platform/heritage-platform.jar"

# 日志文件
LOG_FILE="/www/heritage-platform/logs/app.log"

# PID文件
PID_FILE="/www/heritage-platform/app.pid"

# 最大内存
MAX_MEMORY="512m"

# 最小内存
MIN_MEMORY="256m"

# 创建日志目录
mkdir -p /www/heritage-platform/logs

# 判断程序是否运行
is_running() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if kill -0 $pid 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# 启动应用
start() {
    if is_running; then
        echo "$APP_NAME is already running, PID: $(cat $PID_FILE)"
        return
    fi
    
    echo "Starting $APP_NAME..."
    nohup java -Xms$MIN_MEMORY -Xmx$MAX_MEMORY -jar "$JAR_PATH" --spring.profiles.active=prod > "$LOG_FILE" 2>&1 &
    
    # 保存PID
    echo $! > "$PID_FILE"
    echo "$APP_NAME started, PID: $(cat $PID_FILE)"
}

# 停止应用
stop() {
    if ! is_running; then
        echo "$APP_NAME is not running"
        return
    fi
    
    echo "Stopping $APP_NAME..."
    pid=$(cat "$PID_FILE")
    kill $pid
    
    # 等待进程结束
    for i in {1..30}; do
        if ! kill -0 $pid 2>/dev/null; then
            break
        fi
        sleep 1
    done
    
    # 强制终止
    if kill -0 $pid 2>/dev/null; then
        kill -9 $pid
    fi
    
    rm -f "$PID_FILE"
    echo "$APP_NAME stopped"
}

# 重启应用
restart() {
    stop
    sleep 2
    start
}

# 查看状态
status() {
    if is_running; then
        echo "$APP_NAME is running, PID: $(cat $PID_FILE)"
    else
        echo "$APP_NAME is not running"
    fi
}

# 查看日志
logs() {
    tail -f "$LOG_FILE"
}

# 根据命令执行
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    *)
        echo "Usage: ./start.sh {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
