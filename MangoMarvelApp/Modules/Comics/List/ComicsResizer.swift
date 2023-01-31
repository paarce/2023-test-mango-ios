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

            var height = (frameSize.height / 4) - 4
            if frameSize.height < 400 {
                //landscape iphone
                height = (frameSize.height / 2) - 2
            }
            return .init(
                width: (frameSize.width / 2) - 1,
                height: height
            )
        } else if identifier == InfoCollectionViewCell.identifier {
            return .init(width: frameSize.width, height: frameSize.height)
        } else {
            return .zero
        }
    }
}
