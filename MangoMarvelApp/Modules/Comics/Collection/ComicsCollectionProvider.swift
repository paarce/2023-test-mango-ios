//
//  ComicsCollectionProvider.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

protocol ComicsCollectionProviderReprentable {

    var service: ComicsCollectionServiceRepresentable { get }
    var offset: Int? { get }
    var observer: ComicsCollectionObserver? { get set }

    func reload()
    func fetchNextPageIfPossible()
}

class ComicsCollectionProvider: ComicsCollectionProviderReprentable {

    var observer: ComicsCollectionObserver?
    private (set) var service: ComicsCollectionServiceRepresentable
    private (set) var offset: Int?
    private var isLoading = false

    init(service: ComicsCollectionServiceRepresentable, offset: Int? = nil) {
        self.service = service
        self.offset = offset
    }

    //MARK: - ComicsCollectionProviderReprentable

    func reload() {
        fetch(offset: offset)
    }

    func fetchNextPageIfPossible() {
        let nextPage = (offset ?? 0) + 1
        fetch(offset: nextPage)
    }

    //MARK: - Private methods

    private func fetch(offset: Int?) {
        guard !isLoading else { return }
        isLoading = true
        self.observer?.update(content: .loading)

        service.fecth(
            options: .init(page: offset, keywords: nil)
        ) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.observer?.update(content: .success(response.data.results))

            case .failure(let error):
                self.observer?.update(content: .fail(error))
            }
        }
    }
}
