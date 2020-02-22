//
//  DataStorageBuilder.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentStoreCoordinatorBuilder {
    func coordinator(with storeName: String, managedObjectModel model: NSManagedObjectModel) -> NSPersistentStoreCoordinator?
}

protocol DataStorageBuilder {
    var coordinatorBuilder: PersistentStoreCoordinatorBuilder { get }
    func build(with storeName: String) -> DataStorage?
}

extension DataStorageBuilder {
    func build(with storeName: String) -> DataStorage? {
        guard let model = managedObjectModel(with: storeName) else { return nil }
        guard let coordinator = coordinatorBuilder.coordinator(with: storeName, managedObjectModel: model) else { return nil }
        
        let rootContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        rootContext.performAndWait { [weak rootContext] in
            rootContext?.persistentStoreCoordinator = coordinator
        }
        
        let defaultContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        defaultContext.parent = rootContext
        
        return CoreDataWrapper(model: model, rootContext: rootContext, defaultContext: defaultContext)
    }
    
    func managedObjectModel(with storeName: String) -> NSManagedObjectModel? {
        guard let url = Bundle.main.url(forResource: storeName, withExtension: "momd") else { return nil }
        return NSManagedObjectModel(contentsOf: url)
    }
}

class SQLLitePersistentStoreCoordinatorBuilder: PersistentStoreCoordinatorBuilder {}

extension SQLLitePersistentStoreCoordinatorBuilder {
    func coordinator(with storeName: String, managedObjectModel model: NSManagedObjectModel) -> NSPersistentStoreCoordinator? {
        return setupCoordinator(NSPersistentStoreCoordinator(managedObjectModel: model), storeName: storeName)
    }
}

private extension SQLLitePersistentStoreCoordinatorBuilder {
    func setupCoordinator(_ coordinator: NSPersistentStoreCoordinator, storeName: String) -> NSPersistentStoreCoordinator? {
        guard let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let storeUrl = docUrl.appendingPathComponent("\(storeName).sqlite")
        
        guard let _ = try? coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]) else {
            try? FileManager.default.removeItem(at: storeUrl)
            return setupCoordinator(coordinator, storeName: storeName)
        }
        
        return coordinator
    }
}
