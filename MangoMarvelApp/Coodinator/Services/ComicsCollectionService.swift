//
//  ComicsCollectionService.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation
import Combine

protocol ComicsCollectionServiceRepresentable {
    func fecth(
        options: ComicsEndpoint.Options,
        completion: @escaping (Result<ComicsCollection, Error>) -> Void
    )
}

class ComicsCollectionService: ComicsCollectionServiceRepresentable {

    private let client: RequestPerformer
    var anyCancellable: AnyCancellable?

    init(client: RequestPerformer = RestClient()) {
        self.client = client
    }

    func fecth(
        options: ComicsEndpoint.Options,
        completion: @escaping (Result<ComicsCollection, Error>) -> Void
    ) {
        let endpoint = ComicsEndpoint(options: options)
        do {
            let request = try Request(endpoint: endpoint)
            anyCancellable = client.perform(request: request)
                .sink(receiveCompletion: { result in
                    guard case .failure(let error) = result else { return }
                    completion(.failure(error))
                }, receiveValue: { (episodeList: ComicsCollection) in
                    completion(.success(episodeList))
                })
        } catch( let error) {
            completion(.failure(error))
        }
    }
}
