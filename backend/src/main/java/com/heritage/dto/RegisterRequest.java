package com.heritage.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 注册请求DTO
 * 支持明文和加密两种格式
 */
@Data
public class RegisterRequest {
    // 明文格式（兼容旧版）
    @Size(min = 3, max = 50, message = "用户名长度必须在3-50之间")
    private String username;

    /** 昵称（选填，支持中英文，2-20字符） */
    @Size(max = 20, message = "昵称不能超过20个字符")
    private String nickname;
    
    @Size(min = 6, max = 20, message = "密码长度必须在6-20之间")
    private String password;
    
    @Email(message = "邮箱格式不正确")
    private String email;
    
    // RSA加密格式（encryptedPassword = RSA公钥加密后的Base64密码）
    private String encryptedPassword;
}
