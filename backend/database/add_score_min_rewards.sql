-- ============================================================
-- 补充脚本：插入满分专属奖励藏品
-- 执行前请确保已 USE heritage_platform;
--
-- 如果执行报错"Unknown column 'score_min'"，说明字段不存在，
-- 请先单独执行【步骤A】，再执行【步骤B】
-- ============================================================

USE heritage_platform;

-- ★ 步骤A：添加 score_min 字段（如果字段已存在会报错，直接忽略跳过，执行步骤B）
ALTER TABLE digital_collection_item
    ADD COLUMN score_min INT DEFAULT 60 COMMENT '最低门槛分（100为满分专属奖励）';

-- ★ 步骤B：插入满分专属奖励藏品（INSERT IGNORE 防止重复插入）
INSERT IGNORE INTO digital_collection_item
    (name, serial, category, origin, era, rarity, rarity_class, cover, glow_color, description, score_min, total_supply, left_supply, sale_status, sort_order, enabled)
VALUES
('非遗传承·至尊典藏', 'HC-S01', '荣誉藏品', '非遗平台', '2024', '传奇', 'legendary',
 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400',
 'rgba(217,119,6,0.4)',
 '知识测评满分专属藏品，全球限量发行100份。持有者是非遗文化的真正守护者，永久铭刻荣耀。',
 100, 100, 100, 'ongoing', 0, true),

('昆曲金面', 'HC-S02', '荣誉藏品', '苏州昆曲', '2024', '传奇', 'legendary',
 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400',
 'rgba(217,119,6,0.4)',
 '昆曲被誉为"百戏之祖"，此满分荣誉藏品以昆曲金面为原型，象征文化知识的最高荣耀。',
 100, 50, 50, 'ongoing', 0, true);

-- ★ 步骤C：修复旧数据（如有 score_min 为 NULL 的记录，设为默认60）
UPDATE digital_collection_item SET score_min = 60 WHERE score_min IS NULL;

-- 验证结果
SELECT id, name, score_min, left_supply, enabled
FROM digital_collection_item
WHERE score_min = 100
ORDER BY id;
