//
//  Locations.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 14.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

struct Locations {
    var current: City?
    
    init?(from object: NSManagedObject?) {
        guard let object = `object` else { return nil }
        current = object.value(forKey: "current") as? City
    }
    
    init(current city: City?) {
        current = city
    }
}
