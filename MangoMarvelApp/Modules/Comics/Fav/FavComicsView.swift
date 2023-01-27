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
          .navigationBarTitle(Text("Favorites comics"))
        }
    }


}

struct FavComicsView_Previews: PreviewProvider {
    static var previews: some View {
        FavComicsView(viewModel: .init(interaction: FavComicInteraction(context: AppState.shared.persistenContext)))
    }
}
