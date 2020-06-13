//
//  WeatherRequestProcessor.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 13.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

class WeatherRequestProcessor: AlamofireRequestProcessor {
    func process(url: URL, parameters: [String : Any]?) -> (url: URL, parameters: [String : Any]?) {
        return (url, parameters)
    }
}
