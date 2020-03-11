//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var service = LocationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIHelper.createWindow()

        guard let mainController = UIHelper.loadInitialViewController(storiboardName: "Main") else { return false }
        UIHelper.changeRootViewControllerTo(controller: mainController)
        
        service.requestPermission().start().onUpdate { (ls) in
            debugPrint("onUpdate: " + "\(String(describing: ls?.currentLocation))")
        }
        
        return true
    }
}

