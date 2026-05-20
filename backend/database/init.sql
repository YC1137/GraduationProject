-- 创建数据库
CREATE DATABASE IF NOT EXISTS heritage_platform DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE heritage_platform;

-- 非遗项目表
CREATE TABLE IF NOT EXISTS heritage (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '项目名称',
    category VARCHAR(50) NOT NULL COMMENT '类别',
    region VARCHAR(50) NOT NULL COMMENT '地域',
    level VARCHAR(50) NOT NULL COMMENT '级别',
    inheritor VARCHAR(100) COMMENT '传承人',
    description TEXT COMMENT '简介',
    detail_description TEXT COMMENT '详细介绍',
    thumbnail VARCHAR(500) COMMENT '缩略图',
    images TEXT COMMENT '图片列表(JSON)',
    video VARCHAR(500) COMMENT '视频链接',
    audio VARCHAR(500) COMMENT '音频链接',
    timeline TEXT COMMENT '历史时间轴(JSON)',
    likes INT DEFAULT 0 COMMENT '点赞数',
    favorites INT DEFAULT 0 COMMENT '收藏数',
    views INT DEFAULT 0 COMMENT '浏览量',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (category),
    INDEX idx_region (region),
    INDEX idx_level (level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='非遗项目表';

-- 用户表
CREATE TABLE IF NOT EXISTS user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    nickname VARCHAR(50) COMMENT '昵称（选填）',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    email VARCHAR(100) UNIQUE COMMENT '邮箱',
    avatar VARCHAR(500) COMMENT '头像',
    phone VARCHAR(20) COMMENT '手机号',
    role VARCHAR(20) DEFAULT 'USER' COMMENT '角色(USER/ADMIN)',
    last_login_time DATETIME COMMENT '最后登录时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 评论表
CREATE TABLE IF NOT EXISTS comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    heritage_id BIGINT NOT NULL COMMENT '非遗项目ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    avatar VARCHAR(500) COMMENT '头像',
    content TEXT NOT NULL COMMENT '评论内容',
    likes INT DEFAULT 0 COMMENT '点赞数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_heritage_id (heritage_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- 用户收藏表
CREATE TABLE IF NOT EXISTS user_favorite (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    heritage_id BIGINT NOT NULL COMMENT '非遗项目ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_heritage (user_id, heritage_id),
    INDEX idx_user_id (user_id),
    INDEX idx_heritage_id (heritage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户收藏表';

-- 用户点赞表
CREATE TABLE IF NOT EXISTS user_like (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    heritage_id BIGINT NOT NULL COMMENT '非遗项目ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_heritage (user_id, heritage_id),
    INDEX idx_user_id (user_id),
    INDEX idx_heritage_id (heritage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户点赞表';

-- 知识测验题目表
CREATE TABLE IF NOT EXISTS quiz_question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    question TEXT NOT NULL COMMENT '题目',
    options TEXT NOT NULL COMMENT '选项(JSON数组)',
    answer INT NOT NULL COMMENT '答案索引',
    explanation TEXT COMMENT '解析',
    enabled BOOLEAN NOT NULL DEFAULT true COMMENT '是否启用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识测验题目表';

-- 平台公告表
CREATE TABLE IF NOT EXISTS announcement (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tag VARCHAR(20) NOT NULL COMMENT '标签文字',
    type VARCHAR(20) NOT NULL DEFAULT 'info' COMMENT '标签类型',
    title VARCHAR(300) NOT NULL COMMENT '公告标题',
    content TEXT COMMENT '公告正文',
    pub_date DATE COMMENT '发布日期',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序权重',
    enabled BOOLEAN NOT NULL DEFAULT true COMMENT '是否启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_sort_order (sort_order),
    INDEX idx_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台公告表';

-- 插入初始数据
INSERT INTO heritage (name, category, region, level, inheritor, description, detail_description, thumbnail, images, video, audio, timeline, likes, favorites, views) VALUES
('剪纸艺术', '传统美术', '陕西', '国家级', '王秀英', 
'中国剪纸是用剪刀或刻刀在纸上剪刻花纹，用于装点生活或配合其他民俗活动的一种民间艺术。',
'剪纸艺术是最古老的中国民间艺术之一，作为一种镂空艺术，它能给人以视觉上透空的感觉和艺术享受。剪纸用剪刀将纸剪成各种各样的图案，如窗花、门笺、墙花、顶棚花、灯花等。每逢过节或新婚喜庆，人们便将美丽鲜艳的剪纸贴在家中窗户、墙壁、门和灯笼上，节日的气氛也因此被烘托得更加热烈。陕西剪纸粗犷豪放，构图饱满，造型简练夸张，深受当地民众喜爱。',
'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
'["https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1200","https://images.unsplash.com/photo-1513569143478-b38b2c0ef97f?w=1200","https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
'[{"year":"西汉","event":"剪纸艺术起源，最早用于祭祀和装饰"},{"year":"唐代","event":"剪纸艺术达到鼎盛，技艺更加精湛"},{"year":"宋代","event":"民间剪纸广泛流传，形成地方特色"},{"year":"明清","event":"剪纸成为民间必备的装饰艺术"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
1286, 856, 5432),

('皮影戏', '传统戏剧', '陕西', '国家级', '李明德',
'皮影戏又称"影子戏"或"灯影戏"，是一种以兽皮或纸板做成的人物剪影来表演故事的民间戏剧。',
'皮影戏是中国民间古老的传统艺术，已有两千多年的历史。表演时，艺人们在白色幕布后面，一边操纵影人，一边用当地流行的曲调讲述故事，同时配以打击乐器和弦乐，有浓厚的乡土气息。陕西皮影造型夸张，线条简洁有力，雕刻技艺精湛。传统剧目有《西游记》《封神榜》等。2011年，中国皮影戏入选人类非物质文化遗产代表作名录。',
'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=800',
'["https://images.unsplash.com/photo-1555421689-d68471e189f2?w=1200","https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1200","https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
'[{"year":"西汉","event":"皮影戏雏形出现"},{"year":"宋代","event":"皮影戏在民间广泛流传"},{"year":"元代","event":"随蒙古大军传至波斯等国"},{"year":"清代","event":"皮影戏达到鼎盛时期"},{"year":"2011年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
2145, 1234, 8765),

('苗族刺绣', '传统技艺', '贵州', '国家级', '杨芳',
'苗绣是指苗族民间传承的刺绣技艺，是苗族历史文化中特有的表现形式之一。',
'苗族刺绣工艺独特，针法繁多，色彩艳丽，图案丰富。苗族妇女擅长纺织和刺绣，清《开化府志》、民国《马关县志》都记载有苗族"女子五六岁即教以刺绣"，苗族服饰图案承载了传承本民族文化的历史重任，被称为"穿在身上的史诗"。贵州苗绣题材广泛，有龙凤、花鸟、虫鱼等，每一件都是独一无二的艺术品。',
'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
'["https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200","https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1200","https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
'[{"year":"远古时期","event":"苗族先民开始使用刺绣装饰服饰"},{"year":"明清","event":"苗绣技艺日臻成熟，形成独特风格"},{"year":"近代","event":"苗绣成为苗族文化的重要标志"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
1876, 1023, 6543),

('昆曲', '传统戏剧', '江苏', '国家级', '张继青',
'昆曲又称昆剧、昆腔，是中国最古老的剧种之一，也是中国传统文化艺术中的珍品。',
'昆曲糅合了唱念做打、舞蹈及武术等，以曲词典雅、行腔婉转、表演细腻著称，被誉为"百戏之祖"。昆曲以鼓、板控制演唱节奏，以曲笛、三弦等为主要伴奏乐器，主要以中州官话为舞台语言。经典剧目有《牡丹亭》《长生殿》《桃花扇》等。2001年，昆曲被联合国教科文组织列为"人类口述和非物质遗产代表作"。',
'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800',
'["https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1200","https://images.unsplash.com/photo-1503095396549-807759245b35?w=1200","https://images.unsplash.com/photo-1445001471072-4c96156c6e90?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
'[{"year":"元末明初","event":"昆曲形成于江苏昆山一带"},{"year":"明代中叶","event":"魏良辅改革昆曲，使其走向成熟"},{"year":"清代","event":"昆曲成为全国性剧种，影响深远"},{"year":"2001年","event":"被列入联合国教科文组织人类非遗代表作名录"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
3245, 2156, 12345),

('苏州刺绣', '传统技艺', '江苏', '国家级', '姚惠芬',
'苏绣是中国四大名绣之一，是苏州地区刺绣产品的总称，其发源地在苏州吴县一带。',
'苏绣具有图案秀丽、构思巧妙、绣工细致、针法活泼、色彩清雅的独特风格，地方特色浓郁。苏绣题材广泛，有人物、山水、花鸟、动物等。针法有齐针、散套针、施针、虚实针、乱针、打子针等几十种，丰富多彩。苏绣作品的主要艺术特点为"平、齐、和、光、顺、匀"。代表作品有双面绣《猫》、《金鱼》等，栩栩如生，令人叹为观止。',
'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800',
'["https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=1200","https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200","https://images.unsplash.com/photo-1434725039720-aaad6dd32dfe?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
'[{"year":"三国时期","event":"苏绣开始在吴地流传"},{"year":"宋代","event":"苏绣形成独特的艺术风格"},{"year":"明清","event":"苏绣达到鼎盛，成为贡品"},{"year":"近代","event":"苏绣走向世界，享誉国际"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
2876, 1845, 9876),

('景德镇陶瓷烧制技艺', '传统技艺', '江西', '国家级', '刘伟',
'景德镇陶瓷烧制技艺是中国传统制瓷工艺的集大成者，以其"白如玉、明如镜、薄如纸、声如磬"而闻名于世。',
'景德镇制瓷历史悠久，自宋代以来就是全国的制瓷中心。其陶瓷烧制技艺包括选料、制坯、上釉、彩绘、烧成等72道工序，每道工序都有严格的技术要求。青花、粉彩、玲珑、颜色釉是景德镇四大传统名瓷。景德镇瓷器曾作为"海上丝绸之路"的主要商品远销海外，被誉为"瓷都"。',
'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=800',
'["https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=1200","https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=1200","https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
'[{"year":"东汉","event":"景德镇开始烧制陶瓷"},{"year":"宋代","event":"成为全国制瓷中心"},{"year":"元代","event":"创烧青花瓷"},{"year":"明清","event":"御窑厂设立，技艺登峰造极"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
3456, 2345, 15678),

('古琴艺术', '传统音乐', '浙江', '国家级', '李祥霆',
'古琴，又称瑶琴、玉琴、七弦琴，是中国最古老的弹拨乐器之一，有着三千多年的历史。',
'古琴音域宽广，音色深沉，余韵悠远。古琴艺术体现了中国传统文化"清、微、淡、远"的审美情趣，被视为高雅的代表。古琴曲目丰富，有《高山流水》《广陵散》《平沙落雁》等传世名曲。"琴棋书画"中的"琴"指的就是古琴。2003年，古琴艺术被列入联合国教科文组织人类非物质文化遗产代表作名录。',
'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=800',
'["https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=1200","https://images.unsplash.com/photo-1460723237483-7a6dc9d0b212?w=1200","https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
'[{"year":"周代","event":"古琴已相当流行"},{"year":"春秋战国","event":"古琴艺术逐渐成熟"},{"year":"唐宋","event":"古琴艺术达到鼎盛"},{"year":"明清","event":"古琴流派纷呈"},{"year":"2003年","event":"列入联合国教科文组织人类非遗代表作名录"}]',
2234, 1567, 10234),

('湘绣', '传统技艺', '湖南', '国家级', '刘爱云',
'湘绣是中国四大名绣之一，起源于湖南长沙，以其独特的"鬅毛针"技法和写实风格著称。',
'湘绣擅长刺绣飞禽走兽、山水花鸟。其特色针法"鬅毛针"能表现动物皮毛的质感，栩栩如生。湘绣以长沙为中心，辐射湖南全省及周边地区。代表作品有《虎》《狮》等，其毛发根根分明，神态威猛，令人叹服。湘绣注重质感表现，色彩鲜明，构图严谨，具有浓郁的湖湘文化特色。',
'https://images.unsplash.com/photo-1492778297155-7be4c83960c7?w=800',
'["https://images.unsplash.com/photo-1492778297155-7be4c83960c7?w=1200","https://images.unsplash.com/photo-1581511919791-f8e78e97ad13?w=1200","https://images.unsplash.com/photo-1571847427894-70aca2cb5b72?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
'[{"year":"西汉","event":"长沙马王堆出土早期刺绣品"},{"year":"清末","event":"湘绣形成独特风格"},{"year":"民国","event":"湘绣蓬勃发展，走向国际"},{"year":"1958年","event":"创造出独特的鬅毛针法"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
2987, 1876, 11234),

('越剧', '传统戏剧', '浙江', '国家级', '茅威涛',
'越剧是中国五大戏曲剧种之一，发源于浙江嵊州，以唱腔优美动听、表演真切动人而著称。',
'越剧长于抒情，以唱为主，声腔清悠婉丽，表演真切动人，极具江南灵秀之气。越剧主要流行于江浙沪地区，在海外也有很高声誉。经典剧目有《梁山伯与祝英台》《红楼梦》《西厢记》《白蛇传》等。越剧善于塑造女性形象，被称为"中国女性戏剧"。1906年诞生于浙江嵊县，至今已有百余年历史。',
'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800',
'["https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200","https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=1200","https://images.unsplash.com/photo-1557672172-298e090bd0f1?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
'[{"year":"1906年","event":"越剧诞生于浙江嵊县"},{"year":"1920年代","event":"进入上海，走向全国"},{"year":"1940年代","event":"越剧改革，形成女子越剧"},{"year":"1950年代","event":"越剧进入繁荣时期"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
3678, 2543, 16789),

('龙泉青瓷烧制技艺', '传统技艺', '浙江', '国家级', '徐朝兴',
'龙泉青瓷以其"清澈如秋空、宁静似深海"的梅子青、粉青釉色闻名于世，是中国瓷器的瑰宝。',
'龙泉窑是中国历史上最长的窑系，生产历史达1600多年。龙泉青瓷以釉色青翠著称，釉层丰厚，质地纯净，造型优美。梅子青和粉青是龙泉青瓷的代表釉色，被誉为"青瓷之花"。2009年，龙泉青瓷传统烧制技艺入选联合国教科文组织人类非物质文化遗产代表作名录。龙泉青瓷曾是"海上丝绸之路"的重要输出商品。',
'https://images.unsplash.com/photo-1610701596061-2ecf227e85b2?w=800',
'["https://images.unsplash.com/photo-1610701596061-2ecf227e85b2?w=1200","https://images.unsplash.com/photo-1615485500634-324b7f4cc3c6?w=1200","https://images.unsplash.com/photo-1608106290204-eea6c8d22d9d?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
'[{"year":"三国两晋","event":"龙泉窑创烧"},{"year":"宋代","event":"龙泉青瓷进入鼎盛期"},{"year":"元代","event":"龙泉青瓷大量外销"},{"year":"明清","event":"官窑龙泉青瓷精品迭出"},{"year":"2009年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
2765, 1987, 13456),

('侗族大歌', '传统音乐', '贵州', '国家级', '吴世仙',
'侗族大歌起源于春秋战国时期，是一种多声部、无指挥、无伴奏、自然和声的民间合唱形式。',
'侗族大歌是侗族地区一种多声部、无指挥、无伴奏、自然合声的民间合唱形式，以"众低独高"为特点。侗族大歌的演唱内容涉及历史传说、生产劳动、社交娱乐等各个方面，旋律优美，和声独特。2009年，侗族大歌被列入联合国教科文组织人类非物质文化遗产代表作名录。侗族大歌被音乐界誉为"清泉般闪光的音乐，掠过古梦边缘的旋律"。',
'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
'["https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1200","https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=1200","https://images.unsplash.com/photo-1524650359799-842906ca1c06?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
'[{"year":"春秋战国","event":"侗族大歌起源"},{"year":"宋元","event":"侗族大歌逐渐成熟"},{"year":"明清","event":"侗族大歌广泛流传"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"},{"year":"2009年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
2456, 1654, 11876),

('秦腔', '传统戏剧', '陕西', '国家级', '李梅',
'秦腔是中国西北地区最古老的戏曲剧种，以其高亢激昂的唱腔和粗犷豪放的表演风格著称。',
'秦腔又称乱弹，源于陕西、甘肃一带的民间歌舞，是在古代陕西、甘肃一带民间歌舞的基础上发展起来的。秦腔唱腔高亢激越，强烈急促，有"帮腔"的特殊形式。代表剧目有《三滴血》《窦娥冤》《铡美案》等。秦腔被誉为"中国戏曲之母"，是明代中叶至今流传时间最长、影响最广的声腔剧种。',
'https://images.unsplash.com/photo-1580477667995-2b94f01c9516?w=800',
'["https://images.unsplash.com/photo-1580477667995-2b94f01c9516?w=1200","https://images.unsplash.com/photo-1540575861501-7cf05a4b125a?w=1200","https://images.unsplash.com/photo-1518611012118-696072aa579a?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3',
'[{"year":"明代中叶","event":"秦腔形成于陕甘一带"},{"year":"清代","event":"秦腔传播到全国各地"},{"year":"民国","event":"秦腔进入鼎盛时期"},{"year":"新中国成立后","event":"秦腔剧目整理和创新"},{"year":"2006年","event":"列入首批国家级非物质文化遗产名录"}]',
2987, 1765, 12543),

('端午节', '民俗', '湖南', '国家级', '民俗传承',
'端午节是中国传统节日，为每年农历五月初五，又称端阳节、龙舟节、重午节等。',
'端午节起源于中国古代，最初是祛病防疫的节日，后来纪念爱国诗人屈原。主要习俗有赛龙舟、吃粽子、挂艾草、佩香囊等。湖南汨罗江是屈原投江殉国之地，每年端午节这里都会举行盛大的龙舟竞渡和祭祀活动。2009年，中国端午节入选联合国教科文组织人类非物质文化遗产代表作名录，是中国首个入选的节日。',
'https://images.unsplash.com/photo-1591206369811-4eeb2f18ecf8?w=800',
'["https://images.unsplash.com/photo-1591206369811-4eeb2f18ecf8?w=1200","https://images.unsplash.com/photo-1623578363916-d93fcdcdf699?w=1200","https://images.unsplash.com/photo-1608093808290-7f66537c5c7e?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
'[{"year":"战国时期","event":"屈原投江，端午节开始纪念屈原"},{"year":"汉代","event":"端午节习俗逐渐形成"},{"year":"唐宋","event":"端午节成为重要传统节日"},{"year":"明清","event":"端午节习俗更加丰富"},{"year":"2009年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
4123, 3245, 20567),

('中医针灸', '传统医药', '江苏', '国家级', '石学敏',
'针灸是中医学的重要组成部分，是通过针刺和艾灸刺激人体特定穴位来治疗疾病的方法。',
'针灸学是以中医理论为指导，研究经络、腧穴及刺灸方法，探讨运用针灸防治疾病规律的一门学科。针灸具有适应症广、疗效显著、操作简便、经济安全等优点。2010年，中医针灸被列入联合国教科文组织人类非物质文化遗产代表作名录。针灸已传播到世界183个国家和地区，为全人类的健康做出了巨大贡献。',
'https://images.unsplash.com/photo-1518008284570-9faf7f5813f4?w=800',
'["https://images.unsplash.com/photo-1518008284570-9faf7f5813f4?w=1200","https://images.unsplash.com/photo-1559757175-5700dde675bc?w=1200","https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
'[{"year":"石器时代","event":"砭石治病，针灸起源"},{"year":"春秋战国","event":"针灸理论初步形成"},{"year":"汉代","event":"《黄帝内经》系统总结针灸"},{"year":"明清","event":"针灸学发展到高峰"},{"year":"2010年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
3876, 2987, 18765),

('宣纸制作技艺', '传统技艺', '安徽', '国家级', '邢春荣',
'宣纸产于安徽泾县，因唐代时泾县属宣州府管辖而得名，有"纸中之王、千年寿纸"的美誉。',
'宣纸选用青檀树皮和沙田稻草为原料，经过浸泡、蒸煮、漂白、打浆、水捞、晒纸等108道工序制作而成。宣纸质地绵韧、光洁如玉、不蛀不腐、墨韵清晰，适合书法绘画、裱拓印刷等用途。宣纸制作技艺完全采用手工，工艺复杂，技术性强。2009年，宣纸制作技艺入选联合国教科文组织人类非物质文化遗产代表作名录。',
'https://images.unsplash.com/photo-1455849318743-b2233052fcff?w=800',
'["https://images.unsplash.com/photo-1455849318743-b2233052fcff?w=1200","https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200","https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
'[{"year":"唐代","event":"宣纸开始生产"},{"year":"宋代","event":"宣纸被列为贡品"},{"year":"明清","event":"宣纸制作技艺达到巅峰"},{"year":"近现代","event":"宣纸走向世界"},{"year":"2009年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
2654, 1876, 13245),

('京剧', '传统戏剧', '北京', '国家级', '梅葆玖',
'京剧是中国五大戏曲剧种之一，被誉为中国的"国粹"，距今已有200多年历史。',
'京剧是在北京形成的戏曲剧种之一，至今已有200多年的历史。它是在徽戏和汉戏的基础上，吸收了昆曲、秦腔等戏曲的优点和特长逐渐演变而形成的。京剧唱腔以西皮、二黄为主，用胡琴和锣鼓等伴奏，被视为中国国粹。京剧表演四功五法俱全，包括唱、念、做、打等技艺，行当分为生、旦、净、丑，脸谱艺术独树一帜。2010年，京剧被列入联合国教科文组织人类非物质文化遗产代表作名录。',
'https://images.unsplash.com/photo-1516450137517-162bfbeb8dba?w=800',
'["https://images.unsplash.com/photo-1516450137517-162bfbeb8dba?w=1200","https://images.unsplash.com/photo-1551269901-5c5e14c25df7?w=1200","https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=1200"]',
'https://www.w3schools.com/html/movie.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3',
'[{"year":"1790年","event":"徽班进京，京剧开始孕育"},{"year":"清朝中期","event":"京剧逐渐形成"},{"year":"民国时期","event":"京剧四大名旦诞生，进入鼎盛期"},{"year":"新中国成立后","event":"京剧得到大力发展和推广"},{"year":"2010年","event":"入选联合国教科文组织人类非遗代表作名录"}]',
5678, 3456, 23456),

('二胡演奏', '传统音乐', '江苏', '省级', '闵惠芬',
'二胡是中国传统拉弦乐器，始于唐朝，至今已有一千多年的历史，音色优美，表现力强。',
'二胡又名"胡琴"，是中华民族乐器家族中主要的弓弦乐器之一。二胡由琴筒、琴杆、琴皮、琴弦、琴弓等部分组成，发音柔和优美，有很强的表现力，既能演奏柔和流畅的曲调，也能演奏跳跃有力的旋律。著名二胡曲有《二泉映月》《赛马》《江河水》等。二胡演奏技法丰富，包括揉弦、滑音、颤音、泛音等，是民族管弦乐队中不可或缺的乐器。',
'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=800',
'["https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=1200","https://images.unsplash.com/photo-1519892300165-cb5542fb47c7?w=1200","https://images.unsplash.com/photo-1460723237483-7a6dc9d0b212?w=1200"]',
'https://www.w3schools.com/html/mov_bbb.mp4',
'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3',
'[{"year":"唐代","event":"二胡的前身——奚琴传入中原"},{"year":"宋代","event":"胡琴在民间流行"},{"year":"明清","event":"二胡形制基本定型"},{"year":"20世纪初","event":"刘天华改革二胡，使其登上音乐舞台"},{"year":"现代","event":"二胡成为最受欢迎的民族乐器之一"}]',
1234, 876, 7890);

-- 插入测验题目
INSERT INTO quiz_question (question, options, answer, explanation) VALUES
('以下哪项非遗项目被誉为"百戏之祖"？', '["京剧","昆曲","越剧","黄梅戏"]', 1, '昆曲被誉为"百戏之祖"，是中国最古老的剧种之一，2001年被列入联合国教科文组织人类非遗代表作名录。'),
('中国剪纸艺术起源于哪个朝代？', '["唐代","宋代","西汉","明代"]', 2, '剪纸艺术起源于西汉时期，最早用于祭祀和装饰，已有两千多年的历史。'),
('苗族刺绣被称为什么？', '["指尖上的艺术","穿在身上的史诗","布上的画卷","针线上的传说"]', 1, '苗族刺绣承载了传承本民族文化的历史重任，因其服饰图案丰富而被称为"穿在身上的史诗"。'),
('皮影戏在哪一年入选联合国教科文组织人类非遗代表作名录？', '["2006年","2009年","2011年","2015年"]', 2, '2011年，中国皮影戏入选联合国教科文组织人类非物质文化遗产代表作名录。'),
('苏绣的主要艺术特点不包括以下哪一项？', '["平","齐","活","匀"]', 2, '苏绣作品的主要艺术特点为"平、齐、和、光、顺、匀"，不包括"活"。'),
('以下哪个非遗项目属于传统美术类别？', '["昆曲","皮影戏","剪纸艺术","古琴艺术"]', 2, '剪纸艺术属于传统美术类别，而昆曲和皮影戏属于传统戏剧，古琴艺术属于传统音乐。'),
('首批国家级非物质文化遗产名录公布于哪一年？', '["2001年","2006年","2008年","2010年"]', 1, '2006年，国务院公布了首批国家级非物质文化遗产名录，包括剪纸、昆曲、苏绣等传统艺术。');

-- 插入测试用户
INSERT INTO user (username, password, email, avatar, role) VALUES
('admin', 'admin123', 'admin@heritage.com', 'https://ui-avatars.com/api/?name=admin&background=c8302b&color=fff', 'ADMIN')
ON DUPLICATE KEY UPDATE 
  password = 'admin123',
  email = 'admin@heritage.com',
  avatar = 'https://ui-avatars.com/api/?name=admin&background=c8302b&color=fff',
  role = 'ADMIN';

INSERT INTO user (username, password, email, avatar, role) VALUES
('testuser', '123456', 'test@heritage.com', 'https://ui-avatars.com/api/?name=testuser&background=c8302b&color=fff', 'USER')
ON DUPLICATE KEY UPDATE 
  password = '123456',
  email = 'test@heritage.com',
  avatar = 'https://ui-avatars.com/api/?name=testuser&background=c8302b&color=fff',
  role = 'USER';

-- 数字藏品表
CREATE TABLE IF NOT EXISTS digital_collection_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '藏品名称',
    serial VARCHAR(50) COMMENT '系列编号',
    category VARCHAR(50) COMMENT '类别',
    origin VARCHAR(100) COMMENT '来源',
    era VARCHAR(30) COMMENT '年代',
    rarity VARCHAR(20) COMMENT '稀有度中文',
    rarity_class VARCHAR(20) COMMENT '稀有度class',
    cover VARCHAR(500) COMMENT '封面图',
    glow_color VARCHAR(100) COMMENT '光效颜色',
    description TEXT COMMENT '描述',
    score_min INT DEFAULT 60 COMMENT '最低门槛分（100为满分专属奖励）',
    topic_name VARCHAR(100) DEFAULT NULL COMMENT '绑定专题名称（NULL表示不限专题）',
    total_supply INT DEFAULT 100 COMMENT '总量',
    left_supply INT DEFAULT 100 COMMENT '剩余',
    sale_status VARCHAR(20) DEFAULT 'ongoing' COMMENT '发售状态',
    sale_time DATETIME DEFAULT NULL COMMENT '开售时间（即将开售时用于倒计时）',
    sort_order INT DEFAULT 0 COMMENT '排序',
    enabled BOOLEAN NOT NULL DEFAULT true COMMENT '是否上架',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数字藏品表';

-- 插入示例数字藏品（普通/稀有/史诗，门槛分60）
INSERT INTO digital_collection_item (name, serial, category, origin, era, rarity, rarity_class, cover, glow_color, description, score_min, total_supply, left_supply, sale_status, sort_order, enabled) VALUES
('剪纸精灵', 'HC-001', '传统美术', '陕西剪纸', '现代', '普通', 'common',
 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
 'rgba(156,163,175,0.3)',
 '以陕西剪纸艺术为灵感创作的数字藏品，图案灵动，承载着剪纸的千年技艺。',
 60, 500, 500, 'ongoing', 1, true),

('皮影幻影', 'HC-002', '传统戏剧', '陕西皮影', '现代', '稀有', 'rare',
 'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=400',
 'rgba(37,99,235,0.35)',
 '皮影戏传承两千年，此藏品将光影艺术凝固为永恒数字印记。',
 60, 200, 200, 'ongoing', 2, true),

('苗绣华裳', 'HC-003', '传统技艺', '贵州苗族', '现代', '史诗', 'epic',
 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
 'rgba(124,58,237,0.35)',
 '苗族刺绣"穿在身上的史诗"，针针皆史诗，此藏品重现其惊艳色彩。',
 60, 100, 100, 'ongoing', 3, true),

-- 满分专属奖励藏品（score_min=100）
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
