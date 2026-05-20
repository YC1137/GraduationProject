package com.heritage.service;

import com.heritage.entity.UserDigitalAsset;
import com.heritage.repository.UserDigitalAssetRepository;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.OkHttpClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthGetTransactionReceipt;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.core.methods.response.Log;
import org.web3j.protocol.core.methods.response.TransactionReceipt;


import org.web3j.protocol.http.HttpService;
import org.web3j.tx.RawTransactionManager;
import org.web3j.tx.TransactionManager;
import org.web3j.utils.Numeric;

import java.math.BigInteger;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class BlockchainMintService {

    private static final String TRANSFER_TOPIC = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";

    private final UserDigitalAssetRepository userDigitalAssetRepository;

    @Value("${blockchain.rpc-url}")
    private String rpcUrl;

    @Value("${blockchain.contract-address}")
    private String contractAddress;

    @Value("${blockchain.chain-id:11155111}")
    private Long chainId;

    @Value("${blockchain.gas-price:3000000000}")
    private Long gasPrice;

    @Value("${blockchain.gas-limit:600000}")
    private Long gasLimit;

    @Value("${blockchain.http-timeout-seconds:30}")
    private Long httpTimeoutSeconds;

    @Value("${blockchain.platform-private-key}")
    private String platformPrivateKey;

    /**
     * 异步上链：先入库再异步发送交易，成功后回写 txHash/onChain 字段
     */
    @Async
    public void mintToAddressAsync(Long assetId, String toAddress, String tokenUri) {
        try {
            MintResult result = doMint(toAddress, tokenUri);
            // 回写链上信息（交易已发出，等待确认）
            userDigitalAssetRepository.findById(assetId).ifPresent(asset -> {
                asset.setTxHash(result.getTxHash());
                asset.setContractAddress(result.getContractAddress());
                asset.setChain(result.getChainName());
                asset.setExplorerUrl(result.getExplorerUrl());
                asset.setOnChain(false);
                userDigitalAssetRepository.save(asset);
                log.info("[区块链] 资产 {} 上链交易已发出: {}", assetId, result.getTxHash());
            });
            // 轮询等待交易被确认，最多等 5 分钟
            waitForConfirmation(assetId, result.getTxHash());
        } catch (Exception e) {
            log.warn("[区块链] 资产 {} 上链失败（异步），将保持离线状态: {}", assetId, e.getMessage());
        }
    }

    /**
     * 轮询等待交易收据，确认后回写 onChain=true
     * 每 10 秒查一次，最多查 30 次（5 分钟）
     */
    private void waitForConfirmation(Long assetId, String txHash) {
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(httpTimeoutSeconds, TimeUnit.SECONDS)
                .readTimeout(httpTimeoutSeconds, TimeUnit.SECONDS)
                .build();
        Web3j web3j = Web3j.build(new HttpService(rpcUrl, okHttpClient, false));
        try {
            for (int i = 0; i < 30; i++) {
                TimeUnit.SECONDS.sleep(10);
                EthGetTransactionReceipt receiptResp = web3j.ethGetTransactionReceipt(txHash).send();
                if (receiptResp.getTransactionReceipt().isPresent()) {
                    TransactionReceipt receipt = receiptResp.getTransactionReceipt().get();
                    // status "0x1" 表示成功
                    if ("0x1".equalsIgnoreCase(receipt.getStatus())) {
                        userDigitalAssetRepository.findById(assetId).ifPresent(asset -> {
                            asset.setOnChain(true);
                            userDigitalAssetRepository.save(asset);
                            log.info("[区块链] 资产 {} 已确认上链，区块: {}", assetId, receipt.getBlockNumber());
                        });
                    } else {
                        log.warn("[区块链] 资产 {} 交易失败，status={}", assetId, receipt.getStatus());
                    }
                    return;
                }
            }
            log.warn("[区块链] 资产 {} 等待确认超时（5分钟），txHash={}", assetId, txHash);
        } catch (Exception e) {
            log.warn("[区块链] 资产 {} 轮询确认异常: {}", assetId, e.getMessage());
        } finally {
            web3j.shutdown();
        }
    }

    private MintResult doMint(String toAddress, String tokenUri) {
        if (platformPrivateKey == null || platformPrivateKey.isBlank()) {
            throw new RuntimeException("平台私钥未配置，无法代用户上链");
        }

        String normalizedKey = platformPrivateKey.startsWith("0x") ? platformPrivateKey : "0x" + platformPrivateKey;
        String normalizedContractAddress = normalizeAddress(contractAddress, "合约地址");
        String normalizedToAddress = normalizeAddress(toAddress, "用户链地址");

        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(httpTimeoutSeconds, TimeUnit.SECONDS)
                .readTimeout(httpTimeoutSeconds, TimeUnit.SECONDS)
                .writeTimeout(httpTimeoutSeconds, TimeUnit.SECONDS)
                .build();
        Web3j web3j = Web3j.build(new HttpService(rpcUrl, okHttpClient, false));
        try {
            Credentials credentials = Credentials.create(normalizedKey);
            TransactionManager txManager = new RawTransactionManager(web3j, credentials, chainId);

            Function mintFunction = new Function(
                    "mint",
                    List.of(new Address(normalizedToAddress), new Utf8String(tokenUri)),
                    Collections.emptyList()
            );
            String data = FunctionEncoder.encode(mintFunction);

            EthSendTransaction txResponse = txManager.sendTransaction(
                    BigInteger.valueOf(gasPrice),
                    BigInteger.valueOf(gasLimit),
                    normalizedContractAddress,
                    data,
                    BigInteger.ZERO
            );

            if (txResponse.hasError()) {
                throw new RuntimeException("链上交易发送失败: " + txResponse.getError().getMessage());
            }

            String txHash = txResponse.getTransactionHash();

            MintResult result = new MintResult();
            result.setTxHash(txHash);
            result.setContractAddress(normalizedContractAddress);
            result.setChainName("Sepolia");
            result.setExplorerUrl("https://sepolia.etherscan.io/tx/" + txHash);
            result.setConfirmed(false);
            return result;
        } catch (Exception e) {
            throw new RuntimeException("上链铸造失败: " + e.getMessage(), e);
        } finally {
            web3j.shutdown();
        }
    }

    private String parseTokenId(List<Log> logs) {
        for (Log log : logs) {
            if (log.getTopics() == null || log.getTopics().size() < 4) continue;
            if (!TRANSFER_TOPIC.equalsIgnoreCase(log.getTopics().get(0))) continue;
            BigInteger tokenId = Numeric.toBigInt(log.getTopics().get(3));
            return tokenId.toString();
        }
        return "";
    }

    private String normalizeAddress(String address, String label) {
        if (address == null) {
            throw new RuntimeException(label + "为空");
        }
        String trimmed = address.trim();
        if (!trimmed.startsWith("0x")) {
            trimmed = "0x" + trimmed;
        }
        if (!WalletUtils.isValidAddress(trimmed)) {
            throw new RuntimeException(label + "格式错误: " + address);
        }
        return trimmed;
    }

    @Data
    public static class MintResult {
        private String tokenId;
        private String txHash;
        private String blockNumber;
        private String contractAddress;
        private String chainName;
        private String explorerUrl;
        private Boolean confirmed;
    }
}
