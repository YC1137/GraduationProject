package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 知识测验题目实体类
 */
@Data
@Entity
@Table(name = "quiz_question")
public class QuizQuestion {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;
    
    @Column(nullable = false, columnDefinition = "TEXT")
    private String options;
    
    @Column(nullable = false)
    private Integer answer;
    
    @Column(columnDefinition = "TEXT")
    private String explanation;
    
    @Column(length = 100)
    private String topicName;
    
    @Column(name = "create_time")
    private LocalDateTime createTime;
    
    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT true")
    private Boolean enabled = true;
}
