//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 20.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

enum CoordinatorPolicy {
    case none, changeRoot, push(UINavigationController), showModal(UIViewController)
}

protocol Coordinator: class {
    func show<Params>(policy: CoordinatorPolicy, params: Params?, animated: Bool)
    func back<Result>(from coordinator: Coordinator, result: Result?, animated: Bool)
}

protocol CoordinatorRootHolder: class {
    func set(root coordinator: Coordinator)
}

protocol CoordinatorResult: class {
    func apply<Result>(result: Result)
}

class BaseCoordinator: Coordinator, CoordinatorResult {
    weak var root: CoordinatorRootHolder?
    weak var previous: CoordinatorResult?
    
    var next: Coordinator?
    
    var navigationController: UINavigationController?
    var viewController: UIViewController?
    
    var currentViewController: UIViewController? {
        return navigationController ?? viewController
    }
    var policy: CoordinatorPolicy = .none
    
    init(root: CoordinatorRootHolder?, previous: CoordinatorResult?) {
        self.root = root
        self.previous = previous
    }
    
    func show<Params>(policy: CoordinatorPolicy, params: Params?, animated: Bool) {
        guard let viewController = self.viewController else {
            fatalError("BaseCoordinator.show: viewController should not be nil")
        }
        
        setup(with: params)

        switch policy {
        case .changeRoot:
            guard let currentController = self.currentViewController else {
                fatalError("BaseCoordinator.show: currentController should not be nil")
            }
            
            UIHelper.changeRootViewControllerTo(controller: currentController, animated: animated)
            root?.set(root: self)
            
        case .push(let controller):
            navigationController = controller
            navigationController?.pushViewController(viewController, animated: animated)
            
        case .showModal(let controller):
            let modalNaviagationController = UINavigationController(rootViewController: viewController)
            controller.present(modalNaviagationController, animated: animated, completion: nil)
            
            navigationController = modalNaviagationController
        default: break
        }
    }
    
    func back<Result>(from coordinator: Coordinator, result: Result?, animated: Bool) {
        switch policy {
        case .push:
            navigationController?.popViewController(animated: animated)
            previous?.apply(result: result)
            
        case .showModal:
            navigationController?.dismiss(animated: animated, completion: nil)
            previous?.apply(result: result)
            
        default: fatalError("BaseCoordinator.back: Current policy doesn't support coming back")
        }
    }
    
    func setup<Params>(with params: Params) {}
    func apply<Result>(result: Result) {}
}

class RootCoordinator: BaseCoordinator, CoordinatorRootHolder {
    private(set) var window: UIWindow?
    
    init() {
        super.init(root: nil, previous: nil)
    }
    
    func setup() {
        window = UIHelper.createWindow()
    }
    
    func set(root coordinator: Coordinator) {
        next = coordinator
    }
}
