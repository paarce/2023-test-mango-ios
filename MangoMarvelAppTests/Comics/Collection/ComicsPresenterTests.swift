//
//  ComicsCollectionUseCase.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsPresenterTests: XCTestCase {

    var classUnderTest: ComicsPresenter!
    var provider: ComicsProviderStub!

    override func setUpWithError() throws {
        provider = ComicsProviderStub()
        classUnderTest = ComicsPresenterImpl(provider: provider)
    }

    override func tearDownWithError() throws {
        provider = nil
        classUnderTest = nil
    }

    func testInitView() throws {

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertEqual(provider.fetchComicsPageCalled, 0)
    }

    func testInitView_withLoadingState() throws {

        classUnderTest.update(content: .loading)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertEqual(provider.fetchComicsPageCalled, 0)
    }

    func testInitView_withSucccesState() throws {

        classUnderTest.update(content: .success(comics: [], page: 0))

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertEqual(provider.fetchComicsPageCalled, 0)
    }

    func testInitView_withFailState() throws {

        classUnderTest.update(content: .fail(APIError.serverError))

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertEqual(provider.fetchComicsPageCalled, 0)
    }

    func testClose() throws {

        classUnderTest.close()
        XCTAssertNil(provider.delegate)
    }

    func testReload() throws {

        classUnderTest.reload()
        XCTAssertEqual(provider.fetchComicsPageCalled, 0)
    }

    func testLoadNextPageIfNeeded_withEmptyState() throws {

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertNil(provider.fetchComicsPageCalled)
    }

    func testLoadNextPageIfNeeded_withFailState() throws {
        classUnderTest.update(content: .fail(APIError.serverError))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertNil(provider.fetchComicsPageCalled)
    }

    func testLoadNextPageIfNeeded_withLoadingState() throws {
        classUnderTest.update(content: .loading)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertNil(provider.fetchComicsPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butEmptyArray() throws {
        classUnderTest.update(content: .success(comics: [], page: 0))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertNil(provider.fetchComicsPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butFewComicsArray() throws {

        classUnderTest.update(content: .success(comics: .collectionMock(count: 3), page: 0))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fetchComicsPageCalled, 1)
    }

    func testLoadNextPageIfNeeded_withSuccessState_with10elements() throws {
        classUnderTest.update(content: .success(comics: .collectionMock(count: 10), page: 0))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fetchComicsPageCalled, 1)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements() throws {
        classUnderTest.update(content: .success(comics: .collectionMock(count: 20), page: 0))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertNil(provider.fetchComicsPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements_butLastHiigher() throws {

        classUnderTest.update(content: .success(comics: .collectionMock(count: 20), page: 0))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 200)

        XCTAssertNil(provider.fetchComicsPageCalled)
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
        id: Int = 0
    ) -> ComicDTO {
        .init(comic: .mock(id: id))
    }
}
