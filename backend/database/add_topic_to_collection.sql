-- 给数字藏品表增加专题绑定字段
-- 执行前请确保已 USE heritage_platform;

USE heritage_platform;

ALTER TABLE digital_collection_item
    ADD COLUMN topic_name VARCHAR(100) DEFAULT NULL COMMENT '绑定专题名称（与 quiz_question.topic_name 对应，NULL表示不限专题）'
    AFTER score_min;

-- 验证
SHOW COLUMNS FROM digital_collection_item;
