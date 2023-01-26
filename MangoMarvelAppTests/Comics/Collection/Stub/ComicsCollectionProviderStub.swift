//
//  ComicsCollectionProviderStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation

@testable import MangoMarvelApp

final class ComicsCollectionProviderStub: ComicsCollectionProviderReprentable {
    
    var observer: MangoMarvelApp.ComicsCollectionObserver?

    var reloadCalled = false
    func reload() {
        reloadCalled = true
    }

    var fetchNextPageIfPossibleCalled = false
    func fetchNextPageIfPossible() {
        fetchNextPageIfPossibleCalled = true
    }
}
