//
//  CurrentConditions.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 17.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation


struct CurrentConditions: Decodable {
    var localTime: Date
    var weatherText: String
    var weatherIconId: Int
    var hasPrecipitation: Bool
    var precipitationType: String
    var isDayTime: Bool
    var temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case LocalObservationDateTime
        case WeatherText
        case WeatherIcon
        case HasPrecipitation
        case PrecipitationType
        case IsDayTime
        case Temperature
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        localTime = container.decodeDate(forKey: .LocalObservationDateTime)
        weatherText = container.decodeString(forKey: .WeatherText)
        weatherIconId = container.decodeInt(forKey: .WeatherIcon)
        hasPrecipitation = container.decodeBool(forKey: .HasPrecipitation)
        precipitationType = container.decodeString(forKey: .PrecipitationType)
        isDayTime = container.decodeBool(forKey: .IsDayTime)
        
        temperature = try container.decode(Temperature.self, forKey: .Temperature)
    }
}
