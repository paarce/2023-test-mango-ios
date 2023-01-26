//
//  ComicsCollectionUseCase.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsCollectionUseCaseTests: XCTestCase {

    var classUnderTest: ComicsCollectionUseCaseRepresenable!
    var provider: ComicsCollectionProviderStub!

    override func setUpWithError() throws {
        provider = ComicsCollectionProviderStub()
    }

    override func tearDownWithError() throws {
        provider = nil
        classUnderTest = nil
    }

    func testInitView() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(classUnderTest.onRefresh)
        XCTAssertNotNil(provider.observer)
        XCTAssertTrue(provider.reloadCalled)
    }

    func testInitView_withLoadingState() throws {

        classUnderTest = ComicsCollectionUseCase(state: .loading, provider: provider)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(classUnderTest.onRefresh)
        XCTAssertNotNil(provider.observer)
        XCTAssertFalse(provider.reloadCalled)
    }

    func testInitView_withSucccesState() throws {

        classUnderTest = ComicsCollectionUseCase(state: .success([]), provider: provider)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(classUnderTest.onRefresh)
        XCTAssertNotNil(provider.observer)
        XCTAssertTrue(provider.reloadCalled)
    }

    func testInitView_withFailState() throws {

        classUnderTest = ComicsCollectionUseCase(state: .fail(.init(error: APIError.serverError)), provider: provider)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(classUnderTest.onRefresh)
        XCTAssertNotNil(provider.observer)
        XCTAssertTrue(provider.reloadCalled)
    }

    func testClose() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider)
        classUnderTest.close()
        XCTAssertNil(provider.observer)
    }

    func testReload() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider)
        classUnderTest.reload()
        XCTAssertTrue(provider.reloadCalled)
    }

    func testLoadNextPageIfNeeded_withEmptyState() throws {
        classUnderTest = ComicsCollectionUseCase(provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withFailState() throws {
        classUnderTest = ComicsCollectionUseCase(state: .fail(.init(error: APIError.serverError)), provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withLoadingState() throws {
        classUnderTest = ComicsCollectionUseCase(state: .loading, provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butEmptyArray() throws {
        classUnderTest = ComicsCollectionUseCase(state: .success([]), provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butFewComicsArray() throws {
        classUnderTest = ComicsCollectionUseCase(state: .success([.mock(id: 1), .mock(id: 2), .mock(id: 3)]), provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertTrue(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_with10elements() throws {

        let comics: [ComicDTO] = [
            .mock(id: 1), .mock(id: 2), .mock(id: 3),
            .mock(id: 4), .mock(id: 5), .mock(id: 6),
            .mock(id: 7), .mock(id: 8), .mock(id: 9),
            .mock(id: 10)
        ]
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertTrue(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements() throws {

        let comics: [ComicDTO] = [
            .mock(id: 1), .mock(id: 2), .mock(id: 3),
            .mock(id: 4), .mock(id: 5), .mock(id: 6),
            .mock(id: 7), .mock(id: 8), .mock(id: 9),
            .mock(id: 10),
            .mock(id: 11), .mock(id: 12), .mock(id: 13),
            .mock(id: 14), .mock(id: 15), .mock(id: 16),
            .mock(id: 17), .mock(id: 18), .mock(id: 19),
        ]
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements_butLastHiigher() throws {

        let comics: [ComicDTO] = [
            .mock(id: 1), .mock(id: 2), .mock(id: 3),
            .mock(id: 4), .mock(id: 5), .mock(id: 6),
            .mock(id: 7), .mock(id: 8), .mock(id: 9),
            .mock(id: 10),
            .mock(id: 11), .mock(id: 12), .mock(id: 13),
            .mock(id: 14), .mock(id: 15), .mock(id: 16),
            .mock(id: 17), .mock(id: 18), .mock(id: 19),
        ]
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 200)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testCellSize_withComicCell() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider)

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: ComicCollectionViewCell.identifier)

        XCTAssertEqual(size, .init(width: 49, height: 21))
    }

    func testCellSize_withInfoCell() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider)

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: InfoCollectionViewCell.identifier)

        XCTAssertEqual(size, .init(width: 100, height: 100))
    }

    func testCellSize_withRamdom() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider)

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: "CELL")

        XCTAssertEqual(size, .zero)
    }
}

extension ComicDTO {
    static func mock(
        id: Int = 0
    ) -> ComicDTO {
        .init(comic: .mock(id: id))
    }
}
