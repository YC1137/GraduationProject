-- 给 quiz_question 表添加 enabled 字段
-- 如果你的数据库已经存在 quiz_question 表,请执行此脚本

USE heritage_platform;

-- 添加 enabled 字段
-- MySQL 不支持 IF NOT EXISTS，所以使用存储过程来检查
DROP PROCEDURE IF EXISTS AddEnabledColumn;

DELIMITER $$
CREATE PROCEDURE AddEnabledColumn()
BEGIN
    DECLARE col_exists INT;
    
    -- 检查列是否存在
    SELECT COUNT(*) INTO col_exists
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'heritage_platform'
    AND TABLE_NAME = 'quiz_question'
    AND COLUMN_NAME = 'enabled';
    
    -- 如果列不存在，则添加
    IF col_exists = 0 THEN
        ALTER TABLE quiz_question 
        ADD COLUMN enabled BOOLEAN NOT NULL DEFAULT true COMMENT '是否启用';
    END IF;
END$$
DELIMITER ;

-- 执行存储过程
CALL AddEnabledColumn();

-- 删除存储过程
DROP PROCEDURE IF EXISTS AddEnabledColumn;

-- 确保所有现有数据的 enabled 为 true
UPDATE quiz_question SET enabled = true;
