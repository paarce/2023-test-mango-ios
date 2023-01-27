//
//  FavComicInteraction.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import CoreData

protocol FavComicInteractionRepresentable {

    var context: NSManagedObjectContext { get }

    func add(comic: ComicDTO)
    func remove(comic: ComicDTO)
    func remove(fav: FavComic)

    @discardableResult
    func saveContext() -> Bool
}

struct FavComicInteraction: FavComicInteractionRepresentable {
    private (set) var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fecthByComic(id: Int) -> FavComic? {
        let fetchRequest = FavComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %i", id
        )
        let favs = try? context.fetch(fetchRequest)
        return favs?.first
    }

    func add(comic: ComicDTO) {
        let newFavComic = FavComic(context: context)
        newFavComic.id = Int32(comic.id)
        newFavComic.title = comic.title
        newFavComic.shortDescrip = comic.body
        newFavComic.inlcudedDate = Date()
        saveContext()
    }

    func remove(comic: ComicDTO) {
        if let fav = fecthByComic(id: comic.id) {
            remove(fav: fav)
        }
    }


    func remove(fav: FavComic) {
        context.delete(fav)
        saveContext()
    }

    @discardableResult
    func saveContext() -> Bool {
      do {
        try context.save()
          return true
      } catch {
        print("Error saving managed object context: \(error)")
          return false
      }
    }
}
