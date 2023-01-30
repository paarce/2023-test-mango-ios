//
//  ComicModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import Foundation

struct Comic: Codable {
    let id: Int
    let digitalId: Int?
    let title: String
    let description: String?
    let thumbnail: ImageInfo
    let prices: [Price]
    let dates: [ComicDate]
    let images: [ImageInfo]
    let creators: CreatorsContent
    let stories: StoriesContent
    let events: EventsContent
}

extension Comic: Equatable {
    static func == (lhs: Comic, rhs: Comic) -> Bool {
        lhs.id == rhs.id
    }
}

extension Comic {
    struct Price: Codable {
        let price: Float?
        let type: String?
    }

    struct Date: Codable {
        let date: String?
        let type: String?
    }

    struct ComicDate: Codable {
        let date: String?
        let type: String?
    }
}
extension Comic {
    struct CreatorsContent: Codable {
        let items: [Creator]
        let collectionURI: String?
    }

    struct Creator: Codable {
        let name: String?
        let role: String?
    }
}

extension Comic {
    struct StoriesContent: Codable {
        let items: [Story]
        let collectionURI: String?
    }

    struct Story: Codable {
        let name: String?
        let type: String?
    }
}

extension Comic {
    struct EventsContent: Codable {
        let items: [Event]
        let collectionURI: String?
    }

    struct Event: Codable {
        let name: String?
    }
}

typealias ComicsCollection = APIResponse<CollectionResponse<Comic>>
