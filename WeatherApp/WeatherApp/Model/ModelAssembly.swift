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
        
        assembleServices(container)
    }
}

private extension ModelAssembly {
    func assembleNetwork(_ container: Container) {
        container.register(AlamofireRequestProcessor.self) { _ in WeatherRequestProcessor(infoPlist: PlistFile.infoPlist) }
        container.register(AlamofireResponseProcessor.self) { _ in WeatherResponseProcessor() }
        
        container.register(Network.self) { r in
            AlamofireNetwork(headersBuilder: nil, requestProcessor: r.resolve(AlamofireRequestProcessor.self), responseProcessor: r.resolve(AlamofireResponseProcessor.self))
        }.inObjectScope(.container)
    }
    
    func assembleDataStorage(_ container: Container) {
        container.register(DataStorageBuilder.self) { _ in CommonDataStorageBuilder() }
        container.register(DataStorage.self) { r in
            let builder = r.resolve(DataStorageBuilder.self)
            
            guard let dataStorage = builder?.build(with: "Database") else {
                fatalError("Couldn`t create DataStorage")
            }
            return dataStorage
        }.inObjectScope(.container)
    }
    
    func assembleServices(_ container: Container) {
        assembleGeolocationService(container)
    }
}

private extension ModelAssembly {
    func assembleGeolocationService(_ container: Container) {
        container.register(GeolocationService.self) { r in
            guard let network = r.resolve(Network.self), let dataStorage = r.resolve(DataStorage.self) else {
                fatalError("One or more dependenciea are not resolved")
            }
            return GeolocationService(network: network, dataStorage: dataStorage)
        }.inObjectScope(.container)
    }
}
