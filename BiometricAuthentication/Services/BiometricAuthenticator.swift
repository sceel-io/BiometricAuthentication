//
//  AuthenticationProvider.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright © 2019 Sceel.io. All rights reserved.
//
import UIKit
import LocalAuthentication

enum AuthenticationState {
    case notAuthenticated
    case inProgress
    case authenticated
    case canceled
    
    func isAuthenticatable() -> Bool {
        return [AuthenticationState.notAuthenticated, .authenticated].contains(self)
    }
}

private enum Key {
    static let lastLoginDate = "lastLoginDate"
}

class BiometricAuthenticator {
    
    // MARK: - Private
    //1
    private(set) var state: AuthenticationState = .notAuthenticated
    //2
    private var context = LAContext()

    // MARK: - Public
    //3
    public var allowableReuseDuration: TimeInterval? = nil {
        didSet {
            guard let duration = allowableReuseDuration else {
                return
            }
            self.context.touchIDAuthenticationAllowableReuseDuration = duration
        }
    }
    //4
    var expireTime: TimeInterval = 0
    
}

// MARK:- Authenticator

extension BiometricAuthenticator: Authenticator {
    
    func canAuthenticate() -> Bool {
        var isBiometricAuthenticationAvailable = false
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isBiometricAuthenticationAvailable = (error == nil)
        }
        return isBiometricAuthenticationAvailable && state.isAuthenticatable()
    }
    
    func authenticateWithBioMetrics(reason: String = "", fallbackTitle: String? = "", cancelTitle: String? = "", completion: @escaping (Result<Bool, AuthenticationError>) -> Void) {
        //1
        let reasonString = reason.isEmpty ? defaultBiometricAuthenticationReason() : reason
        //2
        context.localizedFallbackTitle = fallbackTitle
        context.localizedCancelTitle = cancelTitle
        
        //3
        self.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
    }
    
    func authenticateWithPasscode(reason: String, cancelTitle: String? = "", completion: @escaping (Result<Bool, AuthenticationError>) -> ()) {
        //1
        let reasonString = reason.isEmpty ? defaultPasscodeAuthenticationReason() : reason
        
        //2
        context.localizedCancelTitle = cancelTitle
        
        //3
        if #available(iOS 9.0, *) {
            self.evaluate(policy: .deviceOwnerAuthentication, with: context, reason: reasonString, completion: completion)
        } else {
            self.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
        }
    }
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) && context.biometryType == .faceID
        }
        return false
    }
    
    func touchIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            return context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) && context.biometryType == .touchID
        }
        return false
    }
    
    func needReAuthentication() -> Bool {
        return state.isAuthenticatable() && isExpired()
    }
}

// MARK:- Private

extension BiometricAuthenticator {

    private func defaultBiometricAuthenticationReason() -> String {
        return faceIDAvailable() ? "Confirm your face to authenticate." : "Confirm your fingerprint to authenticate."
    }
    
    private func defaultPasscodeAuthenticationReason() -> String {
        return faceIDAvailable() ? "Face ID is locked now, because of too many failed attempts. Enter passcode to login." : "Touch ID is locked now, because of too many failed attempts. Enter passcode to login."
    }
    
    private func isReuseDurationSet() -> Bool {
        guard allowableReuseDuration != nil else {
            return false
        }
        return true
    }
    
    private func evaluate(policy: LAPolicy, with context: LAContext, reason: String, completion: @escaping (Result<Bool, AuthenticationError>) -> ()) {
        state = .inProgress
        context.evaluatePolicy(policy, localizedReason: reason) { [unowned self] (success, err) in
            DispatchQueue.main.async {
                if success {
                    self.state = .authenticated
                    self.setLastLoginDate()
                    completion(.success(success))
                } else {
                    guard let errorType = err as? LAError else {
                        completion(.failure(AuthenticationError(code: .systemCancel)))
                        return
                    }
                    let error = AuthenticationError(code: errorType.code)
                    self.state = error.isCanceled() ? .canceled : .notAuthenticated
                    if error.isCanceled() {
                        self.state = .canceled
                        self.cleanup()
                    } else if error.code == .userFallback {
                        self.evaluate(policy: .deviceOwnerAuthentication, with: context, reason: reason, completion: completion)
                        return
                    } else if error.code == .biometryLockout && policy != .deviceOwnerAuthentication {
                        self.state = .notAuthenticated
                        self.evaluate(policy: .deviceOwnerAuthentication, with: context, reason: reason, completion: completion)
                        return
                    } else {
                        self.state = .notAuthenticated
                    }
                    completion(.failure(error))
                }
                self.context = LAContext()
            }
        }
    }
    
    private func isExpired() -> Bool {
        var isExpired = false
        if expireTime == 0 {
            //if no expire time, but user allow reuse previous biometric login for some time interval
            return allowableReuseDuration != nil
        } else if let lastLoginDate = UserDefaults.standard.object(forKey: Key.lastLoginDate) as? Date {
            isExpired = Date().timeIntervalSince(lastLoginDate) > expireTime
        }
        return isExpired
    }
    
    private func cleanup() {
        UserDefaults.standard.set(nil, forKey: Key.lastLoginDate)
    }
    
    private func setLastLoginDate(_ date: Date? = Date()) {
        UserDefaults.standard.set(date, forKey: Key.lastLoginDate)
    }
}
