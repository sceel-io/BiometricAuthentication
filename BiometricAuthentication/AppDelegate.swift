//
//  AppDelegate.swift
//  BiometricAuth
//
//  Created by Roman Huti on 11/7/19.
//  Copyright © 2019 Sceel.io. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var dependencies: Dependencies!
    var window: UIWindow?
    
    private var navigationController: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupDependencies()
        setupEntryScreen()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if dependencies.authenticator.canAuthenticate() && dependencies.authenticator.needReAuthentication() {
            let top = topViewController()
            let isLogin = top?.isKind(of: LoginViewController.self) ?? true
            if !isLogin {
                top?.present(loginController(), animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Private methods

extension AppDelegate {

    private func setupDependencies() {
        dependencies = StackDependencies()
        
        let authenticator = BiometricAuthenticator()
        authenticator.expireTime = 15
        authenticator.allowableReuseDuration = 10
        dependencies.authenticator = authenticator
        
        navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
    }
    
    private func setupEntryScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let login = LoginWireframe(dependencies: dependencies)
        navigationController.setRootWireframe(login)
        
    }

    private func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    private func loginController() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        let login = LoginWireframe(dependencies: dependencies, loginType: .reLogin)
        navigationController.setRootWireframe(login)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}
