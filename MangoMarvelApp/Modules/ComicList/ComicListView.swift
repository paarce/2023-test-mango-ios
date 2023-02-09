//
//  ComicListView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 6/2/23.
//

import SwiftUI

struct ComicListView: View {

    @State private var searchText = ""
    @ObservedObject var presenter: ComicListPresenter
    private let columns = [
        SwiftUI.GridItem(.flexible()),
        SwiftUI.GridItem(.flexible())
    ]

    var body: some View {

        VStack {
            if !presenter.comics.isEmpty {
                gridView
            }
            switch presenter.state {
            case .loading:
                LoadingGenericListView()
            case .fail:
                ErrorGenericListView()
            default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: presenter.initLoad)
        
    }

    private var gridView: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(presenter.comics) { item in
                        gridCell(item, width: proxy.size.width / 2)
                    }
                }
            }
        }
    }

    private func gridCell(_ comic: Comic, width: CGFloat) -> some View {

        NavigationLink(
            destination: presenter.router.makeDetailView(for: comic),
            label: {
                ComicItemView(comic: comic, width: width)
                    .onAppear(perform: { presenter.loadNextPageIfNeed(comic) })
            }
        )
    }
}

struct ComicItemView: View {
    let comic: Comic
    let width: CGFloat
    private let height: CGFloat = 200

    var body: some View {

        ZStack(alignment: .top) {

            RemoteImage(
                url: comic.thumbnail.url!,
                placeholder: { Image(systemName: "pencil") }
            )
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: width, maxHeight: height)
                .clipped()
                .opacity(0.1)

            Text(comic.title)
                .padding(10)
                .font(Font.system(size: 15, weight: .black))

        }
        .frame(width: width, height: height)

    }
}

struct ComicListView_Previews: PreviewProvider {

    static var previews: some View {
        ComicListView(presenter:
            ComicListPresenter(interactor: ComicListInteractor()
        ))
    }
}

extension Comic: Identifiable { }
