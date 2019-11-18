import UIKit

protocol WireframeInterface: class {
    func dismiss(animated: Bool)
    func addChild(_ child: UIViewController)
    func removeChild(_ child: UIViewController)
}

class BaseWireframe {

    private unowned var _viewController: UIViewController
    
    var dependencies: Dependencies
    
    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: UIViewController?

    init(dependencies: Dependencies, viewController: UIViewController) {
        self.dependencies = dependencies
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        navigationController?.pushWireframe(wireframe, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        viewController.presentWireframe(wireframe, animated: animated)
    }
    
    func dismissMe(animated: Bool = true) {
        viewController.presentingViewController?.dismiss(animated: animated, completion: nil)
    }
    
    func dismiss(animated: Bool = true) {
        viewController.dismiss(animated: animated, completion: nil)
    }
    
    func addChild(_ child: UIViewController) {
        viewController.view.addSubview(child.view)
        viewController.addChild(child)
        child.didMove(toParent: viewController)
    }
    
    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

}

extension BaseWireframe {
    
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
}

extension UIViewController {
    
    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(wireframe.viewController, animated: animated, completion: completion)
    }
    
}

extension UINavigationController {
    
    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.pushViewController(wireframe.viewController, animated: animated)
    }
    
    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        self.setViewControllers([wireframe.viewController], animated: animated)
    }
    
}
