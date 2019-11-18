//
//  LoginInteractor.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import Foundation

final class LoginInteractor {
    var authenticator: Authenticator!
    weak var output: LoginInteractorOutput?
    
    init(authenticator: Authenticator) {
        self.authenticator = authenticator
    }
}

// MARK: - Extensions

extension LoginInteractor: LoginInteractorInterface {
    
    func login() {
        authenticator.authenticateWithBioMetrics(reason: "", fallbackTitle: nil, cancelTitle: nil) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success( _):
                self.output?.didAuthenticationSucceded()
            case .failure(let error):
                self.output?.didAuthenticationFailed(error)
            }
        }
    }
    
    func availableLoginType() -> LoginType {
        if authenticator.touchIDAvailable() {
            return .touchID
        } else if authenticator.faceIDAvailable() {
            return .faceID
        } else {
            return .unknown
        }
    }
}
