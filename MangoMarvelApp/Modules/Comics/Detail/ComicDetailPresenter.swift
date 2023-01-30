//
//  ComicDetailPresenter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import Foundation

enum ComicSection {
    case basic(ComicDTO)
}

protocol ComicDetailPresenter {

    var sections: [ComicSection] { get }
}

final class ComicDetailPresenterImpl: ComicDetailPresenter {
    let sections: [ComicSection]

    private let comic: ComicDTO

    init(comic: ComicDTO) {
        self.comic = comic
        sections = [.basic(comic)]
    }


}
