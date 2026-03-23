-- 完整重建测验系统数据库
USE heritage_platform;

-- 1. 删除旧表(如果存在)
DROP TABLE IF EXISTS quiz_record;
DROP TABLE IF EXISTS quiz_question;
DROP TABLE IF EXISTS quiz_topic;

-- 2. 创建专题表
CREATE TABLE quiz_topic (
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

-- 3. 创建题目表
CREATE TABLE quiz_question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    question TEXT NOT NULL COMMENT '题目',
    options TEXT NOT NULL COMMENT '选项(JSON数组)',
    answer INT NOT NULL COMMENT '答案索引',
    explanation TEXT COMMENT '解析',
    enabled BOOLEAN NOT NULL DEFAULT true COMMENT '是否启用',
    topic_id BIGINT COMMENT '所属专题ID',
    INDEX idx_topic_id (topic_id),
    INDEX idx_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识测验题目表';

-- 4. 创建答题记录表
CREATE TABLE quiz_record (
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

-- 5. 插入专题数据
INSERT INTO quiz_topic (name, description, cover_image, enabled) VALUES
('非遗基础知识', '测试对非物质文化遗产的基础认知', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', true),
('传统戏剧专题', '深入了解中国传统戏剧艺术', 'https://images.unsplash.com/photo-1516307365426-bea591f05011?w=800', true),
('传统技艺专题', '探索中国传统手工艺技术', 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800', true);

-- 6. 插入题目数据
INSERT INTO quiz_question (question, options, answer, explanation, enabled, topic_id) VALUES
('以下哪项非遗项目被誉为"百戏之祖"？', '["京剧","昆曲","越剧","黄梅戏"]', 1, '昆曲被誉为"百戏之祖"，是中国最古老的剧种之一，2001年被列入联合国教科文组织人类非遗代表作名录。', true, 1),
('中国剪纸艺术起源于哪个朝代？', '["唐代","宋代","西汉","明代"]', 2, '剪纸艺术起源于西汉时期，最早用于祭祀和装饰，已有两千多年的历史。', true, 1),
('苗族刺绣被称为什么？', '["指尖上的艺术","穿在身上的史诗","布上的画卷","针线上的传说"]', 1, '苗族刺绣承载了传承本民族文化的历史重任，因其服饰图案丰富而被称为"穿在身上的史诗"。', true, 1),
('皮影戏在哪一年入选联合国教科文组织人类非遗代表作名录？', '["2006年","2009年","2011年","2015年"]', 2, '2011年，中国皮影戏入选联合国教科文组织人类非物质文化遗产代表作名录。', true, 1),
('苏绣的主要艺术特点不包括以下哪一项？', '["平","齐","活","匀"]', 2, '苏绣作品的主要艺术特点为"平、齐、和、光、顺、匀"，不包括"活"。', true, 1),
('以下哪个非遗项目属于传统美术类别？', '["昆曲","皮影戏","剪纸艺术","古琴艺术"]', 2, '剪纸艺术属于传统美术类别，而昆曲和皮影戏属于传统戏剧，古琴艺术属于传统音乐。', true, 1),
('首批国家级非物质文化遗产名录公布于哪一年？', '["2001年","2006年","2008年","2010年"]', 1, '2006年，国务院公布了首批国家级非物质文化遗产名录，包括剪纸、昆曲、苏绣等传统艺术。', true, 1);

-- 7. 更新专题的题目数量
UPDATE quiz_topic t 
SET question_count = (
    SELECT COUNT(*) FROM quiz_question q 
    WHERE q.topic_id = t.id AND q.enabled = true
);

-- 8. 验证数据
SELECT '=== 专题列表 ===' as info;
SELECT id, name, question_count, participant_count FROM quiz_topic;

SELECT '=== 题目列表 ===' as info;
SELECT id, LEFT(question, 30) as question, topic_id FROM quiz_question;

SELECT 'Database rebuild completed successfully!' as info;
