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

struct Crypto {
    private static let sodium = Sodium()
}

extension Crypto {
    private typealias CipherNonce = (authenticatedCipherText: Data, nonce: Nonce)

    static func generateKey() -> Key? {
        return sodium.secretBox.key()
    }

    static func encrypt(_ msg: String, key: Key) -> EncryptedMessage? {
        let data = Data(msg.utf8)
        guard let (cipher, nonce): CipherNonce = sodium.secretBox.seal(message: data, secretKey: key) else {
            return nil
        }

        let encodedMsg   = cipher.base64URLEncodedString()
        let encodedNonce = nonce.base64URLEncodedString()
        return EncryptedMessage(cipherText: encodedMsg, encodedNonce: encodedNonce)
    }

    static func decrypt(_ encrypted: EncryptedMessage, key: Key) -> DecryptedMessage? {
        guard let msgData   = Data(base64URLEncoded: encrypted.cipherText),
              let nonceData = Data(base64URLEncoded: encrypted.encodedNonce),
              let rawMsg    = sodium.secretBox.open(authenticatedCipherText: msgData, secretKey: key, nonce: nonceData),
              let plaintext = String.init(data: rawMsg, encoding: .utf8) else {
                return nil
        }
        return DecryptedMessage(plainText: plaintext)
    }
}
