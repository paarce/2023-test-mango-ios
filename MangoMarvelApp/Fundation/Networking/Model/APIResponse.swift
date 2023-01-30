//
//  APIResponse.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let code: Int
    let status: String
    let data: T
}

struct CollectionResponse<M: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [M]
}

struct ErrorResponse: Codable {
    let code: String?
    let message: String?
}

struct ImageInfo: Codable {
    let path: String
    let fileExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}

extension ImageInfo {

    var url: URL? {
        URL(string: self.path + "." + self.fileExtension)
    }
}

