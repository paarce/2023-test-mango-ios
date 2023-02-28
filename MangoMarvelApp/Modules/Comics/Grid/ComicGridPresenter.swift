//
//  ComicGridPresenter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 28/2/23.
//

import Foundation
import Combine

enum ComicsGridViewState {
    case loading
    case fail(Error)
    case idle
}

class ComicGridPresenter: ObservableObject {

    private var provider: ComicsProvider
    var state: ComicsGridViewState
    @Published var comics: [ComicGridDTO] = []

    private var cancellables = Set<AnyCancellable>()

    init(
        state: ComicsGridViewState = .idle, provider: ComicsProvider
    ) {
        self.state = state
        self.provider = provider
    }

    func initLoad() {
        guard comics.isEmpty else { return }
        state = .loading
        Task {
            do {
                let list = try await provider.reload()
                DispatchQueue.main.async {
                    self.comics = list.map { .init(comic: $0) }
                }
            } catch {
                self.state = .fail(error)
            }
        }
    }


    private enum Constants {
        static let offsetToLoadMore = 5
    }
}
