package com.heritage.repository;

import com.heritage.entity.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 知识测验题目数据访问层
 */
@Repository
public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {
    
    /**
     * 查询所有启用的题目
     */
    List<QuizQuestion> findByEnabledTrue();
    
    /**
     * 根据专题名称查询启用的题目
     */
    List<QuizQuestion> findByTopicNameAndEnabledTrue(String topicName);
    
    /**
     * 查询所有不重复的专题名称
     */
    @Query("SELECT DISTINCT q.topicName FROM QuizQuestion q WHERE q.enabled = true AND q.topicName IS NOT NULL ORDER BY q.topicName")
    List<String> findDistinctTopicNames();
}
