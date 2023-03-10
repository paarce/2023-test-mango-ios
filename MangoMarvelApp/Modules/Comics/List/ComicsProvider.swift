//
//  ComicsCollectionProvider.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

protocol ComicsRemoteProvider {
    func reload() async throws -> [Comic]
    func fetchNextPageComics() async throws -> [Comic]
}

protocol ComicsLocalProvider {

    func fecthFavoritesIds() -> [Int]
    func addFavorite(comic: ComicDTO)
    func removeFavorite(comic: ComicDTO)
}

protocol ComicsProvider: ComicsRemoteProvider, ComicsLocalProvider {}

final class ComicsProviderImpl: ComicsProvider {


    private var remoteService: ComicsRemoteService
    private var localService: ComicsLocalService
    private let limit: Int
    private var page: Int?

    init(remoteService: ComicsRemoteService, localService: ComicsLocalService) {
        self.remoteService = remoteService
        self.localService = localService
        limit = 20
    }

    //MARK: - ComicsRemoteProviderReprentable

    func reload() async throws -> [Comic] {
        try await fetch(page: page ?? 0)
    }

    func fetchNextPageComics() async throws -> [Comic] {
        let currentPage = self.page ?? -1
        let nextPage = currentPage + 1
        return try await fetch(page: nextPage)
    }

    func fetch(page: Int) async throws -> [Comic] {
        let reponse = try await remoteService.fecth(options: .init(offset: page * limit) )
        self.page = reponse.data.offset / self.limit
        return reponse.data.results
    }

    //MARK: - ComicsLocalProviderReprentable

    func fecthFavoritesIds() -> [Int] {
        localService.fetch().map({ Int($0.id) })
    }

    func addFavorite(comic: ComicDTO) {
        try? localService.addFav(comic: comic)
    }

    func removeFavorite(comic: ComicDTO) {
        try? localService.removeFav(comic: comic)
    }
}
