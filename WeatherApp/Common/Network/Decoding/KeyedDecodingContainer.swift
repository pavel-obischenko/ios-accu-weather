//
//  KeyedDecodingContainer.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 14.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeString(forKey key: K) -> String {
        return (try? decode(String.self, forKey: key)) ?? ""
    }
    
    func decodeBool(forKey key: K) -> Bool {
        return (try? decode(Bool.self, forKey: key)) ?? false
    }
    
    func decodeInt(forKey key: K) -> Int {
        return (try? decode(Int.self, forKey: key)) ?? 0
    }
    
    func decodeFloat(forKey key: K) -> Float {
        return (try? decode(Float.self, forKey: key)) ?? 0
    }
    
    func decodeDouble(forKey key: K) -> Double {
        return (try? decode(Double.self, forKey: key)) ?? 0
    }
    
    func decodeDate(forKey key: K) -> Date {
//        return (try? decode(String.self, forKey: key)) ?? ""
        return Date()
    }
}
