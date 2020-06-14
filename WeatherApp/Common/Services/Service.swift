//
//  Service.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 13.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

class Service {
    private(set) var network: Network
    private(set) var dataStorage: DataStorage
    
    init(network: Network, dataStorage: DataStorage) {
        self.network = network
        self.dataStorage = dataStorage
    }
}
