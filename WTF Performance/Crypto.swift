//
//  Crypto.swift
//  WTF Performance
//

import Foundation
import Sodium

typealias Key   = SecretBox.Key
typealias Nonce = SecretBox.Nonce

struct EncryptedMessage {
    let cipherText: String
    let encodedNonce: String
}

struct DecryptedMessage {
    let plainText: String
}

enum Crypto {
    fileprivate static let sodium = Sodium()
}

extension Crypto {
    private typealias CipherNonce = (authenticatedCipherText: Data, nonce: Nonce)

    static func generateKey() -> Key? {
        return sodium.secretBox.key()
    }

    static func encrypt(_ msg: String, key: Key) -> EncryptedMessage? {
        guard let messageData  = msg.data(using: .utf8),
              let (cipher, nonce): CipherNonce = sodium.secretBox.seal(message: messageData, secretKey: key),
              let encodedMsg   = base64UrlEncode(cipher),
              let encodedNonce = base64UrlEncode(nonce)
            else { return nil }

        return EncryptedMessage(cipherText: encodedMsg, encodedNonce: encodedNonce)
    }

    static func decrypt(_ encrypted: EncryptedMessage, key: Key) -> DecryptedMessage? {
        guard let msgData   = base64UrlDecode(encrypted.cipherText),
              let nonceData = base64UrlDecode(encrypted.encodedNonce),
              let rawMsg    = sodium.secretBox.open(authenticatedCipherText: msgData, secretKey: key, nonce: nonceData),
              let plaintext = String(data: rawMsg, encoding: .utf8)
            else { return nil }

        return DecryptedMessage(plainText: plaintext)
    }

}

fileprivate let variant: Utils.Base64Variant = .URLSAFE

extension Crypto {

    static func base64UrlEncode(_ data: Data) -> String? {
        return sodium.utils.bin2base64(data, variant: variant)
    }

    static func base64UrlDecode(_ string: String) -> Data? {
        return sodium.utils.base642bin(string, variant: variant)
    }

}
