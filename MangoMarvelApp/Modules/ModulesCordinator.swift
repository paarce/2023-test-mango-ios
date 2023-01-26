//
//  ModulesCordinator.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

@available(iOS 13.0, *)
class ModuleCoordinator {

    func createMainNavigator() -> UINavigationController {
        UINavigationController(rootViewController:  createComicsCollection())
    }

    func createComicsCollection() -> ComicsCollectionViewController {
        .init(
            useCase: ComicsCollectionUseCase(
                provider: ComicsCollectionProvider(service: ComicsCollectionServiceService())
            )
        )
    }
}
