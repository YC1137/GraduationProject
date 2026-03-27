package com.heritage.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 登录请求DTO
 * 支持明文和加密两种格式
 */
@Data
public class LoginRequest {
    // 明文格式（兼容旧版）
    private String username;
    private String password;
    
    // RSA加密格式（encryptedPassword = RSA公钥加密后的Base64密码）
    private String encryptedPassword;
}
