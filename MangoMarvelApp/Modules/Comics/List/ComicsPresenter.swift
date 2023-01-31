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

protocol ComicsPresenter: ComicsInteractionDelegate {

    var state: ComicsViewState { get }

    func initView(onRefresh: (() -> Void)?)
    func reload()
    func loadNextPageIfNeeded(lastIndexShowed: Int)
}

final class ComicsPresenterImpl: ComicsPresenter  {

    private var provider: ComicsProvider
    private var onRefresh: (() -> Void)?
    private var initialFavIds: [Int]?
    private (set) var state: ComicsViewState {
        didSet {
            onRefresh?()
        }
    }

    init(
        provider: ComicsProvider
    ) {
        self.state = .empty
        self.provider = provider
    }

    func initView(onRefresh: (() -> Void)?) {
        self.onRefresh = onRefresh
        initialFavIds = provider.fecthFavoritesIds()
        reload()
    }

    func reload() {
        guard !isLoading else { return }
        self.state = .loading
        Task {
            do {
                let list = try await provider.reload()
                updateStateWith(comics: list)
            } catch {
                self.state = .fail(error)
            }
        }
    }

    func loadNextPageIfNeeded(lastIndexShowed: Int) {
        guard !isLoading, shouldFetchNextPage(lastIndexShowed) else { return }
        Task {
            do {
                let list = try await provider.fetchNextPageComics()
                updateStateWith(comics: list)
            } catch {
                self.state = .fail(error)
            }
        }
    }

    func addFav(comic: ComicDTO) {
        provider.addFavorite(comic: comic)
    }

    func removeFav(comic: ComicDTO) {
        provider.removeFavorite(comic: comic)
    }
}

extension ComicsPresenterImpl {

    private var isLoading: Bool {
        guard case .loading = state else { return false }
        return true
    }

    private func updateStateWith(comics: [Comic]) {
        if comics.isEmpty {
            state = .empty
        } else {

            var fullComics = [ComicCellViewModel]()
            if case .success(let comics) = state {
                fullComics = comics
            }

            fullComics.append(contentsOf:
                comics.map{ .init(
                    comic: $0,
                    isFav: initialFavIds?.contains($0.id) ?? false,
                    interaction: self
                )}
            )
            state = .success(fullComics)
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

extension InfoCellModel {
    init?(comicsState: ComicsViewState) {
        switch comicsState {
        case .loading:
            self = .init(loadingMessage: "COMICS_LIST_LOADING".localized)
        case .fail(let error):
            self = .init(error: error)
        case .empty:
            self = .init(loadingMessage: "COMICS_LIST_EMPTY".localized)
        default:
            return nil
        }
    }
}
