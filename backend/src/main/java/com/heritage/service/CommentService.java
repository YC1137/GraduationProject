package com.heritage.service;

import com.heritage.entity.Comment;
import com.heritage.entity.CommentLike;
import com.heritage.repository.CommentLikeRepository;
import com.heritage.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * 评论服务层
 */
@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final CommentLikeRepository commentLikeRepository;
    
    /**
     * 获取评论列表（只返回已审核的）
     */
    public List<Comment> getApprovedComments(Long heritageId) {
        return commentRepository.findByHeritageIdAndStatusOrderByCreateTimeDesc(heritageId, 1);
    }
    
    /**
     * 获取所有待审核评论
     */
    public List<Comment> getPendingComments() {
        return commentRepository.findByStatusOrderByCreateTimeDesc(0);
    }

    /**
     * 获取所有评论（管理员审核用）
     */
    public List<Comment> getAllComments() {
        return commentRepository.findAllByOrderByCreateTimeDesc();
    }
    
    /**
     * 发布评论（默认为待审核状态）
     */
    @Transactional
    public Comment postComment(Long heritageId, Long userId, String username, String avatar, String content) {
        Comment comment = new Comment();
        comment.setHeritageId(heritageId);
        comment.setUserId(userId);
        comment.setUsername(username);
        comment.setAvatar(avatar);
        comment.setContent(content);
        comment.setStatus(0); // 默认为待审核状态
        return commentRepository.save(comment);
    }
    
    /**
     * 审核评论
     * @param commentId 评论ID
     * @param status 审核状态：1-通过，2-拒绝
     */
    @Transactional
    public void reviewComment(Long commentId, Integer status) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));
        if (!status.equals(1) && !status.equals(2)) {
            throw new RuntimeException("无效的审核状态");
        }
        comment.setStatus(status);
        commentRepository.save(comment);
    }
    
    /**
     * 删除评论
     */
    @Transactional
    public void deleteComment(Long id) {
        commentRepository.deleteById(id);
    }

    /**
     * 切换评论点赞状态
     * @param commentId 评论ID
     * @param userId 用户ID
     * @return true-点赞成功，false-取消点赞
     */
    @Transactional
    public boolean toggleCommentLike(Long commentId, Long userId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));

        Optional<CommentLike> existingLike = commentLikeRepository.findByCommentIdAndUserId(commentId, userId);

        if (existingLike.isPresent()) {
            // 已点赞，取消点赞
            commentLikeRepository.delete(existingLike.get());
            comment.setLikes(Math.max(0, comment.getLikes() - 1));
            commentRepository.save(comment);
            return false;
        } else {
            // 未点赞，添加点赞
            CommentLike commentLike = new CommentLike();
            commentLike.setCommentId(commentId);
            commentLike.setUserId(userId);
            commentLikeRepository.save(commentLike);

            comment.setLikes(comment.getLikes() + 1);
            commentRepository.save(comment);
            return true;
        }
    }
}
