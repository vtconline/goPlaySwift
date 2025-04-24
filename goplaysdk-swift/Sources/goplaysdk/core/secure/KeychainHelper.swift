//
//  keychainHelper.swift
//  goplaysdk
//
//  Created by Ngô Đồng on 24/4/25.
//

import Foundation
import Security

class KeychainHelper {
    func clearSavedData() {
        // Clear username from UserDefaults
        UserDefaults.standard.removeObject(forKey: "savedUsername")
        
        // Clear password from Keychain
        if let _ = KeychainHelper.load(key: "savedPassword") {
            KeychainHelper.remove(key: "savedPassword")
        }
        
    }
    
    static func save(key: String, data: Data) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
    
    static func remove(key: String) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key
            ] as CFDictionary
            
            SecItemDelete(query) // Remove item from Keychain
        }
}
