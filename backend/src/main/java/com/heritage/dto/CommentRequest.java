package com.heritage.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 评论请求DTO
 */
@Data
public class CommentRequest {
    @NotNull(message = "非遗项目ID不能为空")
    private Long heritageId;
    
    @NotBlank(message = "评论内容不能为空")
    private String content;
}
