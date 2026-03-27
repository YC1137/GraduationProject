package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.HeritageDTO;
import com.heritage.dto.LoginRequest;
import com.heritage.dto.RegisterRequest;
import com.heritage.entity.User;
import com.heritage.service.HeritageService;
import com.heritage.service.UserService;
import com.heritage.util.RsaKeyService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {
    
    private final UserService userService;
    private final HeritageService heritageService;
    private final RsaKeyService rsaKeyService;

    /**
     * 获取RSA公钥（前端加密密码用）
     */
    @GetMapping("/public-key")
    public ApiResponse<String> getPublicKey() {
        return ApiResponse.success(rsaKeyService.getPublicKeyBase64());
    }
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    public ApiResponse<Map<String, Object>> register(@RequestBody RegisterRequest request) {
        try {
            String username = request.getUsername();
            // 如果前端传了加密密码(encryptedPassword)则解密，否则用明文password
            String password = request.getEncryptedPassword() != null
                    ? rsaKeyService.decrypt(request.getEncryptedPassword())
                    : request.getPassword();
            String email = request.getEmail();

            User user = userService.register(username, password, email);

            Map<String, Object> data = new HashMap<>();
            data.put("userId", user.getId());
            data.put("username", user.getUsername());
            data.put("email", user.getEmail());
            data.put("avatar", user.getAvatar());
            data.put("walletAddress", user.getWalletAddress());

            return ApiResponse.success("注册成功", data);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    public ApiResponse<Map<String, Object>> login(@RequestBody LoginRequest request, HttpServletRequest httpRequest, HttpServletResponse httpResponse) {
        try {
            String username = request.getUsername();
            // 如果前端传了加密密码(encryptedPassword)则解密，否则用明文password
            String password = request.getEncryptedPassword() != null
                    ? rsaKeyService.decrypt(request.getEncryptedPassword())
                    : request.getPassword();

            if (username == null || username.trim().isEmpty()) {
                return ApiResponse.error("用户名不能为空");
            }
            if (password == null || password.trim().isEmpty()) {
                return ApiResponse.error("密码不能为空");
            }

            Map<String, Object> result = userService.login(username, password);
            User user = (User) result.get("user");
            String token = (String) result.get("token");

            Map<String, Object> data = new HashMap<>();
            data.put("userId", user.getId());
            data.put("username", user.getUsername());
            data.put("email", user.getEmail());
            data.put("avatar", user.getAvatar());
            data.put("walletAddress", user.getWalletAddress());
            data.put("token", token);

            // 设置Cookie
            Cookie cookie = new Cookie("token", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(24 * 60 * 60);
            String hostHeader = httpRequest.getHeader("Host");
            if (hostHeader != null && hostHeader.contains(":")) {
                String domain = hostHeader.substring(0, hostHeader.indexOf(":"));
                cookie.setDomain(domain);
            } else if (hostHeader != null) {
                cookie.setDomain(hostHeader);
            }
            httpResponse.addCookie(cookie);

            return ApiResponse.success("登录成功", data);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 切换收藏
     */
    @PostMapping("/favorite/{heritageId}")
    public ApiResponse<Map<String, Object>> toggleFavorite(
            @PathVariable Long heritageId,
            @RequestParam Long userId
    ) {
        try {
            boolean isFavorite = userService.toggleFavorite(userId, heritageId);
            Map<String, Object> data = new HashMap<>();
            data.put("isFavorite", isFavorite);
            return ApiResponse.success(data);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 切换点赞
     */
    @PostMapping("/like/{heritageId}")
    public ApiResponse<Map<String, Object>> toggleLike(
            @PathVariable Long heritageId,
            @RequestParam Long userId
    ) {
        try {
            boolean isLiked = userService.toggleLike(userId, heritageId);
            Map<String, Object> data = new HashMap<>();
            data.put("isLiked", isLiked);
            return ApiResponse.success(data);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 获取用户收藏列表（ID）
     */
    @GetMapping("/favorites/{userId}")
    public ApiResponse<List<Long>> getUserFavorites(@PathVariable Long userId) {
        List<Long> favorites = userService.getUserFavorites(userId);
        return ApiResponse.success(favorites);
    }
    
    /**
     * 获取用户收藏详情列表（完整遗产数据）
     */
    @GetMapping("/favorites-detail/{userId}")
    public ApiResponse<List<HeritageDTO>> getUserFavoritesDetail(@PathVariable Long userId) {
        try {
            List<Long> ids = userService.getUserFavorites(userId);
            List<HeritageDTO> list = ids.stream()
                .map(id -> {
                    try { return heritageService.getHeritageDetail(id); }
                    catch (Exception e) { return null; }
                })
                .filter(h -> h != null)
                .collect(Collectors.toList());
            return ApiResponse.success(list);
        } catch (Exception e) {
            return ApiResponse.error("获取收藏列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取用户点赞列表（ID）
     */
    @GetMapping("/likes/{userId}")
    public ApiResponse<List<Long>> getUserLikes(@PathVariable Long userId) {
        List<Long> likes = userService.getUserLikes(userId);
        return ApiResponse.success(likes);
    }
    
    /**
     * 获取用户点赞详情列表（完整遗产数据）
     */
    @GetMapping("/likes-detail/{userId}")
    public ApiResponse<List<HeritageDTO>> getUserLikesDetail(@PathVariable Long userId) {
        try {
            List<Long> ids = userService.getUserLikes(userId);
            List<HeritageDTO> list = ids.stream()
                .map(id -> {
                    try { return heritageService.getHeritageDetail(id); }
                    catch (Exception e) { return null; }
                })
                .filter(h -> h != null)
                .collect(Collectors.toList());
            return ApiResponse.success(list);
        } catch (Exception e) {
            return ApiResponse.error("获取点赞列表失败: " + e.getMessage());
        }
    }

    /**
     * 上传并更新用户头像
     */
    @PostMapping("/avatar/{userId}")
    public ApiResponse<Map<String, Object>> uploadAvatar(
            @PathVariable Long userId,
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {
        if (file.isEmpty()) return ApiResponse.error("文件不能为空");
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) return ApiResponse.error("只允许上传图片");

        String uploadDirStr = System.getProperty("user.dir") + File.separator + "uploads";
        Path uploadDir = Paths.get(uploadDirStr);
        try {
            if (!Files.exists(uploadDir)) Files.createDirectories(uploadDir);

            String original = file.getOriginalFilename();
            String ext = (original != null && original.contains("."))
                    ? original.substring(original.lastIndexOf(".")) : ".jpg";
            String fileName = "avatar_" + userId + "_" + UUID.randomUUID().toString().replace("-", "") + ext;
            Path target = uploadDir.resolve(fileName);
            try (InputStream in = file.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
            // 优先用 Host 请求头（客户端实际访问的地址），兼容手机端通过局域网 IP 访问
            String hostHeader = request.getHeader("Host");
            String baseUrl;
            if (hostHeader != null && !hostHeader.isEmpty()) {
                baseUrl = request.getScheme() + "://" + hostHeader + request.getContextPath();
            } else {
                baseUrl = request.getScheme() + "://" + request.getServerName()
                        + ":" + request.getServerPort() + request.getContextPath();
            }
            String avatarUrl = baseUrl + "/uploads/" + fileName;

            User user = userService.updateAvatar(userId, avatarUrl);
            Map<String, Object> data = new HashMap<>();
            data.put("avatar", user.getAvatar());
            return ApiResponse.success("头像更新成功", data);
        } catch (IOException e) {
            e.printStackTrace();
            return ApiResponse.error("文件保存失败: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return ApiResponse.error("上传异常: " + e.getMessage());
        }
    }
}
