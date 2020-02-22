//
//  DataStorage.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

protocol DataStorage: class {
    func isEntityExists(entityName: String) -> Bool
    
    func createObject(entityName: String) -> NSManagedObject
    func insertObject(object: NSManagedObject)
    func deleteObject(object: NSManagedObject)
    func deleteObjects(objects: [NSManagedObject])
    
    func fetchObjects(entityName: String, limit: Int, offset: Int, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, propertiesToFetch: [Any]?) -> [NSManagedObject]?
    func findFirstObject(entityName: String, predicate: NSPredicate?) -> NSManagedObject?
    func findFirstOrCreateObject(entityName: String, predicate: NSPredicate?) -> NSManagedObject
    
    func save()
}
