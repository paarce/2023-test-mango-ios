//
//  ComicsCollectionProvider.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

protocol ComicsRemoteProviderReprentable {
    func fetchComics()
    func fetchComicsNextPage()
}

protocol ComicsLocalProviderReprentable {

    func fecthFavoritesIds() -> [Int]
    func addFavorite(comic: ComicDTO)
    func removeFavorite(comic: ComicDTO)
}

protocol ComicsProviderReprentable: ComicsRemoteProviderReprentable, ComicsLocalProviderReprentable {

    var delegate: ComicsStateDelegate? { get set }
}

class ComicsCollectionProvider: ComicsProviderReprentable  {

    var delegate: ComicsStateDelegate?
    private var remoteService: ComicsCollectionServiceRepresentable
    private var localService: ComicsLocalService
    private var page: Int
    private let limit: Int
    private var isLoading: Bool

    init(remoteService: ComicsCollectionServiceRepresentable, localService: ComicsLocalService ) {
        self.remoteService = remoteService
        self.localService = localService
        page = 0
        limit = 20
        isLoading = false
    }

    //MARK: - ComicsRemoteProviderReprentable

    func fetchComics() {
        fetchRemote(page: page)
    }

    func fetchComicsNextPage() {
        fetchRemote(page: page + 1)
    }

    //MARK: - ComicsLocalProviderReprentable

    func fecthFavoritesIds() -> [Int]{
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
                self.page = response.data.offset / self.limit
                self.delegate?.update(content: .success(response.data.results))

            case .failure(let error):
                self.delegate?.update(content: .fail(error))
            }
        }
    }
}
