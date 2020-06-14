//
//  GeolocationService.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 08.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

class GeolocationService: Service {
    private(set) var currentCity: City?
    
    override func setup() {
        let currentCityObject = dataStorage.findFirstObject(entityName: "City", predicate: nil)
        currentCity = City(from: currentCityObject)
    }
}
