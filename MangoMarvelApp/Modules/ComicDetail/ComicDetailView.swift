//
//  ComicDetailView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 8/2/23.
//

import SwiftUI

struct ComicDetailView: View {

    let presenter: ComicDetailPresenter

    var body: some View {
        GeometryReader { proxy in

            VStack {
                CarouselImagesView(height: proxy.size.height / 3, items: presenter.galleryImages())
                    .background(Color.red)

                if let title = presenter.comic?.title {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(Font.largeTitle)
                } else {
                    Text("Unable to load the detail information")
                }

                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
    }

}

struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetailView(presenter:
            .init(comic: ComicDetailView_Previews.comic)
        )
    }
}

extension ComicDetailView_Previews {
    static let comic: Comic = .init(
        id: 1,
        digitalId: nil,
        title: "MOCK ",
        description: nil,
        thumbnail: .init(path: "", fileExtension: ""),
        prices: [],
        dates: [],
        images: [],
        creators: .init(items: [], collectionURI: nil),
        stories: .init(items: [], collectionURI: nil),
        events: .init(items: [], collectionURI: nil)
    )
}
