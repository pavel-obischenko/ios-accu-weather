//
//  InfoPlist.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 07.06.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation

class PlistFile {
    // MARK: Key Value Storage
    private var plist: [String: AnyObject]?
    
    // MARK: Singleton (for Info.plist)
    private(set) static var infoPlist = PlistFile(filename: "Info")
    
    // MARK: Initialization
    init(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                plist = dict
            }
        }
    }
    
    // MARK: Access
    subscript(key: String) -> Any? {
        return plist?[key]
    }
}
