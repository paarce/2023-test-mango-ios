//
//  ComicsProviderLocalServiceTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsProviderLocalServiceTests: XCTestCase {

    var classUnderTest: ComicsProviderImpl!
    var localService: ComicsLocalServiceStub!

    override func setUpWithError() throws {
        localService = .init()
        classUnderTest = ComicsProviderImpl(remoteService: ComicsRemoteServiceStub(), localService: localService)
    }

    override func tearDownWithError() throws {
        localService = nil
        classUnderTest = nil
    }

    func testFetchFavorites_sucess() throws {

        localService.fecthFavoritesResult = [.mock(id: 1), .mock(id: 2), .mock(id: 3)]
        let ids = classUnderTest.fecthFavoritesIds()

        XCTAssertEqual(ids, [1, 2, 3])
    }

    func testFetchFavorites_sucess_whenEmpty() throws {

        localService.fecthFavoritesResult = []

        let ids = classUnderTest.fecthFavoritesIds()

        XCTAssertEqual(ids.count, 0)
    }

}
