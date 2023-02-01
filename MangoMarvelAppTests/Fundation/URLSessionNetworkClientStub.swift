//
//  RequestPerformerStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation

@testable import MangoMarvelApp

class URLSessionNetworkClientStub: NetworkClient {

    var callCount = 0
    private var responseData: Data?

    func setResponse(codable: Codable) throws {
        responseData = try JSONEncoder().encode(codable)
    }

    func perform<Output>(for request: URLRequest) async throws -> Output where Output : Decodable {
        callCount += 1
        if let responseData {
            return try JSONDecoder().decode(Output.self, from: responseData)
        } else {
            throw APIError.badRequest
        }
    }
}
