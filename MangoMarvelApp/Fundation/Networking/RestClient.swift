//
//  RestClient.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation
import Combine

struct RestClient: RequestPerformer {

    private let configuration: URLSessionConfiguration
    private let session: URLSession

    init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        configuration = sessionConfiguration
        session = URLSession(configuration: configuration)
    }

    func perform<T, R>(request: T) -> AnyPublisher<R, Error> where T: RequestRepresentable, R: Decodable {
        session.dataTaskPublisher(for: request.urlRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw handleError(data: data, response: response)
                }
                return data
            }
            .decode (type: R.self, decoder: JSONDecoder())
            .mapError({ error -> Error in
                if let error = error as? APIError {
                    return error
                } else if let decoding = error as? DecodingError {
                    return APIError.handleDecoding(error: decoding)
                } else {
                    return APIError.unknown
                }
            })
            .receive(on: RunLoop.main).eraseToAnyPublisher()
    }

    private func handleError(data: Data, response: URLResponse) -> Error {

        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
        if let httpUrlResponse = response as? HTTPURLResponse {
            return APIError.handleResponse(
                code: httpUrlResponse.statusCode,
                message: errorResponse?.message
            )
        }
        return APIError.unknown
    }
}

