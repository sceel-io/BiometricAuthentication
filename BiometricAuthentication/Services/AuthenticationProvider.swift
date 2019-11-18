//
//  AuthenticationProvider.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright © 2019 Sceel.io. All rights reserved.
//

import Foundation

protocol Authenticator {
    func canAuthenticate() -> Bool
    func faceIDAvailable() -> Bool
    func touchIDAvailable() -> Bool
    
    func authenticateWithBioMetrics(reason: String, fallbackTitle: String?, cancelTitle: String?, completion: @escaping (Result<Bool, AuthenticationError>) -> Void)
    func authenticateWithPasscode(reason: String, cancelTitle: String?, completion: @escaping (Result<Bool, AuthenticationError>) -> ())
    
    func needReAuthentication() -> Bool
}

extension Authenticator {
    func needReAuthentication() -> Bool {
        return true
    }
}
