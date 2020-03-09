//
//  CoreDataWrapper.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 22.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataWrapper {
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

extension CoreDataWrapper: DataStorage {
    func isEntityExists(entityName: String) -> Bool {
        return model.entitiesByName[entityName] != nil
    }
    
    func createObject(entityName: String) -> NSManagedObject {
        let context = currentContext
        
        objc_sync_enter(context)
        defer {
            objc_sync_exit(context)
        }
        
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: currentContext)
    }
    
    func deleteObject(object: NSManagedObject) {
        let context = currentContext
        context.performAndWait {
            context.delete(object)
        }
    }
    
    func deleteObjects(objects: [NSManagedObject]) {
        let context = currentContext
        context.performAndWait {
            objects.forEach {
                context.delete($0)
            }
        }
    }
    
    func fetchObjects(entityName: String, limit: Int, offset: Int, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, propertiesToFetch: [Any]? = nil) -> [NSManagedObject]? {
        var result: [NSManagedObject]? = nil
        
        let context = currentContext
        context.performAndWait {
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
        }

        return result
    }
    
    func findFirstObject(entityName: String, predicate: NSPredicate?) -> NSManagedObject? {
        return fetchObjects(entityName: entityName, limit: 0, offset: 0, predicate: predicate)?.first
    }
    
    func findFirstOrCreateObject(entityName: String, predicate: NSPredicate?) -> NSManagedObject {
        if let object = findFirstObject(entityName: entityName, predicate: predicate) {
            return object
        }
        return createObject(entityName: entityName)
    }
    
    func save() {
        save(context: currentContext)
    }
}

private extension CoreDataWrapper {
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

