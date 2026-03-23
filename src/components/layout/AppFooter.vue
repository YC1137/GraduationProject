<template>
    <footer class="app-footer">
      <div class="footer-pattern"></div>
      <div class="container footer-content">
        <div class="footer-section">
          <h3 class="footer-title">关于平台</h3>
          <p class="footer-desc">
            非遗数字化展示平台致力于传承和弘扬中华优秀传统文化，
            通过数字化手段保护和展示非物质文化遗产。
          </p>
        </div>
        
        <div class="footer-section">
          <h3 class="footer-title">快速链接</h3>
          <ul class="footer-links">
            <li><router-link to="/">首页</router-link></li>
            <li><router-link to="/category">分类浏览</router-link></li>
            <li><router-link to="/quiz">知识测验</router-link></li>
          </ul>
        </div>
        
        <div class="footer-section">
          <h3 class="footer-title">联系我们</h3>
          <ul class="footer-contact">
            <li>
              <el-icon><Message /></el-icon>
              <span>heritage@example.com</span>
            </li>
            <li>
              <el-icon><Phone /></el-icon>
              <span>400-123-4567</span>
            </li>
            <li>
              <el-icon><Location /></el-icon>
              <span>北京市朝阳区文化大道123号</span>
            </li>
          </ul>
        </div>
      </div>
      
      <div class="footer-bottom">
        <div class="container">
          <p class="copyright">
            © 2024 非遗数字化展示平台. All Rights Reserved.
          </p>
          <p class="icp">
            传承非遗文化 · 守护民族瑰宝
          </p>
        </div>
      </div>
    </footer>
  </template>
  
  <script setup>
  import { Message, Phone, Location } from '@element-plus/icons-vue'
  // 页脚组件 - 展示平台信息和快速导航
  </script>
  
  <style lang="scss" scoped>
  .app-footer {
    position: relative;
    background: linear-gradient(to bottom, var(--bg-dark), var(--secondary-dark));
    color: var(--bg-light);
    padding: 60px 0 0;
    margin-top: 80px;
    overflow: hidden;
  }
  
  .footer-pattern {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(
      to right,
      var(--primary-color),
      var(--primary-light),
      var(--primary-color)
    );
  }
  
  .footer-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 40px;
    padding-bottom: 40px;
  }
  
  .footer-section {
    .footer-title {
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 20px;
      color: var(--bg-light);
      position: relative;
      padding-bottom: 10px;
      
      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 40px;
        height: 2px;
        background: var(--primary-color);
      }
    }
    
    .footer-desc {
      line-height: 1.8;
      color: rgba(248, 244, 230, 0.8);
      font-size: 14px;
    }
  }
  
  .footer-links {
    list-style: none;
    
    li {
      margin-bottom: 12px;
      
      a {
        color: rgba(248, 244, 230, 0.8);
        font-size: 14px;
        transition: var(--transition);
        
        &:hover {
          color: var(--primary-light);
          padding-left: 5px;
        }
      }
    }
  }
  
  .footer-contact {
    list-style: none;
    
    li {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
      color: rgba(248, 244, 230, 0.8);
      font-size: 14px;
      
      .el-icon {
        color: var(--primary-color);
        font-size: 16px;
      }
    }
  }
  
  .footer-bottom {
    background: rgba(0, 0, 0, 0.2);
    padding: 20px 0;
    text-align: center;
    border-top: 1px solid rgba(248, 244, 230, 0.1);
    
    .container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 10px;
    }
    
    p {
      margin: 0;
      font-size: 13px;
      color: rgba(248, 244, 230, 0.7);
    }
  }
  
  @media (max-width: 768px) {
    .app-footer {
      padding: 20px 0 0; // 减少顶部内边距
      margin-top: 20px; // 减少顶部外边距
    }
    
    .footer-content {
      grid-template-columns: 1fr;
      gap: 15px; // 减少区块间距
      padding-bottom: 15px; // 减少底部内边距
    }
    
    .footer-section {
      .footer-title {
        margin-bottom: 10px; // 减少底部间距
        padding-bottom: 6px; // 减少内边距
        
        &::after {
          height: 1.5px;
        }
      }
      
      .footer-desc {
        line-height: 1.5; // 减少行高
      }
    }
    
    .footer-links {
      li {
        margin-bottom: 6px; // 减少间距
      }
    }
    
    .footer-contact {
      li {
        margin-bottom: 6px; // 减少间距
        gap: 8px; // 减少图标和文字间距
      }
    }
    
    .footer-bottom {
      padding: 12px 0; // 减少内边距
      
      .container {
        flex-direction: column;
        text-align: center;
        gap: 5px; // 减少间距
      }
    }
  }
  </style>
  