package com.heritage.util;

import org.springframework.stereotype.Component;

import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import javax.crypto.Cipher;

/**
 * RSA 密钥管理与解密工具
 * 启动时自动生成2048位RSA密钥对，内存持有，重启后刷新。
 */
@Component
public class RsaKeyService {

    private final PrivateKey privateKey;
    private final String publicKeyBase64;

    public RsaKeyService() throws NoSuchAlgorithmException {
        KeyPairGenerator gen = KeyPairGenerator.getInstance("RSA");
        gen.initialize(2048);
        KeyPair pair = gen.generateKeyPair();
        this.privateKey = pair.getPrivate();
        this.publicKeyBase64 = Base64.getEncoder().encodeToString(pair.getPublic().getEncoded());
    }

    /** 返回Base64编码的公钥（前端用） */
    public String getPublicKeyBase64() {
        return publicKeyBase64;
    }

    /**
     * 用私钥解密前端加密的密文（Base64字符串）
     */
    public String decrypt(String cipherTextBase64) {
        try {
            byte[] cipherBytes = Base64.getDecoder().decode(cipherTextBase64);
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            return new String(cipher.doFinal(cipherBytes), "UTF-8");
        } catch (Exception e) {
            throw new RuntimeException("密码解密失败，请重新登录", e);
        }
    }
}
