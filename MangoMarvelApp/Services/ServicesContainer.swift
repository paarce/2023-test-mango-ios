//
//  Container.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import CoreData

class ServicesContainer {

    let coreDataStack: CoreDataStack

    let comicsRemoteService: ComicsRemoteService
    let comicsLocalService: ComicsLocalService

    init() {

        coreDataStack = CoreDataStack()
        comicsRemoteService = ComicsRemoteServiceImpl()
        comicsLocalService = ComicsLocalServiceImpl(context: coreDataStack.container.viewContext)
    }
}

class CoreDataStack {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    private enum Constants {
        static let containerName = "MangoMarvelApp"
    }
}
