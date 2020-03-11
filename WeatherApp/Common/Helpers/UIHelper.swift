//
//  UIHelper.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 10.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

class UIHelper {
    class func createWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        return window
    }
    
    class public func changeRootViewControllerTo(controller: UIViewController) {
        changeRootViewControllerTo(controller: controller, completion: nil)
    }
    
    class public func changeRootViewControllerTo(controller: UIViewController, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else {
            completion?()
            return
        }
        
        if window.rootViewController != nil {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = controller
                UIView.setAnimationsEnabled(oldState)
            }, completion: { [completion] completed in
                if completion != nil {
                    completion!()
                }
            })
        }
        else {
            window.rootViewController = controller
        }
    }
    
    class func loadInitialViewController(storiboardName: String) -> UIViewController? {
        let storiboard = UIStoryboard(name: storiboardName, bundle: nil);
        return storiboard.instantiateInitialViewController()
    }
    
    class func loadViewController(controllerName: String, storiboardName: String) -> Any? {
        let storiboard = UIStoryboard(name: storiboardName, bundle: nil);
        return storiboard.instantiateViewController(withIdentifier: controllerName)
    }
}
