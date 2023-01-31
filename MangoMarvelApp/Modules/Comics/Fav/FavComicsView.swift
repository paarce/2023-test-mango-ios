//
//  FavComicsView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import SwiftUI

struct FavComicsView: View {

    @ObservedObject var viewModel: FavComicViewModel

    init(viewModel: FavComicViewModel) {
        self.viewModel = viewModel
    }

//    @FetchRequest(
//      entity: FavComic.entity(),
//      sortDescriptors: [
//        NSSortDescriptor(keyPath: \FavComic.inlcudedDate, ascending: true)
//      ]
//    ) var favs: FetchedResults<FavComic>

    var body: some View {

        NavigationView {
          List {
              ForEach(viewModel.favs, id: \.title) {
                  RowView(favComic: $0, completion: { comic in
                      viewModel.moveToDetail(fav: comic)
                  })
            }
            .onDelete(perform: {
                viewModel.deleteFavs(at: $0)
            })
          }
          .navigationBarTitle(Text(Constants.navTitle))
        }
        .onAppear(perform: viewModel.fetchFavoriteComics)
    }

    enum Constants {
        static let navTitle = "COMICS_FAVORITES_TITLE".localized
    }
}

struct RowView: View {

    let favComic: FavComic
    let completion: (FavComic) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(favComic.title ?? "")
            if let date = favComic.dateFormatted {
                Text(String.localizedStringWithFormat("COMICS_FAVORITES_DATE".localized, date))
                    .font(.footnote)
                    .fontWeight(.light)
            }
        }
        .onTapGesture {
            completion(favComic)
        }
    }
}

struct FavComicsView_Previews: PreviewProvider {
    static var previews: some View {
        FavComicsView(viewModel: .init(
            remoteService: AppState.shared.coodinator.services.comicsRemoteService,
            localService: AppState.shared.coodinator.services.comicsLocalService,
            parentView: UIViewController()
        ))
    }
}
