//
//  ComicDTO.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

struct ComicDTO {

    let title: String
    let body: String
    let imageURL: URL?

    init(comic: Comic) {
        title = comic.title ?? ""
        body = comic.description ?? ""
        imageURL = nil
    }
}
