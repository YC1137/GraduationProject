package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * 轮播图实体
 */
@Data
@Entity
@Table(name = "banner")
public class Banner {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** 图片地址 */
    @Column(name = "image_url", nullable = false, length = 500)
    private String imageUrl;

    /** 标题（可选） */
    @Column(length = 100)
    private String title;

    /** 副标题（可选） */
    @Column(length = 200)
    private String subtitle;

    /** 点击跳转链接（可选） */
    @Column(name = "link_url", length = 200)
    private String linkUrl;

    /** 按钮文字（可选） */
    @Column(name = "btn_text", length = 50)
    private String btnText;

    /** 排序权重，越小越靠前 */
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

    /** 切换间隔（毫秒） */
    @Column(name = "interval", nullable = false)
    private Integer interval = 5000;

    /** 是否启用 */
    @Column(nullable = false)
    private Boolean enabled = true;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}
