//
//  UIHelper.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 10.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

class UIHelper {
    static func createWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        return window
    }
    
    static public func changeRootViewControllerTo(controller: UIViewController) {
        changeRootViewControllerTo(controller: controller, completion: nil)
    }
    
    static public func changeRootViewControllerTo(controller: UIViewController, completion: (() -> Void)?) {
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
    
    static func loadInitialViewController(storyboardName: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil);
        return storyboard.instantiateInitialViewController()
    }
    
    static func loadViewController(controllerName: String, storyboardName: String) -> Any? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil);
        return storyboard.instantiateViewController(withIdentifier: controllerName)
    }
}
