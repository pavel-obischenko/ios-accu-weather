//
//  RootCoordinator.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 23.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

class RootCoordinator: BaseCoordinator, CoordinatorRootSetter {
    private(set) var window: UIWindow?
    
    init() {
        super.init(root: nil, result: nil)
    }
    
    func setup() {
        window = UIHelper.createWindow()
    }
    
    func set(root coordinator: Coordinator) {
        next = coordinator
    }
}
