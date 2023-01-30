//
//  ComicsCollectionProviderStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation

@testable import MangoMarvelApp

final class ComicsProviderStub: ComicsProvider {
    var delegate: MangoMarvelApp.ComicsStateDelegate?

    var fetchComicsPageCalled: Int?
    func fetchComics(page: Int) {
        fetchComicsPageCalled = page
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
