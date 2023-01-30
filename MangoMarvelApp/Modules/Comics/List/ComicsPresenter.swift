//
//  File.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum ComicsViewState {
    case empty
    case loading
    case fail(Error)
    case success([ComicCellViewModel])
}

enum ComicsCollectionContent {
    case loading
    case fail(Error)
    case success(comics: [Comic], page: Int)
}

protocol ComicsStateDelegate {
    func update(content: ComicsCollectionContent)
}

protocol ComicsPresenter: ComicsStateDelegate, ComicsInteractionDelegate {

    var state: ComicsViewState { get }

    func initView(onRefresh: (() -> Void)?)
    func reload()
    func loadNextPageIfNeeded(lastIndexShowed: Int)
    func close()
}

final class ComicsPresenterImpl: ComicsPresenter  {

    private (set) var state: ComicsViewState
    private var provider: ComicsProvider
    private var onRefresh: (() -> Void)?
    private var page: Int
    private var initialFavIds: [Int]?

    init(
        provider: ComicsProvider
    ) {
        self.state = .empty
        self.provider = provider
        page = 0
    }

    func initView(onRefresh: (() -> Void)?) {
        self.onRefresh = onRefresh
        provider.delegate = self
        initialFavIds = provider.fecthFavoritesIds()
        reload()
    }

    func reload() {
        provider.fetchComics(page: page)
    }

    func loadNextPageIfNeeded(lastIndexShowed: Int) {
        guard shouldFetchNextPage(lastIndexShowed) else { return }
        provider.fetchComics(page: page + 1)
    }

    func close() {
        provider.delegate = nil
    }

    func addFav(comic: ComicDTO) {
        provider.addFavorite(comic: comic)
    }

    func removeFav(comic: ComicDTO) {
        provider.removeFavorite(comic: comic)
    }
}

extension ComicsPresenterImpl {

    private var storeComics: [ComicCellViewModel]? {
        guard case .success(let comics) = state else { return nil }
        return comics
    }

    func update(content: ComicsCollectionContent) {

        switch content {
        case .loading:
            guard storeComics == nil else { return }
            state = .loading
        case .fail(let error):
            state = .fail(error)
        case .success(let comics, let page):
            self.page = page
            if comics.isEmpty {
                state = .empty
            } else {

                let viewModels = comics.map({ ComicCellViewModel(
                    comic: $0,
                    isFav: initialFavIds?.contains($0.id) ?? false,
                    interaction: self
                )})
                var array = self.storeComics ?? []
                array.append(contentsOf: viewModels)
                state = .success(array)
            }
        }
        onRefresh?()
    }

    private func shouldFetchNextPage(_ lastIndexShowed: Int) -> Bool {
        guard case .success(let comics) = state, comics.count > lastIndexShowed else { return false }
        return (comics.count - lastIndexShowed) < Constants.offsetToLoadMore
    }

    private enum Constants {
        static let offsetToLoadMore = 10
    }
}
