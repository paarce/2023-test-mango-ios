//
//  AppState.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData

class AppState {

    static let shared = AppState()

    let currentEnv: Env
    let coodinator: ModuleCoordinator
    let persistenContext: NSManagedObjectContext

    private init() {
        currentEnv = .init()
        coodinator = .init()

        let container = NSPersistentContainer(name: Constants.containerName)
            container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        persistenContext = container.viewContext
    }

    private enum Constants {
        static let containerName = "MangoMarvelApp"
    }
}
