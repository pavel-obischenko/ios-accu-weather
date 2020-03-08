//
//  Network.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 04.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

public typealias NetworkCompletionBlock = ( _ response : Any?, _ error : Error?) -> ()

public protocol Network: class {
    func GET(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?)
    func PUT(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?)
    func DELETE(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?)
    func POST(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?)
    func PATCH(_ url: URL, body: [String: Any]?, completion: NetworkCompletionBlock?)
}
