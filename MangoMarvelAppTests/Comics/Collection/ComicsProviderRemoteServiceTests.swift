//
//  ComicsCollectionProviderTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsProviderRemoteServicesTests: XCTestCase {

    var classUnderTest: ComicsProviderImpl!
    var remoteService: ComicsRemoteServiceStub!

    override func setUpWithError() throws {
        remoteService = .init()
        classUnderTest = ComicsProviderImpl(remoteService:remoteService, localService: ComicsLocalServiceStub())
    }

    override func tearDownWithError() throws {
        remoteService = nil
        classUnderTest = nil
    }

    func testInitialFetchComics_success() async throws {

        //Given
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.fetchResult = .mock(comics: comics)

        //When
        remoteService.fetchCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 0)
        }
        let comicsFecthed = try await classUnderTest.reload()

        //Then
        XCTAssertEqual(comics, comicsFecthed)
    }

    func testFetchComics_nextPage_success() async throws {

        //Given
        var numPage = 0
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.fetchResult = .mock(comics: comics)

        //When
        remoteService.fetchCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, numPage * 20)
        }
        var comicsFecthed = try await classUnderTest.reload()
        XCTAssertEqual(comics, comicsFecthed)
        numPage += 1

        comicsFecthed = try await classUnderTest.fetchNextPageComics()
        XCTAssertEqual(comics, comicsFecthed)
    }

    func testFetchComics_reload_fromAnotherPage_success() async throws {

        //Given
        let numPage = 1
        let offset = numPage * 20
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.fetchResult = .mock(offset: offset, comics: comics)
        let _ = try await classUnderTest.fetchNextPageComics()

        //When
        remoteService.fetchCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, offset)
        }
        let comicsFecthed = try await classUnderTest.reload()

        //Then
        XCTAssertEqual(comics, comicsFecthed)
    }

    func testFetchComics_nextPage_fromAnotherPage_success() async throws {

        var numPage = 0
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.fetchResult = .mock(comics: comics)

        //When
        remoteService.fetchCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, numPage * 20)
        }
        var comicsFecthed = try await classUnderTest.fetchNextPageComics()
        XCTAssertEqual(comics, comicsFecthed)
        numPage += 1

        comicsFecthed = try await classUnderTest.fetchNextPageComics()
        XCTAssertEqual(comics, comicsFecthed)
    }

    func testInitialFetchComics_fail() async throws {

        //When
        remoteService.fetchCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 0)
        }
        do {
            let _ = try await classUnderTest.reload()
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }

    func testFetchComics_nextPage_fromAnotherPage_fail() async throws {

        var numPage = 0
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.fetchResult = .mock(comics: comics)

        //When
        remoteService.fetchCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, numPage * 20)
        }
        let comicsFecthed = try await classUnderTest.fetchNextPageComics()
        XCTAssertEqual(comics, comicsFecthed)
        numPage += 1

        remoteService.fetchResult = nil

        do {
            let _ = try await classUnderTest.fetchNextPageComics()
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}
