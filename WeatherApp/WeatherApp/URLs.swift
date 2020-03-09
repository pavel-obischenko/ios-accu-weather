//
//  URLs.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 07.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

extension URL {
    static let base = URL(string: "http://dataservice.accuweather.com/")
    
    static let loactionSearch = URL(string: "/locations/v1/cities/geoposition/search", relativeTo: base)
}
