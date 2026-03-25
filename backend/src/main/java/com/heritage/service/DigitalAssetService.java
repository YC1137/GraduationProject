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

import java.util.HashSet;
import java.util.List;
import java.util.Set;
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

        Integer editionNo = generateRandomEditionNo(item.getId(), item.getTotal());

        BlockchainMintService.MintResult chainResult = blockchainMintService.mintToAddress(user.getWalletAddress(), request.getTokenUri());

        UserDigitalAsset asset = new UserDigitalAsset();
        asset.setUserId(user.getId());
        asset.setItemId(item.getId());
        asset.setName(item.getName());
        asset.setEditionNo(editionNo);
        asset.setSerial(formatEditionSerial(item.getSerial(), editionNo, item.getTotal()));

        asset.setOrigin(item.getOrigin());
        asset.setCover(item.getCover());
        asset.setRarity(item.getRarity());
        asset.setRarityClass(item.getRarityClass());
        asset.setSource(request.getSource());
        asset.setOwnedAt(request.getOwnedAt());
        asset.setTokenUri(request.getTokenUri());

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

    private String formatEditionSerial(String baseSerial, Integer editionNo, Integer total) {
        String prefix = (baseSerial == null || baseSerial.isBlank()) ? "COLLECT" : baseSerial.trim();
        return prefix + " · 第" + editionNo + "/" + total + "份";
    }
}

