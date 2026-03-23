# 知识测验系统升级说明

## ✅ 已完成的后端修改

### 1. 数据库设计
- ✅ 创建 `quiz_topic` 表 - 专题管理
- ✅ 创建 `quiz_record` 表 - 答题记录
- ✅ 修改 `quiz_question` 表 - 添加 topic_id 字段

### 2. 实体类
- ✅ QuizTopic.java - 专题实体
- ✅ QuizRecord.java - 答题记录实体
- ✅ QuizQuestion.java - 添加 topicId 字段

### 3. Repository 层
- ✅ QuizTopicRepository - 专题数据访问
- ✅ QuizRecordRepository - 记录数据访问  
- ✅ QuizQuestionRepository - 添加按专题查询

### 4. Service 层
- ✅ QuizTopicService - 专题业务逻辑
- ✅ QuizRecordService - 记录业务逻辑
- ✅ QuizService - 添加按专题查询

### 5. Controller 层
- ✅ QuizController - 添加新接口

### 6. 前端 API
- ✅ quiz.js - 添加所有新接口

## 🚀 部署步骤

### 1. 执行数据库升级脚本
```bash
mysql -u root -p
source d:/Desktop/bysj3 - 副本 - 副本 (2)/backend/database/quiz_upgrade.sql
```

### 2. 重新编译并启动后端
```bash
cd backend
mvn clean package -DskipTests
mvn spring-boot:run
```

### 3. 前端页面开发(待完成)
需要创建以下页面:
- 📄 QuizTopicList.vue - 专题列表页
- 📄 QuizExam.vue - 答题页面(带计时器)
- 📄 QuizRanking.vue - 排行榜页面
- 📄 QuizResult.vue - 答题结果页

## 📋 新功能说明

### 1. 专题管理
- 管理员可以创建多个测验专题
- 每个专题有名称、描述、封面图
- 自动统计题目数量和参与人数

### 2. 答题流程
1. 用户必须登录才能答题
2. 选择专题开始答题
3. 系统记录答题时间
4. 提交后显示成绩和排名
5. 保存答题记录到数据库

### 3. 排行榜
- 按正确率排序(正确率高优先)
- 正确率相同时按用时排序(用时短优先)
- 显示前100名
- 显示用户头像、昵称、成绩

### 4. 个人记录
- 查看历史答题记录
- 显示每次答题的详细信息
- 统计个人最佳成绩

## 🎯 下一步工作

1. 创建前端专题列表页面
2. 修改答题页面支持专题和计时
3. 创建排行榜页面
4. 添加登录验证中间件
5. 美化UI界面

## 🔗 API 接口列表

| 接口 | 方法 | 说明 |
|------|------|------|
| /quiz/topics | GET | 获取所有专题 |
| /quiz/topics/{id} | GET | 获取专题详情 |
| /quiz/topics/{topicId}/questions | GET | 获取专题题目 |
| /quiz/records | POST | 提交答题记录 |
| /quiz/topics/{topicId}/ranking | GET | 获取排行榜 |
| /quiz/users/{userId}/topics/{topicId}/best | GET | 获取最佳记录 |
| /quiz/users/{userId}/history | GET | 获取答题历史 |
