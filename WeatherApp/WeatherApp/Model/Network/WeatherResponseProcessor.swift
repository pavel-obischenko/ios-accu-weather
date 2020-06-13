//
//  WeatherResponseProcessor.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 13.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import Alamofire

class WeatherResponseProcessor: AlamofireResponseProcessor {
    func process<T>(response: Data, url: URL, method: HTTPMethod, parameters: [String : Any]?, completion: NetworkCompletionHandler<T>?) where T : Decodable {
        do {
            let response = try JSONDecoder().decode(T.self, from: response)
            completion?(response, nil)
        }
        catch {
            completion?(nil, error)
        }
    }
}
