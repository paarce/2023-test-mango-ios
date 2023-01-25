//
//  File.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum ComicsCollectionState {
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
    var onRefresh: (() ->Void)? { get }

    func initView(onRefresh: (() -> Void)?)
    func reload()
    func moveTo(page: Int)
    func close()
}

protocol ComicsCollectionObserver {
    func update(content: ComicsCollectionContent)
}

class ComicsCollectionUseCase: ComicsCollectionUseCaseRepresenable {

    private var provider: ComicsCollectionProviderReprentable
    var onRefresh: (() -> Void)?
    private (set) var state: ComicsCollectionState

    init(state: ComicsCollectionState = .empty, provider: ComicsCollectionProviderReprentable) {
        self.state = state
        self.provider = provider
    }

    func initView(onRefresh: (() -> Void)?) {
        self.onRefresh = onRefresh
        provider.observer = self
//        guard case .loading = state else { return }
        provider.reload()
    }

    func reload() {
        provider.reload()
    }

    func moveTo(page: Int) {
        provider.fetchNextPageIfPossible()
    }

    func close() {
        provider.observer = nil
    }
}

extension ComicsCollectionUseCase: ComicsCollectionObserver {

    func update(content: ComicsCollectionContent) {

        switch content {
        case .loading:
            self.state = .loading
        case .fail(let error):
            self.state = .fail(.init(error: error))
        case .success(let comics):
            if comics.isEmpty {
                self.state = .empty
            } else {
                self.state = .success(comics.map({ .init(comic: $0) }))
            }
        }
        onRefresh?()
        
    }

}
