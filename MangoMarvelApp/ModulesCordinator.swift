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
        if #available(iOS 16.0, *) {
            return UIHostingController(
                rootView: ComicsGridView(presenter: .init(interactor: .init(service: services.comicsRemoteService, limit: 10)))
            )
        } else {
            return ComicsCollectionViewController(
                provider: ComicsProviderImpl(
                    remoteService: services.comicsRemoteService,
                    localService: services.comicsLocalService
                )
            )
        }

    }

    func createFavComics(parentView: UIViewController) -> UIViewController {
        let viewController = UIHostingController(rootView:
            FavComicsView(viewModel: .init(
                remoteService: services.comicsRemoteService,
                localService: services.comicsLocalService,
                parentView: parentView
            ))
                .environment(\.managedObjectContext, services.coreDataStack.container.viewContext)
        )
        viewController.title = "COMICS_FAVORITES_TITLE".localized
        return viewController
    }

    func createComicDetail(comic: ComicDTO) -> UIViewController {
        ComicDetailTableViewController(viewModel: ComicDetailViewModelImpl(comic: comic))
    }
}
