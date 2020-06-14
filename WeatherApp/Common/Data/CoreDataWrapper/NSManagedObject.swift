//
//  NSManagedObject.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 14.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func string(forKey key: String) -> String {
        return (value(forKey: key) as? String) ?? ""
    }
    
    func float(forKey key: String) -> Float {
        return (value(forKey: key) as? Float) ?? 0
    }
    
    func double(forKey key: String) -> Double {
        return (value(forKey: key) as? Double) ?? 0
    }
}
