//
//  WTFTests.swift
//  WTF PerformanceTests
//

import XCTest
import Sodium

@testable import WTF_Performance

class WTFTests: XCTestCase {

    static let sodium = Sodium()
    static let key    = Crypto.generateKey()!

    private func randomData(_ bytes: Int) -> String {
        let data = WTFTests.sodium.randomBytes.buf(length: bytes)!
        return String(bytes: data.asciiMasked(), encoding: .utf8)!
    }

    private func encrypt(_ msg: String) -> EncryptedMessage {
        return Crypto.encrypt(msg, key: WTFTests.key)!
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
            // code to actually measure between start and stop

            self.stopMeasuring()

            // repeated tearDown code here
        }

        // one-time tearDown code here
    }

    // MARK: Encryption Tests

    func testEncrypt1B() {
        let msg = randomData(1)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt10B() {
        let msg = randomData(10)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt100B() {
        let msg = randomData(100)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt1KB() {
        let msg = randomData(1_000)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt10KB() {
        let msg = randomData(10_000)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt100KB() {
        let msg = randomData(100_000)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt1MB() {
        let msg = randomData(1_000_000)
        measure { self.runEncryption(msg) }
    }

    func testEncrypt10MB() {
        let msg = randomData(10_000_000)
        measure { self.runEncryption(msg) }
    }

    // MARK: Decryption Tests

    func testDecrypt1B() {
        let cipher = encrypt(randomData(1))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt10B() {
        let cipher = encrypt(randomData(10))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt100B() {
        let cipher = encrypt(randomData(100))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt1KB() {
        let cipher = encrypt(randomData(1_000))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt10KB() {
        let cipher = encrypt(randomData(10_000))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt100KB() {
        let cipher = encrypt(randomData(100_000))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt1MB() {
        let cipher = encrypt(randomData(1_000_000))
        measure { self.runDecryption(cipher) }
    }

    func testDecrypt10MB() {
        let cipher = encrypt(randomData(10_000_000))
        measure { self.runDecryption(cipher) }
    }
    
}

extension Data {
    // quick way to ensure that data can
    // be represented cleanly as a string
    func asciiMasked() -> Data {
        let maskedBytes = [UInt8](self).map { $0 & 127 }
        return Data(bytes: maskedBytes)
    }
}

