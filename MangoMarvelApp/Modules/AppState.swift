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

    private init() {
        currentEnv = .init()

        let container = NSPersistentContainer(name: Constants.containerName)
            container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        coodinator = .init(services: .init(context: container.viewContext))
    }

    private enum Constants {
        static let containerName = "MangoMarvelApp"
    }
}
