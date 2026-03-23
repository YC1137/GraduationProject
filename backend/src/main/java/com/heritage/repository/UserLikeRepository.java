package com.heritage.repository;

import com.heritage.entity.UserLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 用户点赞数据访问层
 */
@Repository
public interface UserLikeRepository extends JpaRepository<UserLike, Long> {
    List<UserLike> findByUserId(Long userId);
    Optional<UserLike> findByUserIdAndHeritageId(Long userId, Long heritageId);
    boolean existsByUserIdAndHeritageId(Long userId, Long heritageId);
    void deleteByUserIdAndHeritageId(Long userId, Long heritageId);
}
