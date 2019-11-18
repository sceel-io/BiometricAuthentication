//
//  LoginPresenter.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

final class LoginPresenter {

    // MARK: - Properties

    private unowned let view: LoginViewInterface
    private let interactor: LoginInteractorInterface
    private let wireframe: LoginWireframeInterface
    private(set) var loginAttempt: LoginAttemptType
    
    // MARK: - Lifecycle

    init(view: LoginViewInterface, interactor: LoginInteractorInterface, wireframe: LoginWireframeInterface, loginAttempt: LoginAttemptType) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.loginAttempt = loginAttempt
    }
}

// MARK: - LoginPresenterInterface

extension LoginPresenter: LoginPresenterInterface {

    func availableLoginType() -> LoginType {
        return interactor.availableLoginType()
    }
    
    func login() {
        interactor.login()
    }
    
    func viewDidAppear() {
        interactor.login()
    }

}

extension LoginPresenter: LoginInteractorOutput {
    
    func didAuthenticationFailed(_ error: AuthenticationError) {
        view.showAlert("Error", error.localizedDescription, nil)
    }
    
    func didAuthenticationSucceded() {
        switch loginAttempt {
        case .first:
            wireframe.navigate(to: .mainTabBar)
        default:
            wireframe.navigate(to: .dismiss)
        }
        
    }
    
}
