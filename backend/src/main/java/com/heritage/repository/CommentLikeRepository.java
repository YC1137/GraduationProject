package com.heritage.repository;

import com.heritage.entity.CommentLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 评论点赞数据访问层
 */
@Repository
public interface CommentLikeRepository extends JpaRepository<CommentLike, Long> {
    
    /**
     * 查找用户是否对评论点赞
     */
    Optional<CommentLike> findByCommentIdAndUserId(Long commentId, Long userId);
    
    /**
     * 统计评论的点赞数
     */
    long countByCommentId(Long commentId);
    
    /**
     * 删除用户对评论的点赞
     */
    void deleteByCommentIdAndUserId(Long commentId, Long userId);
}