package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.entity.BombRecord;
import com.heritage.service.BombRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 非遗炸弹游戏记录接口
 */
@RestController
@RequestMapping("/bomb")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class BombController {

    private final BombRecordService bombRecordService;

    /**
     * 提交一条挑战成功记录
     */
    @PostMapping("/records")
    public ApiResponse<BombRecord> submitRecord(@RequestBody BombRecord record) {
        BombRecord saved = bombRecordService.save(record);
        return ApiResponse.success("记录保存成功", saved);
    }

    /**
     * 获取荣耀榜（最新 N 条成功记录）
     * GET /api/bomb/records/latest?limit=20
     */
    @GetMapping("/records/latest")
    public ApiResponse<List<BombRecord>> getLatest(
            @RequestParam(defaultValue = "20") int limit) {
        List<BombRecord> list = bombRecordService.getLatest(limit);
        return ApiResponse.success(list);
    }

    /**
     * 获取某用户的挑战成功记录
     * GET /api/bomb/records/user/{userId}
     */
    @GetMapping("/records/user/{userId}")
    public ApiResponse<List<BombRecord>> getUserRecords(@PathVariable Long userId) {
        List<BombRecord> list = bombRecordService.getByUser(userId);
        return ApiResponse.success(list);
    }
}
