//
//  RequestHandler.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation
import Combine

struct APIRequest {

    static func urlRequest(
        by endpoint: EndpointRepresentable,
        environment: EnvRepresentable = AppState.shared.currentEnv
    ) throws ->  URLRequest {

        var urlComponents = environment.baseUrlComponents
        urlComponents.path = urlComponents.path.appending(endpoint.id.pathName)
        urlComponents.queryItems = APIRequest.authQueryItems(privateKey: environment.privateKey, publicKey: environment.publicKey)
        var body: Data?

        switch endpoint.method {
        case .post:
            guard let bodyContent = try? JSONSerialization.data(withJSONObject: endpoint.params)
            else { throw APIError.badRequest }
            body = bodyContent
        case .get:
            guard let params = endpoint.params as? [String: String]
            else { throw APIError.badRequest }
            urlComponents.queryItems?
                .append(contentsOf: params.map({ URLQueryItem(name: $0, value: $1)}))
        default:
            break
        }

        guard let baseURL = urlComponents.url else { throw APIError.badRequest }
        var urlRequest =  URLRequest(url: baseURL)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = body

        endpoint.headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }

    private static func authQueryItems(privateKey: String, publicKey: String) -> [URLQueryItem] {

        let timestamp = String(NSDate().timeIntervalSince1970)
        let hash = Encrypt.md5Hex(text: timestamp+privateKey+publicKey)
        return [
            URLQueryItem(name: Constants.Keys.ts, value: timestamp),
            URLQueryItem(name: Constants.Keys.apiKey, value: publicKey),
            URLQueryItem(name: Constants.Keys.hash, value: hash),
        ]
    }

    private enum Constants {
        enum Keys {
            static let ts = "ts"
            static let apiKey = "apikey"
            static let hash = "hash"
        }
    }
}
