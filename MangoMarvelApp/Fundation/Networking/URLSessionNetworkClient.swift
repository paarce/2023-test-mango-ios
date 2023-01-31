//
//  URLSessionNetworkClient.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation

class URLSessionNetworkClient: NetworkClient {

    func perform<Output: Decodable>(for request: URLRequest) async throws -> Output {

        print("Request URL: \(request)")
        print("Request Header: \(String(describing: request.allHTTPHeaderFields))")
        print("Request httpMethod: \(String(describing: request.httpMethod))")
        print("Request Body: \(String(decoding: request.httpBody ?? Data(), as: UTF8.self)))")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw handleError(data: data, response: response)
        }

        do {
            let decodedResponseData = try JSONDecoder().decode(Output.self, from: data)
            return decodedResponseData
        } catch (let error) {
            if let error = error as? APIError {
                throw error
            } else if let decoding = error as? DecodingError {
                throw APIError.handleDecoding(error: decoding)
            } else {
                throw APIError.unknown
            }
        }
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
