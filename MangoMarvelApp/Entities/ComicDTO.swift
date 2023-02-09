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
    let dateFormatted: String?
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


        let saleDate = comic.dates.first(where: { $0.type == .sale })
        if let date = saleDate?.dateValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYYY"
            dateFormatted = dateFormatter.string(from: date)
        } else {
            dateFormatted = nil
        }

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

extension  Comic.Date {

    var dateValue: Date? {
        guard let sdate = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: sdate)
    }
}
