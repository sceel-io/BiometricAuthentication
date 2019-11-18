//
//  LoginInterfaces.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

enum LoginType {
    case touchID
    case faceID
    case unknown
}

protocol LoginWireframeInterface: WireframeInterface {
    
    func navigate(to option: LoginNavigationOption)
}

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    func viewDidAppear()
    func login()
    func availableLoginType() -> LoginType
}

protocol LoginInteractorInterface: InteractorInterface {
    func login()
    func availableLoginType() -> LoginType
}

protocol LoginInteractorOutput: class {
    func didAuthenticationFailed(_ error: AuthenticationError)
    func didAuthenticationSucceded()
}
