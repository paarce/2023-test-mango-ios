//
//  Model+mocks.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation
@testable import MangoMarvelApp

extension ImageInfo {
    static func mock(
        path: String = "",
        fileExtension: String = ""
    ) -> ImageInfo {
        .init(path: path, fileExtension: fileExtension)
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
