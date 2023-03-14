//
//  ContentView.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 7/2/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                if #available(iOS 16.0, *) {
                    ComicsGridView(presenter: .init(interactor: .init(limit: 10)))
                        .navigationTitle("Comics")
                } else {
                    ComicListView(presenter: ComicListPresenter(interactor: ComicListInteractor()))
                        .navigationTitle("Comics")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
