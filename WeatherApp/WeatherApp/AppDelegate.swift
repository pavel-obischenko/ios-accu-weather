//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit
import CoreLocation

import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let assembler = Assembler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIHelper.createWindow()
        
        assemble()
        start()
        
        return true
    }
    
    func start() {
        guard let mainController = UIHelper.loadInitialViewController(storyboardName: "Main") else {
            assertionFailure("Main View Controller Not Found!")
            return }
        UIHelper.changeRootViewControllerTo(controller: mainController)
    }
}

extension AppDelegate {
    func assemble() {
        assembler.apply(assemblies: [ModelAssembly()])
    }
}

