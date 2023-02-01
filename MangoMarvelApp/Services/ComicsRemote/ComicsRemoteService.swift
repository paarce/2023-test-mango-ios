//
//  ComicsCollectionService.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

protocol ComicsRemoteService {
    func fecth(
        options: ComicsEndpoint.Options
    ) async throws -> ComicsCollection

    func find(
        id: Int
    ) async throws -> Comic
}

class ComicsRemoteServiceImpl: ComicsRemoteService {

    private let client: NetworkClient

    init(client: NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func fecth(
        options: ComicsEndpoint.Options
    ) async throws -> ComicsCollection {
        let endpoint = ComicsEndpoint(options: options)
        return try await client.perform(for: APIRequest.urlRequest(by: endpoint))
    }

    func find(id: Int) async throws -> Comic {
        let endpoint = ComicDetailEndpoint(id: id)
        let collection: ComicsCollection = try await client.perform(for: APIRequest.urlRequest(by: endpoint))
        if let comic = collection.data.results.first {
            return comic
        } else {
            throw APIError.serverError
        }
    }
}
