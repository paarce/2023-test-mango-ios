//
//  ComicsCollectionProviderStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation

@testable import MangoMarvelApp

final class ComicsCollectionProviderStub: ComicsProviderReprentable {
    var delegate: MangoMarvelApp.ComicsStateDelegate?

    var fetchComicsCalled = false
    func fetchComics() {
        fetchComicsCalled = true
    }

    var fetchComicsNextPageCalled = false
    func fetchComicsNextPage() {
        fetchComicsNextPageCalled = true
    }

    var fecthFavoritesIdsResult = [Int]()
    func fecthFavoritesIds() -> [Int] {
        fecthFavoritesIdsResult
    }

    var addFavoriteCalled = false
    func addFavorite(comic: MangoMarvelApp.ComicDTO) {
        addFavoriteCalled = true
    }

    var removeFavoriteCalled = false
    func removeFavorite(comic: MangoMarvelApp.ComicDTO) {
        removeFavoriteCalled = true
    }
}
