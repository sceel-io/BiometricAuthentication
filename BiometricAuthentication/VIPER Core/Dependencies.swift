//
//  Dependencies.swift
//  Fotosuche
//
//  Created by Roman Huti on 7/12/19.
//  Copyright © 2019 Sceel.io. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
protocol Dependencies {
    var authenticator: Authenticator { get set }
}
