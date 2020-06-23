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

protocol CoordinatorRootSetter: class {
    func set(root coordinator: Coordinator)
}

protocol CoordinatorResult: class {
    func apply<AppliedResult>(result: AppliedResult)
}
