//
//  Environment.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

enum EnvironmentId {
    case dev
}

protocol EnvironmentRepresentable {
    var baseUrl: String { get }
    var id: EnvironmentId { get }
}

extension EnvironmentRepresentable {
    var baseUrl: String {
        switch id {
        case .dev:
            return "https://gateway.marvel.com:443/v1/public"
        }
    }
}

struct Environment: EnvironmentRepresentable {

    static var shared = Environment()

    let id: EnvironmentId

    private init() {
        self.id = .dev
    }
}
