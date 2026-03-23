package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.CommentRequest;
import com.heritage.entity.Comment;
import com.heritage.entity.User;
import com.heritage.service.CommentService;
import com.heritage.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 评论控制器
 */
@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CommentController {
    
    private final CommentService commentService;
    private final UserService userService;
    
    /**
     * 获取评论列表（只返回已审核的评论）
     */
    @GetMapping("/{heritageId}")
    public ApiResponse<List<Comment>> getComments(@PathVariable Long heritageId) {
        List<Comment> comments = commentService.getApprovedComments(heritageId);
        return ApiResponse.success(comments);
    }
    
    /**
     * 发布评论
     */
    @PostMapping
    public ApiResponse<Comment> postComment(
            @Valid @RequestBody CommentRequest request,
            @RequestParam Long userId
    ) {
        try {
            User user = userService.getUserById(userId);
            Comment comment = commentService.postComment(
                request.getHeritageId(),
                userId,
                user.getUsername(),
                user.getAvatar(),
                request.getContent()
            );
            return ApiResponse.success("评论发布成功，等待审核", comment);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        } catch (Exception e) {
            return ApiResponse.error("评论发布失败：" + e.getMessage());
        }
    }

    /**
     * 切换评论点赞状态
     */
    @PostMapping("/{commentId}/like")
    public ApiResponse<Map<String, Object>> toggleCommentLike(
            @PathVariable Long commentId,
            @RequestParam Long userId
    ) {
        try {
            System.out.println("=== 收到点赞请求 ===");
            System.out.println("commentId: " + commentId);
            System.out.println("userId: " + userId);

            boolean isLiked = commentService.toggleCommentLike(commentId, userId);

            System.out.println("点赞操作结果: " + isLiked);

            Map<String, Object> data = new HashMap<>();
            data.put("isLiked", isLiked);
            String message = isLiked ? "点赞成功" : "取消点赞";
            return ApiResponse.success(message, data);
        } catch (RuntimeException e) {
            System.err.println("点赞操作 RuntimeException: " + e.getMessage());
            e.printStackTrace();
            return ApiResponse.error(e.getMessage());
        } catch (Exception e) {
            System.err.println("点赞操作 Exception: " + e.getMessage());
            e.printStackTrace();
            return ApiResponse.error("点赞操作失败：" + e.getMessage());
        }
    }
    
    /**
     * 管理员：获取所有待审核评论
     */
    @GetMapping("/admin/pending")
    public ApiResponse<List<Comment>> getPendingComments() {
        List<Comment> comments = commentService.getPendingComments();
        return ApiResponse.success(comments);
    }

    /**
     * 管理员：获取所有评论（用于审核页面）
     */
    @GetMapping("/admin/all")
    public ApiResponse<List<Comment>> getAllComments() {
        List<Comment> comments = commentService.getAllComments();
        return ApiResponse.success(comments);
    }
    
    /**
     * 管理员：审核评论
     */
    @PutMapping("/admin/{commentId}/review")
    public ApiResponse<String> reviewComment(
            @PathVariable Long commentId,
            @RequestParam Integer status
    ) {
        try {
            commentService.reviewComment(commentId, status);
            String message = status == 1 ? "评论已通过审核" : "评论已拒绝";
            return ApiResponse.success(message);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 管理员：删除评论
     */
    @DeleteMapping("/admin/{commentId}")
    public ApiResponse<String> deleteComment(@PathVariable Long commentId) {
        try {
            commentService.deleteComment(commentId);
            return ApiResponse.success("评论删除成功");
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
