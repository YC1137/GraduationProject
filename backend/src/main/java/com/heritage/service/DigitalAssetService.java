package com.heritage.service;

import com.heritage.dto.MintDigitalAssetRequest;
import com.heritage.entity.DigitalCollectionItem;
import com.heritage.entity.User;
import com.heritage.entity.UserDigitalAsset;
import com.heritage.repository.DigitalCollectionItemRepository;
import com.heritage.repository.UserDigitalAssetRepository;
import com.heritage.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;


@Service
@RequiredArgsConstructor
public class DigitalAssetService {

    private final UserRepository userRepository;
    private final UserDigitalAssetRepository userDigitalAssetRepository;
    private final DigitalCollectionItemRepository digitalCollectionItemRepository;
    private final BlockchainMintService blockchainMintService;

    @Transactional
    public UserDigitalAsset mintAsset(MintDigitalAssetRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("用户不存在"));

        if (request.getItemId() == null) {
            throw new RuntimeException("藏品ID不能为空");
        }
        if (userDigitalAssetRepository.existsByUserIdAndItemId(user.getId(), request.getItemId())) {
            throw new RuntimeException("该藏品已拥有，无需重复铸造");
        }

        DigitalCollectionItem item = digitalCollectionItemRepository.findById(request.getItemId())
                .orElseThrow(() -> new RuntimeException("藏品不存在或已下架"));

        if (!Boolean.TRUE.equals(item.getEnabled())) {
            throw new RuntimeException("该藏品已下架");
        }
        if (item.getLeft() == null || item.getLeft() <= 0) {
            throw new RuntimeException("该藏品已售罄");
        }

        if (user.getWalletAddress() == null || user.getWalletAddress().isBlank()) {
            throw new RuntimeException("用户链地址不存在，请重新登录后重试");
        }

        // 生成随机编号
        Integer editionNo = generateRandomEditionNo(item.getId(), item.getTotal());
        String serial = formatEditionSerial(editionNo, item.getTotal());

        // 先保存记录（txHash 暂填占位），获得数据库 id，用于构建 tokenURI
        UserDigitalAsset asset = new UserDigitalAsset();
        asset.setUserId(user.getId());
        asset.setItemId(item.getId());
        asset.setName(item.getName());
        asset.setNameEn(item.getNameEn());
        asset.setEditionNo(editionNo);
        asset.setTotal(item.getTotal());
        asset.setSerial(serial);
        asset.setOrigin(item.getOrigin());
        asset.setCover(item.getCover());
        asset.setRarity(item.getRarity());
        asset.setRarityClass(item.getRarityClass());
        asset.setSource(request.getSource());
        asset.setOwnedAt(request.getOwnedAt());
        // 临时占位，上链后更新
        asset.setTxHash("pending");
        asset.setContractAddress("pending");
        asset.setChain("Sepolia");
        asset.setOnChain(false);
        asset = userDigitalAssetRepository.save(asset);

        // 构建 base64 inline tokenURI，不依赖服务器，链上永久可读
        String tokenUri = buildBase64TokenUri(asset);
        asset.setTokenUri(tokenUri);

        // 上链
        BlockchainMintService.MintResult chainResult = blockchainMintService.mintToAddress(user.getWalletAddress(), tokenUri);

        asset.setTokenId(chainResult.getTokenId());
        asset.setTxHash(chainResult.getTxHash());
        asset.setBlockNumber(chainResult.getBlockNumber());
        asset.setContractAddress(chainResult.getContractAddress());
        asset.setChain(chainResult.getChainName());
        asset.setExplorerUrl(chainResult.getExplorerUrl());
        asset.setOnChain(Boolean.TRUE.equals(chainResult.getConfirmed()));

        item.setLeft(Math.max(0, item.getLeft() - 1));
        digitalCollectionItemRepository.save(item);

