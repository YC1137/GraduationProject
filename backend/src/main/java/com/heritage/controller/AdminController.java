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
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
     * 上传图片，返回可访问的 URL
     */
    @PostMapping("/upload")
    public ApiResponse<String> uploadImage(@RequestParam("file") MultipartFile file,
                                           HttpServletRequest request) {
        if (file.isEmpty()) {
            return ApiResponse.error("文件不能为空");
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return ApiResponse.error("只允许上传图片文件");
        }
        // 上传目录：使用绝对路径，放在后端 jar 同级的 uploads/ 目录
        String uploadDirStr = System.getProperty("user.dir") + File.separator + "uploads";
        Path uploadDir = Paths.get(uploadDirStr);
        try {
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }
            // 生成唯一文件名，保留原始扩展名
            String original = file.getOriginalFilename();
            String ext = (original != null && original.contains("."))
                    ? original.substring(original.lastIndexOf("."))
                    : ".jpg";
            String fileName = UUID.randomUUID().toString().replace("-", "") + ext;
            Path target = uploadDir.resolve(fileName);
            try (InputStream in = file.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
            // 拼接可访问的 URL
            String baseUrl = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort() + request.getContextPath();
            String url = baseUrl + "/uploads/" + fileName;
            return ApiResponse.success("上传成功", url);
        } catch (IOException e) {
            return ApiResponse.error("文件保存失败: " + e.getMessage());
        }
    }
    
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
