-- 检查评论表是否存在
DESCRIBE comment;

-- 检查评论表数据
SELECT COUNT(*) as comment_count FROM comment;

-- 检查用户表数据
SELECT id, username FROM user LIMIT 5;

-- 手动插入一条测试评论（用于调试）
INSERT INTO comment (heritage_id, user_id, username, avatar, content, likes, create_time) 
VALUES (1, 1, 'admin', 'https://example.com/avatar.jpg', '这是一条测试评论', 0, NOW());

-- 查询刚插入的评论
SELECT * FROM comment ORDER BY create_time DESC LIMIT 1;