        return userDigitalAssetRepository.save(asset);
    }

    public List<UserDigitalAsset> listByUserId(Long userId) {
        return userDigitalAssetRepository.findByUserIdOrderByIdDesc(userId);
    }

    private Integer generateRandomEditionNo(Long itemId, Integer total) {
        if (total == null || total <= 0) {
            throw new RuntimeException("藏品发行量配置错误");
        }
        Set<Integer> used = new HashSet<>(userDigitalAssetRepository.findEditionNosByItemId(itemId));
        if (used.size() >= total) {
            throw new RuntimeException("该藏品编号已分配完");
        }

        int candidate;
        int retry = 0;
        do {
            candidate = ThreadLocalRandom.current().nextInt(1, total + 1);
            retry++;
            if (retry > total * 2) {
                for (int i = 1; i <= total; i++) {
                    if (!used.contains(i)) {
                        return i;
                    }
                }
                throw new RuntimeException("该藏品编号已分配完");
            }
        } while (used.contains(candidate));

        return candidate;
    }

    private String formatEditionSerial(Integer editionNo, Integer total) {
        return editionNo + "/" + total;
    }

    /**
     * 构建 base64 inline tokenURI，格式：data:application/json;base64,{base64编码的JSON}
     * 直接内嵌 metadata，无需任何服务器，Etherscan/OpenSea 可直接解析
     */
    private String buildBase64TokenUri(UserDigitalAsset asset) {
        String description = buildDescription(asset);

        // attributes - all values in English to avoid encoding issues
        StringBuilder attrs = new StringBuilder("[");
        attrs.append("{\"trait_type\":\"Rarity\",\"value\":\"").append(esc(asset.getRarityClass())).append("\"}");
        attrs.append(",{\"trait_type\":\"Source\",\"value\":\"Direct Claim\"}");
        if (asset.getEditionNo() != null && asset.getTotal() != null) {
            attrs.append(",{\"trait_type\":\"Edition\",\"value\":\"").append(asset.getEditionNo()).append("/").append(asset.getTotal()).append("\"}");
            attrs.append(",{\"trait_type\":\"Total Supply\",\"value\":\"").append(asset.getTotal()).append("\"}");
        }
        attrs.append(",{\"trait_type\":\"Chain\",\"value\":\"Sepolia\"}");
        attrs.append("]");

        // name 优先用英文名，没有则用 HeritageNFT #id
        String tokenIdStr = (asset.getTokenId() != null && !asset.getTokenId().isBlank())
                ? asset.getTokenId() : String.valueOf(asset.getId());
        String name = (asset.getNameEn() != null && !asset.getNameEn().isBlank())
                ? asset.getNameEn() + " #" + tokenIdStr
                : "HeritageNFT #" + tokenIdStr;
        String image = asset.getCover() != null ? asset.getCover() : "";

        String json = "{"
                + "\"name\":\"" + esc(name) + "\","
                + "\"description\":\"" + esc(description) + "\","
                + "\"image\":\"" + esc(image) + "\","
                + "\"attributes\":" + attrs
                + "}";

        String base64 = Base64.getEncoder().encodeToString(json.getBytes(StandardCharsets.UTF_8));
        return "data:application/json;base64," + base64;
    }

    private String buildDescription(UserDigitalAsset asset) {
        List<String> parts = new ArrayList<>();
        if (asset.getRarityClass() != null && !asset.getRarityClass().isBlank()) parts.add(asset.getRarityClass());
        if (asset.getEditionNo() != null && asset.getTotal() != null)
            parts.add("Edition " + asset.getEditionNo() + "/" + asset.getTotal());
        parts.add("Direct Claim");
        return String.join(" | ", parts);
    }

    /**
     * 转义 JSON 字符串：特殊字符 + 所有非 ASCII 字符转为 Unicode 编码
     * 保证最终 JSON 为纯 ASCII，Etherscan 任意环境均可正确解析
     */
    private String esc(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            if (c == '\\') { sb.append("\\\\"); }
            else if (c == '"') { sb.append("\\\""); }
            else if (c == '\n') { sb.append("\\n"); }
            else if (c == '\r') { sb.append("\\r"); }
            else if (c > 0x7F) { sb.append(String.format("\\u%04x", (int) c)); }
            else { sb.append(c); }
        }
        return sb.toString();
    }
}
