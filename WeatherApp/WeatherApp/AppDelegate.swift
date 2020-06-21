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
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let assembler = Assembler()
    let appCoordinator = AppCoordinator()
    
    var dataStorage: DataStorage?
    
//    var disposeBag = DisposeBag()
//    var gs: GeolocationService?
//    var fs: ForecastService?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        assemble()
        construct()
        start()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        dataStorage?.save()
    }
}

extension AppDelegate {
    func assemble() {
        assembler.apply(assemblies: [ModelAssembly()])
    }
    
    func construct() {
        appCoordinator.setup()
        dataStorage = assembler.resolver.resolve(DataStorage.self)
    }
    
    func start() {
        appCoordinator.start()
//        guard let mainController = UIHelper.loadInitialViewController(storyboardName: "Main") else {
//            assertionFailure("Main View Controller Not Found!")
//            return }
//        UIHelper.changeRootViewControllerTo(controller: mainController, animated: false)
        
//        gs = assembler.resolver.resolve(GeolocationService.self)
//        gs?.searchCurrentFor(latitude: 48.125, longitude: 37.851)
//
//        gs?.currentCity?.subscribe({ (event) in
//            debugPrint(event.element as Any)
//        }).disposed(by: disposeBag)
        
//        fs = assembler.resolver.resolve(ForecastService.self)
//        fs?.currentConditions(for: "322772")
//
//        fs?.currentConditions.subscribe({ (event) in
//            debugPrint(event.element as Any)
//        }).disposed(by: disposeBag)
    }
    
    
}

