//
//  NetworkClient.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation

protocol Request {
    var urlRequest: URLRequest { get }
}

protocol NetworkClient {
    func perform<Output: Decodable>(for request: Request) async throws -> Output
}
