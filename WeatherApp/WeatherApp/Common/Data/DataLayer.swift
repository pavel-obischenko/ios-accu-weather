//
//  DataLayer.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

class DataLayer {
    private let model: NSManagedObjectModel
    private let rootContext: NSManagedObjectContext
    private let defaultContext: NSManagedObjectContext
    
    private let threadContextKey = "DataLayerManagedObjectContextKey"
    private let threadContextVersionKey = "DataLayerManagedObjectContextCacheVersionKey"
    private let targetCacheVersion = 0
    
    private var threadContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = defaultContext
        
        let threadDictionary = Thread.current.threadDictionary
        threadDictionary.setObject(context, forKey: threadContextKey as NSString)
        threadDictionary.setObject(targetCacheVersion, forKey: threadContextVersionKey as NSString)
        
        return context
    }
    
    private var currentContext: NSManagedObjectContext {
        if Thread.isMainThread {
            return defaultContext
        }
        
        let threadDictionary = Thread.current.threadDictionary
        guard let currentThreadContext = threadDictionary.object(forKey: threadContextKey) as? NSManagedObjectContext else {
            return threadContext
        }
        
        guard let currentCacheVersion = threadDictionary.object(forKey: threadContextVersionKey) as? Int else {
            return threadContext
        }
        
        if currentCacheVersion != targetCacheVersion {
            return threadContext
        }
        
        return currentThreadContext
    }
    
    init(model: NSManagedObjectModel, rootContext: NSManagedObjectContext, defaultContext: NSManagedObjectContext) {
        self.model = model
        self.rootContext = rootContext
        self.defaultContext = defaultContext
    }
}

extension DataLayer {
    func isEntityExists(entityName: String) -> Bool {
        return model.entitiesByName[entityName] != nil
    }
    
    func createObject(entityName: String) -> NSManagedObject {
        let context = currentContext
        
        objc_sync_enter(context)
        defer {
            objc_sync_exit(context)
        }
        
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
    
    func insertObject(object: NSManagedObject) {
        let context = currentContext
        
        objc_sync_enter(context)
        defer {
            objc_sync_exit(context)
        }
        
        context.insert(object)
    }
    
    func deleteObject(object: NSManagedObject) {
        let context = currentContext
        
        objc_sync_enter(context)
        defer {
            objc_sync_exit(context)
        }
        
        context.delete(object)
    }
    
    func fetch(entityName: String, limit: Int, offset: Int, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, propertiesToFetch: [Any]? = nil) -> [NSManagedObject]? {
        let context = currentContext
        
        objc_sync_enter(context)
        defer {
            objc_sync_exit(context)
        }
        
        var result: [NSManagedObject]? = nil
        
        autoreleasepool {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.includesPropertyValues = false
            request.fetchLimit = limit
            request.fetchOffset = offset
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.propertiesToFetch = propertiesToFetch
            
            result = try? context.fetch(request)
        }
        
        return result
    }
    
    func save() {
        save(context: currentContext)
    }
}

private extension DataLayer {
    func isContextChanged(context: NSManagedObjectContext) -> Bool {
        var changed = false
        
        context.performAndWait {
            changed = context.hasChanges
        }
        return changed
    }
    
    func save(context: NSManagedObjectContext) {
        if isContextChanged(context: context) {
            var result = false
            
            context.performAndWait {
                do {
                    try context.save()
                    result = true
                }
                catch {
                    print("Unable to perform save: \(error.localizedDescription)")
                }
            }
            
            if result, let parent = context.parent {
                save(context: parent)
            }
        }
    }
}
