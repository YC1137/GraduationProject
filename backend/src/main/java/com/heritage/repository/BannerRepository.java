package com.heritage.repository;

import com.heritage.entity.Banner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BannerRepository extends JpaRepository<Banner, Long> {

    /** 查询所有已启用的轮播图，按排序权重升序 */
    List<Banner> findByEnabledTrueOrderBySortOrderAsc();

    /** 查询所有轮播图，按排序权重升序（管理端） */
    List<Banner> findAllByOrderBySortOrderAsc();
}
