//
//  ModulesCordinator.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit
import CoreData
import SwiftUI

struct ModuleCoordinator {

    let services: ServicesContainer

    func createMainNavigator() -> UINavigationController {
        UINavigationController(rootViewController:  createComicsCollection())
    }

    func createComicsCollection() -> UIViewController {
        ComicsCollectionViewController(
            useCase: ComicsCollectionUseCase(
                provider: ComicsCollectionProvider(
                    remoteService: services.comicsRemoteService,
                    localService: services.comicsLocalService
                )
            )
        )
    }

    func createFavComics() -> UIViewController {
        UIHostingController(rootView:
            FavComicsView(viewModel: .init(localService: services.comicsLocalService))
                .environment(\.managedObjectContext, services.context)
        )
    }
}

class ServicesContainer {

    let context: NSManagedObjectContext

    let comicsRemoteService: ComicsCollectionService
    let comicsLocalService: ComicsLocalService

    init(context: NSManagedObjectContext) {

        self.context = context
        comicsRemoteService = ComicsCollectionService()
        comicsLocalService = ComicsLocalServiceImpl(context: context)
    }
}
