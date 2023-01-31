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
        coodinator = .init(services: .init())
    }
}
