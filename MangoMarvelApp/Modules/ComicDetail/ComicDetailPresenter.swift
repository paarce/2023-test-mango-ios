//
//  ComicDetailPresenter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 8/2/23.
//

import SwiftUI

struct ComicDetailPresenter {

    let comic: Comic

    func galleryImages() -> [CarouselImagItemView] {
        comic.images.compactMap({
            guard let url = $0.url else { return nil }
            return CarouselImagItemView(url: url)
        })
    }
    
}

struct CarouselImagItemView: View {

    let url: URL

    var body: some View {
        RemoteImage(url: url, placeholder: { Image("placeholderImage") })
            .aspectRatio(contentMode: .fit)
    }
}
