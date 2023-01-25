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
        completion: @escaping (Result<Codable, Error>) -> Void
    )
}

@available(iOS 13.0, *)
class ComicsCollectionServiceService: ComicsCollectionServiceRepresentable {

    private let client: RequestPerformer
    var anyCancellable: AnyCancellable?

    init(client: RequestPerformer = RestClient()) {
        self.client = client
    }

    func fecth(
        options: ComicsEndpoint.Options,
        completion: @escaping (Result<Codable, Error>) -> Void
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

struct Comic: Codable {
    let id: Int
    let digitalId: Int?
    let title: String?
    let variantDescription: String?
    let description: String?
    let modified: String?
}

typealias ComicsCollection = APIResponse<CollectionResponse<Comic>>
