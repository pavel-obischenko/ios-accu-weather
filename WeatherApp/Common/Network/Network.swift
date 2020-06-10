//
//  Network.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 04.03.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

typealias NetworkMultypartElement = (data: Data, withName: String, mimeType: String)
typealias NetworkCompletionHandler<T: Decodable> = (_ response: T?, _ error: Error?) -> ()
typealias NetworkMultypartBuilder = () -> ([NetworkMultypartElement]?)

protocol Network: class {
    func GET<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?)
    func PUT<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?)
    func DELETE<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?)
    func PATCH<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, completion: NetworkCompletionHandler<T>?)
    func POST<T: Decodable>(_ url: URL, body: [String: Any]?, headers: [String: Any]?, multypartBuilder: NetworkMultypartBuilder?, completion: NetworkCompletionHandler<T>?)
}
