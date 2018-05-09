//
//  WTFTests.swift
//  WTF PerformanceTests
//

import XCTest
import Sodium

@testable import WTF_Performance

class WTFTests: XCTestCase {

    static var msg1B: String!
    static var msg10B: String!
    static var msg100B: String!
    static var msg1KB: String!
    static var msg10KB: String!
    static var msg100KB: String!
    static var msg1MB: String!
    static var msg10MB: String!
    static var msg100MB: String!

    static var enc1B: EncryptedMessage!
    static var enc10B: EncryptedMessage!
    static var enc100B: EncryptedMessage!
    static var enc1KB: EncryptedMessage!
    static var enc10KB: EncryptedMessage!
    static var enc100KB: EncryptedMessage!
    static var enc1MB: EncryptedMessage!
    static var enc10MB: EncryptedMessage!
    static var enc100MB: EncryptedMessage!

    static let sodium = Sodium()
    static let key    = Crypto.generateKey()!

    static func randomData(_ bytes: Int) -> String {
        let data = WTFTests.sodium.randomBytes.buf(length: bytes)!
        return String(bytes: data.asciiMasked(), encoding: .utf8)!
    }

    static func encrypt(_ msg: String) -> EncryptedMessage {
        return Crypto.encrypt(msg, key: WTFTests.key)!
    }

    override class func setUp() {
        super.setUp()

        msg1B    = randomData(1)
        msg10B   = randomData(10)
        msg100B  = randomData(100)
        msg1KB   = randomData(1_000)
        msg10KB  = randomData(10_000)
        msg100KB = randomData(100_000)
        msg1MB   = randomData(1_000_000)
        msg10MB  = randomData(10_000_000)
        msg100MB = randomData(100_000_000)

        enc1B    = encrypt(msg1B)
        enc10B   = encrypt(msg10B)
        enc100B  = encrypt(msg100B)
        enc1KB   = encrypt(msg1KB)
        enc10KB  = encrypt(msg10KB)
        enc100KB = encrypt(msg100KB)
        enc1MB   = encrypt(msg1MB)
        enc10MB  = encrypt(msg10MB)
        enc100MB = encrypt(msg100MB)
    }

    func runEncryption(_ msg: String) {
        _ = Crypto.encrypt(msg, key: WTFTests.key)
    }

    func runDecryption(_ enc: EncryptedMessage) {
        _ = Crypto.decrypt(enc, key: WTFTests.key)
    }

    // MARK: Setup and Teardown Examples

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testPerformanceExample() {
        // one-time setup code here

        self.measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            // repeated setup code here

            self.startMeasuring()
            // code to actually measure here

            self.stopMeasuring()

            // repeated tearDown code here
        }

        // one-time tearDown code here
    }

    // MARK: Encryption Tests

    func testEncrypt1B() {
        measure { self.runEncryption(WTFTests.msg1B) }
    }

    func testEncrypt10B() {
        measure { self.runEncryption(WTFTests.msg10B) }
    }

    func testEncrypt100B() {
        measure { self.runEncryption(WTFTests.msg100B) }
    }

    func testEncrypt1KB() {
        measure { self.runEncryption(WTFTests.msg1KB) }
    }

    func testEncrypt10KB() {
        measure { self.runEncryption(WTFTests.msg10KB) }
    }

    func testEncrypt100KB() {
        measure { self.runEncryption(WTFTests.msg100KB) }
    }

    func testEncrypt1MB() {
        measure { self.runEncryption(WTFTests.msg1MB) }
    }

    func testEncrypt10MB() {
        measure { self.runEncryption(WTFTests.msg10MB) }
    }

    func testEncrypt100MB() {
        measure { self.runEncryption(WTFTests.msg100MB) }
    }

    // MARK: Decryption Tests

    func testDecrypt1B() {
        measure { self.runDecryption(WTFTests.enc1B) }
    }

    func testDecrypt10B() {
        measure { self.runDecryption(WTFTests.enc10B) }
    }

    func testDecrypt100B() {
        measure { self.runDecryption(WTFTests.enc100B) }
    }

    func testDecrypt1KB() {
        measure { self.runDecryption(WTFTests.enc1KB) }
    }

    func testDecrypt10KB() {
        measure { self.runDecryption(WTFTests.enc10KB) }
    }

    func testDecrypt100KB() {
        measure { self.runDecryption(WTFTests.enc100KB) }
    }

    func testDecrypt1MB() {
        measure { self.runDecryption(WTFTests.enc1MB) }
    }

    func testDecrypt10MB() {
        measure { self.runDecryption(WTFTests.enc10MB) }
    }

    func testDecrypt100MB() {
        measure { self.runDecryption(WTFTests.enc100MB) }
    }
    
}

extension Data {
    func asciiMasked() -> Data {
        let maskedBytes = [UInt8](self).map { $0 & 127 }
        return Data(bytes: maskedBytes)
    }
}

