//
//  ProfileWireframe.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

enum ProfileNavigationOption {
//    case <#code#>
}

final class ProfileWireframe: BaseWireframe {

    // MARK: - Properties

    private let storyboard = UIStoryboard(name: "Profile", bundle: nil)

    // MARK: - Module setup

    init(dependencies: Dependencies) {
        let moduleViewController = storyboard.instantiateViewController(ofType: ProfileViewController.self)
        super.init(dependencies: dependencies, viewController: moduleViewController)
        
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }

}


// MARK: - ProfileWireframeInterface

extension ProfileWireframe: ProfileWireframeInterface {
    
    func navigate(to option: ProfileNavigationOption) {
//        switch option {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
    }
}
