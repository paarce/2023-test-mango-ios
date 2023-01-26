//
//  ComicsCollectionProvider.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

protocol ComicsCollectionProviderReprentable {

    var service: ComicsCollectionServiceRepresentable { get }
    var observer: ComicsCollectionObserver? { get set }

    func reload()
    func fetchNextPageIfPossible()
}

class ComicsCollectionProvider: ComicsCollectionProviderReprentable {

    var observer: ComicsCollectionObserver?
    private (set) var service: ComicsCollectionServiceRepresentable
    private var page: Int
    private let limit = 20
    private var isLoading = false

    init(service: ComicsCollectionServiceRepresentable, page: Int = 0) {
        self.service = service
        self.page = page
    }

    //MARK: - ComicsCollectionProviderReprentable

    func reload() {
        fetch(page: page)
    }

    func fetchNextPageIfPossible() {
        fetch(page: page + 1)
    }

    //MARK: - Private methods

    private func fetch(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        self.observer?.update(content: .loading)

        service.fecth(
            options: .init(offset: page * limit)
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.page = response.data.offset / self.limit
                self.observer?.update(content: .success(response.data.results))

            case .failure(let error):
                self.observer?.update(content: .fail(error))
            }
        }
    }
}
