package com.heritage.repository;

import com.heritage.entity.QuizRecord;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 答题记录数据访问层
 */
@Repository
public interface QuizRecordRepository extends JpaRepository<QuizRecord, Long> {
    
    /**
     * 获取总排行榜（每个用户只取其所有专题中的最佳一笔，按正确率降序，正确率相同按时间升序）
     */
    @Query("SELECT qr FROM QuizRecord qr WHERE qr.id IN (" +
           "  SELECT MAX(q2.id) FROM QuizRecord q2 WHERE q2.id IN (" +
           "    SELECT q3.id FROM QuizRecord q3 WHERE (q3.userId, q3.accuracy, q3.timeSpent) IN (" +
           "      SELECT q4.userId, MAX(q4.accuracy), MIN(q4.timeSpent) FROM QuizRecord q4 GROUP BY q4.userId" +
           "    )" +
           "  ) GROUP BY q2.userId" +
           ") ORDER BY qr.accuracy DESC, qr.timeSpent ASC, qr.createdAt DESC")
    List<QuizRecord> findTopRankings(Pageable pageable);
    
    /**
     * 获取专题排行榜（每个用户在该专题下只取最佳成绩，配合 saveRecord 逻辑，此处查询已保证每个用户每专题唯一）
     */
    @Query("SELECT qr FROM QuizRecord qr WHERE qr.topicName = :topicName ORDER BY qr.accuracy DESC, qr.timeSpent ASC, qr.createdAt DESC")
    List<QuizRecord> findTopicRankings(@Param("topicName") String topicName, Pageable pageable);
    
    /**
     * 获取用户在某个专题的最佳成绩
     */
    @Query("SELECT qr FROM QuizRecord qr WHERE qr.userId = :userId AND qr.topicName = :topicName ORDER BY qr.accuracy DESC, qr.timeSpent ASC")
    List<QuizRecord> findUserBestRecordByTopic(@Param("userId") Long userId, @Param("topicName") String topicName, Pageable pageable);
    
    /**
     * 获取用户的所有答题记录
     */
    @Query("SELECT qr FROM QuizRecord qr WHERE qr.userId = :userId ORDER BY qr.createdAt DESC")
    List<QuizRecord> findByUserIdOrderByCreatedAtDesc(@Param("userId") Long userId);
    
    /**
     * 获取用户某个专题的答题次数
     */
    @Query("SELECT COUNT(qr) FROM QuizRecord qr WHERE qr.userId = :userId AND qr.topicName = :topicName")
    Long countByUserIdAndTopicName(@Param("userId") Long userId, @Param("topicName") String topicName);

    /**
     * 检查用户在某专题是否有满分记录（score >= totalScore）
     */
    @Query("SELECT COUNT(qr) FROM QuizRecord qr WHERE qr.userId = :userId AND qr.topicName = :topicName AND qr.score >= qr.totalScore")
    Long countPerfectScoreByUserAndTopic(@Param("userId") Long userId, @Param("topicName") String topicName);
}
