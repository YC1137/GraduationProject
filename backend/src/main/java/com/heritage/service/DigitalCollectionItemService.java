package com.heritage.service;

import com.heritage.entity.DigitalCollectionItem;
import com.heritage.repository.DigitalCollectionItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DigitalCollectionItemService {

    private final DigitalCollectionItemRepository repository;

    public List<DigitalCollectionItem> listRewardByScore(int score) {
        // 返回 scoreMin <= 用户得分 的藏品（门槛分在管理后台配置）
        return repository.findByEnabledTrueAndScoreMinLessThanEqualAndLeftGreaterThanOrderBySortOrderAscIdAsc(score, 0);
    }

    /**
     * 按专题+分数查询奖励藏品（传入 topicName="" 或 null 时退化为仅按分数查询）
     */
    public List<DigitalCollectionItem> listRewardByTopicAndScore(String topicName, int score) {
        if (topicName == null || topicName.isBlank()) {
            return listRewardByScore(score);
        }
        return repository.findRewardByTopicAndScore(topicName, score);
    }

    public List<DigitalCollectionItem> listEnabled(String saleStatus) {
        if (saleStatus == null || saleStatus.isBlank()) {
            return repository.findByEnabledTrueOrderBySortOrderAscIdAsc();
        }
        return repository.findByEnabledTrueAndSaleStatusOrderBySortOrderAscIdAsc(saleStatus);
    }

    public List<DigitalCollectionItem> listAll() {
        return repository.findAllByOrderBySortOrderAscIdAsc();
    }

    @Transactional
    public DigitalCollectionItem save(DigitalCollectionItem item) {
        normalize(item);
        return repository.save(item);
    }

    @Transactional
    public DigitalCollectionItem update(Long id, DigitalCollectionItem item) {
        DigitalCollectionItem existed = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("数字藏品不存在"));

        existed.setName(item.getName());
        existed.setSerial(item.getSerial());
        existed.setCategory(item.getCategory());
        existed.setOrigin(item.getOrigin());
        existed.setEra(item.getEra());
        existed.setRarity(item.getRarity());
        existed.setRarityClass(item.getRarityClass());
        existed.setCover(item.getCover());
        existed.setGlowColor(item.getGlowColor());
        existed.setDescription(item.getDescription());
        existed.setScoreMin(item.getScoreMin());
        existed.setTopicName(item.getTopicName());
        existed.setTotal(item.getTotal());
        existed.setLeft(item.getLeft());
        existed.setSaleStatus(item.getSaleStatus());
        existed.setSaleTime(item.getSaleTime());
        existed.setSortOrder(item.getSortOrder());
        existed.setEnabled(item.getEnabled());

        normalize(existed);
        return repository.save(existed);
    }

    @Transactional
    public void delete(Long id) {
        repository.deleteById(id);
    }

    @Transactional
    public void batchUpdateEnabled(List<Long> ids, Boolean enabled) {
        for (Long id : ids) {
            repository.findById(id).ifPresent(item -> {
                item.setEnabled(enabled);
                repository.save(item);
            });
        }
    }

    private void normalize(DigitalCollectionItem item) {
        if (item.getSortOrder() == null) item.setSortOrder(0);
        if (item.getEnabled() == null) item.setEnabled(true);
        if (item.getTotal() == null) item.setTotal(0);
        if (item.getLeft() == null) item.setLeft(0);
        if (item.getScoreMin() == null) item.setScoreMin(60);
        if (item.getSaleStatus() == null || item.getSaleStatus().isBlank()) item.setSaleStatus("ongoing");
    }
}
