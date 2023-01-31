//
//  ComicsCollectionServiceStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation
@testable import MangoMarvelApp

final class ComicsRemoteServiceStub: ComicsRemoteService {


    var fetchCalled: ((MangoMarvelApp.ComicsEndpoint.Options) -> Void)?
    var fetchResult: MangoMarvelApp.ComicsCollection?

    func fecth(options: MangoMarvelApp.ComicsEndpoint.Options) async throws -> MangoMarvelApp.ComicsCollection {
        fetchCalled?(options)
        if let fetchResult {
            return fetchResult
        } else {
            throw APIError.serverError
        }
    }
    var findCalled: ((Int) -> Void)?
    var findResult: MangoMarvelApp.Comic?

    func find(id: Int) async throws -> MangoMarvelApp.Comic {
        findCalled?(id)
        if let findResult {
            return findResult
        } else {
            throw APIError.serverError
        }
    }
    
}
