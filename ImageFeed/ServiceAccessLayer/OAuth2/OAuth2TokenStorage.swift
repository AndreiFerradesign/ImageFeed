//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrei on 29.01.2023.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
     enum Keys: String {
        case bearerToken
    }
    
    private let keychain = KeychainWrapper.standard
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            keychain.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: Keys.bearerToken.rawValue)
            } else {
                keychain.removeObject(forKey: Keys.bearerToken.rawValue)
            }
        }
    }
}
