package com.heritage.service;

import com.heritage.entity.User;
import com.heritage.entity.UserFavorite;
import com.heritage.entity.UserLike;
import com.heritage.repository.UserFavoriteRepository;
import com.heritage.repository.UserLikeRepository;
import com.heritage.repository.UserRepository;
import com.heritage.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.Keys;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 用户服务层
 */
@Service
@RequiredArgsConstructor
public class UserService {
    
    private final UserRepository userRepository;
    private final UserFavoriteRepository userFavoriteRepository;
    private final UserLikeRepository userLikeRepository;
    private final HeritageService heritageService;
    
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    /**
     * 用户注册
     */
    @Transactional
    public User register(String username, String password, String email) {
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("用户名已存在");
        }
        if (email != null && !email.isBlank() && userRepository.existsByEmail(email)) {
            throw new RuntimeException("邮箱已被注册");
        }
        
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password)); // BCrypt加密
        user.setEmail((email != null && !email.isBlank()) ? email : null);
        user.setAvatar(String.format("https://ui-avatars.com/api/?name=%s&background=c8302b&color=fff", username));
        user.setWalletAddress(generateWalletAddress());
        user.setRole("USER"); // 默认角色为普通用户
        
        return userRepository.save(user);
    }
    
    /**
     * 用户登录 - 返回token
     */
    @Transactional
    public Map<String, Object> login(String username, String password) {
        String normalizedUsername = username == null ? null : username.trim();
        String normalizedPassword = password == null ? null : password.trim();

        User user = userRepository.findByUsername(normalizedUsername)
            .orElseThrow(() -> new RuntimeException("用户名或密码错误"));

        if (!passwordEncoder.matches(normalizedPassword, user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        user.setLastLoginTime(LocalDateTime.now());
        if (user.getWalletAddress() == null || user.getWalletAddress().isBlank()) {
            user.setWalletAddress(generateWalletAddress());
        }
        userRepository.save(user);

        String token = JwtUtil.generateToken(user.getId(), user.getUsername());

        Map<String, Object> result = new HashMap<>();
        result.put("user", user);
        result.put("token", token);

        return result;
    }
    
    /**
     * 根据ID获取用户
     */
    public User getUserById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("用户不存在"));
    }
    
    /**
     * 获取所有用户
     */
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    /**
     * 更新用户头像
     */
    @Transactional
    public User updateAvatar(Long id, String avatarUrl) {
        User user = getUserById(id);
        user.setAvatar(avatarUrl);
        return userRepository.save(user);
    }

    /**
     * 更新用户角色
     */
    @Transactional
    public User updateUserRole(Long id, String role) {
        User user = getUserById(id);
        user.setRole(role);
        return userRepository.save(user);
    }
    
    /**
     * 删除用户
     */
    @Transactional
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
    
    /**
     * 切换收藏
     */
    @Transactional
    public boolean toggleFavorite(Long userId, Long heritageId) {
        if (userFavoriteRepository.existsByUserIdAndHeritageId(userId, heritageId)) {
            userFavoriteRepository.deleteByUserIdAndHeritageId(userId, heritageId);
            heritageService.decreaseFavorites(heritageId);
            return false;
        } else {
            UserFavorite favorite = new UserFavorite();
            favorite.setUserId(userId);
            favorite.setHeritageId(heritageId);
            userFavoriteRepository.save(favorite);
            heritageService.increaseFavorites(heritageId);
            return true;
        }
    }
    
    /**
     * 切换点赞
     */
    @Transactional
    public boolean toggleLike(Long userId, Long heritageId) {
        if (userLikeRepository.existsByUserIdAndHeritageId(userId, heritageId)) {
            userLikeRepository.deleteByUserIdAndHeritageId(userId, heritageId);
            heritageService.decreaseLikes(heritageId);
            return false;
        } else {
            UserLike like = new UserLike();
            like.setUserId(userId);
            like.setHeritageId(heritageId);
            userLikeRepository.save(like);
            heritageService.increaseLikes(heritageId);
            return true;
        }
    }
    
    /**
     * 获取用户收藏的项目ID列表
     */
    public List<Long> getUserFavorites(Long userId) {
        return userFavoriteRepository.findByUserId(userId)
            .stream()
            .map(UserFavorite::getHeritageId)
            .collect(Collectors.toList());
    }
    
    /**
     * 获取用户点赞的项目ID列表
     */
    public List<Long> getUserLikes(Long userId) {
        return userLikeRepository.findByUserId(userId)
            .stream()
            .map(UserLike::getHeritageId)
            .collect(Collectors.toList());
    }

    private String generateWalletAddress() {
        try {
            ECKeyPair keyPair = Keys.createEcKeyPair();
            return "0x" + Keys.getAddress(keyPair.getPublicKey());
        } catch (Exception e) {
            throw new RuntimeException("生成链地址失败", e);
        }
    }
}
