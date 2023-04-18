//
//  Constants.swift
//  ImageFeed
//
//  Created by Andrei on 29.01.2023.
//

import Foundation

enum Constants {
    static let accessKey = "XirHst7O-9XCZTZLyvRuiSpbpRLiqs8aIqwwYOTv5d4"
    static let secretKey = "DQRLVOUF8i8ue9ul_KWgU0qIYSnW4ak0tulO8aVYGDA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"//b
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let tokenURLString = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.unsplashAuthorizeURLString
                                 )
    }
}
