//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 20.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

class AppCoordinator: RootCoordinator {
    func start() {
        let startCoordinator = StartCoordinator(root: self, previous: nil)

        startCoordinator.show(policy: .changeRoot, params: 0, animated: false)
    }
}
