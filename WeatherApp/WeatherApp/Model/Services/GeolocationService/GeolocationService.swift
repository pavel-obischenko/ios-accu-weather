//
//  GeolocationService.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 08.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import RxSwift


class GeolocationService: Service {
    private var locations: BehaviorSubject<Locations?> = BehaviorSubject<Locations?>(value: nil)
    
    var currentCity: Observable<City>? {
        return locations.compactMap { $0?.current }
    }
    
    override func setup() {
        let locationsObject = dataStorage.findFirstOrCreateObject(entityName: "Locations", predicate: nil)
        
        guard let location = Locations(from: locationsObject) else { return }
        locations.onNext(location)
    }
    
    func searchCurrentFor(latitude: Double, longitude: Double) {
        guard let url = URL.geopositionSearch else { fatalError("GeolocationService.searchCurrentFor: Unable to create url") }
        let params = ["q": "\(latitude),\(longitude)"]
        
        network.GET(url, body: params, headers: nil) { [weak self] (city: City?, error) in
            self?.locations.onNext(Locations(current: city))
            
            if let error = error {
                self?.locations.onError(error)
            }
        }
    }
}
