package com.heritage.service;

import com.heritage.entity.QuizRecord;
import com.heritage.repository.QuizRecordRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * 答题记录服务层
 */
@Service
@RequiredArgsConstructor
public class QuizRecordService {
    
    private final QuizRecordRepository quizRecordRepository;
    
    /**
     * 保存答题记录 (如果已有记录则更新最佳成绩)
     */
    public QuizRecord saveRecord(QuizRecord record) {
        // 获取用户该专题的历史最佳记录
        List<QuizRecord> existing = quizRecordRepository.findUserBestRecordByTopic(
            record.getUserId(), 
            record.getTopicName(), 
            PageRequest.of(0, 1)
        );

        if (!existing.isEmpty()) {
            QuizRecord best = existing.get(0);
            // 如果新成绩更好（正确率更高，或者正确率相同但用时更少）
            if (record.getAccuracy().compareTo(best.getAccuracy()) > 0 || 
               (record.getAccuracy().compareTo(best.getAccuracy()) == 0 && record.getTimeSpent() < best.getTimeSpent())) {
                
                best.setScore(record.getScore());
                best.setTotalScore(record.getTotalScore());
                best.setCorrectCount(record.getCorrectCount());
                best.setTotalCount(record.getTotalCount());
                best.setAccuracy(record.getAccuracy());
                best.setTimeSpent(record.getTimeSpent());
                best.setCreatedAt(java.time.LocalDateTime.now());
                return quizRecordRepository.save(best);
            }
            // 如果新成绩没超过最佳，则不更新记录（满足“只记录一次最佳”的要求）
            return best;
        }

        // 没有旧记录，直接保存
        return quizRecordRepository.save(record);
    }
    
    /**
     * 获取总排行榜（前100名）
     */
    public List<QuizRecord> getTopRankings(int limit) {
        return quizRecordRepository.findTopRankings(PageRequest.of(0, limit));
    }
    
    /**
     * 获取专题排行榜（前100名）
     */
    public List<QuizRecord> getTopicRankings(String topicName, int limit) {
        return quizRecordRepository.findTopicRankings(topicName, PageRequest.of(0, limit));
    }
    
    /**
     * 获取用户在某个专题的最佳成绩
     */
    public Optional<QuizRecord> getUserBestRecordByTopic(Long userId, String topicName) {
        List<QuizRecord> records = quizRecordRepository.findUserBestRecordByTopic(userId, topicName, PageRequest.of(0, 1));
        return records.isEmpty() ? Optional.empty() : Optional.of(records.get(0));
    }
    
    /**
     * 获取用户的所有答题记录
     */
    public List<QuizRecord> getUserHistory(Long userId) {
        return quizRecordRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }
    
    /**
     * 获取用户某个专题的答题次数
     */
    public Long getUserTopicAttemptCount(Long userId, String topicName) {
        return quizRecordRepository.countByUserIdAndTopicName(userId, topicName);
    }
}
