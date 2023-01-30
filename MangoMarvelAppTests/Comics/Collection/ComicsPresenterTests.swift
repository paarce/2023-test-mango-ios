//
//  ComicsCollectionUseCase.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsCollectionUseCaseTests: XCTestCase {

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
        XCTAssertTrue(provider.fetchComicsCalled)
    }

    func testInitView_withLoadingState() throws {

        classUnderTest.update(content: .loading)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertTrue(provider.fetchComicsCalled)
    }

    func testInitView_withSucccesState() throws {

        classUnderTest.update(content: .success([]))

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertTrue(provider.fetchComicsCalled)
    }

    func testInitView_withFailState() throws {

        classUnderTest.update(content: .fail(APIError.serverError))

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.delegate)
        XCTAssertTrue(provider.fetchComicsCalled)
    }

    func testClose() throws {

        classUnderTest.close()
        XCTAssertNil(provider.delegate)
    }

    func testReload() throws {

        classUnderTest.reload()
        XCTAssertTrue(provider.fetchComicsCalled)
    }

    func testLoadNextPageIfNeeded_withEmptyState() throws {

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withFailState() throws {
        classUnderTest.update(content: .fail(APIError.serverError))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withLoadingState() throws {
        classUnderTest.update(content: .loading)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butEmptyArray() throws {
        classUnderTest.update(content: .success([]))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butFewComicsArray() throws {

        classUnderTest.update(content: .success(.collectionMock(count: 3)))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertTrue(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_with10elements() throws {
        classUnderTest.update(content: .success(.collectionMock(count: 10)))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertTrue(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements() throws {
        classUnderTest.update(content: .success(.collectionMock(count: 20)))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchComicsNextPageCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements_butLastHiigher() throws {

        classUnderTest.update(content: .success(.collectionMock(count: 20)))

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 200)

        XCTAssertFalse(provider.fetchComicsNextPageCalled)
    }

    func testCellSize_withComicCell() throws {

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: ComicCollectionViewCell.identifier)

        XCTAssertEqual(size, .init(width: 49, height: 21))
    }

    func testCellSize_withInfoCell() throws {

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: InfoCollectionViewCell.identifier)

        XCTAssertEqual(size, .init(width: 100, height: 100))
    }

    func testCellSize_withRamdom() throws {

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: "CELL")

        XCTAssertEqual(size, .zero)
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
