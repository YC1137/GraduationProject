package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

/**
 * 用户点赞实体类
 */
@Data
@Entity
@Table(name = "user_like", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "heritage_id"})
})
public class UserLike {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_id", nullable = false)
    private Long userId;
    
    @Column(name = "heritage_id", nullable = false)
    private Long heritageId;
    
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}
