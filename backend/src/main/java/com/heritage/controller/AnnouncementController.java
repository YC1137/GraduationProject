package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.entity.Announcement;
import com.heritage.repository.AnnouncementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 平台公告接口
 * 前台：GET /api/announcement/list  （仅已启用）
 * 管理：GET/POST/PUT/DELETE /api/announcement/admin/**
 */
@RestController
@RequestMapping("/announcement")
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementRepository announcementRepository;

    // ── 前台接口 ───────────────────────────────────────────────

    /** 获取已启用的公告列表（供前台首页使用） */
    @GetMapping("/list")
    public ApiResponse<List<Announcement>> list() {
        return ApiResponse.success(
                announcementRepository.findByEnabledTrueOrderBySortOrderAscCreateTimeDesc());
    }

    // ── 管理端接口 ─────────────────────────────────────────────

    /** 获取所有公告（含禁用） */
    @GetMapping("/admin/list")
    public ApiResponse<List<Announcement>> adminList() {
        return ApiResponse.success(
                announcementRepository.findAllByOrderBySortOrderAscCreateTimeDesc());
    }

    /** 新增公告 */
    @PostMapping("/admin/add")
    public ApiResponse<Announcement> add(@RequestBody Announcement announcement) {
        return ApiResponse.success(announcementRepository.save(announcement));
    }

    /** 修改公告 */
    @PutMapping("/admin/update")
    public ApiResponse<Announcement> update(@RequestBody Announcement announcement) {
        if (announcement.getId() == null || !announcementRepository.existsById(announcement.getId())) {
            return ApiResponse.error("公告不存在");
        }
        return ApiResponse.success(announcementRepository.save(announcement));
    }

    /** 删除公告 */
    @DeleteMapping("/admin/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        announcementRepository.deleteById(id);
        return ApiResponse.success(null);
    }

    /** 切换启用/禁用 */
    @PutMapping("/admin/{id}/toggle")
    public ApiResponse<Announcement> toggle(@PathVariable Long id) {
        Announcement announcement = announcementRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("公告不存在"));
        announcement.setEnabled(!announcement.getEnabled());
        return ApiResponse.success(announcementRepository.save(announcement));
    }
}
