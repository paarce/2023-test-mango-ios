//
//  ComicCellViewModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import UIKit

class ComicCellViewModel {

    let dto: ComicDTO
    let interaction: FavComicInteractionRepresentable
    var image: UIImage?
    var favButtonText: String {
        isFav ? "Remove fav" : "Add fav"
    }
    var isFav: Bool {
        didSet {
            handleFav()
        }
    }

    init(
        comic: Comic,
        image: UIImage? = nil,
        isFav: Bool,
        interaction: FavComicInteractionRepresentable
    ) {
        self.dto = .init(comic: comic)
        self.image = image
        self.isFav = isFav
        self.interaction = interaction
    }

    func handleFav() {
        if isFav {
            interaction.add(comic: dto)
        } else {
            interaction.remove(comic: dto)
        }
    }
}
