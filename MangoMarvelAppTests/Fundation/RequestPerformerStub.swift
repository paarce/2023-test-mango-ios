//
//  RequestPerformerStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation
import Combine
@testable import MangoMarvelApp

class URLSessionNetworkClientStub: NetworkClient {


    var callCount = 0
    var responseData: Data!

    func setResponse(codable: Codable) throws {
        responseData = try JSONEncoder().encode(codable)
    }

    func perform<Output>(for request: MangoMarvelApp.Request) async throws -> Output where Output : Decodable {
        callCount += 1
        return try JSONDecoder().decode(Output.self, from: responseData)
    }
//    func perform<Output>(for request: MangoMarvelApp.Request) async throws -> Output where Output: Decodable {
//        callCount += 1
//        return reponseData
//    }
}
