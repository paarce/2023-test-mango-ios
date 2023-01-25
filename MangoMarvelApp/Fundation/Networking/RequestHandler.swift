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

        guard let baseUrl = URL(string: environment.baseUrl) else { throw APIError.requestCreation }
        let completeUrl = baseUrl.appendingPathComponent(endpoint.id.pathName)
        var urlRequest =  URLRequest(url: completeUrl)
        urlRequest.httpMethod = endpoint.method.rawValue

        headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        switch endpoint.method {
        case .post:
            guard let body = try? JSONSerialization.data(withJSONObject: endpoint.params)
            else { throw APIError.requestCreation }
            urlRequest.httpBody = body
        case .get:
            guard let params = endpoint.params as? [String: String]
            else { throw APIError.requestCreation }
            let items = params.map({ URLQueryItem(name: $0, value: $1)})
            if #available(iOS 16.0, *) {
                urlRequest.url?.append(
                    queryItems: params.map({ URLQueryItem(name: $0, value: $1)})
                )
            } else {
//                urlRequest.queryItems = items
            }
        default:
            break
        }

        print(urlRequest)
        self.urlRequest = urlRequest
    }
}





@available(iOS 13.0, *)
protocol RequestPerformer {
    func perform<T, R>(request: T)  -> AnyPublisher<R, Error> where T: RequestRepresentable, R: Decodable
}
