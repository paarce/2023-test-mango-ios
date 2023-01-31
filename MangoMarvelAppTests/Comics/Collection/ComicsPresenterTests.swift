//
//  ComicsCollectionUseCase.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsPresenterTests: XCTestCase {

    var classUnderTest: ComicsPresenterImpl!
    var provider: ComicsProviderStub!
    var onRefresh: (() -> Void)!

    override func setUpWithError() throws {
        provider = ComicsProviderStub()
        classUnderTest = ComicsPresenterImpl(provider: provider)
        onRefresh = {}
    }

    override func tearDownWithError() throws {
        provider = nil
        classUnderTest = nil
    }

    func testInitView_success() throws {
        let exp = expectation(description: "Call reload")
        var refreshCount = 0
        onRefresh = {
            refreshCount += 1
            if refreshCount == 2 {
                exp.fulfill()
            }
        }
        provider.reloadResult = .collectionMock(count: 2)
        classUnderTest.initView(onRefresh: onRefresh)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 1)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(refreshCount, 2)
        XCTAssertEqual(provider.reloadCount, 1)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.success', got: \(classUnderTest.state)")
            return
        }

        XCTAssertEqual(comicsFecthed.count, 2)
    }

    func testInitView_fail() throws {
        let exp = expectation(description: "Call reload")
        var refreshCount = 0
        onRefresh = {
            refreshCount += 1
            if refreshCount == 2 {
                exp.fulfill()
            }
        }
        classUnderTest.initView(onRefresh: onRefresh)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 1)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(refreshCount, 2)
        XCTAssertEqual(provider.reloadCount, 1)

        guard case .fail(let error) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.fail', got: \(classUnderTest.state)")
            return
        }
        XCTAssert(error is APIError)
    }

    func testReload_success() throws {

        provider.reloadResult = .collectionMock(count: 2)
        classUnderTest.reload()

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

//        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(provider.reloadCount, 1)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.success', got: \(classUnderTest.state)")
            return
        }

        XCTAssertEqual(comicsFecthed.count, 2)
    }

    func testReload_fail() throws {

        classUnderTest.reload()

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

//        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(provider.reloadCount, 1)

        guard case .fail(let error) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.fail', got: \(classUnderTest.state)")
            return
        }

        XCTAssert(error is APIError)
    }

    func testLoadNextPageIfNeeded_withEmptyState() throws {

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .empty = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
    }

    func testLoadNextPageIfNeeded_withFailState() throws {
        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .fail(let error) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.fail', got: \(classUnderTest.state)")
            return
        }

        XCTAssert(error is APIError)
    }

    func testLoadNextPageIfNeeded_withLoadingState() throws {

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .loading = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.loading', got: \(classUnderTest.state)")
            return
        }
    }

    func testLoadNextPageIfNeeded_withSuccessState_butEmptyArray() throws {

        provider.reloadResult = []

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .empty = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
    }

    func testLoadNextPageIfNeeded_withSuccessState_butFewComicsArray() throws {

        provider.reloadResult = .collectionMock(count: 3)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 3)
    }

    func testLoadNextPageIfNeeded_withSuccessState_with10elements() throws {
        provider.reloadResult = .collectionMock(count: 10)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 10)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements() throws {
//        classUnderTest.update(content: .success(comics: .collectionMock(count: 20), page: 0))

            provider.reloadResult = .collectionMock(count: 20)

            classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

            XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
            XCTAssertEqual(provider.reloadCount, 0)
            XCTAssertEqual(provider.fetchNextPageComicsCount, 1)

            guard case .success(let comicsFecthed) = classUnderTest.state else {
                XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
                return
            }
            XCTAssertEqual(comicsFecthed.count, 20)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements_butLastHiigher() throws {
//        classUnderTest.update(content: .success(comics: .collectionMock(count: 20), page: 0))

        provider.reloadResult = .collectionMock(count: 20)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 200)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 20)

//        XCTAssertNil(provider.fetchComicsPageCalled)
    }
}

extension Array where Element == Comic {

    static func collectionMock(
        count: Int
    ) -> [Comic] {
        Array<Int>(0..<count)
            .map({ .mock(id: $0) })
    }
}

extension ComicDTO {
    static func mock(
        id: Int = 0,
        title: String = ""
    ) -> ComicDTO {
        .init(comic: .mock(id: id, title: title))
    }
}
