//
//  FavComicViewModel.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 27/1/23.
//

import Foundation
import UIKit

class FavComicViewModel: ObservableObject {

    private let parentView: UIViewController
    private let remoteService: ComicsRemoteService
    private let localService: ComicsLocalService

    @Published var favs: [FavComic] = []

    init(remoteService: ComicsRemoteService , localService: ComicsLocalService, parentView: UIViewController) {
        self.remoteService = remoteService
        self.localService = localService
        self.parentView = parentView
    }

    func fetchFavoriteComics() {
        favs = localService.fetch()
    }

    func deleteFavs(at offsets: IndexSet) {
      offsets.forEach { index in
          try? localService.remove(fav: favs[index])
      }
    }

    func moveToDetail(fav: FavComic) {
        Task {
            do {
                let comic = try await remoteService.find(id: Int(fav.id))
                self.performMoveToDetail(dto: ComicDTO(comic: comic))
            } catch { }
        }
    }

    private func performMoveToDetail(dto: ComicDTO) {
        DispatchQueue.main.async {
            let detailView = AppState.shared.coodinator.createComicDetail(comic: dto)
            self.parentView.navigationController?.pushViewController(detailView, animated: true)
        }
    }
}

extension FavComic {
    var dateFormatted: String? {
        guard let date = self.inlcudedDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}
