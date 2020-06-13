//
//  ModelAssembly.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 13.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import Swinject

class ModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Network.self) { _ in AlamofireNetwork(headersBuilder: nil, requestProcessor: nil, responseProcessor: nil) }.inObjectScope(.container)
    }
}
