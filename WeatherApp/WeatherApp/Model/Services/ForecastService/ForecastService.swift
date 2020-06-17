//
//  ForecastService.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 26.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import RxSwift

class ForecastService: Service {
    private var storedConditions = BehaviorSubject<CurrentConditions?>(value: nil)
    
    var currentConditions: Observable<CurrentConditions> {
        return storedConditions.compactMap { $0 }
    }
    
    func currentConditions(for locationKey: String) {
        guard let url = URL(string: locationKey, relativeTo: URL.currentConditions) else { fatalError("ForecastService.currentConditions: Unable to create url") }
        
        network.GET(url, body: nil, headers: nil) { [weak self] (current: [CurrentConditions]?, error) in
            self?.storedConditions.onNext(current?.first)
            
            if let error = error {
                self?.storedConditions.onError(error)
            }
        }
    }
    
    func today() {
        
    }
}
