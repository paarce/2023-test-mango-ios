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
        let request = try! APIRequest(endpoint: endpoint)
        return try await client.perform(for: request)
    }
}
