package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.HeritageDTO;
import com.heritage.entity.Heritage;
import com.heritage.entity.QuizQuestion;
import com.heritage.entity.User;
import com.heritage.service.CommentService;
import com.heritage.service.HeritageService;
import com.heritage.service.QuizService;
import com.heritage.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 后台管理控制器
 */
@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminController {
    
    private final UserService userService;
    private final HeritageService heritageService;
    private final CommentService commentService;
    private final QuizService quizService;
    
    /**
     * 获取所有用户
     */
    @GetMapping("/users")
    public ApiResponse<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ApiResponse.success(users);
    }
    
    /**
     * 根据ID获取用户
     */
    @GetMapping("/user/{id}")
    public ApiResponse<User> getUserById(@PathVariable Long id) {
        User user = userService.getUserById(id);
        return ApiResponse.success(user);
    }
    
    /**
     * 更新用户角色
     */
    @PutMapping("/user/{id}/role")
    public ApiResponse<User> updateUserRole(@PathVariable Long id, @RequestBody Map<String, String> request) {
        try {
            User user = userService.updateUserRole(id, request.get("role"));
            return ApiResponse.success("角色更新成功", user);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 删除用户
     */
    @DeleteMapping("/user/{id}")
    public ApiResponse<Void> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ApiResponse.success("用户删除成功", null);
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
    
    /**
     * 获取所有非遗项目
     */
    @GetMapping("/heritages")
    public ApiResponse<List<HeritageDTO>> getAllHeritages() {
        List<HeritageDTO> heritages = heritageService.getAllHeritages();
        return ApiResponse.success(heritages);
    }
    
    /**
     * 添加非遗项目
     */
    @PostMapping("/heritage")
    public ApiResponse<Heritage> addHeritage(@RequestBody Heritage heritage) {
        Heritage savedHeritage = heritageService.saveHeritage(heritage);
        return ApiResponse.success("添加成功", savedHeritage);
    }
    
    /**
     * 更新非遗项目
     */
    @PutMapping("/heritage/{id}")
    public ApiResponse<Heritage> updateHeritage(@PathVariable Long id, @RequestBody Heritage heritage) {
        heritage.setId(id);
        Heritage updatedHeritage = heritageService.saveHeritage(heritage);
        return ApiResponse.success("更新成功", updatedHeritage);
    }
    
    /**
     * 删除非遗项目
     */
    @DeleteMapping("/heritage/{id}")
    public ApiResponse<Void> deleteHeritage(@PathVariable Long id) {
        heritageService.deleteHeritage(id);
        return ApiResponse.success("删除成功", null);
    }
    
    /**
     * 获取所有测验题目
     */
    @GetMapping("/quizzes")
    public ApiResponse<List<QuizQuestion>> getAllQuizzes() {
        List<QuizQuestion> questions = quizService.getAllQuestions();
        return ApiResponse.success(questions);
    }
    
    /**
     * 添加测验题目
     */
    @PostMapping("/quiz")
    public ApiResponse<QuizQuestion> addQuiz(@RequestBody QuizQuestion question) {
        QuizQuestion savedQuestion = quizService.saveQuestion(question);
        return ApiResponse.success("添加成功", savedQuestion);
    }
    
    /**
     * 更新测验题目
     */
    @PutMapping("/quiz/{id}")
    public ApiResponse<QuizQuestion> updateQuiz(@PathVariable Long id, @RequestBody QuizQuestion question) {
        question.setId(id);
        QuizQuestion updatedQuestion = quizService.saveQuestion(question);
        return ApiResponse.success("更新成功", updatedQuestion);
    }
    
    /**
     * 批量删除非遗项目
     */
    @DeleteMapping("/heritages/batch-delete")
    public ApiResponse<Void> batchDeleteHeritages(@RequestBody Map<String, List<Long>> request) {
        List<Long> ids = request.get("ids");
        heritageService.batchDeleteHeritages(ids);
        return ApiResponse.success("批量删除成功", null);
    }
    
    /**
     * 批量更新非遗项目启用状态
     */
    @PutMapping("/heritages/batch-enabled")
    public ApiResponse<Void> batchUpdateHeritagesEnabled(@RequestBody Map<String, Object> request) {
        List<Long> ids = (List<Long>) request.get("ids");
        Boolean enabled = (Boolean) request.get("enabled");
        heritageService.batchUpdateHeritagesEnabled(ids, enabled);
        return ApiResponse.success("批量更新成功", null);
    }
    
    /**
     * 批量更新测验题目启用状态
     */
    @PutMapping("/quizzes/batch-enabled")
    public ApiResponse<Void> batchUpdateQuizzesEnabled(@RequestBody Map<String, Object> request) {
        List<Long> ids = (List<Long>) request.get("ids");
        Boolean enabled = (Boolean) request.get("enabled");
        quizService.batchUpdateQuestionsEnabled(ids, enabled);
        return ApiResponse.success("批量更新成功", null);
    }
    
    /**
     * 删除测验题目
     */
    @DeleteMapping("/quiz/{id}")
    public ApiResponse<Void> deleteQuiz(@PathVariable Long id) {
        quizService.deleteQuestion(id);
        return ApiResponse.success("删除成功", null);
    }
    
    /**
     * 批量删除测验题目
     */
    @DeleteMapping("/quizzes/batch-delete")
    public ApiResponse<Void> batchDeleteQuizzes(@RequestBody Map<String, List<Long>> request) {
        List<Long> ids = request.get("ids");
        quizService.batchDeleteQuestions(ids);
        return ApiResponse.success("批量删除成功", null);
    }
    
    /**
     * 删除评论
     */
    @DeleteMapping("/comment/{id}")
    public ApiResponse<Void> deleteComment(@PathVariable Long id) {
        commentService.deleteComment(id);
        return ApiResponse.success("删除成功", null);
    }
}
