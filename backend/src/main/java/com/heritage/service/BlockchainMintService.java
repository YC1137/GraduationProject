package com.heritage.service;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.web3j.abi.FunctionEncoder;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.Function;
import okhttp3.OkHttpClient;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.core.methods.response.Log;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.RawTransactionManager;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.response.PollingTransactionReceiptProcessor;
import org.web3j.tx.response.TransactionReceiptProcessor;
import org.web3j.utils.Numeric;

import java.math.BigInteger;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class BlockchainMintService {

    private static final String TRANSFER_TOPIC = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";

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

    @Value("${blockchain.http-timeout-seconds:60}")
    private Long httpTimeoutSeconds;

    @Value("${blockchain.receipt-poll-interval-ms:1500}")
    private Long receiptPollIntervalMs;

    @Value("${blockchain.receipt-poll-attempts:80}")
    private Integer receiptPollAttempts;

    @Value("${blockchain.platform-private-key}")
    private String platformPrivateKey;

    public MintResult mintToAddress(String toAddress, String tokenUri) {
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

            try {
                TransactionReceiptProcessor receiptProcessor = new PollingTransactionReceiptProcessor(web3j, receiptPollIntervalMs, receiptPollAttempts);
                TransactionReceipt receipt = receiptProcessor.waitForTransactionReceipt(txHash);
                result.setBlockNumber(receipt.getBlockNumber().toString());
                result.setTokenId(parseTokenId(receipt.getLogs()));
                result.setConfirmed(true);
            } catch (Exception receiptException) {
                String msg = receiptException.getMessage() == null ? "" : receiptException.getMessage().toLowerCase();
                if (!msg.contains("timeout")) {
                    throw receiptException;
                }
            }

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
