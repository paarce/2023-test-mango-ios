//
//  FavComicHanlderStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData
@testable import MangoMarvelApp

class FavComicInteractionStub: FavComicInteractionRepresentable {
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(comic: MangoMarvelApp.ComicDTO) {

    }

    func remove(comic: MangoMarvelApp.ComicDTO) {

    }

    func remove(fav: MangoMarvelApp.FavComic) {

    }

    func saveContext() -> Bool {
        true
    }
}

class FavComicHanlderStub: FavComicHanlderRepresentable {
    var interaction: MangoMarvelApp.FavComicInteractionRepresentable

    init(context: NSManagedObjectContext) {
        self.interaction = FavComicInteractionStub(context: context)
    }
    func fetch() -> [MangoMarvelApp.FavComic] {
        []
    }
}
