//
//  Model+extension.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation
@testable import MangoMarvelApp

extension Comic {

    static func mock(
        id: Int = 01,
        digitalId: Int? = 1234,
        title: String = "",
        description: String? = nil,
        thumbnail: ImageInfo = .mock(),
        prices: [Comic.Price] = [.mock()],
        dates: [Comic.ComicDate] = [.mock()],
        images: [ImageInfo] = [.mock()],
        creators: CreatorsContent = .mock(),
        stories: StoriesContent = .mock(),
        events: EventsContent = .mock()
    ) -> Comic {
        .init(
            id: id,
            digitalId: digitalId,
            title: title,
            description: description,
            thumbnail: thumbnail,
            prices: prices,
            dates: dates,
            images: images,
            creators: creators,
            stories: stories,
            events: events
        )
    }
}

extension Comic.ComicDate {
    static func mock(
        date: String? = "",
        type: String? = ""
    ) -> Comic.ComicDate {
        .init(date: date, type: type)
    }
}

extension Comic.Price {
    static func mock(
        price: Float? = 10,
        type: String? = ""
    ) -> Comic.Price {
        .init(price: price, type: type)
    }
}

extension Comic.Creator {
    static func mock(
        name: String = "",
        role: String? = ""
    ) -> Comic.Creator {
        .init(name: name, role: role)
    }
}

extension Comic.CreatorsContent {
    static func mock(
        items: [Comic.Creator] = [.mock()],
        uri: String? = ""
    ) -> Comic.CreatorsContent {
        .init(items: items, collectionURI: uri)
    }
}

extension Comic.Event {
    static func mock(
        name: String = ""
    ) -> Comic.Event {
        .init(name: name)
    }
}

extension Comic.EventsContent {
    static func mock(
        items: [Comic.Event] = [.mock()],
        uri: String? = ""
    ) -> Comic.EventsContent {
        .init(items: items, collectionURI: uri)
    }
}

extension Comic.Story {
    static func mock(
        name: String = "",
        type: String? = ""
    ) -> Comic.Story {
        .init(name: name, type: type)
    }
}

extension Comic.StoriesContent {
    static func mock(
        items: [Comic.Story] = [.mock()],
        uri: String? = ""
    ) -> Comic.StoriesContent {
        .init(items: items, collectionURI: uri)
    }
}

extension ComicsCollection {
    static func mock(
        offset: Int = 0,
        comics: [Comic] = [.mock()]
    ) -> ComicsCollection {
        APIResponse.mock(data: CollectionResponse<Comic>.mock(offset: offset, results: comics))
    }
}
