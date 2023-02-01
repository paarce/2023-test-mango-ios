//
//  ComicDetailEndpoint.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation

struct ComicDetailEndpoint: EndpointRepresentable {

    let id: EndpointSupported
    let method: HTTPMethod = .get
    let params: [String : Any]

    init(id: Int) {
        self.id = .comic(id: id)
        self.params = [:]
    }
}
