//
//  TripListPresenter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 6/2/23.
//

import Foundation
import Combine

enum ComicsListViewState {
    case loading
    case fail(Error)
    case idle
}

class ComicListPresenter: ObservableObject {

    let router = ComicListRouter()
    private var interactor: ComicListInteractor

    @Published var state: ComicsListViewState
    @Published var comics: [Comic] = []

    private var cancellables = Set<AnyCancellable>()

    init(state: ComicsListViewState = .idle, interactor: ComicListInteractor) {
        self.state = state
        self.interactor = interactor

        interactor.$comics
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] comics in
                self?.comics = comics
                self?.state = .idle
            })
            .store(in: &cancellables)
    }

    func initLoad() {
        guard comics.isEmpty else { return }
        state = .loading
        interactor.load()
    }

    func loadNextPageIfNeed(_ lastComicShown: Comic) {
        let divider = comics.count - Constants.offsetToLoadMore
        guard let index = comics.firstIndex(of: lastComicShown), index > divider else {
            return
        }
        interactor.loadNextPage()
    }

    

    private enum Constants {
        static let offsetToLoadMore = 5
    }
}
