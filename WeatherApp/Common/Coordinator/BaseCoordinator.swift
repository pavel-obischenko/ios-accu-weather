//
//  BaseCoordinator.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 23.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator, CoordinatorResult {
    weak var rootSetter: CoordinatorRootSetter?
    weak var resultReceiver: CoordinatorResult?
    var next: Coordinator?
    
    var navigationController: UINavigationController?
    var viewController: UIViewController?
    
    var policy: CoordinatorPolicy = .none
    
    init(root setter: CoordinatorRootSetter?, result receiver: CoordinatorResult?) {
        rootSetter = setter
        resultReceiver = receiver
    }
    
    func setup<Params>(with params: Params) {}
    
    func changeRoot(viewController: UIViewController, animated: Bool) {
        UIHelper.changeRootViewControllerTo(controller: viewController, animated: animated)
    }
    
    func push(viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showModal(viewController: UIViewController, in presentingController: UIViewController, animated: Bool) {
        presentingController.present(viewController, animated: animated, completion: nil)
    }
}

// MARK: CoordinatorResult protocol methods implementation
extension BaseCoordinator {
    func apply<AppliedResult>(result: AppliedResult) {}
}

// MARK: Coordinator protocol methods implementation
extension BaseCoordinator {
    func show<Params>(policy: CoordinatorPolicy, params: Params?, animated: Bool) {
        guard let viewController = self.viewController else {
            fatalError("BaseCoordinator.show: viewController should not be nil")
        }
        
        setup(with: params)

        switch policy {
        case .changeRoot:
            let controller = UINavigationController(rootViewController: viewController)
            navigationController = controller
            
            changeRoot(viewController: controller, animated: animated)
            rootSetter?.set(root: self)
            
        case .push(let controller):
            navigationController = controller
            push(viewController: viewController, animated: animated)
            
        case .showModal(let presentingController):
            let controllerToPresent = UINavigationController(rootViewController: viewController)
            navigationController = controllerToPresent
            
            showModal(viewController: controllerToPresent, in: presentingController, animated: animated)
            
        default: break
        }
    }
    
    func back<Result>(from coordinator: Coordinator, result: Result?, animated: Bool) {
        switch policy {
        case .push:
            navigationController?.popViewController(animated: animated)
            resultReceiver?.apply(result: result)
            
        case .showModal:
            navigationController?.dismiss(animated: animated, completion: nil)
            resultReceiver?.apply(result: result)
            
        default: fatalError("BaseCoordinator.back: Current policy doesn't support coming back")
        }
    }
}
