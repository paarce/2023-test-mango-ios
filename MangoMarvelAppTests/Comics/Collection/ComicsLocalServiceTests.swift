//
//  ComicsLocalServiceTests.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 31/1/23.
//

import XCTest
import CoreData
@testable import MangoMarvelApp

final class ComicsLocalServiceTests: XCTestCase {

    var context: NSManagedObjectContext!
    var classUnderTest: ComicsLocalService!

    override func setUpWithError() throws {
        context = TestCoreDataStack().persistentContainer.newBackgroundContext()
        classUnderTest = ComicsLocalServiceImpl(context: context)
    }

    override func tearDownWithError() throws {
        context = nil
        classUnderTest = nil
    }

    func testAddFavoriteComic_sucess() throws {

        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        let dto: ComicDTO = .mock(id: 1, title: "MOCK 1")
        try classUnderTest.addFav(comic: dto)

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        //When
        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", dto.id)
        let result = try context.fetch(fetchRequest)
        let finalFav = try XCTUnwrap(result.first)

        //Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(finalFav.id, Int32(dto.id))
        XCTAssertEqual(finalFav.title, dto.title)
    }

    func testAddFavoriteComic_withSameID_fail() throws {

        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        let dto1: ComicDTO = .mock(id: 1, title: "MOCK 1-1")
        let dto2: ComicDTO = .mock(id: 1, title: "MOCK 1-2")

        //When
        try classUnderTest.addFav(comic: dto1)
        try classUnderTest.addFav(comic: dto2)

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", dto1.id)
        let result = try context.fetch(fetchRequest)
        XCTAssertEqual(result.count, 1)

        //Then
        let finalFav = try XCTUnwrap(result.first)
        XCTAssertEqual(finalFav.id, Int32(dto1.id))
        XCTAssertEqual(finalFav.title, dto1.title)
    }

    func testRemoveExistingComic_success() throws {

        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        let dto1: ComicDTO = .mock(id: 1, title: "MOCK 1-1")
        //When
        try classUnderTest.addFav(comic: dto1)
        try classUnderTest.removeFav(comic: dto1)

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", dto1.id)
        let result = try context.fetch(fetchRequest)
        XCTAssertEqual(result.count, 0)
    }

    func testRemoveExistingFavComic_success() throws {

        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        let dto1: ComicDTO = .mock(id: 1, title: "MOCK 1-1")
        //When
        try classUnderTest.addFav(comic: dto1)

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %i", dto1.id)
        let resultBefore = try context.fetch(fetchRequest)

        //Then
        let finalFav = try XCTUnwrap(resultBefore.first)
        try classUnderTest.remove(fav: finalFav)

        let resultAfter = try context.fetch(fetchRequest)
        XCTAssertEqual(resultAfter.count, 0)
    }

    func testRemoveUnexistingFavComic() throws {

        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
            return true
        }
        let fav: FavComic = .mock(id: 1, context: context)
        //When
        try classUnderTest.remove(fav: fav)

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }

        let fetchRequest: NSFetchRequest<FavComic> = FavComic.fetchRequest()
        let result = try context.fetch(fetchRequest)
        XCTAssertEqual(result.count, 0)
    }

    func testFetchFadvoritesComics() throws {

        try classUnderTest.addFav(comic: .mock(id: 1))
        try classUnderTest.addFav(comic: .mock(id: 2))
        try classUnderTest.addFav(comic: .mock(id: 3))
        try classUnderTest.addFav(comic: .mock(id: 4))
        try classUnderTest.addFav(comic: .mock(id: 5))

        let result = classUnderTest.fetch()

        XCTAssertEqual(result.count, 5)
    }

    func testAddAnRemoveSeveralComics_andFetchThem() throws {

        try classUnderTest.addFav(comic: .mock(id: 1))
        try classUnderTest.addFav(comic: .mock(id: 2))

        var result = classUnderTest.fetch()
        XCTAssertEqual(result.count, 2)

        try classUnderTest.addFav(comic: .mock(id: 3))
        result = classUnderTest.fetch()
        XCTAssertEqual(result.count, 3)

        try classUnderTest.removeFav(comic: .mock(id: 1))
        result = classUnderTest.fetch()
        XCTAssertEqual(result.count, 2)
    }
}

extension FavComic {
    static func mock(
        id: Int32,
        context: NSManagedObjectContext = TestCoreDataStack().persistentContainer.viewContext
    ) -> FavComic {
        let fav = FavComic(context: TestCoreDataStack().persistentContainer.viewContext)
        fav.id = id
        return fav
    }
}
