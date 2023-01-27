//
//  ModulesCordinator.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit
import CoreData
import SwiftUI

class ModuleCoordinator {

    func createMainNavigator() -> UINavigationController {
        UINavigationController(rootViewController:  createComicsCollection())
    }

    func createComicsCollection(context: NSManagedObjectContext = AppState.shared.persistenContext) -> UIViewController {
        ComicsCollectionViewController(
            useCase: ComicsCollectionUseCase(
                provider: ComicsCollectionProvider(service: ComicsCollectionService()),
                favComicsHandler: FavComicHandler(context: context)
            )
        )
    }

    func createFavComics(favComicInteraction: FavComicInteractionRepresentable) -> UIViewController {
        UIHostingController(rootView:
            FavComicsView(viewModel: .init(interaction: favComicInteraction))
                .environment(\.managedObjectContext, favComicInteraction.context)
        )
    }
}
