//
//  FavComicViewModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation

struct FavComicViewModel {

    private let localService: ComicsLocalService

    init(localService: ComicsLocalService) {
        self.localService = localService
    }

    func deleteFavs(from favs: [FavComic],at offsets: IndexSet) {
      offsets.forEach { index in
          localService.remove(fav: favs[index])
      }
    }
}
