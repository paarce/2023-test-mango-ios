//
//  FavComicViewModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation

struct FavComicViewModel {

    private let interaction: FavComicInteractionRepresentable

    init(interaction: FavComicInteractionRepresentable) {
        self.interaction = interaction
    }

    func deleteFavs(from favs: [FavComic],at offsets: IndexSet) {
      offsets.forEach { index in
          interaction.remove(fav: favs[index])
      }
    }
}
