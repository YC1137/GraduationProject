/**
 * RSA 加密工具（使用 jsencrypt，兼容 HTTP 非 localhost 环境）
 * SubtleCrypto 只在 HTTPS/localhost 下可用，jsencrypt 无此限制。
 * 流程：GET /api/user/public-key → 缓存公钥 → 加密密码 → 传 encryptedPassword 字段
 */

import JSEncrypt from 'jsencrypt'
import request from '@/api/request'

let _cachedPublicKeyPem = null  // 缓存 PEM 格式公钥字符串

/**
 * 从后端获取公钥并转成 PEM 格式（自动缓存）
 */
async function getPublicKeyPem() {
    if (_cachedPublicKeyPem) return _cachedPublicKeyPem

    const res = await request.get('/user/public-key')
    // request.js 拦截器已解包，res 直接就是公钥 Base64 字符串
    const base64 = typeof res === 'string' ? res : (res.data ?? res)

    // jsencrypt 需要 PEM 格式（加上头尾）
    _cachedPublicKeyPem = `-----BEGIN PUBLIC KEY-----\n${base64}\n-----END PUBLIC KEY-----`
    return _cachedPublicKeyPem
}

/**
 * 用服务端RSA公钥加密明文（返回 Base64 密文字符串）
 * @param {string} plainText
 * @returns {Promise<string>}
 */
export async function rsaEncrypt(plainText) {
    const pem = await getPublicKeyPem()
    const encryptor = new JSEncrypt()
    encryptor.setPublicKey(pem)
    const result = encryptor.encrypt(plainText)
    if (!result) {
        throw new Error('RSA加密失败，请刷新页面重试')
    }
    return result
}

/**
 * 重置公钥缓存（后端重启后调用）
 */
export function resetPublicKeyCache() {
    _cachedPublicKeyPem = null
}

export default { rsaEncrypt, resetPublicKeyCache }
