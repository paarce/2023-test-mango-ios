//
//  EndpointRepresentable.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum HTTPMethod: String {
    case put = "put"
    case post = "post"
    case get = "get"
    case delete = "delete"
}

protocol EndpointRepresentable {
    var id: EndpointSupported { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    var headers: [String: String] { get }
}

extension EndpointRepresentable {
    var headers: [String: String] { [:] }
}

enum EndpointSupported: Equatable {
    case comics
    case comic(id: Int)

    var pathName: String {
        switch self {
        case .comics:
            return "/comics"
        case .comic(let id):
            return "/comics/\(id)"
        }
    }
}
