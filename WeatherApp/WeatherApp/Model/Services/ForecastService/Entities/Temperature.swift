//
//  Temperature.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 17.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation


struct Temperature: Decodable {
    var metric: TemperatureValue
    var imperial: TemperatureValue
    
    enum Units {
        case C
        case F
    }
    
    enum CodingKeys: String, CodingKey {
        case Metric
        case Imperial
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        metric = try container.decode(TemperatureValue.self, forKey: .Metric)
        imperial = try container.decode(TemperatureValue.self, forKey: .Imperial)
    }
    
    func formattedValue(units: Units = .C) -> String {
        let value = self.value(units: units)
        return String(format: ".2%f %@", value.value, value.unit)
    }
    
    func value(units: Units = .C) -> TemperatureValue {
        switch units {
        case .F:
            return imperial
        default:
            return metric
        }
    }
}

struct TemperatureValue: Decodable {
    var value: Double
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case Value
        case Unit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        value = container.decodeDouble(forKey: .Value)
        unit = container.decodeString(forKey: .Unit)
    }
}
