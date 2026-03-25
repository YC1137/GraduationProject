package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.entity.Banner;
import com.heritage.repository.BannerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 轮播图接口
 * 前台：GET /api/banner/list  （仅已启用，按排序）
 * 管理：GET/POST/PUT/DELETE /api/banner/admin/**
 */
@RestController
@RequestMapping("/banner")
@RequiredArgsConstructor
public class BannerController {

    private final BannerRepository bannerRepository;

    // ── 前台接口 ───────────────────────────────────────────────

    /** 获取已启用的轮播图列表（供前台首页使用） */
    @GetMapping("/list")
    public ApiResponse<List<Banner>> list() {
        return ApiResponse.success(bannerRepository.findByEnabledTrueOrderBySortOrderAsc());
    }

    // ── 管理端接口 ─────────────────────────────────────────────

    /** 获取所有轮播图（含禁用） */
    @GetMapping("/admin/list")
    public ApiResponse<List<Banner>> adminList() {
        return ApiResponse.success(bannerRepository.findAllByOrderBySortOrderAsc());
    }

    /** 新增轮播图 */
    @PostMapping("/admin/add")
    public ApiResponse<Banner> add(@RequestBody Banner banner) {
        return ApiResponse.success(bannerRepository.save(banner));
    }

    /** 修改轮播图 */
    @PutMapping("/admin/update")
    public ApiResponse<Banner> update(@RequestBody Banner banner) {
        if (banner.getId() == null || !bannerRepository.existsById(banner.getId())) {
            return ApiResponse.error("轮播图不存在");
        }
        return ApiResponse.success(bannerRepository.save(banner));
    }

    /** 删除轮播图 */
    @DeleteMapping("/admin/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        bannerRepository.deleteById(id);
        return ApiResponse.success(null);
    }

    /** 切换启用/禁用 */
    @PutMapping("/admin/{id}/toggle")
    public ApiResponse<Banner> toggle(@PathVariable Long id) {
        Banner banner = bannerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("轮播图不存在"));
        banner.setEnabled(!banner.getEnabled());
        return ApiResponse.success(bannerRepository.save(banner));
    }
}
