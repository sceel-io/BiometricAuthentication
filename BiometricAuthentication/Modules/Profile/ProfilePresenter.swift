//
//  ProfilePresenter.swift
//  FiftyCents
//
//  Created by Roman Huti on 10/23/19.
//  Copyright (c) 2019 Roman Huti. All rights reserved.
//

import UIKit

final class ProfilePresenter {

    // MARK: - Properties

    private unowned let view: ProfileViewInterface
    private let interactor: ProfileInteractorInterface
    private let wireframe: ProfileWireframeInterface

    // MARK: - Lifecycle

    init(view: ProfileViewInterface, interactor: ProfileInteractorInterface, wireframe: ProfileWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - ProfilePresenterInterface

extension ProfilePresenter: ProfilePresenterInterface {
}
