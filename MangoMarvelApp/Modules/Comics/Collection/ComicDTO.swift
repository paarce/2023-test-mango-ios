//
//  ComicDTO.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import UIKit

struct ComicDTO {

    let id: Int
    let title: String
    let body: String
    let imageURL: URL?

    init(comic: Comic) {
        id = comic.id
        title = comic.title
        body = comic.description ?? ""
        let str = comic.thumbnail.path + "." + comic.thumbnail.fileExtension
        imageURL = URL(string: str)
    }
}
