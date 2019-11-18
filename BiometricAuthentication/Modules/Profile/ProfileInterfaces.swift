//
//  ProfileInterfaces.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

protocol ProfileWireframeInterface: WireframeInterface {
    
    func navigate(to option: ProfileNavigationOption)
}

protocol ProfileViewInterface: ViewInterface {
}

protocol ProfilePresenterInterface: PresenterInterface {
}

protocol ProfileInteractorInterface: InteractorInterface {
}
