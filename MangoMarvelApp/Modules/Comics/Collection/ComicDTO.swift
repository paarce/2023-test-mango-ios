//
//  ComicDTO.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

class ComicDTO {

    let title: String
    let body: String
    let imageURL: URL?
    var image: UIImage?

    init(comic: Comic) {
        title = "\(comic.id) - \(comic.title)"
        body = comic.description ?? ""
        let str = comic.thumbnail.path + "." + comic.thumbnail.fileExtension
        imageURL = URL(string: str)
    }
}
