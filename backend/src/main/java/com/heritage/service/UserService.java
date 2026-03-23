package com.heritage.service;

import com.heritage.entity.User;
import com.heritage.entity.UserFavorite;
import com.heritage.entity.UserLike;
import com.heritage.repository.UserFavoriteRepository;
import com.heritage.repository.UserLikeRepository;
import com.heritage.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
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
        user.setPassword(password); // 实际项目应该加密
        user.setEmail((email != null && !email.isBlank()) ? email : null);
        user.setAvatar(String.format("https://ui-avatars.com/api/?name=%s&background=c8302b&color=fff", username));
        user.setRole("USER"); // 默认角色为普通用户
        
        return userRepository.save(user);
    }
    
    /**
     * 用户登录
     */
    @Transactional
    public User login(String username, String password) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("用户名或密码错误"));
        
        if (!user.getPassword().equals(password)) {
            throw new RuntimeException("用户名或密码错误");
        }
        
        user.setLastLoginTime(LocalDateTime.now());
        userRepository.save(user);
        
        return user;
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
}
