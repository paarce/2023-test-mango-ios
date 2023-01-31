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
    func addFav(comic: ComicDTO)
    func removeFav(comic: ComicDTO)
    func remove(fav: FavComic)
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

    func addFav(comic: ComicDTO) {
        let newFavComic = FavComic(context: context)
        newFavComic.id = Int32(comic.id)
        newFavComic.title = comic.title
        newFavComic.shortDescrip = comic.body
        newFavComic.inlcudedDate = Date()
        saveContext()
    }

    func removeFav(comic: ComicDTO) {
        if let fav = fecthByComic(id: comic.id) {
            remove(fav: fav)
        }
    }

    func remove(fav: FavComic) {
        context.delete(fav)
        saveContext()
    }


    private func saveContext() {
      do {
        try context.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
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
