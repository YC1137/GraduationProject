package com.heritage.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 非遗炸弹游戏 - 挑战成功记录
 */
@Data
@Entity
@Table(name = "bomb_record", indexes = {
    @Index(name = "idx_bomb_user_id", columnList = "user_id"),
    @Index(name = "idx_bomb_created_at", columnList = "created_at")
})
public class BombRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "username", length = 50)
    private String username;

    /** 本局守护的非遗项目名 */
    @Column(name = "project_name", length = 100, nullable = false)
    private String projectName;

    /** 第几轮引爆（1-5） */
    @Column(name = "win_round", nullable = false)
    private Integer winRound;

    /** 说漏嘴的那个字 */
    @Column(name = "leaked_char", length = 10, nullable = false)
    private String leakedChar;

    /**
     * 完整对话记录，JSON 格式存储：
     * [{"role":"ai","content":"..."},{"role":"user","content":"..."},...]
     */
    @Column(name = "messages", columnDefinition = "TEXT", nullable = false)
    private String messages;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
