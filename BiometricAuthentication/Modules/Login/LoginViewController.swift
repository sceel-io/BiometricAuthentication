//
//  LoginViewController.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: - Properties

    var presenter: LoginPresenterInterface!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
	
    @IBAction func loginAction(_ sender: Any) {
        presenter.login()
    }
    
    private func configureUI() {
        var image:String = ""
        
        switch presenter.availableLoginType() {
        case .faceID:
            image = "faceID"
        case .touchID:
            image = "touchID"
        default:
            image = "none"
        }

        loginButton.setImage(UIImage(named: image), for: .normal)
    }
    
}

// MARK: - LoginViewInterface

extension LoginViewController: LoginViewInterface {
}
