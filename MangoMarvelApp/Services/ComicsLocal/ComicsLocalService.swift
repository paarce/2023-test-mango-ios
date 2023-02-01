//
//  FavComicHandler.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData

protocol ComicsLocalService {
    func fetch() -> [FavComic]
    func addFav(comic: ComicDTO) throws
    func removeFav(comic: ComicDTO) throws
    func remove(fav: FavComic) throws
}

struct ComicsLocalServiceImpl: ComicsLocalService {

    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetch() -> [FavComic] {
        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        let favs = try? context.fetch(fetchRequest)
        return favs ?? []
    }

    func addFav(comic: ComicDTO) throws {
        guard fecthByComic(id: comic.id) == nil else { return }
        let newFavComic = FavComic(context: context)
        newFavComic.id = Int32(comic.id)
        newFavComic.title = comic.title
        newFavComic.shortDescrip = comic.body
        newFavComic.inlcudedDate = Date()
        try context.save()
    }

    func removeFav(comic: ComicDTO) throws {
        if let fav = fecthByComic(id: comic.id) {
            try remove(fav: fav)
        }
    }

    func remove(fav: FavComic) throws {
        context.delete(fav)
        try context.save()
    }

    private func fecthByComic(id: Int) -> FavComic? {
        let fetchRequest = FavComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %i", id
        )
        let favs = try? context.fetch(fetchRequest)
        return favs?.first
    }
}
