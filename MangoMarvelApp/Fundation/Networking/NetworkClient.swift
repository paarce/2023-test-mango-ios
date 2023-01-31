//
//  NetworkClient.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import Foundation

protocol NetworkClient {
    func perform<Output: Decodable>(for request: URLRequest) async throws -> Output
}
