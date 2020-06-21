//
//  StartCoordinator.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 20.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit


class StartCoordinator: BaseCoordinator {
    var startViewController: StartViewController
    var startViewModel: StartViewModel
    
    override init(root: CoordinatorRootHolder?, previous: CoordinatorResult?) {
        startViewController = UIHelper.loadViewController(controllerName: "StartViewController", storyboardName: "StartFlow") as! StartViewController
        
        startViewModel = StartViewModel()
        startViewController.viewModel = startViewModel
        
        let startBinder = StartBinder(view: startViewController, viewModel: startViewModel)
        startViewController.binder = startBinder
        
        super.init(root: root, previous: nil)
        viewController = startViewController
        navigationController?.viewControllers = [startViewController]
    }
}
