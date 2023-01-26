//
//  ComicsEndpointTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class EndpointTests: XCTestCase {
    
    var classUnderTest: EndpointRepresentable!


    override func tearDownWithError() throws {
        classUnderTest = nil
    }

    func testComicsEnpoint_default() throws {

        let options: ComicsEndpoint.Options = .init(offset: nil)
        classUnderTest = ComicsEndpoint(options: options)

        XCTAssertEqual(classUnderTest.id, .comics)
        XCTAssertEqual(classUnderTest.method, .get)
        XCTAssertTrue(classUnderTest.params.isEmpty)
        XCTAssertTrue(classUnderTest.header.isEmpty)
    }

    func testComicsEnpoint_withOffset() throws {

        let options: ComicsEndpoint.Options = .init(offset: 20)
        classUnderTest = ComicsEndpoint(options: options)

        XCTAssertEqual(classUnderTest.id, .comics)
        XCTAssertEqual(classUnderTest.method, .get)
        XCTAssertTrue(classUnderTest.header.isEmpty)
        XCTAssertFalse(classUnderTest.params.isEmpty)

        let value = classUnderTest.params["offset"]
        XCTAssertNotNil(value)
        let offset = try? XCTUnwrap(value as? String)
        XCTAssertEqual(offset, "20")
    }

}
