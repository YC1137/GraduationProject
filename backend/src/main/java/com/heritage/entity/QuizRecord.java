package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 答题记录实体类
 */
@Data
@Entity
@Table(name = "quiz_record", indexes = {
    @Index(name = "idx_user_id", columnList = "user_id"),
    @Index(name = "idx_topic_name", columnList = "topic_name"),
    @Index(name = "idx_accuracy_time", columnList = "accuracy DESC, time_spent ASC"),
    @Index(name = "idx_created_at", columnList = "created_at DESC")
})
public class QuizRecord {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id", nullable = false)
    private Long userId;
    
    @Column(name = "username", length = 50)
    private String username;
    
    @Column(name = "topic_name", length = 100, nullable = false)
    private String topicName;
    
    @Column(nullable = false)
    private Integer score;
    
    @Column(name = "total_score", nullable = false)
    private Integer totalScore;
    
    @Column(name = "correct_count", nullable = false)
    private Integer correctCount;
    
    @Column(name = "total_count", nullable = false)
    private Integer totalCount;
    
    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal accuracy;
    
    @Column(name = "time_spent", nullable = false)
    private Integer timeSpent; // 用时(秒)
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
