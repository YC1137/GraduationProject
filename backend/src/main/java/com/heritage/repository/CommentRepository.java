package com.heritage.repository;

import com.heritage.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 评论数据访问层
 */
@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByHeritageIdOrderByCreateTimeDesc(Long heritageId);
    
    /**
     * 查询已审核的评论（状态为1）
     */
    List<Comment> findByHeritageIdAndStatusOrderByCreateTimeDesc(Long heritageId, Integer status);
    
    /**
     * 查询待审核的评论（状态为0）
     */
    List<Comment> findByStatusOrderByCreateTimeDesc(Integer status);

    /**
     * 查询所有评论，按创建时间倒序
     */
    List<Comment> findAllByOrderByCreateTimeDesc();
}
