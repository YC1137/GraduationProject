package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 平台公告实体
 */
@Data
@Entity
@Table(name = "announcement")
public class Announcement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * 标签文字，如：通知、活动、更新、公告
     */
    @Column(length = 20, nullable = false)
    private String tag;

    /**
     * 标签类型（对应前端样式），可选：info / primary / success / warning / danger
     */
    @Column(length = 20, nullable = false)
    private String type = "info";

    /**
     * 公告标题
     */
    @Column(length = 300, nullable = false)
    private String title;

    /**
     * 公告正文内容（可为空，为空时不展示详情按钮）
     */
    @Column(columnDefinition = "TEXT")
    private String content;

    /**
     * 发布日期
     */
    @Column(name = "pub_date")
    private LocalDate pubDate;

    /**
     * 排序权重，越小越靠前
     */
    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 0;

    /**
     * 是否启用
     */
    @Column(nullable = false)
    private Boolean enabled = true;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}
