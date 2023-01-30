//
//  ModuleCoordinatorTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import XCTest
@testable import MangoMarvelApp

final class ModuleCoordinatorTests: XCTestCase {

    var classUnderTest: ModuleCoordinator!

    override func setUpWithError() throws {
        classUnderTest = .init(.init(services: .init(context: PersistenceMock().managedObjectContext())))
    }

    override func tearDownWithError() throws {
        classUnderTest = nil
    }

    func testCreateMainNavigator() throws {
        let nav = classUnderTest.createMainNavigator()

        XCTAssertNotNil(nav.viewControllers.first is ComicsCollectionViewController)
    }

    func testCreateComicsCollection() throws {
        let viewController = classUnderTest.createComicsCollection()

        XCTAssertNotNil(viewController is ComicsCollectionViewController)
    }
}
