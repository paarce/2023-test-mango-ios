//
//  ComicsResizerTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ComicsResizerTests: XCTestCase {

    var classUnderTest: ComicsResizer!

    override func setUpWithError() throws {
        classUnderTest = ComicsResizerImpl()
    }

    override func tearDownWithError() throws {
        classUnderTest = nil
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
