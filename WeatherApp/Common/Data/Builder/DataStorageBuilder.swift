//
//  DataStorageBuilder.swift
//  WeatherApp
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import Foundation
import CoreData

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
