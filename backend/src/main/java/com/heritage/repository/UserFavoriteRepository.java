package com.heritage.repository;

import com.heritage.entity.UserFavorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 用户收藏数据访问层
 */
@Repository
public interface UserFavoriteRepository extends JpaRepository<UserFavorite, Long> {
    List<UserFavorite> findByUserId(Long userId);
    Optional<UserFavorite> findByUserIdAndHeritageId(Long userId, Long heritageId);
    boolean existsByUserIdAndHeritageId(Long userId, Long heritageId);
    void deleteByUserIdAndHeritageId(Long userId, Long heritageId);
}
