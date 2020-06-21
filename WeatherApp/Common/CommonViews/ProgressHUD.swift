//
//  ProgressHUD.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 19.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import UIKit

protocol ProgressHUD {
    func show(for viewController: UIViewController?)
    func hide()
}
