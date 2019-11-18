//
//  ProfileViewController.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    var presenter: ProfilePresenterInterface!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
}

// MARK: - ProfileViewInterface

extension ProfileViewController: ProfileViewInterface {
}
