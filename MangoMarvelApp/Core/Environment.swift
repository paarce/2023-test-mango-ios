//
//  Environment.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum EnvId {
    case dev
}

protocol EnvRepresentable {
    var baseUrlComponents: URLComponents { get }
    var id: EnvId { get }
}

extension EnvRepresentable {

    var baseUrlComponents: URLComponents {
        switch id {
        case .dev:
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "gateway.marvel.com"
            urlComponents.port = 443
            urlComponents.path = "/v1/public"
            return urlComponents
        }
    }

    var publicKey: String { "460ecb68c512ca20b4dda022c5451542" }
    var privateKey: String {"5fde302bf4439b5728d18383c8171021e47ea9c9" }
}

struct Env: EnvRepresentable {
    let id: EnvId

    init(id: EnvId = .dev) {
        self.id = id
    }
}
