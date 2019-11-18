//
//  LoginWireframe.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

enum LoginNavigationOption {
    case mainTabBar
    case dismiss
}

enum LoginAttemptType {
    case first
    case reLogin
}

final class LoginWireframe: BaseWireframe {

    // MARK: - Properties

    private let storyboard = UIStoryboard(name: "Login", bundle: nil)

    // MARK: - Module setup

    init(dependencies: Dependencies, loginType: LoginAttemptType = .first) {
        let moduleViewController = storyboard.instantiateViewController(ofType: LoginViewController.self)
        super.init(dependencies: dependencies, viewController: moduleViewController)
        
        let interactor = LoginInteractor(authenticator: dependencies.authenticator)
        let presenter = LoginPresenter(view: moduleViewController, interactor: interactor, wireframe: self, loginAttempt: loginType)
        
        interactor.output = presenter
        moduleViewController.presenter = presenter
    }

}


// MARK: - LoginWireframeInterface

extension LoginWireframe: LoginWireframeInterface {
    
    func navigate(to option: LoginNavigationOption) {
        switch option {
        case .mainTabBar:
            let profile = ProfileWireframe(dependencies: dependencies)
            pushWireframe(profile)
            return
        case .dismiss:
            viewController.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
