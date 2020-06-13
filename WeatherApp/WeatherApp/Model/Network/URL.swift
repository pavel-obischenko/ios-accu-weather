//
//  URL.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 08.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

extension URL {
    static let geopositionSearch = URL(string: "locations/v1/cities/geoposition/search", relativeTo: baseUrl)
    static let currentConditions = URL(string: "currentconditions/v1", relativeTo: baseUrl)
}

private extension URL {
    static let baseUrl = URL(string: "http://dataservice.accuweather.com/")
}
