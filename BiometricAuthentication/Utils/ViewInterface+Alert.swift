//
//  ViewInterface.swift
//  FiftyCents
//
//  Created by Roman Huti on 11/4/19.
//  Copyright © 2019 Sceel.io. All rights reserved.
//

import UIKit

extension ViewInterface {
    
    func showAlert(_ title: String = "Error", _ message: String = "Unknown hapened", _ buttonHandler:(() -> Void)?) {
        guard let viewController = self as? UIViewController else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            buttonHandler?()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
