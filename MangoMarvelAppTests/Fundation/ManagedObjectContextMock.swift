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

class PersistenceMock {

    /// Returns a `NSManagedObjectContext` linking to memory instead of SQLite
    func managedObjectContext() -> NSManagedObjectContext {
        return managedObjectContextLazy
    }

    /// This will return the `NSManagedObjectContext` which in this time will
    /// be redirected to memory instead of the original DatabaseManager linking
    /// to the SQLite file.
    ///
    /// Is important to highlight that Swift doesn't like creation of more than
    /// one `NSManagedObjectContext` and therefore we had to lazly do that.
    /// The `override func managedObjectContext()` itself can't be lazy due
    /// to it's superclass constraints and therefore this helper computed property
    /// had to be implemented to bridge the incompatibility.
    lazy var managedObjectContextLazy: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    /// Gets the `NSManagedObjectModel` from the superclass
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()

    /// Redirects the `NSPersistentStoreCoordinator` to memory.
    ///
    /// Here is all the magic happening. The `NSPersistentStoreCoordinator` is
    /// redirected to memory instead of SQLite.
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        do {
            try coordinator!.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        }
        catch {
            coordinator = nil
            print("Error")
        }

        return coordinator
    }()
}
