//
//  FavComicsView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import SwiftUI

struct FavComicsView: View {

    var viewModel: FavComicViewModel

    init(viewModel: FavComicViewModel) {
        self.viewModel = viewModel
    }

    @FetchRequest(
      entity: FavComic.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \FavComic.inlcudedDate, ascending: true)
      ]
    ) var favs: FetchedResults<FavComic>

    var body: some View {

        NavigationView {
          List {
            ForEach(favs, id: \.title) {
                Text($0.title ?? "")
            }
            .onDelete(perform: {
                viewModel.deleteFavs(from: Array(favs), at: $0)
            })
          }
          .navigationBarTitle(Text(Constants.navTitle))
        }
    }

    enum Constants {
        static let navTitle = "COMICS_FAVORITES_TITLE".localized
    }
}

struct FavComicsView_Previews: PreviewProvider {
    static var previews: some View {
        FavComicsView(viewModel: .init(localService: AppState.shared.coodinator.services.comicsLocalService))
    }
}
