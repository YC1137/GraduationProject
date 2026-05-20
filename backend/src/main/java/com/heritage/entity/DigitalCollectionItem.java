package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "digital_collection_item")
public class DigitalCollectionItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 50)
    private String serial;

    @Column(length = 50)
    private String category;

    @Column(length = 100)
    private String origin;

    @Column(length = 30)
    private String era;

    @Column(length = 20)
    private String rarity;

    @Column(name = "rarity_class", length = 20)
    private String rarityClass;

    @Column(length = 500)
    private String cover;

    @Column(name = "glow_color", length = 100)
    private String glowColor;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "score_min")
    private Integer scoreMin;

    @Column(name = "topic_name", length = 100)
    private String topicName;

    @Column(name = "total_supply")
    private Integer total;

    @Column(name = "left_supply")
    private Integer left;

    @Column(name = "sale_status", length = 20)
    private String saleStatus;

    @Column(name = "sale_time")
    private LocalDateTime saleTime;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT true")
    private Boolean enabled = true;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}
