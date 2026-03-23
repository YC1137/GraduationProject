package com.heritage.service;

import com.heritage.entity.QuizQuestion;
import com.heritage.repository.QuizQuestionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 知识测验服务层
 */
@Service
@RequiredArgsConstructor
public class QuizService {
    
    private final QuizQuestionRepository quizQuestionRepository;
    
    /**
     * 获取所有测验题目(只返回启用的)
     */
    public List<QuizQuestion> getAllQuestions() {
        return quizQuestionRepository.findByEnabledTrue();
    }
    
    /**
     * 根据专题获取题目
     */
    public List<QuizQuestion> getQuestionsByTopic(String topicName) {
        return quizQuestionRepository.findByTopicNameAndEnabledTrue(topicName);
    }
    
    /**
     * 获取所有专题名称
     */
    public List<String> getAllTopics() {
        return quizQuestionRepository.findDistinctTopicNames();
    }
    
    /**
     * 保存测验题目
     */
    public QuizQuestion saveQuestion(QuizQuestion question) {
        return quizQuestionRepository.save(question);
    }
    
    /**
     * 删除测验题目
     */
    public void deleteQuestion(Long id) {
        quizQuestionRepository.deleteById(id);
    }
    
    /**
     * 批量删除测验题目
     */
    public void batchDeleteQuestions(List<Long> ids) {
        quizQuestionRepository.deleteAllById(ids);
    }
    
    /**
     * 批量更新测验题目启用状态
     */
    public void batchUpdateQuestionsEnabled(List<Long> ids, Boolean enabled) {
        for (Long id : ids) {
            QuizQuestion question = quizQuestionRepository.findById(id).orElse(null);
            if (question != null) {
                question.setEnabled(enabled);
                quizQuestionRepository.save(question);
            }
        }
    }
}
