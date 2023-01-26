//
//  RequestPerformerStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation
import Combine
@testable import MangoMarvelApp

//struct RequestPerformerStub: RequestPerformer {
//
//    var performCalled: (() -> Void)?
//    var result: Result<MangoMarvelApp.RequestRepresentable, Error> = .failure(APIError.noData)
//
//    func perform<T, R>(request: T) -> AnyPublisher<R, Error> where T : MangoMarvelApp.RequestRepresentable, R : Decodable {
//        performCalled?()
//        switch result {
//        case .success(let model):
//
//            return Just<MangoMarvelApp.RequestRepresentable>(model)
//                    .setFailureType(to: APIError.self) // <--
//                    .eraseToAnyPublisher()
//        case .failure(let error):
//            return Just(error).eraseToAnyPublisher()
//        }
//    }
//}
