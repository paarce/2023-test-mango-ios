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
    case success([Comic])
}

protocol ComicsStateDelegate {
    func update(content: ComicsCollectionContent)
}

protocol ComicsInteractionDelegate {
    func addFav(comic: ComicDTO)
    func removeFav(comic: ComicDTO)
}

protocol ComicsPresenter: ComicsStateDelegate, ComicsInteractionDelegate {

    var state: ComicsViewState { get }

    func initView(onRefresh: (() -> Void)?)
    func reload()
    func loadNextPageIfNeeded(lastIndexShowed: Int)
    func close()
    func cellSize(from frameSize: CGSize, in identifier: String) -> CGSize
}

final class ComicsPresenterImpl: ComicsPresenter  {

    private var provider: ComicsProvider
    private (set) var state: ComicsViewState
    private var onRefresh: (() -> Void)?
    private var initialFavIds: [Int]?

    init(
        provider: ComicsProvider
    ) {
        self.state = .empty
        self.provider = provider
    }

    func initView(onRefresh: (() -> Void)?) {
        self.onRefresh = onRefresh
        provider.delegate = self
        initialFavIds = provider.fecthFavoritesIds()
        provider.fetchComics()
    }

    func reload() {
        provider.fetchComics()
    }

    func loadNextPageIfNeeded(lastIndexShowed: Int) {
        guard shouldFetchNextPage(lastIndexShowed) else { return }
        provider.fetchComicsNextPage()
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
        case .success(let comics):
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
}

extension ComicsPresenterImpl {

    func cellSize(from frameSize: CGSize, in identifier: String) -> CGSize {
        if identifier == ComicCollectionViewCell.identifier {
            return .init(
                width: (frameSize.width / 2) - 1,
                height: (frameSize.height / 4) - 4
            )
        } else if identifier == InfoCollectionViewCell.identifier {
            return .init(width: frameSize.width, height: frameSize.height)
        } else {
            return .zero
        }
    }

    private func shouldFetchNextPage(_ lastIndexShowed: Int) -> Bool {
        guard case .success(let comics) = state, comics.count > lastIndexShowed else { return false }
        return (comics.count - lastIndexShowed) < Constants.offsetToLoadMore
    }

    private enum Constants {
        static let offsetToLoadMore = 10
    }
}
