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
    var favHandler: FavComicHanlderRepresentable!

    override func setUpWithError() throws {
        provider = ComicsCollectionProviderStub()
        favHandler = FavComicHanlderStub(context: PersistenceMock().managedObjectContext())
    }

    override func tearDownWithError() throws {
        provider = nil
        classUnderTest = nil
    }

    func testInitView() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.observer)
        XCTAssertTrue(provider.reloadCalled)
    }

    func testInitView_withLoadingState() throws {

        classUnderTest = ComicsCollectionUseCase(state: .loading, provider: provider, favComicsHandler: favHandler)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.observer)
        XCTAssertFalse(provider.reloadCalled)
    }

    func testInitView_withSucccesState() throws {

        classUnderTest = ComicsCollectionUseCase(state: .success([]), provider: provider, favComicsHandler: favHandler)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.observer)
        XCTAssertTrue(provider.reloadCalled)
    }

    func testInitView_withFailState() throws {

        classUnderTest = ComicsCollectionUseCase(state: .fail(.init(error: APIError.serverError)), provider: provider, favComicsHandler: favHandler)

        classUnderTest.initView(onRefresh: {})

        XCTAssertNotNil(provider.observer)
        XCTAssertTrue(provider.reloadCalled)
    }

    func testClose() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)
        classUnderTest.close()
        XCTAssertNil(provider.observer)
    }

    func testReload() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)
        classUnderTest.reload()
        XCTAssertTrue(provider.reloadCalled)
    }

    func testLoadNextPageIfNeeded_withEmptyState() throws {
        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withFailState() throws {
        classUnderTest = ComicsCollectionUseCase(state: .fail(.init(error: APIError.serverError)), provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withLoadingState() throws {
        classUnderTest = ComicsCollectionUseCase(state: .loading, provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butEmptyArray() throws {
        classUnderTest = ComicsCollectionUseCase(state: .success([]), provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_butFewComicsArray() throws {
        let comics: [ComicCellViewModel] = .collectionMock(count: 3, interaction: favHandler.interaction)
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertTrue(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_with10elements() throws {

        let comics: [ComicCellViewModel] = .collectionMock(count: 10, interaction: favHandler.interaction)
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertTrue(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements() throws {

        let comics: [ComicCellViewModel] = .collectionMock(count: 20, interaction: favHandler.interaction)
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements_butLastHiigher() throws {

        let comics: [ComicCellViewModel] = .collectionMock(count: 20, interaction: favHandler.interaction)
        classUnderTest = ComicsCollectionUseCase(state: .success(comics), provider: provider, favComicsHandler: favHandler)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 200)

        XCTAssertFalse(provider.fetchNextPageIfPossibleCalled)
    }

    func testCellSize_withComicCell() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: ComicCollectionViewCell.identifier)

        XCTAssertEqual(size, .init(width: 49, height: 21))
    }

    func testCellSize_withInfoCell() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: InfoCollectionViewCell.identifier)

        XCTAssertEqual(size, .init(width: 100, height: 100))
    }

    func testCellSize_withRamdom() throws {

        classUnderTest = ComicsCollectionUseCase(provider: provider, favComicsHandler: favHandler)

        let size = classUnderTest.cellSize(from: .init(width: 100, height: 100), in: "CELL")

        XCTAssertEqual(size, .zero)
    }
}

extension Array where Element == ComicCellViewModel {

    static func collectionMock(
        count: Int,
        interaction: FavComicInteractionRepresentable
    ) -> [ComicCellViewModel] {
        Array<Int>(0..<count)
            .map({ .mock(id: $0, isFav: false, interaction: interaction) })
    }
}

extension ComicCellViewModel {

    static func mock(
        id: Int,
        isFav: Bool,
        interaction: FavComicInteractionRepresentable
    ) -> ComicCellViewModel {
        .init(comic: .mock(id: id), isFav: isFav, interaction: interaction)
    }
}

extension ComicDTO {
    static func mock(
        id: Int = 0
    ) -> ComicDTO {
        .init(comic: .mock(id: id))
    }
}
