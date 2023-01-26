//
//  ComicsCollectionProviderTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsCollectionProviderTests: XCTestCase {

    var classUnderTest: ComicsCollectionProviderReprentable!
    var service: ComicsCollectionServiceStub!
    var observer: ComicsCollectionObserverStub!

    override func setUpWithError() throws {
        service = .init()
        observer = ComicsCollectionObserverStub()
        classUnderTest = ComicsCollectionProvider(service: service)
        classUnderTest.observer = observer
    }

    override func tearDownWithError() throws {
        service = nil
        observer = nil
        classUnderTest = nil
    }

    func testInitialFetchComics_success() throws {

        //Given
        var observerCalledCount = 0
        let comics: [Comic] = [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
        ]
        service.result = .success(.mock(comics: comics))

        //Then
        service.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 0)
        }
        observer.updateCalled = { content in
            if case .success(let comicsFecthed) = content {
                XCTAssertEqual(comics, comicsFecthed)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.reload()
    }

    func testFetchComics_nextPage_success() throws {

        //Given
        var observerCalledCount = 0
        let comics: [Comic] = [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
        ]
        service.result = .success(.mock(offset: 0, comics: comics))

        //Then
        service.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 20)
        }
        observer.updateCalled = { content in
            if case .success(let comicsFecthed) = content {
                XCTAssertEqual(comics, comicsFecthed)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchNextPageIfPossible()
    }

    func testFetchComics_reload_fromAnotherPage_success() throws {

        let numPage = Int.random(in: 2..<10)
        classUnderTest = ComicsCollectionProvider(service: service, page: numPage)

        //Given
        let comics: [Comic] = [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
        ]
        service.result = .success(.mock(comics: comics))

        //Then
        service.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, numPage * 20)
        }
        observer.updateCalled = { content in
            guard case .success(let comicsFecthed) = content else {
                XCTFail("Unexpected result. Expected '.success', got: \(content)")
                return
            }
            XCTAssertEqual(comics, comicsFecthed)
        }

        //When
        classUnderTest.reload()
    }

    func testFetchComics_nextPage_fromAnotherPage_success() throws {

        let numPage = Int.random(in: 2..<10)
        classUnderTest = ComicsCollectionProvider(service: service, page: numPage)

        //Given
        let comics: [Comic] = [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
        ]
        service.result = .success(.mock(comics: comics))

        //Then
        service.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, (numPage + 1) * 20)
        }
        observer.updateCalled = { content in
            guard case .success(let comicsFecthed) = content else {
                XCTFail("Unexpected result. Expected '.success', got: \(content)")
                return
            }
            XCTAssertEqual(comics, comicsFecthed)
        }

        //When
        classUnderTest.fetchNextPageIfPossible()
    }

    func testInitialFetchComics_fail() throws {

        //Given
        var observerCalledCount = 0
        service.result = .failure(APIError.serverError)

        //Then
        service.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 0)
        }
        observer.updateCalled = { content in
            if case .fail(let error) = content,
               let apiError = try? XCTUnwrap(error as? APIError) {
                XCTAssertEqual(apiError.errorDescription, APIError.serverError.errorDescription)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.reload()
    }

    func testFetchComics_nextPage_fromAnotherPage_fail() throws {

        //Given
        var observerCalledCount = 0
        service.result = .failure(APIError.serverError)

        //Then
        service.fecthCalled = { withOptions in
            XCTAssertEqual(withOptions.offset, 20)
        }
        observer.updateCalled = { content in
            if case .fail(let error) = content,
               let apiError = try? XCTUnwrap(error as? APIError) {
                XCTAssertEqual(apiError.errorDescription, APIError.serverError.errorDescription)
                XCTAssertEqual(observerCalledCount, 1)
            } else if case .loading = content {
                observerCalledCount += 1
            }
        }

        //When
        classUnderTest.fetchNextPageIfPossible()
    }
}
