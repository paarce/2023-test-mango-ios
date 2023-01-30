//
//  ComicsCollectionProvider.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

protocol ComicsRemoteProvider {
    func fetchComics(page: Int)
}

protocol ComicsLocalProvider {

    func fecthFavoritesIds() -> [Int]
    func addFavorite(comic: ComicDTO)
    func removeFavorite(comic: ComicDTO)
}

protocol ComicsProvider: ComicsRemoteProvider, ComicsLocalProvider {

    var delegate: ComicsStateDelegate? { get set }
}

final class ComicsProviderImpl: ComicsProvider  {


    var delegate: ComicsStateDelegate?
    private var remoteService: ComicsRemoteService
    private var localService: ComicsLocalService
    private let limit: Int
    private var isLoading: Bool

    init(remoteService: ComicsRemoteService, localService: ComicsLocalService) {
        self.remoteService = remoteService
        self.localService = localService
        limit = 20
        isLoading = false
    }

    //MARK: - ComicsRemoteProviderReprentable

    func fetchComics(page: Int) {
        fetchRemote(page: page)
    }

    //MARK: - ComicsLocalProviderReprentable

    func fecthFavoritesIds() -> [Int] {
        localService.fetch().map({ Int($0.id) })
    }

    func addFavorite(comic: ComicDTO) {
        localService.addFav(comic: comic)
    }

    func removeFavorite(comic: ComicDTO) {
        localService.removeFav(comic: comic)
    }

    //MARK: - Private methods

    private func fetchRemote(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        delegate?.update(content: .loading)

        remoteService.fecth(
            options: .init(offset: page * limit)
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.delegate?.update(content:
                    .success(
                        comics: response.data.results,
                        page: response.data.offset / self.limit
                    )
                )

            case .failure(let error):
                self.delegate?.update(content: .fail(error))
            }
        }
    }
}
