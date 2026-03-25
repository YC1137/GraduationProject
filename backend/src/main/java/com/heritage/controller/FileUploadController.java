package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Set;
import java.util.UUID;

/**
 * 通用文件上传接口
 * POST /api/upload/image  → 上传图片，返回可访问的 URL
 */
@RestController
@RequestMapping("/upload")
@RequiredArgsConstructor
public class FileUploadController {

    @Value("${server.port:8080}")
    private int serverPort;

    @Value("${server.servlet.context-path:/api}")
    private String contextPath;

    private static final Set<String> ALLOWED_TYPES = Set.of(
            "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    );
    private static final long MAX_SIZE = 10 * 1024 * 1024L; // 10MB

    @PostMapping("/image")
    public ApiResponse<String> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return ApiResponse.error("请选择要上传的文件");
        }
        if (!ALLOWED_TYPES.contains(file.getContentType())) {
            return ApiResponse.error("仅支持 jpg/png/gif/webp 格式图片");
        }
        if (file.getSize() > MAX_SIZE) {
            return ApiResponse.error("图片大小不能超过 10MB");
        }

        try {
            // 保存到运行目录下的 uploads/ 文件夹
            String uploadDir = System.getProperty("user.dir") + File.separator + "uploads";
            Path dirPath = Paths.get(uploadDir);
            if (!Files.exists(dirPath)) {
                Files.createDirectories(dirPath);
            }

            // 生成唯一文件名，保留原始扩展名
            String originalName = file.getOriginalFilename();
            String ext = (originalName != null && originalName.contains("."))
                    ? originalName.substring(originalName.lastIndexOf("."))
                    : ".jpg";
            String fileName = UUID.randomUUID().toString().replace("-", "") + ext;

            Path filePath = dirPath.resolve(fileName);
            Files.write(filePath, file.getBytes());

            // 返回可访问的 URL（通过 WebMvcConfig 的 /uploads/** 映射）
            String url = "http://localhost:" + serverPort + contextPath + "/uploads/" + fileName;
            return ApiResponse.success(url);
        } catch (IOException e) {
            return ApiResponse.error("文件上传失败：" + e.getMessage());
        }
    }
}
