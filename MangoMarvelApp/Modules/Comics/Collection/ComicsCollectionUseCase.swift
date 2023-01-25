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
    case error
    case success
}

protocol ComicsCollectionUseCaseRepresenable {

    var state: ComicsCollectionState { get }

    func initView()
    func reload()
    func moveTo(page: Int)
}

class ComicsCollectionUseCase: ComicsCollectionUseCaseRepresenable {

    private var provider: ComicsCollectionProviderReprentable
    private (set) var state: ComicsCollectionState

    init(state: ComicsCollectionState = .empty, provider: ComicsCollectionProviderReprentable) {
        self.state = state
        self.provider = provider
    }

    func initView() {
        guard state != .loading else { return }
        self.provider.reload()
    }

    func reload() {
        self.provider.reload()
    }

    func moveTo(page: Int) {
        self.provider.fetchNextPageIfPossible()
    }
}
