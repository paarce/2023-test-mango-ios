//
//  ComicGridModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 28/2/23.
//
import Foundation
import UIKit

class ComicGridModel: ObservableObject {

    let id: Int
    let title: String
    @Published var image: UIImage?
    var size: CGSize {
        image?.size ?? .init(width: 300, height: .random(in: 100...300))
    }

    init(comic: Comic) {
        id = comic.id
        title = comic.title
        guard let url = comic.thumbnail.url else { return }
        ImageRemote.downloadImage(from: url, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        })
    }
}

extension ComicGridModel: Equatable {
    static func == (lhs: ComicGridModel, rhs: ComicGridModel) -> Bool {
        lhs.id == rhs.id
    }
}
