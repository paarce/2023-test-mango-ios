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
    var favButtonImage: UIImage {
        isFav ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
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
