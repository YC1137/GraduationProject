USE heritage_platform;

-- 创建临时表存储每个用户在每个专题的最佳记录ID
CREATE TEMPORARY TABLE best_records AS
SELECT MIN(id) as id
FROM quiz_record
WHERE (user_id, topic_name, accuracy, time_spent) IN (
    SELECT user_id, topic_name, MAX(accuracy) as max_acc, MIN(time_spent) as min_time
    FROM quiz_record
    GROUP BY user_id, topic_name
)
GROUP BY user_id, topic_name;

-- 删除不在最佳记录名单中的记录
DELETE FROM quiz_record 
WHERE id NOT IN (SELECT id FROM best_records);

DROP TEMPORARY TABLE best_records;
