package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.HeritageDTO;
import com.heritage.dto.LoginRequest;
import com.heritage.dto.RegisterRequest;
import com.heritage.entity.User;
import com.heritage.service.HeritageService;
import com.heritage.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    public ApiResponse<Map<String, Object>> register(@Valid @RequestBody RegisterRequest request) {
        try {
            User user = userService.register(request.getUsername(), request.getPassword(), request.getEmail());
            
            Map<String, Object> data = new HashMap<>();
            data.put("username", user.getUsername());
            data.put("email", user.getEmail());
            data.put("avatar", user.getAvatar());
            
            return ApiResponse.success("注册成功", data);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    public ApiResponse<Map<String, Object>> login(@Valid @RequestBody LoginRequest request) {
        try {
            User user = userService.login(request.getUsername(), request.getPassword());
            
            Map<String, Object> data = new HashMap<>();
            data.put("userId", user.getId());
            data.put("username", user.getUsername());
            data.put("email", user.getEmail());
            data.put("avatar", user.getAvatar());
            data.put("token", "mock-token-" + user.getId()); // 简化版token
            
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
}
