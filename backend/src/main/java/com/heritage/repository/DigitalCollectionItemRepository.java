package com.heritage.repository;

import com.heritage.entity.DigitalCollectionItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface DigitalCollectionItemRepository extends JpaRepository<DigitalCollectionItem, Long> {
    List<DigitalCollectionItem> findByEnabledTrueOrderBySortOrderAscIdAsc();

    List<DigitalCollectionItem> findByEnabledTrueAndSaleStatusOrderBySortOrderAscIdAsc(String saleStatus);

    List<DigitalCollectionItem> findAllByOrderBySortOrderAscIdAsc();

    // 查询 scoreMin <= 传入分数，且库存 > 0，且已启用的藏品（用于测评奖励）
    List<DigitalCollectionItem> findByEnabledTrueAndScoreMinLessThanEqualAndLeftGreaterThanOrderBySortOrderAscIdAsc(
            Integer scoreMin, Integer left);

    /**
     * 按专题+分数查询奖励藏品：
     * topicName 精确匹配传入专题，且 scoreMin <= score，且库存 > 0，且已启用
     */
    @Query("SELECT d FROM DigitalCollectionItem d WHERE d.enabled = true AND d.left > 0 " +
           "AND d.scoreMin <= :score " +
           "AND d.topicName = :topicName " +
           "ORDER BY d.sortOrder ASC, d.id ASC")
    List<DigitalCollectionItem> findRewardByTopicAndScore(
            @Param("topicName") String topicName,
            @Param("score") Integer score);
}

