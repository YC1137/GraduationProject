/**
 * 模拟非遗项目数据
 * 实际项目中应从后端 API 获取
 */
export const mockHeritageData = [
    {
        id: 1,
        name: '剪纸艺术',
        category: '传统美术',
        region: '陕西',
        level: '国家级',
        inheritor: '王秀英',
        description: '中国剪纸是用剪刀或刻刀在纸上剪刻花纹，用于装点生活或配合其他民俗活动的一种民间艺术。',
        detailDescription: '剪纸艺术是最古老的中国民间艺术之一，作为一种镂空艺术，它能给人以视觉上透空的感觉和艺术享受。剪纸用剪刀将纸剪成各种各样的图案，如窗花、门笺、墙花、顶棚花、灯花等。每逢过节或新婚喜庆，人们便将美丽鲜艳的剪纸贴在家中窗户、墙壁、门和灯笼上，节日的气氛也因此被烘托得更加热烈。',
        thumbnail: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        images: [
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1200',
            'https://images.unsplash.com/photo-1513569143478-b38b2c0ef97f?w=1200',
            'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=1200'
        ],
        video: 'https://www.w3schools.com/html/mov_bbb.mp4',
        audio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        timeline: [
            { year: '西汉', event: '剪纸艺术起源，最早用于祭祀和装饰' },
            { year: '唐代', event: '剪纸艺术达到鼎盛，技艺更加精湛' },
            { year: '宋代', event: '民间剪纸广泛流传，形成地方特色' },
            { year: '明清', event: '剪纸成为民间必备的装饰艺术' },
            { year: '2006年', event: '列入首批国家级非物质文化遗产名录' }
        ],
        likes: 1286,
        favorites: 856,
        views: 5432
    },
    {
        id: 2,
        name: '皮影戏',
        category: '传统戏剧',
        region: '陕西',
        level: '国家级',
        inheritor: '李明德',
        description: '皮影戏又称"影子戏"或"灯影戏"，是一种以兽皮或纸板做成的人物剪影来表演故事的民间戏剧。',
        detailDescription: '皮影戏是中国民间古老的传统艺术，已有两千多年的历史。表演时，艺人们在白色幕布后面，一边操纵影人，一边用当地流行的曲调讲述故事，同时配以打击乐器和弦乐，有浓厚的乡土气息。2011年，中国皮影戏入选人类非物质文化遗产代表作名录。',
        thumbnail: 'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=800',
        images: [
            'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=1200',
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1200',
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=1200'
        ],
        video: 'https://www.w3schools.com/html/movie.mp4',
        audio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        timeline: [
            { year: '西汉', event: '皮影戏雏形出现' },
            { year: '宋代', event: '皮影戏在民间广泛流传' },
            { year: '元代', event: '随蒙古大军传至波斯等国' },
            { year: '清代', event: '皮影戏达到鼎盛时期' },
            { year: '2011年', event: '入选联合国教科文组织人类非遗代表作名录' }
        ],
        likes: 2145,
        favorites: 1234,
        views: 8765
    },
    {
        id: 3,
        name: '苗族刺绣',
        category: '传统技艺',
        region: '贵州',
        level: '国家级',
        inheritor: '杨芳',
        description: '苗绣是指苗族民间传承的刺绣技艺，是苗族历史文化中特有的表现形式之一。',
        detailDescription: '苗族刺绣工艺独特，针法繁多，色彩艳丽，图案丰富。苗族妇女擅长纺织和刺绣，清《开化府志》、民国《马关县志》都记载有苗族"女子五六岁即教以刺绣"，苗族服饰图案承载了传承本民族文化的历史重任，被称为"穿在身上的史诗"。',
        thumbnail: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        images: [
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200',
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=1200',
            'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=1200'
        ],
        video: 'https://www.w3schools.com/html/mov_bbb.mp4',
        audio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        timeline: [
            { year: '远古时期', event: '苗族先民开始使用刺绣装饰服饰' },
            { year: '明清', event: '苗绣技艺日臻成熟，形成独特风格' },
            { year: '近代', event: '苗绣成为苗族文化的重要标志' },
            { year: '2006年', event: '列入首批国家级非物质文化遗产名录' }
        ],
        likes: 1876,
        favorites: 1023,
        views: 6543
    },
    {
        id: 4,
        name: '昆曲',
        category: '传统戏剧',
        region: '江苏',
        level: '国家级',
        inheritor: '张继青',
        description: '昆曲又称昆剧、昆腔，是中国最古老的剧种之一，也是中国传统文化艺术中的珍品。',
        detailDescription: '昆曲糅合了唱念做打、舞蹈及武术等，以曲词典雅、行腔婉转、表演细腻著称，被誉为"百戏之祖"。昆曲以鼓、板控制演唱节奏，以曲笛、三弦等为主要伴奏乐器，主要以中州官话为舞台语言。2001年，昆曲被联合国教科文组织列为"人类口述和非物质遗产代表作"。',
        thumbnail: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800',
        images: [
            'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=1200',
            'https://images.unsplash.com/photo-1503095396549-807759245b35?w=1200',
            'https://images.unsplash.com/photo-1445001471072-4c96156c6e90?w=1200'
        ],
        video: 'https://www.w3schools.com/html/movie.mp4',
        audio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        timeline: [
            { year: '元末明初', event: '昆曲形成于江苏昆山一带' },
            { year: '明代中叶', event: '魏良辅改革昆曲，使其走向成熟' },
            { year: '清代', event: '昆曲成为全国性剧种，影响深远' },
            { year: '2001年', event: '被列入联合国教科文组织人类非遗代表作名录' },
            { year: '2006年', event: '列入首批国家级非物质文化遗产名录' }
        ],
        likes: 3245,
        favorites: 2156,
        views: 12345
    },
    {
        id: 5,
        name: '苏州刺绣',
        category: '传统技艺',
        region: '江苏',
        level: '国家级',
        inheritor: '姚惠芬',
        description: '苏绣是中国四大名绣之一，是苏州地区刺绣产品的总称，其发源地在苏州吴县一带。',
        detailDescription: '苏绣具有图案秀丽、构思巧妙、绣工细致、针法活泼、色彩清雅的独特风格，地方特色浓郁。苏绣题材广泛，有人物、山水、花鸟、动物等。针法有齐针、散套针、施针、虚实针、乱针、打子针等几十种，丰富多彩。苏绣作品的主要艺术特点为"平、齐、和、光、顺、匀"。',
        thumbnail: 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=800',
        images: [
            'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=1200',
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=1200',
            'https://images.unsplash.com/photo-1434725039720-aaad6dd32dfe?w=1200'
        ],
        video: 'https://www.w3schools.com/html/mov_bbb.mp4',
        audio: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        timeline: [
            { year: '三国时期', event: '苏绣开始在吴地流传' },
            { year: '宋代', event: '苏绣形成独特的艺术风格' },
            { year: '明清', event: '苏绣达到鼎盛，成为贡品' },
            { year: '近代', event: '苏绣走向世界，享誉国际' },
            { year: '2006年', event: '列入首批国家级非物质文化遗产名录' }
        ],
        likes: 2876,
        favorites: 1845,
        views: 9876
    }
]

