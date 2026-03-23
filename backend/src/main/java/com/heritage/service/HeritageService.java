package com.heritage.service;

import com.heritage.dto.HeritageDTO;
import com.heritage.entity.Heritage;
import com.heritage.repository.HeritageRepository;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 非遗项目服务层
 */
@Service
@RequiredArgsConstructor
public class HeritageService {
    
    private final HeritageRepository heritageRepository;
    
    /**
     * 获取所有非遗项目
     */
    public List<HeritageDTO> getAllHeritages() {
        return heritageRepository.findAll().stream()
                .map(HeritageDTO::fromEntity)
                .collect(Collectors.toList());
    }
    
    /**
     * 获取非遗项目列表(支持筛选)
     */
    public List<HeritageDTO> getHeritageList(String category, String region, String level, String keyword) {
        Specification<Heritage> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            
            if (category != null && !category.isEmpty()) {
                predicates.add(cb.equal(root.get("category"), category));
            }
            if (region != null && !region.isEmpty()) {
                predicates.add(cb.equal(root.get("region"), region));
            }
            if (level != null && !level.isEmpty()) {
                predicates.add(cb.equal(root.get("level"), level));
            }
            if (keyword != null && !keyword.isEmpty()) {
                String pattern = "%" + keyword + "%";
                predicates.add(cb.or(
                    cb.like(root.get("name"), pattern),
                    cb.like(root.get("description"), pattern)
                ));
            }
            
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        
        return heritageRepository.findAll(spec).stream()
                .map(HeritageDTO::fromEntity)
                .collect(Collectors.toList());
    }
    
    /**
     * 获取非遗项目详情
     */
    public HeritageDTO getHeritageDetail(Long id) {
        Heritage heritage = getHeritageEntity(id);
        return HeritageDTO.fromEntity(heritage);
    }
    
    /**
     * 获取非遗项目实体（内部方法）
     */
    private Heritage getHeritageEntity(Long id) {
        return heritageRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("项目不存在"));
    }
    
    /**
     * 增加浏览量
     */
    @Transactional
    public void increaseViews(Long id) {
        Heritage heritage = getHeritageEntity(id);
        heritage.setViews(heritage.getViews() + 1);
        heritageRepository.save(heritage);
    }
    
    /**
     * 增加点赞数
     */
    @Transactional
    public void increaseLikes(Long id) {
        Heritage heritage = getHeritageEntity(id);
        heritage.setLikes(heritage.getLikes() + 1);
        heritageRepository.save(heritage);
    }
    
    /**
     * 减少点赞数
     */
    @Transactional
    public void decreaseLikes(Long id) {
        Heritage heritage = getHeritageEntity(id);
        heritage.setLikes(Math.max(0, heritage.getLikes() - 1));
        heritageRepository.save(heritage);
    }
    
    /**
     * 增加收藏数
     */
    @Transactional
    public void increaseFavorites(Long id) {
        Heritage heritage = getHeritageEntity(id);
        heritage.setFavorites(heritage.getFavorites() + 1);
        heritageRepository.save(heritage);
    }
    
    /**
     * 减少收藏数
     */
    @Transactional
    public void decreaseFavorites(Long id) {
        Heritage heritage = getHeritageEntity(id);
        heritage.setFavorites(Math.max(0, heritage.getFavorites() - 1));
        heritageRepository.save(heritage);
    }
    
    /**
     * 保存非遗项目
     */
    @Transactional
    public Heritage saveHeritage(Heritage heritage) {
        return heritageRepository.save(heritage);
    }
    
    /**
     * 删除非遗项目
     */
    @Transactional
    public void deleteHeritage(Long id) {
        heritageRepository.deleteById(id);
    }
    
    /**
     * 批量删除非遗项目
     */
    @Transactional
    public void batchDeleteHeritages(List<Long> ids) {
        heritageRepository.deleteAllById(ids);
    }
    
    /**
     * 批量更新非遗项目启用状态
     */
    @Transactional
    public void batchUpdateHeritagesEnabled(List<Long> ids, Boolean enabled) {
        for (Long id : ids) {
            Heritage heritage = heritageRepository.findById(id).orElse(null);
            if (heritage != null) {
                heritage.setEnabled(enabled);
                heritageRepository.save(heritage);
            }
        }
    }
}
