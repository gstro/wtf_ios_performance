//
//  WTFCheckTests.swift
//  WTF PerformanceTests
//

import XCTest
import SwiftCheck
import Sodium

@testable import WTF_Performance

class WTFCheckTests: XCTestCase {
    let sodium = Sodium()

    func testBase64urlEncoding() {
        property("Base64url encoding for sodium should match manual") <- forAll { (data: Data) in
            let sodiumEncoded = Crypto.base64UrlEncode(data)
            let manualEncoded = data.base64URLEncodedString()
            print("sodium: \(sodiumEncoded!)\nmanual: \(manualEncoded)")
            return sodiumEncoded != nil && sodiumEncoded! == manualEncoded
        }
    }

    func testBase64urlDecoding() {
        property("Base64url decoding for sodium should match manual") <- forAll { (encoded: Base64UrlEncodedString) in
            let sodiumDecoded = Crypto.base64UrlDecode(encoded.value)
            let manualDecoded = Data(base64URLEncoded: encoded.value)
            print("string: \(encoded.value)\n  sodium: \(sodiumDecoded!)\n  manual: \(manualDecoded!)")
            return sodiumDecoded != nil && manualDecoded != nil && sodiumDecoded! == manualDecoded!
        }
    }

    func testCheckExamples() {
        property("String count match characters array count") <- forAll { (randomString: String) in
            print("Test string: \(randomString)\n")
            return randomString.count == [Character](randomString).count
        }
    }

    func testCheckShrinking() {
        property("String might fail?") <- forAll { (randomString: String) in
            print("Test string: \(randomString)\n")
            return randomString.isEmpty || functionThatFailsOnDigitsOrSymbols(randomString)
        }
    }

}


extension Data: Arbitrary {
    public static var arbitrary: Gen<Data> {
        return [UInt8].arbitrary.flatMap { bytes in
            return Gen<Data>.pure(Data(bytes: bytes))
        }
    }
}

extension EncryptedMessage: Arbitrary {
    public static var arbitrary: Gen<EncryptedMessage> {
        return Gen<EncryptedMessage>.compose { c in
            return EncryptedMessage(cipherText: c.generate(), encodedNonce: c.generate())
        }
    }
}

struct Base64UrlEncodedString: Arbitrary {
    let value: String

    static var arbitrary: Gen<Base64UrlEncodedString> {
        return Data.arbitrary.flatMap { data in
            let manual = data.base64URLEncodedString()
            return Gen<Base64UrlEncodedString>.pure(Base64UrlEncodedString(value: manual))
        }
    }
}


// artificial function to simulate failure
func functionThatFailsOnDigitsOrSymbols(_ str: String) -> Bool {
    return !CharacterSet
        .decimalDigits
        .union(.symbols)
        .contains(str.unicodeScalars.first!)
}
