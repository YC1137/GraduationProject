/*
 Navicat Premium Dump SQL

 Source Server         : easyproject
 Source Server Type    : MySQL
 Source Server Version : 80300 (8.3.0)
 Source Host           : localhost:3306
 Source Schema         : heritage_platform

 Target Server Type    : MySQL
 Target Server Version : 80300 (8.3.0)
 File Encoding         : 65001

 Date: 04/05/2026 00:52:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `pub_date` date NULL DEFAULT NULL,
  `sort_order` int NOT NULL,
  `tag` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, NULL, b'1', '2026-03-20', 1, '通知', '平台正式上线，欢迎广大非遗爱好者注册体验！', '尊敬的用户：\n\n非遗文化数字保护平台现已正式上线运营。本平台致力于非物质文化遗产的数字化记录、传播与保护工作，汇聚了来自全国各地的珍贵非遗项目资源。\n\n欢迎广大非遗爱好者、研究者及传承人注册使用，共同守护中华传统文化的根与魂。\n\n平台运营团队\n2026-03-20', 'info', NULL);
INSERT INTO `announcement` VALUES (2, NULL, b'1', '2026-03-18', 2, '活动', '2026年非遗文化节线上知识竞答活动开始报名', '活动主题：传承非遗，共绘文化\n\n活动时间：2026年4月1日 - 4月30日\n\n参与方式：\n1. 登录平台，进入\"活动\"专区\n2. 点击\"非遗知识竞答\"参与答题\n3. 答对题目越多，积分越高，可兑换平台专属周边\n\n奖项设置：\n- 一等奖：非遗手工艺品礼盒 × 5名\n- 二等奖：平台年度会员 × 20名\n- 三等奖：精美书签套装 × 100名\n\n期待您的参与！', 'primary', NULL);
INSERT INTO `announcement` VALUES (3, NULL, b'1', '2026-03-15', 3, '更新', '新增50余项国家级非遗项目数据，内容持续扩充中', '本次数据更新内容如下：\n\n一、新增项目\n- 国家级非遗代表性项目 52 项\n- 涵盖传统音乐、传统舞蹈、传统戏剧、传统美术等多个类别\n- 重点补充了西藏、新疆、云南、贵州等地区的少数民族非遗项目\n\n二、内容优化\n- 完善了现有项目的图文资料\n- 新增传承人访谈视频链接 30 余条\n- 优化了地图分布展示效果\n\n感谢广大用户的持续关注与支持！', 'success', NULL);
INSERT INTO `announcement` VALUES (4, NULL, b'1', '2026-03-10', 4, '公告', '关于非遗数字化保护成果展览征集工作的通知', '各位非遗传承人、研究者及爱好者：\n\n为集中展示近年来非遗数字化保护工作成果，平台现面向社会征集优秀数字化保护案例及作品，具体事项如下：\n\n【征集内容】\n1. 非遗项目数字化记录成果（视频、音频、图集）\n2. 非遗传承与创新应用案例\n3. 非遗文创产品设计方案\n\n【征集时间】\n即日起至 2026年5月31日\n\n【提交方式】\n请将作品及简介发送至平台官方邮箱，邮件主题注明\"非遗展览征集\"。\n\n优秀作品将在平台首页进行展示，并颁发荣誉证书。', 'warning', NULL);
INSERT INTO `announcement` VALUES (5, NULL, b'1', '2026-03-08', 5, '活动', '非遗传承人线上直播讲堂第三期即将开播', '非遗传承人线上直播讲堂第三期将于近期开播，本期特邀以下传承人参与分享：\n\n主讲嘉宾：\n- 王大师（苏绣国家级代表性传承人）\n  主题：苏绣针法技艺的传承与创新\n\n- 李老师（景德镇陶瓷烧制技艺省级传承人）\n  主题：千年瓷都的守艺之路\n\n直播时间：2026年4月10日 14:00\n直播平台：本平台\"直播\"专区\n\n欢迎广大用户准时观看，与传承人零距离交流！', 'primary', NULL);

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `subtitle` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `link_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `btn_text` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sort_order` int NULL DEFAULT 0,
  `interval` int NULL DEFAULT 5000,
  `enabled` tinyint(1) NULL DEFAULT 1,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, 'http://localhost:8080/api/uploads/bf5618a56cfa44b89a832effcd9a721b.png', '1', '', '/digital-collection', '', 0, 5000, 1, '2026-03-25 11:43:09', '2026-03-25 14:21:39');
INSERT INTO `banner` VALUES (2, 'http://localhost:8080/api/uploads/78865fdec7014a7b8f3bf14c3ee3ddb6.png', '', '', '/heritage-map', '', 0, 5000, 1, '2026-03-25 14:21:56', '2026-03-26 16:59:24');
INSERT INTO `banner` VALUES (3, 'http://localhost:8080/api/uploads/33c8913b029547dc8d1d8a1240af9b24.png', '', '', '/ai-chat', '', 0, 5000, 1, '2026-03-25 14:47:55', '2026-03-25 14:47:55');
INSERT INTO `banner` VALUES (4, 'http://localhost:8080/api/uploads/df13aa1bd4a7401689148b249ea9eb60.png', '', '', '/bomb', '', 0, 5000, 1, '2026-03-27 15:18:28', '2026-03-27 15:18:28');

-- ----------------------------
-- Table structure for bomb_record
-- ----------------------------
DROP TABLE IF EXISTS `bomb_record`;
CREATE TABLE `bomb_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `win_round` int NOT NULL,
  `leaked_char` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `messages` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bomb_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_bomb_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bomb_record
-- ----------------------------
INSERT INTO `bomb_record` VALUES (1, 32, 'admin999', '湘绣', 1, '湘', '[{\"role\":\"ai\",\"greeting\":true,\"content\":\"游戏开始！我心里守护着一个非遗项目的秘密，你已经知道是哪个了——但我绝对不会亲口说出名字里的字！你有 5 次提问机会，尽管来！\"},{\"role\":\"user\",\"content\":\"这个非遗项目通常在什么节日表演？\"},{\"role\":\"ai\",\"content\":\"嗯，我需要回答关于“湘绣”的问题，但要避免提到“湘”和“绣”这两个字。玩家问的是通常在什么节日表演。首先，我要确认答对项目，同时避开禁字。\\n\\n“湘绣”通常在传统节日期间表演，比如春节、端午节、中秋节等。这些节日有丰富的文化活动，适合展示传统手工艺。我可以提到这些节日，并暗示表演的内容，但避免使用“绣”字。\\n\\n另外，我需要将回答引导到保护传统技艺的重要性，保持守护者的角色，语气要友好自然。\\n\\n要检查回答中是否有“湘”或“绣”，确保没有出现任何禁字。可能我需要用其他方式表达，比如“传统刺绣表演”而不直接使用“绣”字。\\n\\n最后，整理回答，确保在60到120字之间，并符合格式要求。\\n</think>\\n\\n在春节、端午节、中秋节等传统节日期间，许多非物质文化遗产都会通过特别的表演形式向人们展示。而我守护的这项传统技艺，正是在这些节日里，通过精美的作品和精彩的展示，让人们感受到传统文化的魅力。这不仅丰富了节日氛围，也让更多人了解和喜爱这项珍贵的文化遗产。\"}]', '2026-03-26 16:19:37');
INSERT INTO `bomb_record` VALUES (2, 32, 'admin999', '宣纸制作技艺', 1, '艺', '[{\"role\":\"ai\",\"greeting\":true,\"content\":\"游戏开始！我心里守护着一个非遗项目的秘密，你已经知道是哪个了——但我绝对不会亲口说出名字里的字！你有 5 次提问机会，尽管来！\"},{\"role\":\"user\",\"content\":\"它流传于哪个省份或地区？\"},{\"role\":\"ai\",\"content\":\"这项传统工艺主要流传于安徽省南部地区，特别是黄山脚下。那里的山清水秀为这项独特的工艺提供了得天独厚的自然条件，青檀树皮和沙田稻草都是不可或缺的原料。\"}]', '2026-03-26 16:21:07');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `heritage_id` bigint NOT NULL COMMENT '非遗项目ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `likes` int NULL DEFAULT 0 COMMENT '点赞数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_heritage_id`(`heritage_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 16, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', 'qweqweqwe', 0, '2026-03-02 17:02:58', 0);
INSERT INTO `comment` VALUES (2, 1, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', 'test comment', 0, '2026-03-02 17:18:46', 0);
INSERT INTO `comment` VALUES (3, 1, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', 'test comment 2', 0, '2026-03-02 17:20:46', 0);
INSERT INTO `comment` VALUES (6, 999, 1, 'test', NULL, 'test comment', 0, '2026-03-02 17:24:48', 0);
INSERT INTO `comment` VALUES (7, 72, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', '21342', 0, '2026-03-02 20:40:51', 0);
INSERT INTO `comment` VALUES (8, 33, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', '2444444444', 0, '2026-03-03 01:45:50', 0);
INSERT INTO `comment` VALUES (9, 11, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', '123123', 0, '2026-03-03 15:03:11', 0);
INSERT INTO `comment` VALUES (10, 1, 17, 'admin222', 'https://ui-avatars.com/api/?name=admin222&background=c8302b&color=fff', '1234123412', 0, '2026-03-04 18:21:35', 0);
INSERT INTO `comment` VALUES (11, 2, 1, 'admin', 'http://localhost:8080/api/uploads/avatar_1_4b2c1ca981964a7692e9c0004224c2b0.png', '评论', 1, '2026-03-24 11:28:52', 1);
INSERT INTO `comment` VALUES (12, 2, 1, 'admin', 'http://localhost:8080/api/uploads/avatar_1_b86842e8098d49118ed54047c36cdc53.png', '2222', 0, '2026-03-24 11:31:44', 2);
INSERT INTO `comment` VALUES (13, 19, 38, '测试名', 'https://ui-avatars.com/api/?name=测试名&background=c8302b&color=fff', '11', 0, '2026-05-03 21:50:06', 0);

-- ----------------------------
-- Table structure for comment_like
-- ----------------------------
DROP TABLE IF EXISTS `comment_like`;
CREATE TABLE `comment_like`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `comment_id` bigint NOT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment_like
-- ----------------------------
INSERT INTO `comment_like` VALUES (1, 11, '2026-03-24 11:31:35.371548', 1);

-- ----------------------------
-- Table structure for digital_collection_item
-- ----------------------------
DROP TABLE IF EXISTS `digital_collection_item`;
CREATE TABLE `digital_collection_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `countdown` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `era` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `glow_color` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `left_supply` int NULL DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `origin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `rarity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `rarity_class` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sale_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `score_min` int NULL DEFAULT NULL,
  `serial` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sort_order` int NULL DEFAULT NULL,
  `total_supply` int NULL DEFAULT NULL,
  `update_time` datetime(6) NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `name_en` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `topic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `sale_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of digital_collection_item
-- ----------------------------
INSERT INTO `digital_collection_item` VALUES (1, '大师', '', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-24 22:16:03.808595', 1, '现代', 'rgba(100,100,100,0.3)', 90, '剪纸', 'test', '稀有', 'common', 'ongoing', 60, '400', 0, 100, '2026-05-03 23:51:52.258874', NULL, NULL, NULL, NULL);
INSERT INTO `digital_collection_item` VALUES (2, '', '', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 09:50:06.577468', 1, '', 'rgba(100,100,100,0.3)', 0, '皮影', '', '传奇', 'common', 'ongoing', 60, '', 0, 10, '2026-05-01 19:44:01.778966', NULL, NULL, NULL, NULL);
INSERT INTO `digital_collection_item` VALUES (3, '瓶子', '', 'http://localhost:8080/api/uploads/6fe4d448d4924a0ba78ad34da141f835.png', '2026-03-27 14:55:55.304416', 1, '不知道', 'rgba(NaN,186,NaN,1)', 96, 'test', '中国', '传奇', 'legendary', 'ongoing', 60, '', 0, 100, '2026-05-03 22:22:09.037743', '很不错', NULL, NULL, NULL);
INSERT INTO `digital_collection_item` VALUES (4, '荣誉藏品', NULL, 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400', NULL, 1, '2024', 'rgba(217,119,6,0.4)', 98, '非遗传承·至尊典藏', '非遗平台', '传奇', 'legendary', 'ongoing', 100, 'HC-S01', 0, 100, '2026-05-02 20:56:55.959036', '知识测评满分专属藏品，全球限量发行100份。持有者是非遗文化的真正守护者，永久铭刻荣耀。', NULL, 'test', NULL);
INSERT INTO `digital_collection_item` VALUES (5, '荣誉藏品', NULL, 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400', NULL, 1, '2024', 'rgba(217,119,6,0.4)', 48, '昆曲金面', '苏州昆曲', '传奇', 'legendary', 'ongoing', 100, 'HC-S02', 0, 50, '2026-05-02 21:41:10.026943', '昆曲被誉为\"百戏之祖\"，此满分荣誉藏品以昆曲金面为原型，象征文化知识的最高荣耀。', NULL, 'newtest', NULL);

-- ----------------------------
-- Table structure for heritage
-- ----------------------------
DROP TABLE IF EXISTS `heritage`;
CREATE TABLE `heritage`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类别',
  `region` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '地域',
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '级别',
  `inheritor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传承人',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '简介',
  `detail_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详细介绍',
  `thumbnail` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '缩略图',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片列表(JSON)',
  `video` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '视频链接',
  `audio` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '音频链接',
  `sidebar_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '侧栏图URL',
  `timeline` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '历史时间轴(JSON)',
  `likes` int NULL DEFAULT 0 COMMENT '点赞数',
  `favorites` int NULL DEFAULT 0 COMMENT '收藏数',
  `views` int NULL DEFAULT 0 COMMENT '浏览量',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE,
  INDEX `idx_region`(`region` ASC) USING BTREE,
  INDEX `idx_level`(`level` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 136 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '非遗项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of heritage
-- ----------------------------
INSERT INTO `heritage` VALUES (1, '剪纸艺术', '传统美术', '陕西', '国家级', '王秀英', '中国剪纸是用剪刀或刻刀在纸上剪刻花纹，用于装点生活或配合其他民俗活动的一种民间艺术。', '剪纸艺术是最古老的中国民间艺术之一，作为一种镂空艺术，它能给人以视觉上透空的感觉和艺术享受。剪纸用剪刀将纸剪成各种各样的图案，如窗花、门笺、墙花、顶棚花、灯花等。每逢过节或新婚喜庆，人们便将美丽鲜艳的剪纸贴在家中窗户、墙壁、门和灯笼上，节日的气氛也因此被烘托得更加热烈。', 'https://tse2-mm.cn.bing.net/th/id/OIP-C.-moHn1Wq10d1-psoDGK7vwHaE8?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '[\"https://tse2-mm.cn.bing.net/th/id/OIP-C.5ze42uDSvhAvrMVtFI4FmgHaE8?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3\",\"https://images.unsplash.com/photo-1513569143478-b38b2c0ef97f?w=1200\",\"https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=1200\",\"https://tse2-mm.cn.bing.net/th/id/OIP-C.5ze42uDSvhAvrMVtFI4FmgHaE8?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3\",\"https://tse2-mm.cn.bing.net/th/id/OIP-C.5ze42uDSvhAvrMVtFI4FmgHaE8?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '[{\"year\":\"西汉\",\"event\":\"剪纸艺术起源，最早用于祭祀和装饰\"},{\"year\":\"唐代\",\"event\":\"剪纸艺术达到鼎盛，技艺更加精湛\"},{\"year\":\"宋代\",\"event\":\"民间剪纸广泛流传，形成地方特色\"},{\"year\":\"明清\",\"event\":\"剪纸成为民间必备的装饰艺术\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"},{\"year\":\"2414\",\"event\":\"124124\"}]', 1287, 857, 5487, '2026-01-27 03:00:35', '2026-03-25 22:05:50', 1);
INSERT INTO `heritage` VALUES (2, '皮影戏', '传统戏剧', '陕西', '国家级', '李明德', '皮影戏又称\"影子戏\"或\"灯影戏\"，是一种以兽皮或纸板做成的人物剪影来表演故事的民间戏剧。', '皮影戏是中国民间古老的传统艺术，已有两千多年的历史。表演时，艺人们在白色幕布后面，一边操纵影人，一边用当地流行的曲调讲述故事，同时配以打击乐器和弦乐，有浓厚的乡土气息。2011年，中国皮影戏入选人类非物质文化遗产代表作名录。', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '[\"https://images.unsplash.com/photo-1555421689-d68471e189f2?w=1200\",\"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1200\",\"https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1200\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3', 'http://localhost:8080/api/uploads/ba168bc49dca4c0eaeb64c603429fcda.png', '[{\"year\":\"西汉\",\"event\":\"皮影戏雏形出现\"},{\"year\":\"宋代\",\"event\":\"皮影戏在民间广泛流传\"},{\"year\":\"元代\",\"event\":\"随蒙古大军传至波斯等国\"},{\"year\":\"清代\",\"event\":\"皮影戏达到鼎盛时期\"},{\"year\":\"2011年\",\"event\":\"入选联合国教科文组织人类非遗代表作名录\"},{\"year\":\"test\",\"event\":\"test13213123\"},{\"year\":\"12312\",\"event\":\"312313\"}]', 2145, 1234, 8779, '2026-01-27 03:00:35', '2026-03-27 15:01:35', 1);
INSERT INTO `heritage` VALUES (3, '苗族刺绣', '传统技艺', '贵州', '国家级', '杨芳', '苗绣是指苗族民间传承的刺绣技艺，是苗族历史文化中特有的表现形式之一。', '苗族刺绣工艺独特，针法繁多，色彩艳丽，图案丰富。苗族妇女擅长纺织和刺绣，清《开化府志》、民国《马关县志》都记载有苗族\"女子五六岁即教以刺绣\"，苗族服饰图案承载了传承本民族文化的历史重任，被称为\"穿在身上的史诗\"。', 'https://tse2-mm.cn.bing.net/th/id/OIP-C.J7YkBj9M09Rkj3W-I9d8iQHaE7?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '[\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\",\"https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1200\",\"https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3', 'http://localhost:8080/api/uploads/a104f09c1ec84298bc07f21f559eabd2.png', '[{\"year\":\"远古时期\",\"event\":\"苗族先民开始使用刺绣装饰服饰\"},{\"year\":\"明清\",\"event\":\"苗绣技艺日臻成熟，形成独特风格\"},{\"year\":\"近代\",\"event\":\"苗绣成为苗族文化的重要标志\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 1876, 1024, 6546, '2026-01-27 03:00:35', '2026-03-26 20:05:56', 1);
INSERT INTO `heritage` VALUES (4, '昆曲', '传统戏剧', '江苏', '国家级', '张继青', '昆曲又称昆剧、昆腔，是中国最古老的剧种之一，也是中国传统文化艺术中的珍品。', '昆曲糅合了唱念做打、舞蹈及武术等，以曲词典雅、行腔婉转、表演细腻著称，被誉为\"百戏之祖\"。昆曲以鼓、板控制演唱节奏，以曲笛、三弦等为主要伴奏乐器，主要以中州官话为舞台语言。2001年，昆曲被联合国教科文组织列为\"人类口述和非物质遗产代表作\"。', 'https://n.sinaimg.cn/sinakd20220929s/0/w1920h1280/20220929/2cc0-7bca360c54d463e1906c8631e8379221.jpg', '[\"https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1200\",\"https://ts4.tc.mm.bing.net/th/id/OIP-C.Xdshqi_aweGwytqD0fnLHgHaE-?rs=1&pid=ImgDetMain&o=7&rm=3\",\"https://ts1.tc.mm.bing.net/th/id/R-C.d790d4a0775f87c314cddef066583aaa?rik=QGMGwJWpmFqykQ&riu=http%3a%2f%2fwenhui.whb.cn%2fu%2fcms%2fwww%2f201802%2f28110112bcrh.jpg&ehk=7Y2ioZzFlkrkrEIh0rcibod5oOGGavgngTPwzzwT56I%3d&risl=&pid=ImgRaw&r=0\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3', 'http://localhost:8080/api/uploads/a7bb27dffe5b4ad69858daac961798ad.png', '[{\"year\":\"元末明初\",\"event\":\"昆曲形成于江苏昆山一带\"},{\"year\":\"明代中叶\",\"event\":\"魏良辅改革昆曲，使其走向成熟\"},{\"year\":\"清代\",\"event\":\"昆曲成为全国性剧种，影响深远\"},{\"year\":\"2001年\",\"event\":\"被列入联合国教科文组织人类非遗代表作名录\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 3245, 2156, 12348, '2026-01-27 03:00:35', '2026-03-25 22:30:49', 1);
INSERT INTO `heritage` VALUES (5, '苏州刺绣', '传统技艺', '江苏', '国家级', '姚惠芬', '苏绣是中国四大名绣之一，是苏州地区刺绣产品的总称，其发源地在苏州吴县一带。', '苏绣具有图案秀丽、构思巧妙、绣工细致、针法活泼、色彩清雅的独特风格，地方特色浓郁。苏绣题材广泛，有人物、山水、花鸟、动物等。针法有齐针、散套针、施针、虚实针、乱针、打子针等几十种，丰富多彩。苏绣作品的主要艺术特点为\"平、齐、和、光、顺、匀\"。', 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800', '[\"https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=1200\",\"https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200\",\"https://images.unsplash.com/photo-1434725039720-aaad6dd32dfe?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3', 'http://localhost:8080/api/uploads/4ef55fe4cae74ce99c489a4b26ecb05a.png', '[{\"year\":\"三国时期\",\"event\":\"苏绣开始在吴地流传\"},{\"year\":\"宋代\",\"event\":\"苏绣形成独特的艺术风格\"},{\"year\":\"明清\",\"event\":\"苏绣达到鼎盛，成为贡品\"},{\"year\":\"近代\",\"event\":\"苏绣走向世界，享誉国际\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 2876, 1845, 9883, '2026-01-27 03:00:35', '2026-03-24 15:14:25', 1);
INSERT INTO `heritage` VALUES (11, '景德镇陶瓷烧制技艺', '传统技艺', '江西', '国家级', '刘伟', '景德镇陶瓷烧制技艺是中国传统制瓷工艺的集大成者，以其\"白如玉、明如镜、薄如纸、声如磬\"而闻名于世。', '景德镇制瓷历史悠久，自宋代以来就是全国的制瓷中心。其陶瓷烧制技艺包括选料、制坯、上釉、彩绘、烧成等72道工序，每道工序都有严格的技术要求。青花、粉彩、玲珑、颜色釉是景德镇四大传统名瓷。景德镇瓷器曾作为\"海上丝绸之路\"的主要商品远销海外，被誉为\"瓷都\"。', 'https://ts1.tc.mm.bing.net/th/id/R-C.1a29b01ed63375063996c403df816e66?rik=rkEtnQC6w63QNA&riu=http%3a%2f%2fn.sinaimg.cn%2fsinakd20221115ac%2f134%2fw2000h1334%2f20221115%2f014f-dfc014ace0040ce1aa17596d1b024209.jpg&ehk=pKgWX%2fKTjjEfaSqmUkbX%2b8JwLVLHkbCJjOiTvprG5jY%3d&risl=&pid=ImgRaw&r=0', '[\"https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=1200\",\"https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=1200\",\"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3', 'http://localhost:8080/api/uploads/140da25aebb14865b5a0aec259ceba10.png', '[{\"year\":\"东汉\",\"event\":\"景德镇开始烧制陶瓷\"},{\"year\":\"宋代\",\"event\":\"成为全国制瓷中心\"},{\"year\":\"元代\",\"event\":\"创烧青花瓷\"},{\"year\":\"明清\",\"event\":\"御窑厂设立，技艺登峰造极\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 3456, 2345, 15681, '2026-01-27 03:21:54', '2026-05-04 00:28:05', 1);
INSERT INTO `heritage` VALUES (12, '古琴艺术', '传统音乐', '浙江', '国家级', '李祥霆', '古琴，又称瑶琴、玉琴、七弦琴，是中国最古老的弹拨乐器之一，有着三千多年的历史。', '古琴音域宽广，音色深沉，余韵悠远。古琴艺术体现了中国传统文化\"清、微、淡、远\"的审美情趣，被视为高雅的代表。古琴曲目丰富，有《高山流水》《广陵散》《平沙落雁》等传世名曲。\"琴棋书画\"中的\"琴\"指的就是古琴。2003年，古琴艺术被列入联合国教科文组织人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=800', '[\"https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=1200\",\"https://images.unsplash.com/photo-1460723237483-7a6dc9d0b212?w=1200\",\"https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=1200\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3', 'http://localhost:8080/api/uploads/43ca2c97eccd4444b5cc27a4287274fc.png', '[{\"year\":\"周代\",\"event\":\"古琴已相当流行\"},{\"year\":\"春秋战国\",\"event\":\"古琴艺术逐渐成熟\"},{\"year\":\"唐宋\",\"event\":\"古琴艺术达到鼎盛\"},{\"year\":\"明清\",\"event\":\"古琴流派纷呈\"},{\"year\":\"2003年\",\"event\":\"列入联合国教科文组织人类非遗代表作名录\"}]', 2234, 1567, 10234, '2026-01-27 03:21:54', '2026-03-24 15:24:52', 1);
INSERT INTO `heritage` VALUES (13, '湘绣', '传统技艺', '湖南', '国家级', '刘爱云', '湘绣是中国四大名绣之一，起源于湖南长沙，以其独特的\"鬅毛针\"技法和写实风格著称。', '湘绣擅长刺绣飞禽走兽、山水花鸟。其特色针法\"鬅毛针\"能表现动物皮毛的质感，栩栩如生。湘绣以长沙为中心，辐射湖南全省及周边地区。代表作品有《虎》《狮》等，其毛发根根分明，神态威猛，令人叹服。湘绣注重质感表现，色彩鲜明，构图严谨，具有浓郁的湖湘文化特色。', 'https://n.sinaimg.cn/sinakd20118/215/w2048h1367/20220302/7988-7ad4d3148952376f5500f592517bcbca.jpg', '[\"https://images.unsplash.com/photo-1492778297155-7be4c83960c7?w=1200\",\"https://images.unsplash.com/photo-1581511919791-f8e78e97ad13?w=1200\",\"https://images.unsplash.com/photo-1571847427894-70aca2cb5b72?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3', 'http://localhost:8080/api/uploads/b2837d1b8ef946c7af20f9b808a1cef9.png', '[{\"year\":\"西汉\",\"event\":\"长沙马王堆出土早期刺绣品\"},{\"year\":\"清末\",\"event\":\"湘绣形成独特风格\"},{\"year\":\"民国\",\"event\":\"湘绣蓬勃发展，走向国际\"},{\"year\":\"1958年\",\"event\":\"创造出独特的鬅毛针法\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 2987, 1876, 11234, '2026-01-27 03:21:54', '2026-03-25 22:27:00', 1);
INSERT INTO `heritage` VALUES (14, '越剧', '传统戏剧', '浙江', '国家级', '茅威涛', '越剧是中国五大戏曲剧种之一，发源于浙江嵊州，以唱腔优美动听、表演真切动人而著称。', '越剧长于抒情，以唱为主，声腔清悠婉丽，表演真切动人，极具江南灵秀之气。越剧主要流行于江浙沪地区，在海外也有很高声誉。经典剧目有《梁山伯与祝英台》《红楼梦》《西厢记》《白蛇传》等。越剧善于塑造女性形象，被称为\"中国女性戏剧\"。1906年诞生于浙江嵊县，至今已有百余年历史。', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.dFNd4-bcfW6IyJH4o_0aXAHaEK?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '[\"https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200\",\"https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=1200\",\"https://images.unsplash.com/photo-1557672172-298e090bd0f1?w=1200\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3', 'http://localhost:8080/api/uploads/26c357512ca540e6b0a3fc908f131699.png', '[{\"year\":\"1906年\",\"event\":\"越剧诞生于浙江嵊县\"},{\"year\":\"1920年代\",\"event\":\"进入上海，走向全国\"},{\"year\":\"1940年代\",\"event\":\"越剧改革，形成女子越剧\"},{\"year\":\"1950年代\",\"event\":\"越剧进入繁荣时期\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 3679, 2543, 16795, '2026-01-27 03:21:54', '2026-05-03 22:20:57', 1);
INSERT INTO `heritage` VALUES (16, '侗族大歌', '传统音乐', '贵州', '国家级', '吴世仙', '侗族大歌起源于春秋战国时期，是一种多声部、无指挥、无伴奏、自然和声的民间合唱形式。', '侗族大歌是侗族地区一种多声部、无指挥、无伴奏、自然合声的民间合唱形式，以\"众低独高\"为特点。侗族大歌的演唱内容涉及历史传说、生产劳动、社交娱乐等各个方面，旋律优美，和声独特。2009年，侗族大歌被列入联合国教科文组织人类非物质文化遗产代表作名录。侗族大歌被音乐界誉为\"清泉般闪光的音乐，掠过古梦边缘的旋律\"。', 'https://ts1.tc.mm.bing.net/th/id/R-C.2a360c5996068e43bf3742459b2a0fed?rik=LTC2iLC3l4XHHw&riu=http%3a%2f%2fim.wenwuchina.com%2fupload%2f2017%2f02%2f14%2f20170214104545207.jpg&ehk=TyhQKQChlFFz5XN3Qra57RLVLBFZOlQgovuprIlkd8c%3d&risl=&pid=ImgRaw&r=0', '[\"https://ts1.tc.mm.bing.net/th/id/R-C.2a360c5996068e43bf3742459b2a0fed?rik=LTC2iLC3l4XHHw&riu=http%3a%2f%2fim.wenwuchina.com%2fupload%2f2017%2f02%2f14%2f20170214104545207.jpg&ehk=TyhQKQChlFFz5XN3Qra57RLVLBFZOlQgovuprIlkd8c%3d&risl=&pid=ImgRaw&r=0\",\"https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=1200\",\"https://images.unsplash.com/photo-1524650359799-842906ca1c06?w=1200\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3', 'http://localhost:8080/api/uploads/d9121f8c99e34c91b75797635681e3f4.png', '[{\"year\":\"春秋战国\",\"event\":\"侗族大歌起源\"},{\"year\":\"宋元\",\"event\":\"侗族大歌逐渐成熟\"},{\"year\":\"明清\",\"event\":\"侗族大歌广泛流传\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"},{\"year\":\"2009年\",\"event\":\"入选联合国教科文组织人类非遗代表作名录\"}]', 2456, 1654, 11879, '2026-01-27 03:21:54', '2026-03-25 22:33:04', 1);
INSERT INTO `heritage` VALUES (17, '秦腔', '传统戏剧', '陕西', '国家级', '李梅', '秦腔是中国西北地区最古老的戏曲剧种，以其高亢激昂的唱腔和粗犷豪放的表演风格著称。', '秦腔又称乱弹，源于陕西、甘肃一带的民间歌舞，是在古代陕西、甘肃一带民间歌舞的基础上发展起来的。秦腔唱腔高亢激越，强烈急促，有\"帮腔\"的特殊形式。代表剧目有《三滴血》《窦娥冤》《铡美案》等。秦腔被誉为\"中国戏曲之母\"，是明代中叶至今流传时间最长、影响最广的声腔剧种。', 'https://tse4-mm.cn.bing.net/th/id/OIP-C.TzYnb8T02BoNXKrn-gXCoAHaE7?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '[\"https://images.unsplash.com/photo-1580477667995-2b94f01c9516?w=1200\",\"https://images.unsplash.com/photo-1540575861501-7cf05a4b125a?w=1200\",\"https://images.unsplash.com/photo-1518611012118-696072aa579a?w=1200\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3', 'http://localhost:8080/api/uploads/a41d87ea28cb4f6195c796e778560f29.png', '[{\"year\":\"明代中叶\",\"event\":\"秦腔形成于陕甘一带\"},{\"year\":\"清代\",\"event\":\"秦腔传播到全国各地\"},{\"year\":\"民国\",\"event\":\"秦腔进入鼎盛时期\"},{\"year\":\"新中国成立后\",\"event\":\"秦腔剧目整理和创新\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 2987, 1765, 12543, '2026-01-27 03:21:54', '2026-03-25 15:32:44', 1);
INSERT INTO `heritage` VALUES (18, '端午节', '民俗', '湖南', '国家级', '民俗传承', '端午节是中国传统节日，为每年农历五月初五，又称端阳节、龙舟节、重午节等。', '端午节起源于中国古代，最初是祛病防疫的节日，后来纪念爱国诗人屈原。主要习俗有赛龙舟、吃粽子、挂艾草、佩香囊等。湖南汨罗江是屈原投江殉国之地，每年端午节这里都会举行盛大的龙舟竞渡和祭祀活动。2009年，中国端午节入选联合国教科文组织人类非物质文化遗产代表作名录，是中国首个入选的节日。', 'http://localhost:8080/api/uploads/11cf49caced448e5aeb206ecb6b11d44.jpg', '[\"https://images.unsplash.com/photo-1591206369811-4eeb2f18ecf8?w=1200\",\"https://images.unsplash.com/photo-1623578363916-d93fcdcdf699?w=1200\",\"https://images.unsplash.com/photo-1608093808290-7f66537c5c7e?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3', 'http://localhost:8080/api/uploads/ae1598a428c04b7a8eaa925658ee87b5.png', '[{\"year\":\"战国时期\",\"event\":\"屈原投江，端午节开始纪念屈原\"},{\"year\":\"汉代\",\"event\":\"端午节习俗逐渐形成\"},{\"year\":\"唐宋\",\"event\":\"端午节成为重要传统节日\"},{\"year\":\"明清\",\"event\":\"端午节习俗更加丰富\"},{\"year\":\"2009年\",\"event\":\"入选联合国教科文组织人类非遗代表作名录\"}]', 4124, 3246, 20578, '2026-01-27 03:21:54', '2026-05-03 22:22:01', 1);
INSERT INTO `heritage` VALUES (19, '中医针灸', '传统医药', '江苏', '国家级', '石学敏', '针灸是中医学的重要组成部分，是通过针刺和艾灸刺激人体特定穴位来治疗疾病的方法。', '针灸学是以中医理论为指导，研究经络、腧穴及刺灸方法，探讨运用针灸防治疾病规律的一门学科。针灸具有适应症广、疗效显著、操作简便、经济安全等优点。2010年，中医针灸被列入联合国教科文组织人类非物质文化遗产代表作名录。针灸已传播到世界183个国家和地区，为全人类的健康做出了巨大贡献。', 'http://localhost:8080/api/uploads/fe412d98247343c1bd3cd65bec4a9942.jpg', '[\"https://images.unsplash.com/photo-1518008284570-9faf7f5813f4?w=1200\",\"https://images.unsplash.com/photo-1559757175-5700dde675bc?w=1200\",\"https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=1200\"]', 'https://www.w3schools.com/html/movie.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3', NULL, '[{\"year\":\"石器时代\",\"event\":\"砭石治病，针灸起源\"},{\"year\":\"春秋战国\",\"event\":\"针灸理论初步形成\"},{\"year\":\"汉代\",\"event\":\"《黄帝内经》系统总结针灸\"},{\"year\":\"明清\",\"event\":\"针灸学发展到高峰\"},{\"year\":\"2010年\",\"event\":\"入选联合国教科文组织人类非遗代表作名录\"}]', 3876, 2987, 18771, '2026-01-27 03:21:54', '2026-05-04 00:22:02', 1);
INSERT INTO `heritage` VALUES (20, '宣纸制作技艺', '传统技艺', '安徽', '国家级', '邢春荣', '宣纸产于安徽泾县，因唐代时泾县属宣州府管辖而得名，有\"纸中之王、千年寿纸\"的美誉。', '宣纸选用青檀树皮和沙田稻草为原料，经过浸泡、蒸煮、漂白、打浆、水捞、晒纸等108道工序制作而成。宣纸质地绵韧、光洁如玉、不蛀不腐、墨韵清晰，适合书法绘画、裱拓印刷等用途。宣纸制作技艺完全采用手工，工艺复杂，技术性强。2009年，宣纸制作技艺入选联合国教科文组织人类非物质文化遗产代表作名录。', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.F-uHfzZbE9_d29xqnx7pQgHaE8?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '[\"https://images.unsplash.com/photo-1455849318743-b2233052fcff?w=1200\",\"https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200\",\"https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3', 'http://localhost:8080/api/uploads/a67183bce2c342b88eb81a8269819074.png', '[{\"year\":\"唐代\",\"event\":\"宣纸开始生产\"},{\"year\":\"宋代\",\"event\":\"宣纸被列为贡品\"},{\"year\":\"明清\",\"event\":\"宣纸制作技艺达到巅峰\"},{\"year\":\"近现代\",\"event\":\"宣纸走向世界\"},{\"year\":\"2009年\",\"event\":\"入选联合国教科文组织人类非遗代表作名录\"}]', 2654, 1876, 13252, '2026-01-27 03:21:54', '2026-03-26 17:39:28', 1);
INSERT INTO `heritage` VALUES (21, '剪纸艺术', '传统美术', '陕西', '国家级', '王秀英', '中国剪纸是用剪刀或刻刀在纸上剪刻花纹，用于装点生活或配合其他民俗活动的一种民间艺术。', '剪纸艺术是最古老的中国民间艺术之一，作为一种镂空艺术，它能给人以视觉上透空的感觉和艺术享受。剪纸用剪刀将纸剪成各种各样的图案，如窗花、门笺、墙花、顶棚花、灯花等。每逢过节或新婚喜庆，人们便将美丽鲜艳的剪纸贴在家中窗户、墙壁、门和灯笼上，节日的气氛也因此被烘托得更加热烈。陕西剪纸粗犷豪放，构图饱满，造型简练夸张，深受当地民众喜爱。', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', '[\"https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1200\",\"https://images.unsplash.com/photo-1513569143478-b38b2c0ef97f?w=1200\",\"https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"西汉\",\"event\":\"剪纸艺术起源，最早用于祭祀和装饰\"},{\"year\":\"唐代\",\"event\":\"剪纸艺术达到鼎盛，技艺更加精湛\"},{\"year\":\"宋代\",\"event\":\"民间剪纸广泛流传，形成地方特色\"},{\"year\":\"明清\",\"event\":\"剪纸成为民间必备的装饰艺术\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 1286, 856, 5432, '2026-01-27 03:25:39', '2026-01-27 03:25:39', 1);
INSERT INTO `heritage` VALUES (109, '京剧', '传统戏剧', '北京', '国家级', '梅兰芳', '京剧是中国五大戏曲剧种之一，被视为中国国粹。', '京剧腔调以西皮、二黄为主，用胡琴和锣鼓等伴奏。角色分为生、旦、净、丑四大行。表演注重唱、念、做、打并重。京剧以其独特的艺术魅力被誉为\"东方歌剧\"，是中华文化的杰出代表。2006年列入首批国家级非物质文化遗产名录，2010年被列入人类非物质文化遗产代表作名录。', 'https://img95.699pic.com/photo/50195/0005.jpg_wh860.jpg', '[\"https://www.beijing.gov.cn/tsbj/jwwh/jingju/202011/W020201117340099773048.jpg\",\"https://bpic.588ku.com/back_origin_min_pic/23/05/10/22c8e5c0717fae1f0bf05c2ea6b45212.jpg!/fw/750/quality/99/unsharp/true/compress/true\",\"https://bpic.588ku.com/back_origin_min_pic/23/05/10/970360ead7443803200d5717dc94b889.jpg!/fw/750/quality/99/unsharp/true/compress/true\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'http://localhost:8080/api/uploads/ca02263239104550b5afa56b9dcf1371.png', '[{\"year\":\"1790年\",\"event\":\"京剧形成于北京\"},{\"year\":\"1820年代\",\"event\":\"京剧艺术基本成熟\"},{\"year\":\"1860年代\",\"event\":\"京剧进入繁荣期\"},{\"year\":\"民国时期\",\"event\":\"京剧走向鼎盛，名家辈出\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 2134, 8765, 3422, '2026-03-26 20:04:11', '2026-03-26 20:12:40', 1);
INSERT INTO `heritage` VALUES (110, '景泰蓝制作技艺', '传统技艺', '北京', '国家级', '钱美华', '景泰蓝又称\"铜胎掐丝珐琅\"，是一种将铜丝掐成各种图案焊接在铜胎上，再填入珐琅釉料烧制而成的工艺美术品。', '景泰蓝制作工艺复杂，需经过制胎、掐丝、烧焊、点蓝、烧蓝、磨光、镀金等多道工序。其色彩丰富，以蓝为主色调，作品庄重典雅，富丽堂皇。景泰蓝既是实用器物，也是精美的艺术品，被誉为\"中华国粹\"。明代景泰年间制作的最为精美，故称\"景泰蓝\"。', 'https://www.beijing.gov.cn/tsbj/jwwh/tushuofeiyi/202312/W020231225398806866235.jpg', '[\"https://www.beijing.gov.cn/tsbj/jwwh/tushuofeiyi/202312/W020231225398806866235.jpg\",\"https://ts1.tc.mm.bing.net/th/id/R-C.691fe4ff39de1241f501889f5ae681fa?rik=ScDwFS0W2YYWwQ&riu=http%3a%2f%2fe0.ifengimg.com%2f03%2f2019%2f0313%2fDF0CCD9DDF5CA542A592B065FDE080E01C694483_size45_w640_h514.jpeg&ehk=LatVQ0jvuOXZMzMfLhIWdSzSnM9vkK%2bqIBHGj%2bt7cvs%3d&risl=&pid=ImgRaw&r=0\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'http://localhost:8080/api/uploads/61fb9ef1be7544ce9954b32cb2407eaa.png', '[{\"year\":\"元代\",\"event\":\"景泰蓝工艺从阿拉伯地区传入中国\"},{\"year\":\"明代\",\"event\":\"景泰年间达到鼎盛，蓝色珐琅最为著名\"},{\"year\":\"清代\",\"event\":\"宫廷成立造办处，专制御用景泰蓝\"},{\"year\":\"1904年\",\"event\":\"景泰蓝工艺品在国际博览会上获奖\"},{\"year\":\"2006年\",\"event\":\"列入首批国家级非物质文化遗产名录\"}]', 1245, 4321, 1876, '2026-03-26 20:04:11', '2026-03-26 20:11:22', 1);
INSERT INTO `heritage` VALUES (111, '龙泉青瓷烧制技艺', '传统技艺', '浙江', '国家级', '徐朝兴', '龙泉青瓷是中国陶瓷的杰出代表，以其\"青如玉、明如镜、薄如纸、声如磬\"的特点闻名于世。', '龙泉青瓷始于三国两晋，盛于宋代。其釉色青翠莹润，有粉青、梅子青等名贵品种。烧制工艺包括选料、成型、装饰、上釉、烧制等环节，需要精湛的技艺和丰富的经验。龙泉青瓷不仅具有实用价值，更是极具收藏价值的艺术品。2009年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800', '[\"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200\",\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"三国两晋\",\"event\":\"龙泉青瓷开始烧制\"},{\"year\":\"北宋\",\"event\":\"龙泉青瓷技艺日趋成熟\"},{\"year\":\"南宋\",\"event\":\"龙泉青瓷达到鼎盛，形成独特风格\"},{\"year\":\"明代\",\"event\":\"龙泉窑成为著名瓷窑\"},{\"year\":\"2009年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 1567, 5678, 2134, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (115, '苏绣', '传统美术', '江苏', '国家级', '姚建萍', '苏绣是中国四大名绣之一，以精细雅洁著称，被誉为\"东方艺术的明珠\"。', '苏绣历史悠久，起源于苏州地区。其特点可以用\"平、齐、细、密、匀、顺、和，光\"八个字概括。技法丰富，有齐针、套针、戗针、乱针等四十多种。题材广泛，有人物、山水、花鸟、动物等。苏绣作品精美绝伦，具有很高的艺术价值和收藏价值。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=800', '[\"https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=1200\",\"https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"春秋时期\",\"event\":\"苏绣已有2000多年历史\"},{\"year\":\"宋代\",\"event\":\"苏绣技艺日趋成熟，形成独特风格\"},{\"year\":\"明代\",\"event\":\"苏绣成为著名绣种\"},{\"year\":\"清代\",\"event\":\"苏绣进入鼎盛期，涌现出大量精品\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 1234, 4567, 1987, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (116, '太极拳', '传统体育', '河南', '国家级', '陈小旺', '太极拳是中国传统武术的代表，以柔克刚、借力打力著称，是一种内外兼修的传统拳术。', '太极拳起源于河南温县陈家沟，由陈王廷创编。其动作圆活连贯，轻柔缓慢，如行云流水。太极拳讲究意、气、神三者合一，具有强身健体、修身养性的功效。太极拳流派众多，主要有陈式、杨式、武式、吴式、孙式等。2020年，太极拳入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800', '[\"https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=1200\",\"https://images.unsplash.com/photo-1599809275671-b5942cabc7a2?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"明末清初\",\"event\":\"陈王廷创编太极拳\"},{\"year\":\"清代中叶\",\"event\":\"太极拳在陈家沟代代相传\"},{\"year\":\"民国时期\",\"event\":\"太极拳传播至全国各大城市\"},{\"year\":\"1956年\",\"event\":\"国家体委编创二十四式简化太极拳\"},{\"year\":\"2020年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 2456, 7890, 3654, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (117, '宣纸制作技艺', '传统技艺', '安徽', '国家级', '曹光华', '宣纸是中国传统的书画用纸，产于安徽宣城，因其优良的品质被誉为\"纸中之王\"。', '宣纸以青檀皮和沙田稻草为原料，经过108道工序手工制作而成。其特点是纹理清晰、质地绵韧、色泽白雅、润墨性强。有\"轻似蝉翼白如雪，抖似细绸不闻声\"的美誉。宣纸不仅是书画的理想材料，也是保存文献档案的最佳用纸，有\"千年寿纸\"之称。2009年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1585338107529-13afc5f02586?w=800', '[\"https://images.unsplash.com/photo-1585338107529-13afc5f02586?w=1200\",\"https://images.unsplash.com/photo-1560485742-3b3b6e9a8c0f?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"唐代\",\"event\":\"宣纸产于宣城地区\"},{\"year\":\"宋代\",\"event\":\"宣纸制作技艺日趋完善\"},{\"year\":\"明代\",\"event\":\"宣纸成为宫廷和文人墨客的首选用纸\"},{\"year\":\"清代\",\"event\":\"宣纸制作达到鼎盛，品种繁多\"},{\"year\":\"2009年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 876, 3210, 1432, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (118, '二十四节气', '民俗', '全国', '国家级', '', '二十四节气是中国古代农耕文明的产物，反映了季节变化、气候特点和物候现象。', '二十四节气包括立春、雨水、惊蛰、春分、清明、谷雨、立夏、小满、芒种、夏至、小暑、大暑、立秋、处暑，白露、秋分、寒露、霜降、立冬、小雪、大雪、冬至、小寒、大寒。二十四节气指导着中国人民的农业生产和日常生活，是中国传统历法体系的重要组成部分。2016年入选人类非物质文化遗产代表作名录。', 'https://5b0988e595225.cdn.sohucs.com/images/20191223/3781dd6b3fd04d758b7fd95031dc59cc.jpeg', '[\"https://5b0988e595225.cdn.sohucs.com/images/20191223/3781dd6b3fd04d758b7fd95031dc59cc.jpeg\",\"http://img.ts.cn/003/506/980/00350698049_c9db5525.jpg\",\"http://img.ts.cn/003/506/980/00350698050_bc9614e0.jpg\",\"http://img.ts.cn/003/506/980/00350698051_1f61f8c5.jpg\",\"http://img.ts.cn/003/506/980/00350698052_ae73ff46.jpg\",\"http://img.ts.cn/003/506/980/00350698054_70d6218c.jpg\",\"http://img.ts.cn/003/506/980/00350698055_b5113f80.jpg\",\"http://img.ts.cn/003/506/980/00350698056_56f6731d.jpg\",\"http://img.ts.cn/003/506/980/00350698057_d4cefa32.jpg\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 'https://p6-flow-imagex-sign.byteimg.com/tos-cn-i-a9rns2rl98/rc_gen_image/4024004674e04d55b118dd371ba6051a.jpeg~tplv-a9rns2rl98-image_dld_watermark_1_5b.png?lk3s=8e244e95&rcl=202603262010330037B36A873216CDAF69&rrcfp=827586d3&x-expires=2089887044&x-signature=ZKAGeM26ccirpe7Y12Ur4RkY4HI%3D', '[{\"year\":\"春秋时期\",\"event\":\"古代天文数学家用土圭测日影，定出春分、秋分\"},{\"year\":\"战国时期\",\"event\":\"增加夏至、冬至，形成四个节气\"},{\"year\":\"秦汉时期\",\"event\":\"二十四节气逐步完善\"},{\"year\":\"汉武帝时期\",\"event\":\"二十四节气正式列入历法\"},{\"year\":\"2016年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 1987, 6543, 2877, '2026-03-26 20:04:11', '2026-03-26 20:14:29', 1);
INSERT INTO `heritage` VALUES (119, '蜀绣', '传统美术', '四川', '国家级', '郝淑萍', '蜀绣是中国四大名绣之一，以其生动传神的图案和精细的针法著称。', '蜀绣又称\"川绣\"，起源于四川地区，历史悠久。其特点包括形象生动、绚丽多彩、虚实得体。针法技艺独特，有121种之多，以套针为主，配合纱针、铺针等技法。题材以花鸟虫鱼、人物走兽为主。蜀绣作品具有浓郁的地方特色和艺术风格。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=800', '[\"https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200\",\"https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"春秋时期\",\"event\":\"蜀绣已有2000多年历史\"},{\"year\":\"汉代\",\"event\":\"蜀绣技艺达到较高水平\"},{\"year\":\"唐代\",\"event\":\"蜀绣成为宫廷贡品\"},{\"year\":\"清代\",\"event\":\"蜀绣进入鼎盛期，涌现众多佳作\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 987, 3876, 1655, '2026-03-26 20:04:11', '2026-05-02 21:18:12', 1);
INSERT INTO `heritage` VALUES (120, '中医针灸', '传统医药', '全国', '国家级', '王雪苔', '中医针灸是中国传统医学的重要组成部分，包括针法和灸法，是一种通过刺激人体穴位来治疗疾病的方法。', '针灸理论以经络学说为核心，认为人体有365个穴位，分别属于十二经脉和奇经八脉。针法是用金属针刺入穴位，灸法是用艾绒燃烧熏烤穴位。针灸具有疏通经络、调和气血、平衡阴阳的作用，对多种疾病有显著疗效。2010年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=800', '[\"https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=1200\",\"https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"新石器时代\",\"event\":\"砭石是针灸的起源\"},{\"year\":\"春秋战国时期\",\"event\":\"针灸理论开始形成\"},{\"year\":\"秦汉时期\",\"event\":\"《黄帝内经》奠定针灸理论基础\"},{\"year\":\"宋代\",\"event\":\"针灸教学体系完善，穴位逐步规范化\"},{\"year\":\"2010年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 1543, 5432, 2345, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (121, '宜兴紫砂陶制作技艺', '传统技艺', '江苏', '国家级', '顾绍培', '宜兴紫砂陶是中国独特的陶瓷品种，以其独特的紫砂泥料和精湛的制作工艺著称。', '宜兴紫砂陶始于宋代，盛于明清。紫砂泥料是一种特殊的陶土，含有丰富的铁元素，烧制后呈紫红色或紫棕色。紫砂壶造型优美，款式繁多，有\"方非一式，圆不一相\"之说。紫砂壶具有良好的透气性和保温性，泡茶不走味，是茶具中的珍品。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800', '[\"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200\",\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"宋代\",\"event\":\"宜兴紫砂陶开始烧制\"},{\"year\":\"明代\",\"event\":\"供春创制紫砂壶，技艺日趋成熟\"},{\"year\":\"清代\",\"event\":\"紫砂壶进入鼎盛期，制壶名家辈出\"},{\"year\":\"民国时期\",\"event\":\"紫砂壶艺继续发展\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 1234, 4567, 1876, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (122, '评弹艺术', '传统音乐', '江苏', '国家级', '蒋月泉', '评弹是苏州评话和弹词的总称，是一种以说唱为主的曲艺形式。', '苏州评话以说为主，辅以评，故事情节生动，人物形象鲜明。弹词则唱演并重，曲调优美，唱词文雅。评弹艺术语言生动风趣，表演细腻传神，具有浓郁的江南水乡特色。传统书目有《三国演义》、《水浒传》、《珍珠塔》等。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1516567832553-9f06df2c6ee4?w=800', '[\"https://images.unsplash.com/photo-1516567832553-9f06df2c6ee4?w=1200\",\"https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"明代\",\"event\":\"评弹起源于苏州地区\"},{\"year\":\"清代乾隆年间\",\"event\":\"评弹艺术基本成型，名家辈出\"},{\"year\":\"近代\",\"event\":\"蒋月泉改革评弹，创立\"蒋调\"\"},{\"year\":\"当代\",\"event\":\"评弹继续传承发展\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 876, 2987, 1432, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (123, '湘绣', '传统美术', '湖南', '国家级', '刘爱云', '湘绣是中国四大名绣之一，以其独特的虎头绣和鬅毛针技法著称。', '湘绣起源于湖南长沙地区，历史悠久。其特点包括形象生动、色彩丰富、针法独特。湘绣最具特色的技法是虎头绣和鬅毛针，能逼真地表现动物的毛发质感。题材以狮虎等猛兽、人物、花鸟为主。湘绣作品具有鲜明的地方特色和艺术风格。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=800', '[\"https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=1200\",\"https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"春秋战国时期\",\"event\":\"湘绣已有2000多年历史\"},{\"year\":\"汉代\",\"event\":\"湘绣技艺达到较高水平\"},{\"year\":\"清代\",\"event\":\"湘绣进入鼎盛期，形成独特风格\"},{\"year\":\"近代\",\"event\":\"湘绣涌现众多刺绣大师\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 943, 3654, 1567, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (124, '粤剧', '传统戏剧', '广东', '国家级', '陈笑风', '粤剧是中国南方戏曲剧种之一，以广州话演唱，有\"南国红豆\"的美誉。', '粤剧形成于清代中叶，融合了唱、念、做、打等多种表演形式。其唱腔优美，板式丰富，有梆子、二黄两大声腔体系。表演注重武打和舞蹈，动作洗练大方。粤剧行当分为生、旦、丑、末、净等。经典剧目有《帝女花》、《紫钗记》等。2009年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1547534767-2efd3d12da4e?w=800', '[\"https://images.unsplash.com/photo-1547534767-2efd3d12da4e?w=1200\",\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"明代\",\"event\":\"弋阳腔传入广东，为粤剧前身\"},{\"year\":\"清代中叶\",\"event\":\"粤剧在广东形成\"},{\"year\":\"清末民初\",\"event\":\"粤剧进入繁荣期，涌现众多流派\"},{\"year\":\"1950年代\",\"event\":\"粤剧进行改革，艺术水平提高\"},{\"year\":\"2009年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 1234, 4567, 1987, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (125, '中国木拱桥传统营造技艺', '传统技艺', '福建', '国家级', '郑多金', '木拱桥是中国传统的桥梁建筑形式，不用一钉一铁，全凭榫卯嵌合。', '木拱桥又称\"虹桥\"，主要分布在福建、浙江等地。其结构巧妙，利用木料的抗压、抗拉特性，通过榫卯嵌合将木材连接成稳定的拱形结构。木拱桥造型优美，与周围山水环境和谐相融。著名的木拱桥有福建的鸾峰桥、浙江的溪东桥等。2009年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=800', '[\"https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?w=1200\",\"https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"宋代\",\"event\":\"木拱桥开始出现\"},{\"year\":\"明代\",\"event\":\"木拱桥营造技艺日趋成熟\"},{\"year\":\"清代\",\"event\":\"木拱桥遍布福建、浙江山区\"},{\"year\":\"当代\",\"event\":\"木拱桥营造技艺得到保护和传承\"},{\"year\":\"2009年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 765, 2345, 1234, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (126, '活字印刷术', '传统技艺', '全国', '国家级', '', '活字印刷术是中国古代四大发明之一，由毕昇发明，是印刷史上的重大革命。', '活字印刷术发明于北宋庆历年间，采用胶泥刻字，单字排版，反复使用。其优点在于可以灵活排版，适合印刷多种书籍。活字印刷术比西方活字印刷早400多年，对世界文明的发展产生了深远影响。后来发展出木活字、金属活字等多种形式。2010年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1561287898-4f4c2c5e0e7e?w=800', '[\"https://images.unsplash.com/photo-1561287898-4f4c2c5e0e7e?w=1200\",\"https://images.unsplash.com/photo-1585338107529-13afc5f02586?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"北宋庆历年间\",\"event\":\"毕昇发明活字印刷术\"},{\"year\":\"元代\",\"event\":\"王祯创制木活字\"},{\"year\":\"明代\",\"event\":\"金属活字出现并广泛应用\"},{\"year\":\"清代\",\"event\":\"活字印刷达到鼎盛\"},{\"year\":\"2010年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 1123, 3876, 1876, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (127, '皮影戏', '传统戏剧', '陕西', '国家级', '汪天稳', '皮影戏是一种用兽皮制成的人物剪影进行表演的民间戏剧形式，有\"电影的先驱\"之称。', '皮影戏源于陕西华县，距今已有2000多年历史。制作皮影要经过选皮、刮皮、描样、雕刻、上色等十多道工序。表演时，艺人在白色幕布后操纵皮影，配合戏曲唱腔和音乐，讲述故事。皮影造型生动，色彩鲜艳，具有很高的艺术价值。2011年入选人类非物质文化遗产代表作名录。', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', '[\"https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1200\",\"https://images.unsplash.com/photo-1513569143478-b38b2c0ef97f?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"西汉\",\"event\":\"皮影戏起源，相传用于祭祀\"},{\"year\":\"唐代\",\"event\":\"皮影戏用于宫廷娱乐\"},{\"year\":\"宋代\",\"event\":\"皮影戏达到鼎盛，遍及民间\"},{\"year\":\"清代\",\"event\":\"皮影戏传播至全国各地\"},{\"year\":\"2011年\",\"event\":\"入选人类非物质文化遗产代表作名录\"}]', 1032, 3654, 1654, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (128, '敦煌壁画', '传统美术', '甘肃', '国家级', '', '敦煌壁画是敦煌艺术的重要组成部分，以其宏大的规模、精湛的技艺和深厚的文化内涵闻名于世。', '敦煌莫高窟始建于前秦时期，历经十六国、北魏、西魏、北周、隋、唐、五代、宋、西夏、元等朝代，形成巨大的石窟群。壁画内容丰富，包括佛像、菩萨、飞天、经变画、本生故事等。壁画色彩鲜艳，线条流畅，人物形象生动，是研究中国古代艺术和文化的重要资料。1987年，莫高窟被列入世界文化遗产名录。', 'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800', '[\"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200\",\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"前秦建元二年\",\"event\":\"莫高窟开始营建\"},{\"year\":\"北魏时期\",\"event\":\"壁画风格受印度犍陀罗艺术影响\"},{\"year\":\"唐代\",\"event\":\"敦煌壁画达到鼎盛，技法成熟，色彩绚丽\"},{\"year\":\"西夏元代\",\"event\":\"壁画继续发展，融入新元素\"},{\"year\":\"1987年\",\"event\":\"莫高窟被列入世界文化遗产名录\"}]', 2345, 8765, 3421, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (129, '蜀锦织造技艺', '传统技艺', '四川', '国家级', '叶永洲', '蜀锦是中国四大名锦之一，以其绚丽的色彩、独特的纹样和精湛的织造技艺著称。', '蜀锦产于四川成都，有两千多年历史。其织造技艺复杂，需在花楼织机上由两人配合操作，一人拉花，一人投梭送纬。蜀锦图案丰富，有几何纹、花鸟纹、人物故事等。色彩以红、蓝、黄、绿为主，鲜艳华丽。蜀锦不仅是精美的工艺品，也是研究蜀文化的重要实物资料。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=800', '[\"https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=1200\",\"https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"春秋战国时期\",\"event\":\"蜀锦已有2000多年历史\"},{\"year\":\"汉代\",\"event\":\"蜀锦成为著名织锦品种\"},{\"year\":\"唐代\",\"event\":\"蜀锦织造技艺达到鼎盛\"},{\"year\":\"宋代\",\"event\":\"蜀锦图案创新，品种繁多\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 876, 3210, 1432, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (130, '中医正骨疗法', '传统医药', '全国', '国家级', '罗有名', '中医正骨疗法是通过手法复位、夹板固定、药物治疗等方法治疗骨折、关节脱位等疾病的中医特色疗法。', '正骨疗法历史悠久，起源于古代中医伤科。其特点是注重整体观念，强调筋骨并重。通过望、闻、问、切四诊合参，诊断病情。手法的运用是正骨的核心，包括摸、接、端、提、推、拿、按、摩等。正骨疗法对骨折、关节脱位、软组织损伤等有显著疗效。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=800', '[\"https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=1200\",\"https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"周代\",\"event\":\"正骨疗法已有记载\"},{\"year\":\"隋代\",\"event\":\"《诸病源候论》记载正骨方法\"},{\"year\":\"唐代\",\"event\":\"正骨成为专科\"},{\"year\":\"清代\",\"event\":\"《医宗金鉴》总结正骨经验\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 1032, 3876, 1655, '2026-03-26 20:04:11', '2026-03-26 20:04:32', 1);
INSERT INTO `heritage` VALUES (131, '黄酒酿造技艺', '传统技艺', '浙江', '国家级', '钱兴华', '黄酒是中国特有的传统酿造酒，以其醇厚的口感和丰富的营养价值被誉为\"液体蛋糕\"。', '绍兴黄酒产于浙江绍兴，有2500多年历史。采用优质糯米和鉴湖水为原料，经过浸米、蒸饭、落缸、开耙、压榨、煎酒等工序，自然发酵而成。黄酒含有多氨基酸、微量元素等营养成分，具有舒筋活血、美容养颜的功效。绍兴黄酒品种繁多，有加饭酒、善酿酒、香雪酒等。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800', '[\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\",\"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"春秋时期\",\"event\":\"黄酒酿造已有2500多年历史\"},{\"year\":\"宋代\",\"event\":\"黄酒酿造技艺日趋成熟\"},{\"year\":\"清代\",\"event\":\"绍兴黄酒成为著名特产\"},{\"year\":\"1915年\",\"event\":\"绍兴黄酒在美国巴拿马万国博览会上获金奖\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 765, 2345, 1234, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (132, '河南坠子', '传统音乐', '河南', '国家级', '陈梅生', '河南坠子是由河南坠子为基础发展而成的曲艺形式，以其独特的唱腔和表演风格著称。', '河南坠子形成于清代末年，主要流布于河南及周边地区。其唱腔粗犷豪放，旋律优美，有\"一泻千里\"之势。表演形式灵活，有单口、对口、群口等多种形式。坠子书内容丰富，有历史故事、民间传说、公案侠义等题材。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1516567832553-9f06df2c6ee4?w=800', '[\"https://images.unsplash.com/photo-1516567832553-9f06df2c6ee4?w=1200\",\"https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"清代末年\",\"event\":\"河南坠子形成于河南地区\"},{\"year\":\"民国时期\",\"event\":\"坠子广泛流传于中原地区\"},{\"year\":\"1950年代\",\"event\":\"河南坠子进行改革，艺术水平提高\"},{\"year\":\"当代\",\"event\":\"河南坠子继续传承发展\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 654, 1876, 987, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (133, '茅台酒酿造技艺', '传统技艺', '贵州', '国家级', '季克良', '茅台酒是中国酱香型白酒的典型代表，以其独特的风味和卓越的品质被誉为\"国酒\"。', '茅台酒产于贵州仁怀茅台镇，有800多年历史。采用优质高粱为原料，经过九次蒸煮、八次发酵、七次取酒等复杂工艺，自然发酵而成。茅台酒具有酱香突出、幽雅细腻、酒体醇厚、回味悠长等特点。其酿造技艺独特，是中华民族智慧的结晶。2014年，茅台酒酿造技艺列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800', '[\"https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200\",\"https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"西汉\",\"event\":\"茅台镇已有酿酒历史\"},{\"year\":\"1915年\",\"event\":\"茅台酒在美国巴拿马万国博览会上获金奖\"},{\"year\":\"1935年\",\"event\":\"长征途中红军与茅台镇结缘\"},{\"year\":\"1949年\",\"event\":\"茅台酒成为开国大典国宴用酒\"},{\"year\":\"2014年\",\"event\":\"茅台酒酿造技艺列入国家级非物质文化遗产名录\"}]', 1876, 5432, 2876, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (134, '泥人张彩塑', '传统美术', '天津', '国家级', '张明达', '泥人张彩塑是天津的传统民间艺术，以其精湛的塑形技艺和绚丽的彩绘风格著称。', '泥人张彩塑起源于天津，由张明山创立于清代道光年间。其特点是将雕塑与彩绘完美结合，人物形象生动逼真，色彩鲜艳和谐。泥人张彩塑题材广泛，有戏曲人物、民间故事、市井生活等。制作工艺包括和泥、捏制、彩绘等步骤。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=800', '[\"https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=1200\",\"https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"清代道光年间\",\"event\":\"张明山创立泥人张彩塑\"},{\"year\":\"清代\",\"event\":\"泥人张彩塑技艺代代相传\"},{\"year\":\"近代\",\"event\":\"泥人张彩塑进入鼎盛期\"},{\"year\":\"当代\",\"event\":\"泥人张彩塑继续传承发展\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 765, 2987, 1123, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);
INSERT INTO `heritage` VALUES (135, '杨柳青木板年画', '传统美术', '天津', '国家级', '霍庆顺', '杨柳青木版年画是中国著名的木版年画之一，以其细腻的刻工、鲜艳的色彩和丰富的内容著称。', '杨柳青年画产于天津西青区杨柳青镇，有600多年历史。其制作工艺包括刻版、印刷、手绘上色等环节。年画内容丰富，有门神、仕女、娃娃、戏曲人物、山水花鸟等。色彩鲜艳，线条细腻，构图饱满，富有浓郁的民间艺术特色。2006年列入国家级非物质文化遗产名录。', 'https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=800', '[\"https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=1200\",\"https://images.unsplash.com/photo-1582562124811-c09020d0a2cb?w=1200\"]', 'https://www.w3schools.com/html/mov_bbb.mp4', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', NULL, '[{\"year\":\"明代\",\"event\":\"杨柳青年画开始兴起\"},{\"year\":\"清代乾隆年间\",\"event\":\"杨柳青年画达到鼎盛\"},{\"year\":\"清代晚期\",\"event\":\"杨柳青年画遍及北方地区\"},{\"year\":\"近代\",\"event\":\"杨柳青年画进行改革创新\"},{\"year\":\"2006年\",\"event\":\"列入国家级非物质文化遗产名录\"}]', 687, 2345, 1098, '2026-03-26 20:04:11', '2026-03-26 20:04:11', 1);

-- ----------------------------
-- Table structure for quiz_question
-- ----------------------------
DROP TABLE IF EXISTS `quiz_question`;
CREATE TABLE `quiz_question`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目',
  `options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '选项(JSON数组)',
  `answer` int NOT NULL COMMENT '答案索引',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '解析',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `topic_id` bigint NULL DEFAULT NULL COMMENT '所属专题ID',
  `topic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专题名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_topic_id`(`topic_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识测验题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of quiz_question
-- ----------------------------
INSERT INTO `quiz_question` VALUES (1, '以下哪项非遗项目被誉为\"百戏之祖\"？', '[\"京剧\",\"昆曲\",\"越剧\",\"黄梅戏\"]', 1, '昆曲被誉为\"百戏之祖\"，是中国最古老的剧种之一。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (2, '中国剪纸艺术起源于哪个朝代？', '[\"唐代\",\"宋代\",\"西汉\",\"明代\"]', 2, '中国剪纸艺术起源于西汉时期。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (3, '苗族刺绣被称为什么？', '[\"指尖上的芭蕾\",\"穿在身上的史书\",\"布上的交响乐\",\"线上的文明\"]', 1, '苗族刺绣被称为\"穿在身上的史书\"。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (4, '皮影戏在哪一年入选联合国教科文组织名录？', '[\"2005年\",\"2009年\",\"2011年\",\"2013年\"]', 2, '中国皮影戏于2011年入选。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (5, '苏绣的主要艺术特点不包括以下哪一项？', '[\"针法细腻\",\"色彩淡雅\",\"题材广泛\",\"构图夸张\"]', 3, '苏绣以细腻淡雅著称，构图写实。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (6, '木版年画属于哪类非遗？', '[\"传统美术\",\"传统戏剧\",\"传统技艺\",\"民俗\"]', 0, '木版年画属于传统美术。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (7, '首批国家级非遗名录公布于哪一年？', '[\"2004年\",\"2006年\",\"2008年\",\"2010年\"]', 1, '首批国家级非遗名录于2006年公布。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (8, '景泰蓝工艺起源于哪个朝代？', '[\"唐代\",\"元代\",\"明代\",\"清代\"]', 1, '景泰蓝工艺起源于元代。', 1, NULL, '非遗基础知识', '2026-01-29 00:05:43');
INSERT INTO `quiz_question` VALUES (9, '11223', '[\"唐代\",\"宋代\",\"西汉\",\"明代\"]', 0, 'ahhhhhhh', 1, NULL, 'test', NULL);
INSERT INTO `quiz_question` VALUES (10, '以下哪项非遗项目被誉为\"百戏之祖\"？', '[\"京剧\",\"昆曲\",\"越剧\",\"黄梅戏\"]', 1, '昆曲被誉为\"百戏之祖\"，是中国最古老的剧种之一，2001年被列入联合国教科文组织人类非遗代表作名录。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (11, '中国剪纸艺术起源于哪个朝代？', '[\"唐代\",\"宋代\",\"西汉\",\"明代\"]', 2, '剪纸艺术起源于西汉时期，最早用于祭祀和装饰，已有两千多年的历史。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (12, '苗族刺绣被称为什么？', '[\"指尖上的艺术\",\"穿在身上的史诗\",\"布上的画卷\",\"针线上的传说\"]', 1, '苗族刺绣承载了传承本民族文化的历史重任，因其服饰图案丰富而被称为\"穿在身上的史诗\"。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (13, '皮影戏在哪一年入选联合国教科文组织人类非遗代表作名录？', '[\"2006年\",\"2009年\",\"2011年\",\"2015年\"]', 2, '2011年，中国皮影戏入选联合国教科文组织人类非物质文化遗产代表作名录。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (14, '苏绣的主要艺术特点不包括以下哪一项？', '[\"平\",\"齐\",\"活\",\"匀\"]', 2, '苏绣作品的主要艺术特点为\"平、齐、和、光、顺、匀\"，不包括\"活\"。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (15, '以下哪个非遗项目属于传统美术类别？', '[\"昆曲\",\"皮影戏\",\"剪纸艺术\",\"古琴艺术\"]', 2, '剪纸艺术属于传统美术类别，而昆曲和皮影戏属于传统戏剧，古琴艺术属于传统音乐。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (16, '首批国家级非物质文化遗产名录公布于哪一年？', '[\"2001年\",\"2006年\",\"2008年\",\"2010年\"]', 1, '2006年，国务院公布了首批国家级非物质文化遗产名录，包括剪纸、昆曲、苏绣等传统艺术。', 1, NULL, NULL, '2026-01-29 02:17:09');
INSERT INTO `quiz_question` VALUES (17, '“二十四节气”是中国古代订立的一种用来指导农事的补充历法，2016年被列入联合国教科文组织人类非物质文化遗产代表作名录。以下哪个节气通常在每年公历2月19日左右，是春季的第二个节气，标志着降雨开始增多？', 'A. 惊蛰,B. 雨水,C. 春分,D. 立春', 1, '', 1, NULL, '非遗测试题', NULL);
INSERT INTO `quiz_question` VALUES (18, '昆曲被誉为“百戏之祖”，是中国最古老的戏曲形式之一，并在2001年成为首批入选联合国“人类口头和非物质遗产代表作”的中国项目。请问昆曲的起源地是现在的哪个省份？', 'A. 浙江省,B. 江苏省,C. 安徽省,D. 北京市', 1, '', 1, NULL, '非遗基础知识', NULL);
INSERT INTO `quiz_question` VALUES (19, '昆曲被誉为“百戏之祖”，是中国最古老的戏曲形式之一，并在2001年成为首批入选联合国“人类口头和非物质遗产代表作”的中国项目。请问昆曲的起源地是现在的哪个省份？', 'A. 浙江省,,B. 江苏省,C. 安徽省,D. 北京市', 1, '', 1, NULL, '非遗测试题', NULL);
INSERT INTO `quiz_question` VALUES (20, '123123', '1,2,3,4', 0, '', 1, NULL, 'newtest', NULL);

-- ----------------------------
-- Table structure for quiz_record
-- ----------------------------
DROP TABLE IF EXISTS `quiz_record`;
CREATE TABLE `quiz_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `score` int NOT NULL COMMENT '得分',
  `total_score` int NOT NULL COMMENT '总分',
  `correct_count` int NOT NULL COMMENT '答对题数',
  `total_count` int NOT NULL COMMENT '总题数',
  `accuracy` decimal(5, 2) NOT NULL COMMENT '正确率(%)',
  `time_spent` int NOT NULL COMMENT '用时(秒)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
  `topic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_score`(`score` DESC) USING BTREE,
  INDEX `idx_accuracy`(`accuracy` DESC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_topic_name`(`topic_name` ASC) USING BTREE,
  INDEX `idx_accuracy_time`(`accuracy` DESC, `time_spent` ASC) USING BTREE,
  CONSTRAINT `quiz_record_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '答题记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of quiz_record
-- ----------------------------
INSERT INTO `quiz_record` VALUES (5, 1, 10, 10, 1, 1, 100.00, 1, '2026-01-29 00:49:17', 'test', 'admin');
INSERT INTO `quiz_record` VALUES (7, 1, 20, 20, 1, 2, 50.00, 3, '2026-03-24 11:16:17', '非遗测试题', 'admin');
INSERT INTO `quiz_record` VALUES (8, 33, 20, 20, 2, 2, 100.00, 2, '2026-05-02 19:27:16', '非遗测试题', 'sctest');
INSERT INTO `quiz_record` VALUES (9, 34, 20, 20, 2, 2, 100.00, 2, '2026-05-02 20:25:49', '非遗测试题', 'xyhxyh');
INSERT INTO `quiz_record` VALUES (10, 32, 10, 10, 0, 1, 0.00, 2, '2026-05-02 21:26:17', 'test', 'admin999');
INSERT INTO `quiz_record` VALUES (11, 32, 10, 10, 1, 1, 100.00, 1, '2026-05-02 21:26:52', 'newtest', 'admin999');
INSERT INTO `quiz_record` VALUES (12, 36, 10, 10, 1, 1, 100.00, 2, '2026-05-02 21:27:22', 'newtest', 'mvmvmvm');
INSERT INTO `quiz_record` VALUES (13, 37, 10, 10, 1, 1, 100.00, 1, '2026-05-02 21:34:01', 'newtest', 'qweqwe');
INSERT INTO `quiz_record` VALUES (14, 38, 10, 10, 1, 1, 100.00, 3, '2026-05-03 22:43:33', 'test', 'amdamd');

-- ----------------------------
-- Table structure for quiz_topic
-- ----------------------------
DROP TABLE IF EXISTS `quiz_topic`;
CREATE TABLE `quiz_topic`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '专题名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '专题描述',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '封面图片',
  `question_count` int NULL DEFAULT 0 COMMENT '题目数量',
  `participant_count` int NULL DEFAULT 0 COMMENT '参与人数',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_enabled`(`enabled` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '测验专题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of quiz_topic
-- ----------------------------
INSERT INTO `quiz_topic` VALUES (1, '非遗基础知识', '测试对非物质文化遗产的基础认知', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 8, 0, '2026-01-28 23:17:05', '2026-01-28 23:17:05', 1);
INSERT INTO `quiz_topic` VALUES (2, '传统戏剧专题', '深入了解中国传统戏剧艺术', 'https://images.unsplash.com/photo-1516307365426-bea591f05011?w=800', 0, 0, '2026-01-28 23:17:05', '2026-01-28 23:17:05', 1);
INSERT INTO `quiz_topic` VALUES (3, '传统技艺专题', '探索中国传统手工艺技术', 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800', 0, 0, '2026-01-28 23:17:05', '2026-01-28 23:17:05', 1);
INSERT INTO `quiz_topic` VALUES (4, '非遗基础知识', '测试对非物质文化遗产的基础认知', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 0, 0, '2026-01-28 23:17:45', '2026-01-28 23:17:45', 1);
INSERT INTO `quiz_topic` VALUES (5, '传统戏剧专题', '深入了解中国传统戏剧艺术', 'https://images.unsplash.com/photo-1516307365426-bea591f05011?w=800', 0, 0, '2026-01-28 23:17:45', '2026-01-28 23:17:45', 1);
INSERT INTO `quiz_topic` VALUES (6, '传统技艺专题', '探索中国传统手工艺技术', 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800', 0, 0, '2026-01-28 23:17:45', '2026-01-28 23:17:45', 1);

-- ----------------------------
-- Table structure for site_config
-- ----------------------------
DROP TABLE IF EXISTS `site_config`;
CREATE TABLE `site_config`  (
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of site_config
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'USER',
  `wallet_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `UK_9ga8tj7f3cpyntf1xebugca74`(`wallet_address` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin123', 'admin@heritage.com', 'http://localhost:8080/api/uploads/avatar_1_1050d81b80ba47fcb10bc10b45a69c8f.png', NULL, '2026-03-25 15:46:16', '2026-01-27 03:00:35', '2026-03-25 16:42:36', 'ADMIN', '0xb6ed26444f7eb909dac36be55f23202caa73813a', NULL);
INSERT INTO `user` VALUES (30, 'admin666', '$2a$10$Ox3R1RxcMor94ETEStiNHuQNjqLdnBLOVQdNavI0gH5galPLe4ZDq', NULL, 'https://ui-avatars.com/api/?name=admin666&background=c8302b&color=fff', NULL, '2026-03-25 17:04:39', '2026-03-25 17:03:03', '2026-03-25 17:04:39', 'USER', '0x9bda861e604781eba8da6aa07991a0fd67b370ca', NULL);
INSERT INTO `user` VALUES (31, 'admin777', '$2a$10$B18anKPpnVqtl8ldfM1TUOAds7NoxPtqnN1IsQMfRzSC/OW52KGLq', NULL, 'https://ui-avatars.com/api/?name=admin777&background=c8302b&color=fff', NULL, '2026-03-25 17:27:18', '2026-03-25 17:27:17', '2026-03-25 17:27:18', 'USER', '0x780be5ba45244d174f29ea71be241d5fe4b6edea', NULL);
INSERT INTO `user` VALUES (32, 'admin999', '$2a$10$iLkwK.vbY4BUW5GsFHEb6e2rwJPnqUPwf6EJv7ptsmzAClMSm0Ufq', NULL, 'https://ui-avatars.com/api/?name=admin999&background=c8302b&color=fff', NULL, '2026-03-26 19:47:34', '2026-03-25 17:42:39', '2026-03-26 19:47:34', 'USER', '0x26fc362c5a47f1e1b539b07fd33361f4b55d983b', NULL);
INSERT INTO `user` VALUES (33, 'sctest', '$2a$10$y5owk92A2PAtaPJ.fTXJ7.6WAsEUBggQmvD9RmaRdET713DNRwQ92', NULL, 'https://ui-avatars.com/api/?name=sctest&background=c8302b&color=fff', NULL, '2026-05-01 19:44:29', '2026-05-01 19:44:29', '2026-05-01 19:44:29', 'USER', '0x9332e2c6996fdbd69ec2ede54c98b46eebf2dd08', NULL);
INSERT INTO `user` VALUES (34, 'xyhxyh', '$2a$10$hTkiTnsGbHWaj5vjisfoqOHOrFC8Ldrh0JtfEzkxx9YxmW3RvcsRO', NULL, 'https://ui-avatars.com/api/?name=xyhxyh&background=c8302b&color=fff', NULL, '2026-05-02 20:24:12', '2026-05-02 20:24:12', '2026-05-02 20:24:13', 'USER', '0xe1aa8f099b64120bbb686e0ca13897a368cf83d8', NULL);
INSERT INTO `user` VALUES (35, 'cscscs', '$2a$10$2BDbzLqhGbxdenKWDQnG..EnnbiwURREgD4C5Ce8/ZMJpanMsyYX6', NULL, 'https://ui-avatars.com/api/?name=cscscs&background=c8302b&color=fff', NULL, '2026-05-02 21:10:12', '2026-05-02 21:10:12', '2026-05-02 21:10:12', 'USER', '0x7ddfddf17addf6663c878f3af90f4f6835d90cb5', NULL);
INSERT INTO `user` VALUES (36, 'mvmvmvm', '$2a$10$7c62Rog1K4POFEIt5g6ogek2A9Mnsy66oOtSmn9lDkYvf4WxqoJfC', NULL, 'https://ui-avatars.com/api/?name=mvmvmvm&background=c8302b&color=fff', NULL, '2026-05-02 21:27:10', '2026-05-02 21:27:10', '2026-05-02 21:27:10', 'USER', '0x2300935dca6452ae9da342f5f24648d636af9497', NULL);
INSERT INTO `user` VALUES (37, 'qweqwe', '$2a$10$fKYSqcpJt0iN/O.y7WREJONDpvufny6/lasQE/fmGadHMPyRnx4xy', NULL, 'https://ui-avatars.com/api/?name=qweqwe&background=c8302b&color=fff', NULL, '2026-05-02 21:33:50', '2026-05-02 21:33:50', '2026-05-02 21:33:50', 'USER', '0xd7ada7060e3bb4791535ecf4f8e8fc8955d3258b', NULL);
INSERT INTO `user` VALUES (38, 'amdamd', '$2a$10$1McwYXFIFSLgudWbOYNwFeLt1o3WAvFfW6Fq2476dcw6npivfasGe', NULL, 'http://localhost:8080/api/uploads/avatar_38_621c080fca2c407a86f1c7f2a7299656.png', NULL, '2026-05-03 21:45:44', '2026-05-03 21:45:44', '2026-05-03 22:21:54', 'USER', '0xd003ad8ec3384a116471d6c3429e1f4dd8347dd8', '测试名22');

-- ----------------------------
-- Table structure for user_digital_asset
-- ----------------------------
DROP TABLE IF EXISTS `user_digital_asset`;
CREATE TABLE `user_digital_asset`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `block_number` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `chain_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `contract_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cover` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `explorer_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `item_id` bigint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `on_chain` bit(1) NOT NULL,
  `origin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `owned_at` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `rarity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `rarity_class` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `serial` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `token_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `token_uri` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `tx_hash` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `edition_no` int NULL DEFAULT NULL,
  `total_supply` int NULL DEFAULT NULL,
  `name_en` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_item`(`user_id` ASC, `item_id` ASC) USING BTREE,
  UNIQUE INDEX `uk_item_edition`(`item_id` ASC, `edition_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_digital_asset
-- ----------------------------
INSERT INTO `user_digital_asset` VALUES (1, '10512170', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'https://images.unsplash.com/photo-1618220048045-10a6dbdf83e0?w=400&q=80', '2026-03-24 21:59:37.033184', 'https://sepolia.etherscan.io/tx/0xa44a8cd4c6c3a858ca3e8cca542ff046531a7c10ff57076dd42509d1b5db1be9', 1, '龙泉青瓷梅瓶', b'1', '浙江·龙泉', '2026/3/24', '稀有', 'rare', '#DC-00124', 'drop', '3', 'data:application/json;base64,eyJuYW1lIjoi6b6Z5rOJ6Z2S55O35qKF55O2IiwiZGVzY3JpcHRpb24iOiLmtZnmsZ/Ct+m+meaziSDCtyDpmbbnk7flmajniakgwrcg56iA5pyJIiwiaW1hZ2UiOiJodHRwczovL2ltYWdlcy51bnNwbGFzaC5jb20vcGhvdG8tMTYxODIyMDA0ODA0NS0xMGE2ZGJkZjgzZTA/dz00MDAmcT04MCIsImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiLnqIDmnInluqYiLCJ2YWx1ZSI6IueogOaciSJ9LHsidHJhaXRfdHlwZSI6Iuadpea6kCIsInZhbHVlIjoi6aaW5Y+R5pS26JePIn0seyJ0cmFpdF90eXBlIjoi57yW5Y+3IiwidmFsdWUiOiIjREMtMDAxMjQifV19', '0xa44a8cd4c6c3a858ca3e8cca542ff046531a7c10ff57076dd42509d1b5db1be9', 1, NULL, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (2, '10512254', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-24 22:17:01.124727', 'https://sepolia.etherscan.io/tx/0xd89bf8442c37081f6ec679bd312ba71d6bda489d028c845c3cc44214f9928553', 1, '剪纸', b'1', 'test', '2026/3/24', '稀有', 'common', '400', 'drop', '4', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IummluWPkeaUtuiXjyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0xd89bf8442c37081f6ec679bd312ba71d6bda489d028c845c3cc44214f9928553', 18, NULL, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (3, '10512308', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-24 22:27:59.629030', 'https://sepolia.etherscan.io/tx/0x1aaa8ac6adb792f5f1ac33be242031734eb117416d602a33d5bbf1ba765b27ba', 1, '剪纸', b'1', 'test', '2026/3/24', '稀有', 'common', '400', 'drop', '5', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IummluWPkeaUtuiXjyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0x1aaa8ac6adb792f5f1ac33be242031734eb117416d602a33d5bbf1ba765b27ba', 19, NULL, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (4, '10515544', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-25 09:34:37.378485', 'https://sepolia.etherscan.io/tx/0x56a3cde43f2d69211da6835df9724741d45da80c022e9b7683e105649d1ece83', 1, '剪纸', b'1', 'test', '2026/3/25', '稀有', 'common', '400 · 第81/100份', 'drop', '6', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IummluWPkeaUtuiXjyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0x56a3cde43f2d69211da6835df9724741d45da80c022e9b7683e105649d1ece83', 20, 81, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (5, '10515596', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-25 09:45:36.144875', 'https://sepolia.etherscan.io/tx/0xa667fb78b4347ca12299ba7b1d8c3f967fa6f46130e9f6c27a8b7cb7067fc30e', 1, '剪纸', b'1', 'test', '2026/3/25', '稀有', 'common', '3/100', 'drop', '7', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ2YWx1ZSI6IueogOaciSIsInRyYWl0X3R5cGUiOiLnqIDmnInluqYifSx7InZhbHVlIjoi6aaW5Y+R5pS26JePIiwidHJhaXRfdHlwZSI6Iuadpea6kCJ9LHsidmFsdWUiOiIzLzEwMCIsInRyYWl0X3R5cGUiOiLnvJblj7cifSx7InZhbHVlIjoiMTAwIiwidHJhaXRfdHlwZSI6IuWPkeihjOmHjyJ9XX0=', '0xa667fb78b4347ca12299ba7b1d8c3f967fa6f46130e9f6c27a8b7cb7067fc30e', 22, 3, 100, NULL);
INSERT INTO `user_digital_asset` VALUES (6, '10515620', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 09:50:26.588447', 'https://sepolia.etherscan.io/tx/0x7e6e9f19587893a8f505cb6160d5ce65f2bf1452be45e311ba8bd84234c89b8c', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '7/10', 'drop', '8', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiIgwrcgIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InZhbHVlIjoi5Lyg5aWHIiwidHJhaXRfdHlwZSI6IueogOacieW6piJ9LHsidmFsdWUiOiLpppblj5HmlLbol48iLCJ0cmFpdF90eXBlIjoi5p2l5rqQIn0seyJ2YWx1ZSI6IjcvMTAiLCJ0cmFpdF90eXBlIjoi57yW5Y+3In0seyJ2YWx1ZSI6IjEwIiwidHJhaXRfdHlwZSI6IuWPkeihjOmHjyJ9XX0=', '0x7e6e9f19587893a8f505cb6160d5ce65f2bf1452be45e311ba8bd84234c89b8c', 22, 7, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (7, '10515657', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 09:58:16.934140', 'https://sepolia.etherscan.io/tx/0x3d021bbf628d29475ef24a7f8395d48db12354bc919c5fed6f79746dbd42a68b', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '10/10', 'drop', '9', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiIgwrcgIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InZhbHVlIjoi5Lyg5aWHIiwidHJhaXRfdHlwZSI6IueogOacieW6piJ9LHsidmFsdWUiOiLpppblj5HmlLbol48iLCJ0cmFpdF90eXBlIjoi5p2l5rqQIn0seyJ2YWx1ZSI6IjEwLzEwIiwidHJhaXRfdHlwZSI6Iue8luWPtyJ9LHsidmFsdWUiOiIxMCIsInRyYWl0X3R5cGUiOiLlj5HooYzph48ifV19', '0x3d021bbf628d29475ef24a7f8395d48db12354bc919c5fed6f79746dbd42a68b', 23, 10, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (8, '10515678', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 10:03:00.827822', 'https://sepolia.etherscan.io/tx/0xed33c6fb7dffb6ed8806849640c236f8f4ee3945b6ba5d91b852ca44f6e84550', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '5/10', 'drop', '10', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiIgwrcgIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InZhbHVlIjoi5Lyg5aWHIiwidHJhaXRfdHlwZSI6IueogOacieW6piJ9LHsidmFsdWUiOiLpppblj5HmlLbol48iLCJ0cmFpdF90eXBlIjoi5p2l5rqQIn0seyJ2YWx1ZSI6IjUvMTAiLCJ0cmFpdF90eXBlIjoi57yW5Y+3In0seyJ2YWx1ZSI6IjEwIiwidHJhaXRfdHlwZSI6IuWPkeihjOmHjyJ9XX0=', '0xed33c6fb7dffb6ed8806849640c236f8f4ee3945b6ba5d91b852ca44f6e84550', 24, 5, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (9, '10515712', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 10:10:12.899374', 'https://sepolia.etherscan.io/tx/0xfd5b131814c493140cb60da5d36c5cfe777bdb7dd9b624d0630538f20f5ec5c6', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '8/10', 'drop', '11', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiIgwrcgIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InZhbHVlIjoi5Lyg5aWHIiwidHJhaXRfdHlwZSI6IueogOacieW6piJ9LHsidmFsdWUiOiLpppblj5HmlLbol48iLCJ0cmFpdF90eXBlIjoi5p2l5rqQIn0seyJ2YWx1ZSI6IjgvMTAiLCJ0cmFpdF90eXBlIjoi57yW5Y+3In0seyJ2YWx1ZSI6IjEwIiwidHJhaXRfdHlwZSI6IuWPkeihjOmHjyJ9XX0=', '0xfd5b131814c493140cb60da5d36c5cfe777bdb7dd9b624d0630538f20f5ec5c6', 25, 8, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (10, '10515729', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-25 10:13:25.385263', 'https://sepolia.etherscan.io/tx/0x87e4d9598135071c49367630ac663ac94195284706b0e840144fd3c0a95f7c6b', 1, '剪纸', b'1', 'test', '2026/3/25', '稀有', 'common', '31/100', 'drop', '12', 'http://localhost:8080/api/digital-asset/metadata/id/10', '0x87e4d9598135071c49367630ac663ac94195284706b0e840144fd3c0a95f7c6b', 25, 31, 100, NULL);
INSERT INTO `user_digital_asset` VALUES (11, '10515755', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 10:18:37.850764', 'https://sepolia.etherscan.io/tx/0xb990dcb406c955080e2b3c21d8d921013f4bb8630a26d9a3c0c1b348068419b2', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '2/10', 'drop', '13', 'http://localhost:8080/api/digital-asset/metadata/id/11', '0xb990dcb406c955080e2b3c21d8d921013f4bb8630a26d9a3c0c1b348068419b2', 26, 2, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (12, '10515838', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 10:36:16.159708', 'https://sepolia.etherscan.io/tx/0x839ac2703d22ffd014c5744f2a72e9de3d6eea6a6f77b7aca69373c0e3411f06', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '9/10', 'drop', '14', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiLkvKDlpYcgwrcg56ysOS8xMOS7vSIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiLnqIDmnInluqYiLCJ2YWx1ZSI6IuS8oOWlhyJ9LHsidHJhaXRfdHlwZSI6Iuadpea6kCIsInZhbHVlIjoi6aaW5Y+R5pS26JePIn0seyJ0cmFpdF90eXBlIjoi57yW5Y+3IiwidmFsdWUiOiI5LzEwIn0seyJ0cmFpdF90eXBlIjoi5Y+R6KGM6YePIiwidmFsdWUiOiIxMCJ9LHsidHJhaXRfdHlwZSI6IumTviIsInZhbHVlIjoiU2Vwb2xpYSJ9XX0=', '0x839ac2703d22ffd014c5744f2a72e9de3d6eea6a6f77b7aca69373c0e3411f06', 27, 9, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (13, '10515844', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-25 10:37:37.504869', 'https://sepolia.etherscan.io/tx/0xcd79e1e22d8eebfef90e6252ea95e125a5214ae0c8ab26b57a82b2df2cc10a5a', 1, '剪纸', b'1', 'test', '2026/3/25', '稀有', 'common', '57/100', 'drop', '15', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOeogOaciSDCtyDnrKw1Ny8xMDDku70iLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IummluWPkeaUtuiXjyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNTcvMTAwIn0seyJ0cmFpdF90eXBlIjoi5Y+R6KGM6YePIiwidmFsdWUiOiIxMDAifSx7InRyYWl0X3R5cGUiOiLkuqflnLAiLCJ2YWx1ZSI6InRlc3QifSx7InRyYWl0X3R5cGUiOiLpk74iLCJ2YWx1ZSI6IlNlcG9saWEifV19', '0xcd79e1e22d8eebfef90e6252ea95e125a5214ae0c8ab26b57a82b2df2cc10a5a', 27, 57, 100, NULL);
INSERT INTO `user_digital_asset` VALUES (14, '10515874', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 10:44:00.989823', 'https://sepolia.etherscan.io/tx/0x26c495da75c89d7b085d2391683d4f0eb27f76da306432fbaca6e0408def4b36', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '3/10', 'drop', '16', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiLkvKDlpYcgfCBFZGl0aW9uIDMvMTAgfCBEaXJlY3QgQ2xhaW0iLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy85NmU2OWZiZjJlNmI0YzJhYTdiNDgxYTUxZjE3MWY0NS5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoiUmFyaXR5IiwidmFsdWUiOiLkvKDlpYcifSx7InRyYWl0X3R5cGUiOiJTb3VyY2UiLCJ2YWx1ZSI6IkRpcmVjdCBDbGFpbSJ9LHsidHJhaXRfdHlwZSI6IkVkaXRpb24iLCJ2YWx1ZSI6IjMvMTAifSx7InRyYWl0X3R5cGUiOiJUb3RhbCBTdXBwbHkiLCJ2YWx1ZSI6IjEwIn0seyJ0cmFpdF90eXBlIjoiQ2hhaW4iLCJ2YWx1ZSI6IlNlcG9saWEifV19', '0x26c495da75c89d7b085d2391683d4f0eb27f76da306432fbaca6e0408def4b36', 28, 3, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (15, '10515940', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-25 10:57:29.795035', 'https://sepolia.etherscan.io/tx/0x752541b364270342346e27d8a6fe2542a9409f43921d4acee8abb8da9231c45e', 1, '剪纸', b'1', 'test', '2026/3/25', '稀有', 'common', '13/100', 'drop', '17', 'data:application/json;base64,eyJuYW1lIjoiSGVyaXRhZ2VORlQgIzE1IiwiZGVzY3JpcHRpb24iOiJjb21tb24gfCBFZGl0aW9uIDEzLzEwMCB8IERpcmVjdCBDbGFpbSIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzI2N2I1ZjY2YWY1MzQ0OTk4ZmVjZDkzOGJkNTUzZjI0LnBuZyIsImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiJSYXJpdHkiLCJ2YWx1ZSI6ImNvbW1vbiJ9LHsidHJhaXRfdHlwZSI6IlNvdXJjZSIsInZhbHVlIjoiRGlyZWN0IENsYWltIn0seyJ0cmFpdF90eXBlIjoiRWRpdGlvbiIsInZhbHVlIjoiMTMvMTAwIn0seyJ0cmFpdF90eXBlIjoiVG90YWwgU3VwcGx5IiwidmFsdWUiOiIxMDAifSx7InRyYWl0X3R5cGUiOiJDaGFpbiIsInZhbHVlIjoiU2Vwb2xpYSJ9XX0=', '0x752541b364270342346e27d8a6fe2542a9409f43921d4acee8abb8da9231c45e', 28, 13, 100, NULL);
INSERT INTO `user_digital_asset` VALUES (16, '10515952', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 11:00:19.730989', 'https://sepolia.etherscan.io/tx/0x9aa3b29cf167ad9b0f263981062cbeba8781586b1189578045f03df401c88682', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', '4/10', 'drop', '18', 'data:application/json;base64,eyJuYW1lIjoiSGVyaXRhZ2VORlQgIzE2IiwiZGVzY3JpcHRpb24iOiJjb21tb24gfCBFZGl0aW9uIDQvMTAgfCBEaXJlY3QgQ2xhaW0iLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy85NmU2OWZiZjJlNmI0YzJhYTdiNDgxYTUxZjE3MWY0NS5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoiUmFyaXR5IiwidmFsdWUiOiJjb21tb24ifSx7InRyYWl0X3R5cGUiOiJTb3VyY2UiLCJ2YWx1ZSI6IkRpcmVjdCBDbGFpbSJ9LHsidHJhaXRfdHlwZSI6IkVkaXRpb24iLCJ2YWx1ZSI6IjQvMTAifSx7InRyYWl0X3R5cGUiOiJUb3RhbCBTdXBwbHkiLCJ2YWx1ZSI6IjEwIn0seyJ0cmFpdF90eXBlIjoiQ2hhaW4iLCJ2YWx1ZSI6IlNlcG9saWEifV19', '0x9aa3b29cf167ad9b0f263981062cbeba8781586b1189578045f03df401c88682', 29, 4, 10, NULL);
INSERT INTO `user_digital_asset` VALUES (17, '10517354', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-03-25 15:47:36.609400', 'https://sepolia.etherscan.io/tx/0x3cc71bad24287ce76f8f651f4ba8d99548957752e66c802739709c93d07ee802', 2, '皮影', b'1', '', '2026/3/25', '传奇', 'common', 'COLLECT · 第1/10份', 'drop', '19', 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiIgwrcgIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiLnqIDmnInluqYiLCJ2YWx1ZSI6IuS8oOWlhyJ9LHsidHJhaXRfdHlwZSI6Iuadpea6kCIsInZhbHVlIjoi6aaW5Y+R5pS26JePIn0seyJ0cmFpdF90eXBlIjoi57yW5Y+3IiwidmFsdWUiOiIifV19', '0x3cc71bad24287ce76f8f651f4ba8d99548957752e66c802739709c93d07ee802', 1, 1, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (18, '10519178', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-25 22:06:49.841481', 'https://sepolia.etherscan.io/tx/0x013b49632c5a5794d3fde3f1397e84f8e45d0021fe16c836da379735287c8528', 1, '剪纸', b'1', 'test', '2026/3/25', '稀有', 'common', '400 · 第58/100份', 'drop', '20', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IummluWPkeaUtuiXjyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0x013b49632c5a5794d3fde3f1397e84f8e45d0021fe16c836da379735287c8528', 30, 58, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (19, '10525442', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-03-26 19:47:02.328419', 'https://sepolia.etherscan.io/tx/0x70530ed02f030fd4d799b527427fab65dac76ce9211fdb0eb67fe7b6e6f32d4f', 1, '剪纸', b'1', 'test', '2026/3/26', '稀有', 'common', '400 · 第24/100份', 'drop', '21', 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IummluWPkeaUtuiXjyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0x70530ed02f030fd4d799b527427fab65dac76ce9211fdb0eb67fe7b6e6f32d4f', 32, 24, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (20, '10531024', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/6fe4d448d4924a0ba78ad34da141f835.png', '2026-03-27 14:57:00.036011', 'https://sepolia.etherscan.io/tx/0x724857bf3a1f54a73935309560b8d6b50bc313272ee4d953782ac87bf735cae8', 3, 'test', b'1', '中国', '2026/3/27', '传奇', 'legendary', 'COLLECT · 第43/100份', 'drop', '22', 'data:application/json;base64,eyJuYW1lIjoidGVzdCIsImRlc2NyaXB0aW9uIjoi5Lit5Zu9IMK3IOeTtuWtkCDCtyDkvKDlpYciLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy82ZmU0ZDQ0OGQ0OTI0YTBiYTc4YWQzNGRhMTQxZjgzNS5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLkvKDlpYcifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiIn1dfQ==', '0x724857bf3a1f54a73935309560b8d6b50bc313272ee4d953782ac87bf735cae8', 1, 43, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (21, '10531041', 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/6fe4d448d4924a0ba78ad34da141f835.png', '2026-03-27 15:00:24.296635', 'https://sepolia.etherscan.io/tx/0x6fb88ad9b9ef4101999548e15547c8636b56b64d6fd4042abaae76b8208e0e31', 3, 'test', b'1', '中国', '2026/3/27', '传奇', 'legendary', 'COLLECT · 第92/100份', 'drop', '23', 'data:application/json;base64,eyJuYW1lIjoidGVzdCIsImRlc2NyaXB0aW9uIjoi5Lit5Zu9IMK3IOeTtuWtkCDCtyDkvKDlpYciLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy82ZmU0ZDQ0OGQ0OTI0YTBiYTc4YWQzNGRhMTQxZjgzNS5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLkvKDlpYcifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiIn1dfQ==', '0x6fb88ad9b9ef4101999548e15547c8636b56b64d6fd4042abaae76b8208e0e31', 32, 92, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (22, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/96e69fbf2e6b4c2aa7b481a51f171f45.png', '2026-05-01 19:44:01.736441', 'https://sepolia.etherscan.io/tx/0x32b40a1f2fc4668ad3497334a64b741bd1712b9b2d89493392bc0c0e797f4627', 2, '皮影', b'0', '', '2026/5/1', '传奇', 'common', 'COLLECT · 第6/10份', 'drop', NULL, 'data:application/json;base64,eyJuYW1lIjoi55qu5b2xIiwiZGVzY3JpcHRpb24iOiIgwrcgIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2FwaS91cGxvYWRzLzk2ZTY5ZmJmMmU2YjRjMmFhN2I0ODFhNTFmMTcxZjQ1LnBuZyIsImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiLnqIDmnInluqYiLCJ2YWx1ZSI6IuS8oOWlhyJ9LHsidHJhaXRfdHlwZSI6Iuadpea6kCIsInZhbHVlIjoi6aKG5Y+W6I635b6XIn0seyJ0cmFpdF90eXBlIjoi57yW5Y+3IiwidmFsdWUiOiIifV19', '0x32b40a1f2fc4668ad3497334a64b741bd1712b9b2d89493392bc0c0e797f4627', 32, 6, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (23, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-05-01 19:44:31.749103', 'https://sepolia.etherscan.io/tx/0x127f4906fedf06d29f7677a0c25fb626a7a02e7e2b3a9e267b22bf9820390447', 1, '剪纸', b'0', 'test', '2026/5/1', '稀有', 'common', '400 · 第94/100份', 'drop', NULL, 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0x127f4906fedf06d29f7677a0c25fb626a7a02e7e2b3a9e267b22bf9820390447', 33, 94, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (24, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/6fe4d448d4924a0ba78ad34da141f835.png', '2026-05-02 19:14:56.145007', 'https://sepolia.etherscan.io/tx/0xc6360e4f54bc350150274212ea9d75341d07066b8c186f0f5c529ddcc476959e', 3, 'test', b'0', '中国', '2026/5/2', '传奇', 'legendary', 'COLLECT · 第57/100份', 'drop', NULL, 'data:application/json;base64,eyJuYW1lIjoidGVzdCIsImRlc2NyaXB0aW9uIjoi5Lit5Zu9IMK3IOeTtuWtkCDCtyDkvKDlpYciLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy82ZmU0ZDQ0OGQ0OTI0YTBiYTc4YWQzNGRhMTQxZjgzNS5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLkvKDlpYcifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiIn1dfQ==', '0xc6360e4f54bc350150274212ea9d75341d07066b8c186f0f5c529ddcc476959e', 33, 57, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (25, NULL, 'Sepolia', '', 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400', '2026-05-02 19:27:16.823235', '', 4, '非遗传承·至尊典藏', b'0', '非遗平台', '2026-05-02', '传奇', 'legendary', 'HC-S01 · 第80/100份', '测评满分奖励', NULL, '', 'PENDING_1777721236811', 33, 80, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (26, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400', '2026-05-02 20:18:57.684560', 'https://sepolia.etherscan.io/tx/0xfd987948d9db7b5de3383475e61d9a2d6cab042d65845bb9d0311c5233c2c468', 5, '昆曲金面', b'0', '苏州昆曲', '2026/5/2', '传奇', 'legendary', 'HC-S02 · 第13/50份', 'quiz', NULL, 'data:application/json;base64,eyJuYW1lIjoi5piG5puy6YeR6Z2iIiwiZGVzY3JpcHRpb24iOiLoi4/lt57mmIbmm7Igwrcg6I2j6KqJ6JeP5ZOBIMK3IOS8oOWlhyIsImltYWdlIjoiaHR0cHM6Ly9pbWFnZXMudW5zcGxhc2guY29tL3Bob3RvLTE1MTY0NTAzNjA0NTItOTMxMmY1ZTg2ZmM3P3c9NDAwIiwiYXR0cmlidXRlcyI6W3sidHJhaXRfdHlwZSI6IueogOacieW6piIsInZhbHVlIjoi5Lyg5aWHIn0seyJ0cmFpdF90eXBlIjoi5p2l5rqQIiwidmFsdWUiOiLmtYvpqozojrflvpcifSx7InRyYWl0X3R5cGUiOiLnvJblj7ciLCJ2YWx1ZSI6IkhDLVMwMiJ9XX0=', '0xfd987948d9db7b5de3383475e61d9a2d6cab042d65845bb9d0311c5233c2c468', 33, 13, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (27, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400', '2026-05-02 20:24:22.561725', 'https://sepolia.etherscan.io/tx/0xcef7b28859b24a8d3624660ffa71be751579e46778d7c841a40eebfc6b22cb05', 4, '非遗传承·至尊典藏', b'1', '非遗平台', '2026/5/2', '传奇', 'legendary', 'HC-S01 · 第8/100份', 'drop', NULL, 'data:application/json;base64,eyJuYW1lIjoi6Z2e6YGX5Lyg5om/wrfoh7PlsIrlhbjol48iLCJkZXNjcmlwdGlvbiI6IumdnumBl+W5s+WPsCDCtyDojaPoqonol4/lk4Egwrcg5Lyg5aWHIiwiaW1hZ2UiOiJodHRwczovL2ltYWdlcy51bnNwbGFzaC5jb20vcGhvdG8tMTYxMDcwMTU5NjAwNy0xMTUwMjg2MWRjZmE/dz00MDAiLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLkvKDlpYcifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiSEMtUzAxIn1dfQ==', '0xcef7b28859b24a8d3624660ffa71be751579e46778d7c841a40eebfc6b22cb05', 34, 8, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (28, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400', '2026-05-02 21:41:10.006676', 'https://sepolia.etherscan.io/tx/0x34f4c30b7fcca3230abe8016b1aa61bc4661b002632d85c7eb4f3d14008cca1f', 5, '昆曲金面', b'1', '苏州昆曲', '2026-05-02', '传奇', 'legendary', 'HC-S02 · 第16/50份', '测评满分奖励', NULL, '', '0x34f4c30b7fcca3230abe8016b1aa61bc4661b002632d85c7eb4f3d14008cca1f', 37, 16, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (29, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/6fe4d448d4924a0ba78ad34da141f835.png', '2026-05-03 22:22:08.959849', 'https://sepolia.etherscan.io/tx/0xb1976869c6465de3a7e3f5640b75539cabf23aa656f08f66d84f2c6dd3138360', 3, 'test', b'1', '中国', '2026/5/3', '传奇', 'legendary', 'COLLECT · 第53/100份', 'drop', NULL, 'data:application/json;base64,eyJuYW1lIjoidGVzdCIsImRlc2NyaXB0aW9uIjoi5Lit5Zu9IMK3IOeTtuWtkCDCtyDkvKDlpYciLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy82ZmU0ZDQ0OGQ0OTI0YTBiYTc4YWQzNGRhMTQxZjgzNS5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLkvKDlpYcifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiIn1dfQ==', '0xb1976869c6465de3a7e3f5640b75539cabf23aa656f08f66d84f2c6dd3138360', 38, 53, NULL, NULL);
INSERT INTO `user_digital_asset` VALUES (30, NULL, 'Sepolia', '0xcf2B554b77d6E6696266BFd8b3919eD58B21991f', 'http://localhost:8080/api/uploads/267b5f66af5344998fecd938bd553f24.png', '2026-05-03 23:51:52.252343', 'https://sepolia.etherscan.io/tx/0xd0530a437862a1e5ec3de2523bfa793d652ffa83ae5ba9a93c15b449cdf1a568', 1, '剪纸', b'1', 'test', '2026/5/3', '稀有', 'common', '400 · 第26/100份', 'drop', NULL, 'data:application/json;base64,eyJuYW1lIjoi5Ymq57q4IiwiZGVzY3JpcHRpb24iOiJ0ZXN0IMK3IOWkp+W4iCDCtyDnqIDmnIkiLCJpbWFnZSI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC9hcGkvdXBsb2Fkcy8yNjdiNWY2NmFmNTM0NDk5OGZlY2Q5MzhiZDU1M2YyNC5wbmciLCJhdHRyaWJ1dGVzIjpbeyJ0cmFpdF90eXBlIjoi56iA5pyJ5bqmIiwidmFsdWUiOiLnqIDmnIkifSx7InRyYWl0X3R5cGUiOiLmnaXmupAiLCJ2YWx1ZSI6IumihuWPluiOt+W+lyJ9LHsidHJhaXRfdHlwZSI6Iue8luWPtyIsInZhbHVlIjoiNDAwIn1dfQ==', '0xd0530a437862a1e5ec3de2523bfa793d652ffa83ae5ba9a93c15b449cdf1a568', 38, 26, NULL, NULL);

-- ----------------------------
-- Table structure for user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite`;
CREATE TABLE `user_favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `heritage_id` bigint NOT NULL COMMENT '非遗项目ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_heritage`(`user_id` ASC, `heritage_id` ASC) USING BTREE,
  UNIQUE INDEX `UK45lekr1ou4bajy8dgqqp0ah3d`(`user_id` ASC, `heritage_id` ASC) USING BTREE,
  UNIQUE INDEX `UKiu2vqx85o5pq3r8n38rqqqel3`(`user_id` ASC, `heritage_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_heritage_id`(`heritage_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_favorite
-- ----------------------------
INSERT INTO `user_favorite` VALUES (3, 1, 3, '2026-01-27 04:12:00');
INSERT INTO `user_favorite` VALUES (6, 1, 36, '2026-01-27 04:35:42');
INSERT INTO `user_favorite` VALUES (8, 17, 1, '2026-03-02 21:08:39');
INSERT INTO `user_favorite` VALUES (10, 17, 53, '2026-03-02 21:10:21');
INSERT INTO `user_favorite` VALUES (11, 1, 18, '2026-03-27 15:03:11');

-- ----------------------------
-- Table structure for user_like
-- ----------------------------
DROP TABLE IF EXISTS `user_like`;
CREATE TABLE `user_like`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `heritage_id` bigint NOT NULL COMMENT '非遗项目ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_heritage`(`user_id` ASC, `heritage_id` ASC) USING BTREE,
  UNIQUE INDEX `UKf0sfcok603k2unadjp251i6s0`(`user_id` ASC, `heritage_id` ASC) USING BTREE,
  UNIQUE INDEX `UKric7y9nsw12899dxceh952q67`(`user_id` ASC, `heritage_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_heritage_id`(`heritage_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户点赞表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_like
-- ----------------------------
INSERT INTO `user_like` VALUES (1, 1, 36, '2026-01-27 04:07:47');
INSERT INTO `user_like` VALUES (2, 1, 18, '2026-01-27 04:08:03');
INSERT INTO `user_like` VALUES (15, 1, 72, '2026-01-28 20:37:17');
INSERT INTO `user_like` VALUES (17, 17, 1, '2026-03-02 21:08:41');
INSERT INTO `user_like` VALUES (22, 17, 53, '2026-03-02 21:10:36');
INSERT INTO `user_like` VALUES (23, 17, 6, '2026-03-03 15:03:29');
INSERT INTO `user_like` VALUES (24, 1, 14, '2026-03-24 16:40:02');

SET FOREIGN_KEY_CHECKS = 1;
