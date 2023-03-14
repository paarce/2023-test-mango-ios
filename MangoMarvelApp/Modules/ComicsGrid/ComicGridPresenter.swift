//
//  ComicGridPresenter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 28/2/23.
//
import SwiftUI
import Combine

enum ComicsGridViewState {
    case loading
    case fail(Error)
    case idle
}

@available(iOS 15.0, *)
class ComicGridPresenter: ObservableObject {

    let router = ComicListRouter()
    private var interactor: ComicListInteractor
    var state: ComicsGridViewState
    @Published var comics: [ComicGridModel] = []

    private var cancellables = Set<AnyCancellable>()

    init(
        state: ComicsGridViewState = .idle, interactor: ComicListInteractor
    ) {
        self.state = state
        self.interactor = interactor

        interactor.$comics
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] comics in
                self?.comics = comics.map { .init(comic: $0) }
                self?.state = .idle
            })
            .store(in: &cancellables)
    }

    func initLoad() {
        guard comics.isEmpty else { return }
        state = .loading
        interactor.load()
    }

    func loadNextPageIfNeed(_ lastItemShown: ComicGridModel) {
        let divider = comics.count - Constants.offsetToLoadMore
        guard let index = comics.firstIndex(of: lastItemShown), index > divider else {
            return
        }
//        interactor.loadNextPage()
    }

    func gridCell(_ item: ComicGridModel) -> some View {
        NavigationLink(
            destination: router.makeDetailView(for: interactor.comics.first(where: { $0.id == item.id })),
            label: {
                ComicGridItemView(comic: item)
                    .onAppear(perform: { self.loadNextPageIfNeed(item) })
            }
        )
    }

    private enum Constants {
        static let offsetToLoadMore = 2
    }
}
