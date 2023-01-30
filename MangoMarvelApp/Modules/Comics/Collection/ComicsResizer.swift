//
//  ComicsResizer.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 30/1/23.
//

import Foundation

protocol ComicsResizer {
    func cellSize(from frameSize: CGSize, in identifier: String) -> CGSize
}

final class ComicsResizerImpl: ComicsResizer {

    func cellSize(from frameSize: CGSize, in identifier: String) -> CGSize {
        if identifier == ComicCollectionViewCell.identifier {
            return .init(
                width: (frameSize.width / 2) - 1,
                height: (frameSize.height / 4) - 4
            )
        } else if identifier == InfoCollectionViewCell.identifier {
            return .init(width: frameSize.width, height: frameSize.height)
        } else {
            return .zero
        }
    }
}
