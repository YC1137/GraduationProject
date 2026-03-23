-- 为quiz_question表添加topic_name字段
USE heritage_platform;

-- 使用存储过程安全地添加列（避免重复添加）
DROP PROCEDURE IF EXISTS AddTopicNameColumn;

DELIMITER $$
CREATE PROCEDURE AddTopicNameColumn()
BEGIN
    DECLARE col_exists INT;
    
    -- 检查topic_name列是否存在
    SELECT COUNT(*) INTO col_exists
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'quiz_question'
    AND COLUMN_NAME = 'topic_name';
    
    -- 如果列不存在，则添加
    IF col_exists = 0 THEN
        ALTER TABLE quiz_question 
        ADD COLUMN topic_name VARCHAR(100) COMMENT '专题名称',
        ADD COLUMN create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        ADD INDEX idx_topic_name (topic_name);
    END IF;
END$$
DELIMITER ;

-- 执行存储过程
CALL AddTopicNameColumn();

-- 删除存储过程
DROP PROCEDURE IF EXISTS AddTopicNameColumn;

-- 为现有题目设置默认专题名称
UPDATE quiz_question SET topic_name = '非遗基础知识' WHERE topic_name IS NULL;

-- ============ 重要：执行完上面的ALTER TABLE后，继续执行下面的语句 ============

-- 为现有题目设置默认专题名称
UPDATE quiz_question SET topic_name = '非遗基础知识' WHERE topic_name IS NULL OR topic_name = '';

-- 验证
SELECT '=== 检查字段是否添加成功 ===' as '';
SHOW COLUMNS FROM quiz_question;

SELECT '=== 当前题目列表 ===' as '';
SELECT id, LEFT(question, 30) as question_preview, topic_name, enabled, create_time FROM quiz_question;
