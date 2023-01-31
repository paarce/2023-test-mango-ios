//
//  URLSessionNetworkClient.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation

class URLSessionNetworkClient: NetworkClient {

    func perform<Output: Decodable>(for request: Request) async throws -> Output {

        let urlRequest = request.urlRequest

        print("Request URL: \(urlRequest)")
        print("Request Header: \(String(describing: urlRequest.allHTTPHeaderFields))")
        print("Request httpMethod: \(String(describing: urlRequest.httpMethod))")
        print("Request Body: \(String(decoding: urlRequest.httpBody ?? Data(), as: UTF8.self)))")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw handleError(data: data, response: response)
        }
        print("Response: \(urlRequest)")
        print("Response Data: \(String(decoding: data, as: UTF8.self))")
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
