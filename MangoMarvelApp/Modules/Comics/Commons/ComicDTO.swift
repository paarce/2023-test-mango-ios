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
    let thumbnailURL: URL?
    let price: String?
    let images: [URL]
    let creators: [GridItem]
    let events: [GridItem]
    let stories: [GridItem]

    init(comic: Comic) {
        id = comic.id
        title = comic.title
        body = comic.description ?? ""
        thumbnailURL = comic.thumbnail.url
        images = comic.images.compactMap({ $0.url })
        creators = comic.creators.items.compactMap({ .init(creator: $0) })
        events = comic.events.items.compactMap({ .init(event: $0) })
        stories = comic.stories.items.compactMap({ .init(story: $0) })
        if let price = comic.prices.first?.price {
            self.price = String(format: "$%.02f", price)
        } else {
            price = nil
        }
    }
}


extension GridItem {

    init?(creator: Comic.Creator) {
        guard let name = creator.name else { return nil }
        self = .init(title: name, subtitle: creator.role)
    }

    init?(story: Comic.Story) {
        guard let type = story.type else { return nil }
        self = .init(title: type, subtitle: story.name)
    }

    init?(event: Comic.Event) {
        guard let name = event.name else { return nil }
        self = .init(title: name, subtitle: nil)
    }
}
