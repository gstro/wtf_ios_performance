//
//  ViewController.swift
//  WTF Performance
//

import UIKit

class ViewController: UIViewController {
    private enum CryptoOp: Int {
        case decrypt, encrypt
    }

    // generate secret key on each launch
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
        DispatchQueue.global().async {
            let text = try? String(contentsOfFile: filepath)
            DispatchQueue.main.async {
                self.textView.text = text
            }
        }
    }

    // MARK: Crypto Operations

    private func encrypt() {
        guard let text = textView.text,
              !text.isEmpty,
              let key = secretKey
            else { return print("Failed to encrypt") }

        DispatchQueue.global().async {
            self.encrypted = Crypto.encrypt(text, key: key)
            DispatchQueue.main.async {
                self.textView.text = "Encrypted!"
            }
        }
    }

    private func decrypt() {
        guard let encMsg = encrypted,
              let key = secretKey
            else { return print("Failed to decrypt") }

        DispatchQueue.global().async {
            self.decrypted = Crypto.decrypt(encMsg, key: key)
            DispatchQueue.main.async {
                self.textView.text = self.decrypted?.plainText
            }
        }
    }

}
