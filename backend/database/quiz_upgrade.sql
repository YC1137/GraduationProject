-- 知识测验升级脚本
USE heritage_platform;

-- 1. 创建题目专题表
CREATE TABLE IF NOT EXISTS quiz_topic (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '专题名称',
    description TEXT COMMENT '专题描述',
    cover_image VARCHAR(500) COMMENT '封面图片',
    question_count INT DEFAULT 0 COMMENT '题目数量',
    participant_count INT DEFAULT 0 COMMENT '参与人数',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    enabled BOOLEAN NOT NULL DEFAULT true COMMENT '是否启用',
    INDEX idx_created_at (created_at),
    INDEX idx_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='测验专题表';

-- 2. 修改题目表,添加专题关联(使用存储过程避免重复添加)
DROP PROCEDURE IF EXISTS AddTopicIdColumn;

DELIMITER $$
CREATE PROCEDURE AddTopicIdColumn()
BEGIN
    DECLARE col_exists INT;
    
    -- 检查列是否存在
    SELECT COUNT(*) INTO col_exists
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'quiz_question'
    AND COLUMN_NAME = 'topic_id';
    
    -- 如果列不存在，则添加
    IF col_exists = 0 THEN
        ALTER TABLE quiz_question 
        ADD COLUMN topic_id BIGINT COMMENT '所属专题ID',
        ADD INDEX idx_topic_id (topic_id);
    END IF;
END$$
DELIMITER ;

-- 执行存储过程
CALL AddTopicIdColumn();

-- 删除存储过程
DROP PROCEDURE IF EXISTS AddTopicIdColumn;

-- 3. 创建答题记录表
CREATE TABLE IF NOT EXISTS quiz_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    topic_id BIGINT NOT NULL COMMENT '专题ID',
    score INT NOT NULL COMMENT '得分',
    total_score INT NOT NULL COMMENT '总分',
    correct_count INT NOT NULL COMMENT '答对题数',
    total_count INT NOT NULL COMMENT '总题数',
    accuracy DECIMAL(5,2) NOT NULL COMMENT '正确率(%)',
    time_spent INT NOT NULL COMMENT '用时(秒)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
    INDEX idx_user_id (user_id),
    INDEX idx_topic_id (topic_id),
    INDEX idx_score (score DESC),
    INDEX idx_accuracy (accuracy DESC),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES quiz_topic(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='答题记录表';

-- 4. 插入示例专题
INSERT INTO quiz_topic (name, description, cover_image, enabled) VALUES
('非遗基础知识', '测试对非物质文化遗产的基础认知', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', true),
('传统戏剧专题', '深入了解中国传统戏剧艺术', 'https://images.unsplash.com/photo-1516307365426-bea591f05011?w=800', true),
('传统技艺专题', '探索中国传统手工艺技术', 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800', true);

-- 5. 将现有题目关联到第一个专题
UPDATE quiz_question SET topic_id = 1 WHERE topic_id IS NULL;

-- 6. 更新专题的题目数量
UPDATE quiz_topic t 
SET question_count = (
    SELECT COUNT(*) FROM quiz_question q 
    WHERE q.topic_id = t.id AND q.enabled = true
);

-- 验证数据
SELECT '=== 专题列表 ===' as '';
SELECT id, name, question_count, participant_count, created_at FROM quiz_topic;

SELECT '=== 题目分布 ===' as '';
SELECT topic_id, COUNT(*) as count FROM quiz_question GROUP BY topic_id;
