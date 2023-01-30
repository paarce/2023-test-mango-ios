//
//  ComicCellViewModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import UIKit

protocol ComicsInteractionDelegate {
    func addFav(comic: ComicDTO)
    func removeFav(comic: ComicDTO)
}

class ComicCellViewModel {

    let dto: ComicDTO
    let interaction: ComicsInteractionDelegate
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
        interaction: ComicsInteractionDelegate
    ) {
        self.dto = .init(comic: comic)
        self.image = image
        self.isFav = isFav
        self.interaction = interaction
    }

    func handleFav() {
        if isFav {
            interaction.addFav(comic: dto)
        } else {
            interaction.removeFav(comic: dto)
        }
    }
}
