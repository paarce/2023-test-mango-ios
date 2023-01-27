//
//  FavComicHandler.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData

protocol FavComicHanlderRepresentable {

    var interaction: FavComicInteractionRepresentable { get }

    func fetch() -> [FavComic]
}

struct FavComicHandler: FavComicHanlderRepresentable {

    private var context: NSManagedObjectContext
    let interaction: FavComicInteractionRepresentable

    init(context: NSManagedObjectContext) {
        self.context = context
        self.interaction = FavComicInteraction(context: context)
    }

    func fetch() -> [FavComic] {

        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        let favs = try? context.fetch(fetchRequest)
        return favs ?? []
    }
}
