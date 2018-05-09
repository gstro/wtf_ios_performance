//
//  ViewController.swift
//  WTF Performance
//

import UIKit
import Sodium

class ViewController: UIViewController {
    private enum CryptoOp: Int {
        case decrypt, encrypt
    }

    private let secretKey = Crypto.generateKey()

    private var encrypted: EncryptedMessage?
    private var decrypted: DecryptedMessage?

    @IBOutlet weak var textView: UITextView!

    // MARK: User Actions

    @IBAction func cryptoOperation(_ sender: UISegmentedControl) {
        switch CryptoOp(rawValue: sender.selectedSegmentIndex) {
        case .decrypt?:
            decrypt()
        case .encrypt?:
            encrypt()
        default:
            return
        }
    }

    @IBAction func loadText(_ sender: Any) {
        guard let filepath = Bundle.main.path(forResource: "passwords", ofType: "txt") else { return }
        textView.text = try? String(contentsOfFile: filepath)
    }

    // MARK: Crypto Operations

    private func encrypt() {
        guard !textView.text.isEmpty,
            let key = secretKey
            else { return print("Failed to encrypt") }

        encrypted = Crypto.encrypt(textView.text, key: key)
        textView.text = "Encrypted!"
    }

    private func decrypt() {
        guard let encMsg = encrypted,
            let key = secretKey
            else { return print("Failed to decrypt") }

        decrypted = Crypto.decrypt(encMsg, key: key)
        textView.text = decrypted?.plainText
    }

}
