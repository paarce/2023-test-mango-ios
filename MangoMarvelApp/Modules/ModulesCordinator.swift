//
//  ModulesCordinator.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

@available(iOS 13.0, *)
class ModuleCoordinator {

    func createComicsCollection() -> ComicsCollectionViewController {
        .init(
            useCase: ComicsCollectionUseCase(
                provider: ComicsCollectionProvider(service: ComicsCollectionServiceService())
            )
        )
    }
}
