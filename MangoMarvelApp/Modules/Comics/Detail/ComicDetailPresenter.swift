//
//  ComicDetailPresenter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import Foundation

enum ComicSection {
    case image(URL?)
    case basic(ComicDTO)
    case creators([GridItem])
    case stories([GridItem])
    case events([GridItem])
}

protocol ComicDetailPresenter {

    var sections: [ComicSection] { get }
}

final class ComicDetailPresenterImpl: ComicDetailPresenter {
    let sections: [ComicSection]

    init(comic: ComicDTO) {
        sections = [
            .image(comic.thumbnailURL),
            .basic(comic),
            .creators(comic.creators),
            .stories(comic.stories),
            .events(comic.events)
        ]
    }
}

extension ComicSection {
    var title: String {
        switch self {
        case .stories:
            return "COMICS_DETAIL_SECTION_STORIES".localized
        case .events:
            return "COMICS_DETAIL_SECTION_EVENTS".localized
        case .creators:
            return "COMICS_DETAIL_SECTION_CREATORS".localized
        default:
            return ""
        }
    }
}
