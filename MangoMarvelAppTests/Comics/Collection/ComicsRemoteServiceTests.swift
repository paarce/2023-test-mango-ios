//
//  ComicsCollectionServiceTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsRemoteServiceTests: XCTestCase {

    var client: URLSessionNetworkClientStub!
    var classUnderTest: ComicsRemoteService!
    
    override func setUpWithError() throws {
        client = .init()
        classUnderTest = ComicsRemoteServiceImpl(client: client)
    }

    func testFecth_whenBodyEmpty_success() async throws {
        try client.setResponse(codable: ComicsCollection(code: 200, status: "Ok", data: .mock(results: [.mock()])))
        let response = try await classUnderTest.fecth(options: .init(offset: nil))
        XCTAssertEqual(client.callCount, 1)
        XCTAssertEqual(response.data.results.count, 1)
    }

}
