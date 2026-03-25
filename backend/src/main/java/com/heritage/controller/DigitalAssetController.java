package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.MintDigitalAssetRequest;
import com.heritage.entity.UserDigitalAsset;
import com.heritage.service.DigitalAssetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/digital-asset")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class DigitalAssetController {

    private final DigitalAssetService digitalAssetService;

    @PostMapping("/mint")
    public ApiResponse<UserDigitalAsset> mint(@Valid @RequestBody MintDigitalAssetRequest request) {
        try {
            return ApiResponse.success("上链成功", digitalAssetService.mintAsset(request));
        } catch (RuntimeException e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<UserDigitalAsset>> listByUser(@PathVariable Long userId) {
        return ApiResponse.success(digitalAssetService.listByUserId(userId));
    }
}
