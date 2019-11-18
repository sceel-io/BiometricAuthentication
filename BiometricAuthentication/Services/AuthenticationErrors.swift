//
//  AuthenticationProvider.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright © 2019 Sceel.io. All rights reserved.
//

import Foundation
import LocalAuthentication

struct AuthenticationError: LocalizedError {
    var code: LAError.Code
    
    init(code: LAError.Code) {
        self.code = code
    }
    
    public var localizedDescription: String {
        switch self.code {
        case .authenticationFailed:
            return "Your biometric data was not recognized. Please try again"
        case .passcodeNotSet:
            return "Please set device passcode to use Biomertic for authentication."
        case .systemCancel:
            return "Biometric authentication was canceled by system"
        case .userCancel:
            return "Biometric authentication was canceled"
        case .biometryLockout:
            return "Biometric authentication is locked now, because of too many failed attempts. Enter passcode"
        case .biometryNotAvailable:
            return "Biometric authentication is not available for this device."
        case .biometryNotEnrolled:
            return "Biometric authentication is not enrolled for this device."
        default:
            return "Your biometric data was not recognized. Please try again"
        }
    }

}

extension AuthenticationError: Equatable {
    
}

extension AuthenticationError {
    func isCanceled() -> Bool {
        return [LAError.Code.userCancel, .appCancel, .systemCancel].contains(self.code)
    }
}
