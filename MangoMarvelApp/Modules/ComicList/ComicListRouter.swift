//
//  TripListRouter.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 6/2/23.
//

import SwiftUI

class ComicListRouter {

    func makeDetailView(for comic: Comic?) -> some View {
        ComicDetailView(presenter: .init(comic: comic))
    }
}
