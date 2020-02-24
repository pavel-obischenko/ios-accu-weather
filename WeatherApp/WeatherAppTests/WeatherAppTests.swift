//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Pavel Obischenko on 21.02.2020.
//  Copyright © 2020 Pavel Obischenko. All rights reserved.
//

import XCTest
import CoreData

@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var storage: DataStorage? = nil

    override func setUp() {
        storage = InMemoryDataStorageBuilder().build(with: "TestDatabase")
    }

    override func tearDown() {
        storage = nil
    }

    func testDataStorageCreation() {
        XCTAssertNotNil(storage)
    }
    
    func testIsEntityExists() {
        XCTAssertNotNil(storage)
        guard let storage = storage else { return }
        
        XCTAssertTrue(storage.isEntityExists(entityName: "First"))
        XCTAssertTrue(storage.isEntityExists(entityName: "Second"))
        XCTAssertFalse(storage.isEntityExists(entityName: "Unknown"))
    }
    
    func testObjectCreation() {
        XCTAssertNotNil(storage)
        guard let storage = storage else { return }
        
        let objectFirst = storage.createObject(entityName: "First")
        XCTAssertNotNil(objectFirst)
        
        let value = "NameValue"
        let key = "name"
        objectFirst.setValue(value, forKey: key)
        
        XCTAssertTrue((objectFirst.value(forKey: key) as? String) == value)
        XCTAssertTrue(objectFirst.hasChanges)
        XCTAssertTrue(objectFirst.isInserted)
        XCTAssertFalse(objectFirst.isFault)
        XCTAssertFalse(objectFirst.isDeleted)
        XCTAssertFalse(objectFirst.isUpdated)
        
        XCTAssertTrue(storage.fetchObjects(entityName: "First", limit: 0, offset: 0, predicate: nil, sortDescriptors: nil, propertiesToFetch: nil)?.count == 1)
    }
    
    func testObjectDeletion() {
        XCTAssertNotNil(storage)
        guard let storage = storage else { return }

        XCTAssertTrue(storage.fetchObjects(entityName: "First", limit: 0, offset: 0, predicate: nil, sortDescriptors: nil, propertiesToFetch: nil)?.count == 0)
        
        let objectFirst = storage.createObject(entityName: "First")
        XCTAssertNotNil(objectFirst)
        
        XCTAssertTrue(storage.fetchObjects(entityName: "First", limit: 0, offset: 0, predicate: nil, sortDescriptors: nil, propertiesToFetch: nil)?.count == 1)
        
        storage.deleteObject(object: objectFirst)
        XCTAssertTrue(storage.fetchObjects(entityName: "First", limit: 0, offset: 0, predicate: nil, sortDescriptors: nil, propertiesToFetch: nil)?.count == 0)
    }
}
