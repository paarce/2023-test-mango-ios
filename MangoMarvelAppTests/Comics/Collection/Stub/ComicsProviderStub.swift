//
//  ComicsCollectionProviderStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation

@testable import MangoMarvelApp

final class ComicsProviderStub: ComicsProvider {

    var reloadCount = 0
    var reloadResult: [MangoMarvelApp.Comic]?

    func reload() async throws -> [MangoMarvelApp.Comic] {
        reloadCount += 1
        if let data = reloadResult {
            return data
        } else {
            throw APIError.serverError
        }
    }

    var fetchNextPageComicsCount = 0
    var fetchNextPageComicsResult: [MangoMarvelApp.Comic]?
    func fetchNextPageComics() async throws -> [MangoMarvelApp.Comic] {
        fetchNextPageComicsCount += 1
        if let data = fetchNextPageComicsResult {
            return data
        } else {
            throw APIError.serverError
        }
    }

    var fecthFavoritesIdsCount = 0
    var fecthFavoritesIdsResult = [Int]()
    func fecthFavoritesIds() -> [Int] {
        fecthFavoritesIdsCount += 1
        return fecthFavoritesIdsResult
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
