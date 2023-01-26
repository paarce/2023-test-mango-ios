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
        thumbnail: ImageInfo = .init(path: "", fileExtension: "")
    ) -> Comic {
        .init(id: id, digitalId: digitalId, title: title, description: description, thumbnail: thumbnail)
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

extension CollectionResponse {

    static func mock<T: Codable>(
        offset: Int = 0,
        limit: Int = 20,
        total: Int = 200,
        count: Int = 0,
        results: [T]
    ) -> CollectionResponse<T> {
        .init(offset: offset, limit: limit, total: total, count: count, results: results)
    }
}

extension APIResponse {

    static func mock<T: Codable>(data: T) -> APIResponse<T> {
        .init(code: 200, status: "ok", data: data)
    }
}
