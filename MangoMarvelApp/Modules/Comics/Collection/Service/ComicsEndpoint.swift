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
        let keywords: String?
    }

    let id: EndpointSupported = .comics
    let method: HTTPMethod = .get
    let params: [String : Any]

    init(options: Options) {
        var params: [String: String] = [:]
        if let page = options.page {
            params["page"] = "\(page)"
        }
        if let keywords = options.keywords  {
            params["name"] = keywords
        }
        self.params = params
    }
}
