//
//  File.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum ComicsCollectionState: Equatable {
    static func == (lhs: ComicsCollectionState, rhs: ComicsCollectionState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty), (.loading, .loading),
            (.fail, .fail), (.success, .success):
            return true
        default:
            return false
        }
    }

    case empty
    case loading
    case fail(ErrorDTO)
    case success([ComicDTO])
}

enum ComicsCollectionContent {
    case loading
    case fail(Error)
    case success([Comic])
}

protocol ComicsCollectionUseCaseRepresenable {

    var state: ComicsCollectionState { get }
    var storeComics: [ComicDTO]? { get }
    var onRefresh: (() ->Void)? { get }

    func initView(onRefresh: (() -> Void)?)
    func reload()
    func loadNextPageIfNeeded(lastIndexShowed: Int)
    func close()
    func cellSize(from frameSize: CGSize, in identifier: String) -> CGSize
}

protocol ComicsCollectionObserver {
    func update(content: ComicsCollectionContent)
}

class ComicsCollectionUseCase: ComicsCollectionUseCaseRepresenable {


    private var provider: ComicsCollectionProviderReprentable
    private (set) var state: ComicsCollectionState
    private (set) var onRefresh: (() -> Void)?
    var storeComics: [ComicDTO]? {
        switch state {
        case .success(let comics) :
            return comics
        default:
            return nil
        }
    }

    init(state: ComicsCollectionState = .empty, provider: ComicsCollectionProviderReprentable) {
        self.state = state
        self.provider = provider
    }

    func initView(onRefresh: (() -> Void)?) {
        self.onRefresh = onRefresh
        provider.observer = self
        guard state != .loading else { return }
        provider.reload()
    }

    func reload() {
        provider.reload()
    }

    func loadNextPageIfNeeded(lastIndexShowed: Int) {
        guard shouldFetchNextPage(lastIndexShowed) else { return }
        provider.fetchNextPageIfPossible()
    }

    func close() {
        provider.observer = nil
    }

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
        guard case .success(let comics) = state else { return false }
        return (comics.count - lastIndexShowed) < Constants.offsetToLoadMore
    }

    private enum Constants {
        static let offsetToLoadMore = 10
    }
}

extension ComicsCollectionUseCase: ComicsCollectionObserver {

    func update(content: ComicsCollectionContent) {

        switch content {
        case .loading:
            guard storeComics == nil else { return }
            state = .loading
        case .fail(let error):
            state = .fail(.init(error: error))
        case .success(let comics):
            if comics.isEmpty {
                state = .empty
            } else {
                var array = self.storeComics ?? []
                array.append(contentsOf: comics.map({ .init(comic: $0) }))
                state = .success(array)
            }
        }
        onRefresh?()
    }

}
