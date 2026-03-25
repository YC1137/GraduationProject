package com.heritage.repository;

import com.heritage.entity.UserDigitalAsset;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface UserDigitalAssetRepository extends JpaRepository<UserDigitalAsset, Long> {
    List<UserDigitalAsset> findByUserIdOrderByIdDesc(Long userId);

    boolean existsByUserIdAndItemId(Long userId, Long itemId);

    @Query("select a.editionNo from UserDigitalAsset a where a.itemId = :itemId and a.editionNo is not null")
    List<Integer> findEditionNosByItemId(@Param("itemId") Long itemId);
}

