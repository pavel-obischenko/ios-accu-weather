//
//  AlamofireNetwork.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 07.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import Alamofire

protocol AlamofireHeadersBuilder: class {
    func build(for url: URL, method: HTTPMethod, parameters: [String: Any]?) -> HTTPHeaders?
}

protocol AlamofireResponseProcessor: class {
    func process(response: [String: Any], url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: NetworkCompletionBlock?)
}

class AlamofireNetwork: Network {
    private var headersBuilder: AlamofireHeadersBuilder?
    private var responseProcessor: AlamofireResponseProcessor?
    
    init(headersBuilder: AlamofireHeadersBuilder?) {
        self.headersBuilder = headersBuilder
    }
    
    func GET(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?) {
        request(url, method: .get, parameters: body, completion: completion)
    }
    
    func PUT(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?) {
        request(url, method: .put, parameters: body, completion: completion)
    }
    
    func DELETE(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?) {
        request(url, method: .delete, parameters: body, completion: completion)
    }
    
    func POST(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?) {
        request(url, method: .post, parameters: body, completion: completion)
    }
    
    func PATCH(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?) {
        request(url, method: .patch, parameters: body, completion: completion)
    }
    
    private func request(_ url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: NetworkCompletionBlock?) {
        AF.request(url, method: method, parameters: parameters, headers: headersBuilder?.build(for: url, method: method, parameters: parameters)).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                guard let responseProcessor = self?.responseProcessor else {
                    completion?(response, nil)
                    break
                }
                
                let value = (response.value as? [String : Any]) ?? [String : Any]()
                responseProcessor.process(response: value, url: url, method: method, parameters: parameters, completion: completion)
            case let .failure(error):
                completion?(nil, error)
            }
        }
    }
}
