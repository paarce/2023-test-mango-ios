//
//  ComicsCollectionUseCase.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsPresenterTests: XCTestCase {

    var delegate: ComicsViewStateDelegateStub!
    var classUnderTest: ComicsPresenter!
    var provider: ComicsProviderStub!

    override func setUpWithError() throws {
        provider = ComicsProviderStub()
        delegate = .init()
        classUnderTest = ComicsPresenterImpl(provider: provider, delegate: delegate)
        classUnderTest.delegate = delegate
    }

    override func tearDownWithError() throws {
        provider = nil
        classUnderTest = nil
    }

    func testInitView_success() throws {
        let exp = expectation(description: "Call reload")
        var refreshCount = 0
        delegate.onCalled = {
            refreshCount += 1
            if refreshCount == 2 {
                exp.fulfill()
            }
        }

        provider.reloadResult = .collectionMock(count: 2)
        classUnderTest.initView()

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
        delegate.onCalled = {
            refreshCount += 1
            if refreshCount == 2 {
                exp.fulfill()
            }
        }
        classUnderTest.initView()

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

        let exp = expectation(description: "Call reload")
        var refreshCount = 0
        delegate.onCalled = {
            refreshCount += 1
            if refreshCount == 2 {
                exp.fulfill()
            }
        }
        provider.reloadResult = .collectionMock(count: 2)
        classUnderTest.reload()

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(provider.reloadCount, 1)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.success', got: \(classUnderTest.state)")
            return
        }

        XCTAssertEqual(comicsFecthed.count, 2)
    }

    func testReload_fail() throws {
        let exp = expectation(description: "Call reload")
        var refreshCount = 0
        delegate.onCalled = {
            refreshCount += 1
            if refreshCount == 2 {
                exp.fulfill()
            }
        }

        classUnderTest.reload()

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)

        waitForExpectations(timeout: 0.1, handler: nil)
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

        classUnderTest = ComicsPresenterImpl(state: .fail(APIError.serverError), provider: provider, delegate: delegate)
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

        classUnderTest = ComicsPresenterImpl(state: .loading, provider: provider, delegate: delegate)

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
        let exp = expectation(description: "Call fecth next page")

        classUnderTest = ComicsPresenterImpl(state: .success(.collectionMock(count: 3)), provider: provider, delegate: delegate)
        delegate.onCalled = {
            exp.fulfill()
        }
        provider.fetchNextPageComicsResult = .collectionMock(count: 10)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)
        waitForExpectations(timeout: 0.1, handler: nil)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 1)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 13)
    }

    func testLoadNextPageIfNeeded_withSuccessState_with10elements() throws {
        classUnderTest = ComicsPresenterImpl(state: .success(.collectionMock(count: 10)), provider: provider, delegate: delegate)
        let exp = expectation(description: "Call fecth next page")
        delegate.onCalled = {
            exp.fulfill()
        }
        provider.fetchNextPageComicsResult = .collectionMock(count: 10)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)
        waitForExpectations(timeout: 0.1, handler: nil)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 1)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 20)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements() throws {
        classUnderTest = ComicsPresenterImpl(state: .success(.collectionMock(count: 20)), provider: provider, delegate: delegate)
        var onCallCount = 0
        delegate.onCalled = {
            onCallCount += 1
        }
        provider.fetchNextPageComicsResult = .collectionMock(count: 10)
        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 1)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)
        XCTAssertEqual(onCallCount, 0)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 20)
    }

    func testLoadNextPageIfNeeded_withSuccessState_withMoreThan10elements_butLastHiigher() throws {
        classUnderTest = ComicsPresenterImpl(state: .success(.collectionMock(count: 20)), provider: provider, delegate: delegate)
        var onCallCount = 0
        delegate.onCalled = {
            onCallCount += 1
        }
        provider.reloadResult = .collectionMock(count: 20)

        classUnderTest.loadNextPageIfNeeded(lastIndexShowed: 200)

        XCTAssertEqual(provider.fecthFavoritesIdsCount, 0)
        XCTAssertEqual(provider.reloadCount, 0)
        XCTAssertEqual(provider.fetchNextPageComicsCount, 0)
        XCTAssertEqual(onCallCount, 0)

        guard case .success(let comicsFecthed) = classUnderTest.state else {
            XCTFail("Unexpected result. Expected '.empty', got: \(classUnderTest.state)")
            return
        }
        XCTAssertEqual(comicsFecthed.count, 20)
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

extension Array where Element == ComicCellViewModel {

    static func collectionMock(
        count: Int,
        interaction: ComicsInteractionDelegate = ComicsInteractionDelegateStub()
    ) -> [ComicCellViewModel] {
        Array<Int>(0..<count)
            .map({ .init(comic: .mock(id: $0), isFav: false, interaction: interaction) })
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
