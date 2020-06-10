//
//  URL.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 08.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

extension URL {
    private static let serverUrl = URL(string: "http://dataservice.accuweather.com/")
    
    static let geopositionSearch = URL(string: "locations/v1/cities/geoposition/search", relativeTo: serverUrl)
    static let currentConditions = URL(string: "currentconditions/v1", relativeTo: serverUrl)
}
