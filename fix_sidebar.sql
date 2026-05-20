-- 修复侧栏图：将无效的localhost图片替换为网络图片
-- 执行前先选择数据库：USE heritage_platform;

UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1513569143478-b38b2c0ef97f?w=400' WHERE id = 1;
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=400' WHERE id = 2;
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400' WHERE id = 3;
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400' WHERE id = 4;
-- id=5 苏州刺绣 已有有效侧栏图
-- id=11 景泰蓝
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400' WHERE id = 11;
-- id=12 故宫修缮技艺
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=400' WHERE id = 12;
-- id=13 中国书法
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1492778297155-7be4c83960c7?w=400' WHERE id = 13;
-- id=14 中国剪纸 (已有)
-- id=16 泥塑
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400' WHERE id = 16;
-- id=17 木偶戏
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1524650359799-842906ca1c06?w=400' WHERE id = 17;
-- id=18 京剧
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1580477667995-2b94f01c9516?w=400' WHERE id = 18;
-- id=19 中医针灸 - 无侧栏图
-- id=20 古琴艺术
UPDATE heritage SET sidebar_image = 'https://images.unsplash.com/photo-1455849318743-b2233052fcff?w=400' WHERE id = 20;
-- id=21 针灸 - 无侧栏图