/**
 * 知识测验题目数据
 */
export const quizQuestions = [
    {
        id: 1,
        question: '以下哪项非遗项目被誉为"百戏之祖"？',
        options: ['京剧', '昆曲', '越剧', '黄梅戏'],
        answer: 1,
        explanation: '昆曲被誉为"百戏之祖"，是中国最古老的剧种之一，2001年被列入联合国教科文组织人类非遗代表作名录。'
    },
    {
        id: 2,
        question: '中国剪纸艺术起源于哪个朝代？',
        options: ['唐代', '宋代', '西汉', '明代'],
        answer: 2,
        explanation: '剪纸艺术起源于西汉时期，最早用于祭祀和装饰，已有两千多年的历史。'
    },
    {
        id: 3,
        question: '苗族刺绣被称为什么？',
        options: ['指尖上的艺术', '穿在身上的史诗', '布上的画卷', '针线上的传说'],
        answer: 1,
        explanation: '苗族刺绣承载了传承本民族文化的历史重任，因其服饰图案丰富而被称为"穿在身上的史诗"。'
    },
    {
        id: 4,
        question: '皮影戏在哪一年入选联合国教科文组织人类非遗代表作名录？',
        options: ['2006年', '2009年', '2011年', '2015年'],
        answer: 2,
        explanation: '2011年，中国皮影戏入选联合国教科文组织人类非物质文化遗产代表作名录。'
    },
    {
        id: 5,
        question: '苏绣的主要艺术特点不包括以下哪一项？',
        options: ['平', '齐', '活', '匀'],
        answer: 2,
        explanation: '苏绣作品的主要艺术特点为"平、齐、和、光、顺、匀"，不包括"活"。'
    },
    {
        id: 6,
        question: '以下哪个非遗项目属于传统美术类别？',
        options: ['昆曲', '皮影戏', '剪纸艺术', '古琴艺术'],
        answer: 2,
        explanation: '剪纸艺术属于传统美术类别，而昆曲和皮影戏属于传统戏剧，古琴艺术属于传统音乐。'
    },
    {
        id: 7,
        question: '首批国家级非物质文化遗产名录公布于哪一年？',
        options: ['2001年', '2006年', '2008年', '2010年'],
        answer: 1,
        explanation: '2006年，国务院公布了首批国家级非物质文化遗产名录，包括剪纸、昆曲、苏绣等传统艺术。'
    }
  ]