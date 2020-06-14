//
//  City.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 14.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation


struct City: Decodable {
    var locationKey: String
    var localizedName: String
    
    var regionId: String
    var regionLocalizedName: String
    
    var countryId: String
    var countryLocalizedName: String
    
    var areaId: String
    var areaLocalizedName: String
    
    var latitude: Double
    var longitude: Double
    
    var gmtOffset: Float
    
    enum CodingKeys: String, CodingKey {
        case Key, LocalizedName
        case Region
        case Country
        case AdministrativeArea
        case TimeZone
        case GeoPosition
    }
    
    enum RegionKeys: String, CodingKey {
        case ID, LocalizedName
    }
    
    enum CountryKeys: String, CodingKey {
        case ID, LocalizedName
    }
    
    enum AdministrativeAreaKeys: String, CodingKey {
        case ID, LocalizedName
    }
    
    enum TimeZoneKeys: String, CodingKey {
        case GmtOffset
    }
    
    enum GeoPositionKeys: String, CodingKey {
        case Latitude, Longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        locationKey = container.decodeString(forKey: .Key)
        localizedName = container.decodeString(forKey: .LocalizedName)
        
        let regionContainer = try container.nestedContainer(keyedBy: RegionKeys.self, forKey: .Region)
        regionId = regionContainer.decodeString(forKey: .ID)
        regionLocalizedName = regionContainer.decodeString(forKey: .LocalizedName)
        
        let countryContainer = try container.nestedContainer(keyedBy: CountryKeys.self, forKey: .Country)
        countryId = countryContainer.decodeString(forKey: .ID)
        countryLocalizedName = countryContainer.decodeString(forKey: .LocalizedName)
        
        let areaContainer = try container.nestedContainer(keyedBy: AdministrativeAreaKeys.self, forKey: .AdministrativeArea)
        areaId = areaContainer.decodeString(forKey: .ID)
        areaLocalizedName = areaContainer.decodeString(forKey: .LocalizedName)
        
        let timeZoneContainer = try container.nestedContainer(keyedBy: TimeZoneKeys.self, forKey: .TimeZone)
        gmtOffset = timeZoneContainer.decodeFloat(forKey: .GmtOffset)
        
        let geopositionContainer = try container.nestedContainer(keyedBy: GeoPositionKeys.self, forKey: .GeoPosition)
        latitude = geopositionContainer.decodeDouble(forKey: .Latitude)
        longitude = geopositionContainer.decodeDouble(forKey: .Longitude)
    }
}
