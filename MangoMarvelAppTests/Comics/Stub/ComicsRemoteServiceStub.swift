//
//  ComicsCollectionServiceStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation
@testable import MangoMarvelApp

final class ComicsRemoteServiceStub: ComicsRemoteService {

    var fecthCalled: ((MangoMarvelApp.ComicsEndpoint.Options) -> Void)?
    var result: MangoMarvelApp.ComicsCollection?

    func fecth(options: MangoMarvelApp.ComicsEndpoint.Options) async throws -> MangoMarvelApp.ComicsCollection {
        fecthCalled?(options)
        if let result {
            return result
        } else {
            throw APIError.serverError
        }
    }
    
}
