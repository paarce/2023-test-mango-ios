//
//  ManagedObjectContextMock.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData
@testable import MangoMarvelApp

class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "MangoMarvelApp")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
