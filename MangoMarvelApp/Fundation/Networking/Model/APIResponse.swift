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
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let etag: String
    let data: T
}

struct CollectionResponse<M: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let result: [M]
}

struct ErrorResponse: Codable {
    let code: String?
    let message: String?
}
