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
            presenter: ComicsPresenterImpl(
                provider: ComicsProviderImpl(
                    remoteService: services.comicsRemoteService,
                    localService: services.comicsLocalService
                )
            )
        )
    }

    func createFavComics() -> UIViewController {
        UIHostingController(rootView:
            FavComicsView(viewModel: .init(localService: services.comicsLocalService))
                .environment(\.managedObjectContext, services.coreDataStack.container.viewContext)
        )
    }

    func createComicDetail(comic: ComicDTO) -> UIViewController {
        ComicDetailTableViewController(presenter: ComicDetailPresenterImpl(comic: comic))
    }
}