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
              ComicListView(presenter:
                ComicListPresenter(interactor: ComicListInteractor())
              )
              .navigationTitle("Comics")
          }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
