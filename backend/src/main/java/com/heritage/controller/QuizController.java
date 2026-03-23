package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.entity.QuizQuestion;
import com.heritage.entity.QuizRecord;
import com.heritage.service.QuizService;
import com.heritage.service.QuizRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * 知识测验控制器
 */
@RestController
@RequestMapping("/quiz")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class QuizController {
    
    private final QuizService quizService;
    private final QuizRecordService quizRecordService;
    
    /**
     * 获取所有测验题目
     */
    @GetMapping("/questions")
    public ApiResponse<List<QuizQuestion>> getQuestions() {
        List<QuizQuestion> questions = quizService.getAllQuestions();
        return ApiResponse.success(questions);
    }
    
    /**
     * 根据专题获取题目
     */
    @GetMapping("/questions/topic/{topicName}")
    public ApiResponse<List<QuizQuestion>> getQuestionsByTopic(@PathVariable String topicName) {
        List<QuizQuestion> questions = quizService.getQuestionsByTopic(topicName);
        return ApiResponse.success(questions);
    }
    
    /**
     * 获取所有专题列表
     */
    @GetMapping("/topics")
    public ApiResponse<List<String>> getAllTopics() {
        List<String> topics = quizService.getAllTopics();
        return ApiResponse.success(topics);
    }
    
    /**
     * 提交答题记录
     */
    @PostMapping("/records")
    public ApiResponse<QuizRecord> submitRecord(@RequestBody QuizRecord record) {
        QuizRecord savedRecord = quizRecordService.saveRecord(record);
        return ApiResponse.success("提交成功", savedRecord);
    }
    
    /**
     * 获取总排行榜
     */
    @GetMapping("/rankings/top")
    public ApiResponse<List<QuizRecord>> getTopRankings(@RequestParam(defaultValue = "100") int limit) {
        List<QuizRecord> rankings = quizRecordService.getTopRankings(limit);
        return ApiResponse.success(rankings);
    }
    
    /**
     * 获取专题排行榜
     */
    @GetMapping("/rankings/topic/{topicName}")
    public ApiResponse<List<QuizRecord>> getTopicRankings(
            @PathVariable String topicName,
            @RequestParam(defaultValue = "100") int limit) {
        List<QuizRecord> rankings = quizRecordService.getTopicRankings(topicName, limit);
        return ApiResponse.success(rankings);
    }
    
    /**
     * 获取用户在某个专题的最佳成绩
     */
    @GetMapping("/users/{userId}/topics/{topicName}/best")
    public ApiResponse<QuizRecord> getUserBestRecord(
            @PathVariable Long userId,
            @PathVariable String topicName) {
        Optional<QuizRecord> record = quizRecordService.getUserBestRecordByTopic(userId, topicName);
        return record.map(ApiResponse::success)
                .orElse(ApiResponse.error("暂无记录"));
    }
    
    /**
     * 获取用户答题历史
     */
    @GetMapping("/users/{userId}/history")
    public ApiResponse<List<QuizRecord>> getUserHistory(@PathVariable Long userId) {
        List<QuizRecord> history = quizRecordService.getUserHistory(userId);
        return ApiResponse.success(history);
    }
}

