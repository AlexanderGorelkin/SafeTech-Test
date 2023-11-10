//
//  AsymmetricCrypto.swift
//  SafeTechFramework
//
//  Created by Александр Горелкин on 10.11.2023.
//

import Security
import CryptoKit
import Foundation

class AsymmetricCrypto {
    static let shared = AsymmetricCrypto()
    private let privateKeyTag = "com.yourapp.privateKey"
    private let publicKeyTag = "com.yourapp.publicKey"
    
    private var privateKey: SecKey?
    private var publicKey: SecKey?
    
    private init() {
        loadKeys()
    }
    
    private func generateKeys() {
        let privateKeyAttributes: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048
        ]
        var error: Unmanaged<CFError>?
        guard let newPrivateKey = SecKeyCreateRandomKey(privateKeyAttributes as CFDictionary, &error),
              let newPublicKey = SecKeyCopyPublicKey(newPrivateKey) else {
            print("Error to create")
            return
        }
        privateKey = newPrivateKey
        publicKey = newPublicKey
        let resultPrivate = KeychainHelper.saveData(key: privateKey!, forTag: privateKeyTag)
        let resultPublic = KeychainHelper.saveData(key: publicKey!, forTag: publicKeyTag)
        if !resultPublic || !resultPrivate {
            print("Failed to saved data")
        }
    }
    private func loadKeys() {
        let privateKeyLoaded = KeychainHelper.loadData(forTag: privateKeyTag)
        let publicKeyLoaded = KeychainHelper.loadData(forTag: publicKeyTag)
        
        if privateKeyLoaded == nil || publicKeyLoaded == nil {
            generateKeys()
        }
    }
    
    func encryptString(message: String) throws -> Data? {
        guard let publicKey = publicKey else {
            print("Public key not available. Generate a key pair first.")
            return nil
        }
        
        guard let messageData = message.data(using: .utf8) else {
            print("Failed to convert message to data")
            return nil
        }
        let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA256, messageData as CFData, nil)
        return encryptedData as Data?
    }
    func decryptData(encryptedData: Data) throws -> String? {
        guard let privateKey = privateKey else {
            print("Private key not available. Generate a key pair first.")
            return nil
        }
        guard encryptedData.count == SecKeyGetBlockSize(privateKey) else {
            return ""
        }
        var error: Unmanaged<CFError>?
        guard let clearTextData = SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA256, encryptedData as CFData, &error) as Data? else {
            return ""
        }
        guard let clearText = String(data: clearTextData, encoding: .utf8) else { return ""}
        return clearText
    }
}

class KeychainHelper {
    static func saveData(key: SecKey, forTag tag: String) -> Bool {
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueRef as String: key]
        let status = SecItemAdd(addquery as CFDictionary, nil)
        print(status)
        return status == errSecSuccess
    }
    
    static func loadData(forTag tag: String) -> SecKey? {
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        ]
        
        var resultData: SecKey? = nil
        var result: AnyObject?
        let status = SecItemCopyMatching(getquery as CFDictionary, &result)
        if status == errSecSuccess {
            resultData = result as! SecKey
            return resultData!
        } else {
            return resultData!
        }
    }
}

