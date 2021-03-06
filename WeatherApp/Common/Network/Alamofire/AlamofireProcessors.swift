//
//  AlamofireProcessors.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 10.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import Alamofire

protocol AlamofireResponseProcessor: class {
    func process<T: Decodable>(response: Data, url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: NetworkCompletionHandler<T>?)
}

protocol AlamofireRequestProcessor {
    func process(url: URL, parameters: [String: Any]?) -> (url: URL, parameters: [String: Any]?)
}

extension AlamofireResponseProcessor {
    func process<T: Decodable>(response: Data, url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        do {
            let response = try JSONDecoder().decode(T.self, from: response)
            completion?(response, nil)
        }
        catch {
            completion?(nil, error)
        }
    }
}

extension AlamofireRequestProcessor {
    func process(url: URL, parameters: [String: Any]?) -> (url: URL, parameters: [String: Any]?) {
        return (url, parameters)
    }
}

class DefaultAlamofireResponseProcessor: AlamofireResponseProcessor {}
class DefaultAlamofireRequestProcessor: AlamofireRequestProcessor {}
