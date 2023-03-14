//
//  ComicsEndpoint.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

struct ComicsEndpoint: EndpointRepresentable {

    struct Options {
        let page: Int?
        let limit: Int
    }

    let id: EndpointSupported = .comics
    let method: HTTPMethod = .get
    let params: [String : Any]

    init(options: Options) {
        var params = [
            "limit": String(options.limit)
        ]
        if let page = options.page {
            params["offset"] = String(page / options.limit)
        }
        self.params = params
    }
}
