//
//  RequestHandler.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation
import Combine

protocol RequestRepresentable {
    var urlRequest: URLRequest { get }
}

struct Request: RequestRepresentable {

    private let headers: [String: String] = [:]
    let urlRequest: URLRequest

    init(environment: EnvironmentRepresentable = Environment.shared, endpoint: EndpointRepresentable) throws {

        var urlComponents = environment.baseUrlComponents
        urlComponents.path = urlComponents.path.appending(endpoint.id.pathName)
        urlComponents.queryItems = Request.authQueryItems(privateKey: environment.privateKey, publicKey: environment.publicKey)
        var body: Data?

        switch endpoint.method {
        case .post:
            guard let bodyContent = try? JSONSerialization.data(withJSONObject: endpoint.params)
            else { throw APIError.requestCreation }
            body = bodyContent
        case .get:
            guard let params = endpoint.params as? [String: String]
            else { throw APIError.requestCreation }
            urlComponents.queryItems?
                .append(contentsOf: params.map({ URLQueryItem(name: $0, value: $1)}))
        default:
            break
        }

        guard let baseURL = urlComponents.url else { throw APIError.requestCreation }
        var urlRequest =  URLRequest(url: baseURL)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = body

        headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        print(urlRequest)
        self.urlRequest = urlRequest
    }

    //TODO: Find a real place to this and keys
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


@available(iOS 13.0, *)
protocol RequestPerformer {
    func perform<T, R>(request: T)  -> AnyPublisher<R, Error> where T: RequestRepresentable, R: Decodable
}
