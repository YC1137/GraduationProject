-- 创建答题记录表
USE heritage_platform;

-- 使用存储过程安全创建表
DROP PROCEDURE IF EXISTS CreateQuizRecordTable;

DELIMITER $$
CREATE PROCEDURE CreateQuizRecordTable()
BEGIN
    DECLARE table_exists INT;
    
    -- 检查表是否存在
    SELECT COUNT(*) INTO table_exists
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'quiz_record';
    
    -- 如果表不存在，则创建
    IF table_exists = 0 THEN
        CREATE TABLE quiz_record (
            id BIGINT PRIMARY KEY AUTO_INCREMENT,
            user_id BIGINT NOT NULL COMMENT '用户ID',
            username VARCHAR(50) COMMENT '用户名',
            topic_name VARCHAR(100) NOT NULL COMMENT '专题名称',
            score INT NOT NULL COMMENT '得分',
            total_score INT NOT NULL COMMENT '总分',
            correct_count INT NOT NULL COMMENT '答对题数',
            total_count INT NOT NULL COMMENT '总题数',
            accuracy DECIMAL(5,2) NOT NULL COMMENT '正确率(%)',
            time_spent INT NOT NULL COMMENT '用时(秒)',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
            INDEX idx_user_id (user_id),
            INDEX idx_topic_name (topic_name),
            INDEX idx_accuracy_time (accuracy DESC, time_spent ASC),
            INDEX idx_created_at (created_at DESC)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='答题记录表';
    END IF;
END$$
DELIMITER ;

-- 执行存储过程
CALL CreateQuizRecordTable();

-- 删除存储过程
DROP PROCEDURE IF EXISTS CreateQuizRecordTable;

-- 验证
SELECT '=== quiz_record表结构 ===' as '';
SHOW COLUMNS FROM quiz_record;
