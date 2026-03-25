package com.heritage.controller;

import com.heritage.dto.ApiResponse;
import com.heritage.dto.MintDigitalAssetRequest;
import com.heritage.entity.UserDigitalAsset;
import com.heritage.repository.UserDigitalAssetRepository;
import com.heritage.service.DigitalAssetService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/digital-asset")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class DigitalAssetController {

    private final DigitalAssetService digitalAssetService;
    private final UserDigitalAssetRepository userDigitalAssetRepository;

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

    /**
     * ERC-721 metadata 接口（按数据库id），tokenURI = baseUrl/digital-asset/metadata/id/{id}
     */
    @GetMapping(value = "/metadata/id/{id}", produces = "application/json;charset=UTF-8")
    public Map<String, Object> metadataById(@PathVariable Long id, HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        UserDigitalAsset asset = userDigitalAssetRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("藏品不存在"));
        return buildMeta(asset);
    }

    /**
     * ERC-721 metadata 接口（按tokenId兼容旧数据）
     */
    @GetMapping(value = "/metadata/{tokenId}", produces = "application/json;charset=UTF-8")
    public Map<String, Object> metadata(@PathVariable String tokenId, HttpServletResponse response) {
        response.setContentType("application/json;charset=UTF-8");
        UserDigitalAsset asset = userDigitalAssetRepository.findByTokenId(tokenId)
                .orElseThrow(() -> new RuntimeException("藏品不存在"));
        return buildMeta(asset);
    }

    private Map<String, Object> buildMeta(UserDigitalAsset asset) {
        Map<String, Object> meta = new LinkedHashMap<>();
        // 优先使用英文名
        String displayName = (asset.getNameEn() != null && !asset.getNameEn().isBlank())
                ? asset.getNameEn()
                : (asset.getName() != null ? asset.getName() : "Heritage NFT");
        meta.put("name", displayName);
        meta.put("description", buildDesc(asset));
        meta.put("image", asset.getCover() != null ? asset.getCover() : "");

        List<Map<String, String>> attrs = new ArrayList<>();
        attrs.add(attr("稀有度", asset.getRarity()));
        attrs.add(attr("来源", "quiz".equals(asset.getSource()) ? "测验获得" : "首发收藏"));
        if (asset.getEditionNo() != null && asset.getTotal() != null) {
            attrs.add(attr("编号", asset.getEditionNo() + "/" + asset.getTotal()));
            attrs.add(attr("发行量", String.valueOf(asset.getTotal())));
        }
        if (asset.getChain() != null) attrs.add(attr("链", asset.getChain()));
        meta.put("attributes", attrs);
        return meta;
    }

    private String buildDesc(UserDigitalAsset a) {
        List<String> parts = new ArrayList<>();
        if (a.getOrigin() != null && !a.getOrigin().isBlank()) parts.add(a.getOrigin());
        if (a.getRarity() != null && !a.getRarity().isBlank()) parts.add(a.getRarity());
        if (a.getEditionNo() != null && a.getTotal() != null)
            parts.add("第" + a.getEditionNo() + "/" + a.getTotal() + "份");
        return String.join(" · ", parts);
    }

    private Map<String, String> attr(String type, String value) {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("trait_type", type);
        m.put("value", value != null ? value : "");
        return m;
    }
}

