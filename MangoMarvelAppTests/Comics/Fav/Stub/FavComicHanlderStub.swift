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

    var fecthFavoritesIdsResult = [MangoMarvelApp.FavComic]()
    func fetch() -> [MangoMarvelApp.FavComic] {
        fecthFavoritesIdsResult
    }

    var addFavCalled = false
    func addFav(comic: MangoMarvelApp.ComicDTO) {
        addFavCalled = true
    }

    var removeFavCalled = false
    func removeFav(comic: MangoMarvelApp.ComicDTO) {
        removeFavCalled = true
    }

    var removeCalled = false
    func remove(fav: MangoMarvelApp.FavComic) {
        removeCalled = false
    }
    

}
