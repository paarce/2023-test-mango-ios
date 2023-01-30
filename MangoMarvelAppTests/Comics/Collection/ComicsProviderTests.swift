//
//  ComicsCollectionProviderTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsProviderTests: XCTestCase {

    var classUnderTest: ComicsProvider!
    var remoteService: ComicsRemoteServiceStub!
    var localService: ComicsLocalServiceStub!
    var delegate: ComicsStateDelegateStub!

    override func setUpWithError() throws {
        remoteService = .init()
        localService = .init()
        delegate = ComicsStateDelegateStub()
        classUnderTest = ComicsProviderImpl(remoteService:remoteService, localService: localService)
        classUnderTest.delegate = delegate
    }

    override func tearDownWithError() throws {
        remoteService = nil
        delegate = nil
        classUnderTest = nil
    }

    func testInitialFetchComics_success() throws {

        //Given
        var observerCalledCount = 0
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.result = .success(.mock(comics: comics))

        //Then
        remoteService.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 0)
        }
        delegate.updateCalled = { content in
            if case .success(let comicsFecthed) = content {
                XCTAssertEqual(comics, comicsFecthed)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchComics()
    }

    func testFetchComics_nextPage_success() throws {

        //Given
        var observerCalledCount = 0
        let comics: [Comic] = [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
        ]
        remoteService.result = .success(.mock(offset: 0, comics: comics))

        //Then
        remoteService.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 20)
        }
        delegate.updateCalled = { content in
            if case .success(let comicsFecthed) = content {
                XCTAssertEqual(comics, comicsFecthed)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchComicsNextPage()
    }

    func testFetchComics_reload_fromAnotherPage_success() throws {

        //Given
        var observerCalledCount = 0
        let numPage = Int.random(in: 2..<10)
        let offset = numPage * 20
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.result = .success(.mock(offset: offset, comics: comics))
        classUnderTest.fetchComicsNextPage()

        //Then
        remoteService.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, offset)
        }
        delegate.updateCalled = { content in
            if case .success(let comicsFecthed) = content {
                XCTAssertEqual(comics, comicsFecthed)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchComics()
    }

    func testFetchComics_nextPage_fromAnotherPage_success() throws {

        //Given
        var observerCalledCount = 0
        let numPage = Int.random(in: 2..<10)
        let comics: [Comic] = .collectionMock(count: 3)
        remoteService.result = .success(.mock(offset: numPage * 20, comics: comics))
        classUnderTest.fetchComicsNextPage()

        //Then
        remoteService.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, (numPage + 1) * 20)
        }
        delegate.updateCalled = { content in
            if case .success(let comicsFecthed) = content {
                XCTAssertEqual(comics, comicsFecthed)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchComicsNextPage()
    }

    func testInitialFetchComics_fail() throws {

        //Given
        var observerCalledCount = 0
        remoteService.result = .failure(APIError.serverError)

        //Then
        remoteService.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 0)
        }
        delegate.updateCalled = { content in
            if case .fail(let error) = content,
               let apiError = try? XCTUnwrap(error as? APIError) {
                XCTAssertEqual(apiError.errorDescription, APIError.serverError.errorDescription)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchComics()
    }

    func testFetchComics_nextPage_fromAnotherPage_fail() throws {

        //Given
        var observerCalledCount = 0
        remoteService.result = .failure(APIError.serverError)

        //Then
        remoteService.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 20)
        }
        delegate.updateCalled = { content in
            if case .fail(let error) = content,
               let apiError = try? XCTUnwrap(error as? APIError) {
                XCTAssertEqual(apiError.errorDescription, APIError.serverError.errorDescription)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchComicsNextPage()
    }
}
