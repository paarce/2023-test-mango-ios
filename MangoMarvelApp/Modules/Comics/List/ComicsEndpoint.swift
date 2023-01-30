//
//  ComicsEndpoint.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

struct ComicsEndpoint: EndpointRepresentable {

    struct Options {
        let offset: Int?
    }

    let id: EndpointSupported = .comics
    let method: HTTPMethod = .get
    let params: [String : Any]

    init(options: Options) {
        var params: [String: String] = [:]
        if let offset = options.offset {
            params["offset"] = "\(offset)"
        }
        self.params = params
    }
}
