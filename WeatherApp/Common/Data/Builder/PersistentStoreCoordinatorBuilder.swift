//
//  PersistentStoreCoordinatorBuilder.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 23.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentStoreCoordinatorBuilder {
    func coordinator(with storeName: String, managedObjectModel model: NSManagedObjectModel) -> NSPersistentStoreCoordinator?
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


class InMemoryPersistentStoreCoordinatorBuilder: PersistentStoreCoordinatorBuilder {}

extension InMemoryPersistentStoreCoordinatorBuilder {
    func coordinator(with storeName: String, managedObjectModel model: NSManagedObjectModel) -> NSPersistentStoreCoordinator? {
        return setupCoordinator(NSPersistentStoreCoordinator(managedObjectModel: model), storeName: storeName)
    }
}

private extension InMemoryPersistentStoreCoordinatorBuilder {
    func setupCoordinator(_ coordinator: NSPersistentStoreCoordinator, storeName: String) -> NSPersistentStoreCoordinator? {
        guard let _ = try? coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil) else { return nil }
        return coordinator
    }
}
