package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

/**
 * 非遗项目实体类
 */
@Data
@Entity
@Table(name = "heritage")
public class Heritage {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 100)
    private String name;
    
    @Column(nullable = false, length = 50)
    private String category;
    
    @Column(nullable = false, length = 50)
    private String region;
    
    @Column(nullable = false, length = 50)
    private String level;
    
    @Column(length = 100)
    private String inheritor;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "detail_description", columnDefinition = "TEXT")
    private String detailDescription;
    
    @Column(length = 500)
    private String thumbnail;
    
    @Column(columnDefinition = "TEXT")
    private String images;
    
    @Column(length = 500)
    private String video;
    
    @Column(length = 500)
    private String audio;
    
    @Column(columnDefinition = "TEXT")
    private String timeline;
    
    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer likes = 0;
    
    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer favorites = 0;
    
    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer views = 0;
    
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
    
    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT true")
    private Boolean enabled = true;
}
