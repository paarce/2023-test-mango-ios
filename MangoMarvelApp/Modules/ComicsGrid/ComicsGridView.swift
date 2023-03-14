//
//  ComicGridView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 28/2/23.
//
import SwiftUI

@available(iOS 16.0, *)
struct ComicsGridView: View {

    @ObservedObject var presenter: ComicGridPresenter

    var body: some View {
        ScrollView(.vertical) {
            MansonryLayout(columns: 2) {
                ForEach(presenter.comics.lazy, id: \.id) { comic in
                    presenter.gridCell(comic)
                }
            }
        }
        .onAppear(perform: presenter.initLoad)
    }
}

@available(iOS 16.0, *)
struct ComicGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsGridView(presenter: ComicGridPresenter(
            interactor: ComicListInteractor(limit: 10)
        ))
    }
}
