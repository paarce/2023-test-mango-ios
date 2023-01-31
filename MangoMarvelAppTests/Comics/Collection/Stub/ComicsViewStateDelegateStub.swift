//
//  ComicsViewStateDelegateStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation
@testable import MangoMarvelApp

class ComicsViewStateDelegateStub: ComicsViewStateDelegate {

    var onCalled: (() -> Void)?
    var stateChangedCount = 0
    func stateUpdated() {
        stateChangedCount += 1
        onCalled?()
    }
}

class ComicsInteractionDelegateStub: ComicsInteractionDelegate {

    var addFavCount = 0
    func addFav(comic: MangoMarvelApp.ComicDTO) {
        addFavCount += 1
    }

    var removeFavCount = 0
    func removeFav(comic: MangoMarvelApp.ComicDTO) {
        removeFavCount += 1
    }

}
