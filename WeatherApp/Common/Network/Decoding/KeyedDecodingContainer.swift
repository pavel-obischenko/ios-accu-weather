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
    
    func decodeFloat(forKey key: K) -> Float {
        return (try? decode(Float.self, forKey: key)) ?? 0
    }
    
    func decodeDouble(forKey key: K) -> Double {
        return (try? decode(Double.self, forKey: key)) ?? 0
    }
}
