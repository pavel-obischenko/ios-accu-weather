//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 19.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewModel {
    var isLoading: Observable<Bool> { get }
    
    func start()
    func stop()
}

extension ViewModel {
    func start() {}
    func stop() {}
}

class BaseViewModel: ViewModel {
    var isLoading: Observable<Bool> = BehaviorSubject<Bool>(value: false)
}
