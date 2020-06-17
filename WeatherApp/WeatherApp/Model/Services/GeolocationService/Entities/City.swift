//
//  City.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 14.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

struct City: Decodable {
    var locationKey: String = ""
    var localizedName: String = ""
    
    var regionId: String = ""
    var regionLocalizedName: String = ""
    
    var countryId: String = ""
    var countryLocalizedName: String = ""
    
    var areaId: String = ""
    var areaLocalizedName: String = ""
    
    var latitude: Double = 0
    var longitude: Double = 0
    
    var gmtOffset: Float = 0
    
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
    
    init?(from object: NSManagedObject?) {
        guard let object = `object` else { return nil }
        
        locationKey = object.string(forKey: "locationKey")
        localizedName = object.string(forKey: "localizedName")
        
        regionId = object.string(forKey: "regionId")
        regionLocalizedName = object.string(forKey: "regionLocalizedName")
        
        countryId = object.string(forKey: "countryId")
        countryLocalizedName = object.string(forKey: "countryLocalizedName")
        
        areaId = object.string(forKey: "areaId")
        areaLocalizedName = object.string(forKey: "areaLocalizedName")
        
        gmtOffset = object.float(forKey: "gmtOffset")
        
        latitude = object.double(forKey: "latitude")
        longitude = object.double(forKey: "longitude")
    }
}
