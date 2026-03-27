package com.heritage.util;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * 解密工具类
 * 用于解密前端传来的加密数据
 */
public class CryptoUtil {
    
    /**
     * XOR 解密
     * @param encryptedBase64 Base64编码的加密数据
     * @param key 前端传递的密钥（不hash）
     * @return 解密后的原始字符串
     */
    public static String xorDecrypt(String encryptedBase64, String key) {
        try {
            // Base64 解码
            byte[] encryptedBytes = Base64.getDecoder().decode(encryptedBase64);
            String encrypted = new String(encryptedBytes, StandardCharsets.UTF_8);
            
            // XOR 解密
            StringBuilder result = new StringBuilder();
            for (int i = 0; i < encrypted.length(); i++) {
                result.append((char) (encrypted.charAt(i) ^ key.charAt(i % key.length())));
            }
            
            return result.toString();
        } catch (Exception e) {
            // 如果解密失败，返回原始数据（降级处理）
            return encryptedBase64;
        }
    }
    
    /**
     * 从加密数据中解析出用户名和密码
     * 加密格式: "encryptedUsername|encryptedPassword" （两个Base64字符串用|分隔）
     * @param data 加密的数据，格式为 "Base64(encrypted_username)|Base64(encrypted_password)"
     * @param key 前端传递的密钥
     * @return Map 包含 username 和 password
     */
    public static Map<String, String> decryptCredentials(String data, String key) {
        Map<String, String> result = new HashMap<>();

        try {
            // 先按 | 分割，得到两个Base64编码的加密字符串
            String[] parts = data.split("\\|", 2);

            if (parts.length == 2) {
                // 分别解密用户名和密码
                String username = xorDecrypt(parts[0], key);
                String password = xorDecrypt(parts[1], key);

                result.put("username", username);
                result.put("password", password);
            } else {
                // 解密失败，降级处理
                System.err.println("解密失败：数据格式错误，无法解析用户名和密码");
                result.put("username", data);
                result.put("password", key);
            }
        } catch (Exception e) {
            System.err.println("解密异常：" + e.getMessage());
            e.printStackTrace();
            result.put("username", data);
            result.put("password", key);
        }

        return result;
    }
}
