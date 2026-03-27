package com.heritage.repository;

import com.heritage.entity.BombRecord;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BombRecordRepository extends JpaRepository<BombRecord, Long> {

    /** 最新挑战成功记录列表（用于荣耀榜） */
    @Query("SELECT r FROM BombRecord r ORDER BY r.createdAt DESC")
    List<BombRecord> findLatest(Pageable pageable);

    /** 某用户的挑战成功记录 */
    List<BombRecord> findByUserIdOrderByCreatedAtDesc(Long userId);
}
