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
        assembleNetwork(container)
        assembleDataStorage(container)
    }
    
    func assembleNetwork(_ container: Container) {
        container.register(AlamofireRequestProcessor.self) { _ in WeatherRequestProcessor() }
        container.register(AlamofireResponseProcessor.self) { _ in WeatherResponseProcessor() }
        
        container.register(Network.self) { r in
            AlamofireNetwork(headersBuilder: nil, requestProcessor: r.resolve(AlamofireRequestProcessor.self), responseProcessor: r.resolve(AlamofireResponseProcessor.self))
        }.inObjectScope(.container)
    }
    
    func assembleDataStorage(_ container: Container) {
        container.register(DataStorageBuilder.self) { _ in CommonDataStorageBuilder() }
        container.register(DataStorage.self) { r in
            let builder = r.resolve(DataStorageBuilder.self)
            let dataStorage = builder?.build(with: "Database")
            
            if dataStorage == nil {
                fatalError("Couldn`t create DataStorage")
            }
            
            return dataStorage!
        }
    }
}
