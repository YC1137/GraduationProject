package com.heritage.repository;

import com.heritage.entity.DigitalCollectionItem;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DigitalCollectionItemRepository extends JpaRepository<DigitalCollectionItem, Long> {
    List<DigitalCollectionItem> findByEnabledTrueOrderBySortOrderAscIdAsc();

    List<DigitalCollectionItem> findByEnabledTrueAndSaleStatusOrderBySortOrderAscIdAsc(String saleStatus);

    List<DigitalCollectionItem> findAllByOrderBySortOrderAscIdAsc();
}
