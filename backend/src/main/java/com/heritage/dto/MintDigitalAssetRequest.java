package com.heritage.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MintDigitalAssetRequest {
    @NotNull(message = "用户ID不能为空")
    private Long userId;

    @NotNull(message = "藏品ID不能为空")
    private Long itemId;

    private String source;

    private String ownedAt;
}
