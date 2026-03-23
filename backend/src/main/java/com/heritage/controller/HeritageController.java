package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.HeritageDTO;
import com.heritage.service.HeritageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 非遗项目控制器
 */
@RestController
@RequestMapping("/heritage")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class HeritageController {
    
    private final HeritageService heritageService;
    
    /**
     * 获取非遗项目列表
     */
    @GetMapping("/list")
    public ApiResponse<List<HeritageDTO>> getHeritageList(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) String level,
            @RequestParam(required = false) String keyword
    ) {
        List<HeritageDTO> list = heritageService.getHeritageList(category, region, level, keyword);
        return ApiResponse.success(list);
    }
    
    /**
     * 获取非遗项目详情
     */
    @GetMapping("/detail/{id}")
    public ApiResponse<HeritageDTO> getHeritageDetail(@PathVariable Long id) {
        HeritageDTO heritage = heritageService.getHeritageDetail(id);
        heritageService.increaseViews(id);
        return ApiResponse.success(heritage);
    }
}
