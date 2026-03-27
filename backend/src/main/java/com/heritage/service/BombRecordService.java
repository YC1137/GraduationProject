package com.heritage.service;

import com.heritage.entity.BombRecord;
import com.heritage.repository.BombRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BombRecordService {

    private final BombRecordRepository bombRecordRepository;

    /** 保存一条挑战成功记录 */
    public BombRecord save(BombRecord record) {
        return bombRecordRepository.save(record);
    }

    /** 获取最新的 N 条成功记录（荣耀榜） */
    public List<BombRecord> getLatest(int limit) {
        return bombRecordRepository.findLatest(PageRequest.of(0, limit));
    }

    /** 获取某用户的成功记录 */
    public List<BombRecord> getByUser(Long userId) {
        return bombRecordRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }
}
