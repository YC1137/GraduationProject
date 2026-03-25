package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.entity.DigitalCollectionItem;
import com.heritage.service.DigitalCollectionItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class DigitalCollectionController {

    private final DigitalCollectionItemService digitalCollectionItemService;

    @GetMapping("/digital-collection/list")
    public ApiResponse<List<DigitalCollectionItem>> listEnabled(
            @RequestParam(required = false) String saleStatus
    ) {
        try {
            return ApiResponse.success(digitalCollectionItemService.listEnabled(saleStatus));
        } catch (Exception e) {
            return ApiResponse.error("查询数字藏品失败: " + e.getMessage());
        }
    }

    @GetMapping("/admin/digital-collection/list")
    public ApiResponse<List<DigitalCollectionItem>> listAll() {
        try {
            return ApiResponse.success(digitalCollectionItemService.listAll());
        } catch (Exception e) {
            return ApiResponse.error("查询数字藏品失败: " + e.getMessage());
        }
    }



    @PostMapping("/admin/digital-collection")
    public ApiResponse<DigitalCollectionItem> create(@RequestBody DigitalCollectionItem item) {
        try {
            return ApiResponse.success("创建成功", digitalCollectionItemService.save(item));
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/admin/digital-collection/{id}")
    public ApiResponse<DigitalCollectionItem> update(@PathVariable Long id, @RequestBody DigitalCollectionItem item) {
        try {
            return ApiResponse.success("更新成功", digitalCollectionItemService.update(id, item));
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/admin/digital-collection/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        digitalCollectionItemService.delete(id);
        return ApiResponse.success("删除成功", null);
    }

    @PutMapping("/admin/digital-collection/batch-enabled")
    public ApiResponse<Void> batchEnabled(@RequestBody Map<String, Object> request) {
        List<Long> ids = (List<Long>) request.get("ids");
        Boolean enabled = (Boolean) request.get("enabled");
        digitalCollectionItemService.batchUpdateEnabled(ids, enabled);
        return ApiResponse.success("批量更新成功", null);
    }
}
