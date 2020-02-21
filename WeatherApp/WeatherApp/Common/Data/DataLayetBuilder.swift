//
//  DataLayetBuilder.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

class DataLayetBuilder {
    public func build(with storeName: String) -> DataLayer? {
        guard let model = managedObjectModel(with: storeName) else { return nil }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        guard let _ = persistentStore(with: storeName, coordinator: coordinator) else { return nil }
        
        let rootContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        rootContext.performAndWait { [weak rootContext] in
            rootContext?.persistentStoreCoordinator = coordinator
        }
        
        let defaultContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        defaultContext.parent = rootContext
        
        return DataLayer(model: model, rootContext: rootContext, defaultContext: defaultContext)
    }
    
    private func managedObjectModel(with storeName: String) -> NSManagedObjectModel? {
        guard let url = Bundle.main.url(forResource: storeName, withExtension: "momd") else { return nil }
        return NSManagedObjectModel(contentsOf: url)
    }
    
    private func persistentStore(with storeName: String, coordinator: NSPersistentStoreCoordinator) -> NSPersistentStore? {
        guard let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let storeUrl = docUrl.appendingPathComponent("\(storeName).sqlite")
        
        var store = try? coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        
        if store == nil {
            try? FileManager.default.removeItem(at: storeUrl)
            store = persistentStore(with: storeName, coordinator: coordinator)
        }
        
        return store
    }
}
