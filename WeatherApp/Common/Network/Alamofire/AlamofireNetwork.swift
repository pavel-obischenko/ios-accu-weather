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

class AlamofireNetwork: Network {
    private(set) var headersBuilder: AlamofireHeadersBuilder?
    private(set) var responseProcessor: AlamofireResponseProcessor
    private(set) var requestProcessor: AlamofireRequestProcessor
    
    init(headersBuilder: AlamofireHeadersBuilder?, requestProcessor: AlamofireRequestProcessor?, responseProcessor: AlamofireResponseProcessor?) {
        self.headersBuilder = headersBuilder
        
        self.requestProcessor = requestProcessor ?? DefaultAlamofireRequestProcessor()
        self.responseProcessor = responseProcessor ?? DefaultAlamofireResponseProcessor()
    }
    
    func GET<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        request(url, method: .get, parameters: body, completion: completion)
    }
    
    func PUT<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        request(url, method: .put, parameters: body, completion: completion)
    }
    
    func DELETE<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        request(url, method: .delete, parameters: body, completion: completion)
    }
    
    func POST<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        request(url, method: .post, parameters: body, completion: completion)
    }
    
    func POST<T: Decodable>(_ url: URL, body: [String : Any]?, headers: [String : Any]?, multypartBuilder: NetworkMultypartBuilder?, completion: NetworkCompletionHandler<T>?) {
    }
    
    func PATCH<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        request(url, method: .patch, parameters: body, completion: completion)
    }
}

private extension AlamofireNetwork {
    func request<T: Decodable>(_ url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: NetworkCompletionHandler<T>?) {
        let requestParams = requestProcessor.process(url: url, parameters: parameters)
        
        AF.request(requestParams.url, method: method, parameters: requestParams.parameters, headers: headersBuilder?.build(for: url, method: method, parameters: parameters)).responseJSON { [weak self] response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    completion?(nil, nil)
                    return
                }
                
                self?.responseProcessor.process(response: data, url: url, method: method, parameters: parameters, completion: completion)
                
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}
