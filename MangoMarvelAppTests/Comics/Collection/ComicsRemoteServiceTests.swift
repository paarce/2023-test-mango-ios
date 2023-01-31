//
//  ComicsRemoteServiceTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 31/1/23.
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

    override func tearDownWithError() throws {
        client = nil
        classUnderTest = nil
    }

    func testFecth_whenBodyEmpty_success() async throws {
        try client.setResponse(codable: ComicsCollection.mock())
        let response = try await classUnderTest.fecth(options: .init(offset: nil))
        XCTAssertEqual(client.callCount, 1)
        XCTAssertEqual(response.data.offset, 0)
        XCTAssertEqual(response.data.results.count, 1)
    }

    func testFecth_whenOffsetPaseed_success() async throws {
        try client.setResponse(codable: ComicsCollection.mock(offset: 40))
        let response = try await classUnderTest.fecth(options: .init(offset: 20))
        XCTAssertEqual(client.callCount, 1)
        XCTAssertEqual(response.data.offset, 40)
        XCTAssertEqual(response.data.results.count, 1)
    }

    func testFecth_fail() async throws {
        do {
            let response = try await classUnderTest.fecth(options: .init(offset: nil))
            XCTAssertEqual(client.callCount, 1)
            XCTAssertEqual(response.data.offset, 0)
        } catch {
            XCTAssertNotNil(error as? APIError)
        }
    }
}
