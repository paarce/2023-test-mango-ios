//
//  ErrorDTO.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 25/1/23.
//

import Foundation

struct ErrorDTO {

    let message: String

    init(error: Error) {
        self.message = error.localizedDescription
    }
}
