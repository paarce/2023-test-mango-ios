//
//  ComicsCollectionObserverStub.swift
//  MangoMarvelAppTests
//
//  Created by Augusto Cordero Perez on 26/1/23.
//

import Foundation
@testable import MangoMarvelApp

final class ComicsStateDelegateStub: ComicsStateDelegate {

    var updateCalled: ((MangoMarvelApp.ComicsCollectionContent) -> Void)?
    func update(content: MangoMarvelApp.ComicsCollectionContent) {
        updateCalled?(content)
    }
}
