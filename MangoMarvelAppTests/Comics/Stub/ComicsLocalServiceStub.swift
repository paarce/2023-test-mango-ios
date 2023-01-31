//
//  FavComicHanlderStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData
@testable import MangoMarvelApp

class ComicsLocalServiceStub: ComicsLocalService {

    var fecthFavoritesResult = [MangoMarvelApp.FavComic]()
    func fetch() -> [MangoMarvelApp.FavComic] {
        fecthFavoritesResult
    }

    var addFavCount = 0
    func addFav(comic: MangoMarvelApp.ComicDTO) {
        addFavCount += 1
    }

    var removeFavCount = 0
    func removeFav(comic: MangoMarvelApp.ComicDTO) {
        removeFavCount += 1
    }

    var removeCount = 0
    func remove(fav: MangoMarvelApp.FavComic) {
        removeCount += 1
    }
}
