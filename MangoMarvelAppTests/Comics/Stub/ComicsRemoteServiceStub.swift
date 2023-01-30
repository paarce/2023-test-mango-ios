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
    var result: Result<MangoMarvelApp.ComicsCollection, Error> = .failure(APIError.noData)

    func fecth(options: MangoMarvelApp.ComicsEndpoint.Options, completion: @escaping (Result<MangoMarvelApp.ComicsCollection, Error>) -> Void) {
        fecthCalled?(options)
        completion(result)
    }
    
}
