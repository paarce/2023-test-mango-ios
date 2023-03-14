//
//  TripListInteractor.swift
//  MangoMarvelApp
//
//  Created by Augusto Cordero Perez on 6/2/23.
//

import Foundation

class ComicListInteractor {

    @Published private (set) var comics: [Comic]
    private let remoteService: ComicsRemoteService
    private var page: Int
    private let limit: Int
    private var isLoading = false

    init(service: ComicsRemoteService = ComicsRemoteServiceImpl(), limit: Int = 20) {
        comics = []
        page = 0
        remoteService = service
        self.limit = limit
    }

    func load() {
        guard !isLoading else { return }
        Task {
            do {
                self.comics = try await fetch(page: page)
            } catch {
                print(error)
            }
        }
    }

    func loadNextPage() {
        guard !isLoading else { return }
        Task {
            do {
                let newComics = try await fetch(page: page + 1)
                self.comics.append(contentsOf: newComics)
            } catch {
                print(error)
            }
        }
    }

    private func fetch(page: Int) async throws -> [Comic] {
        isLoading = true
        let reponse = try await remoteService.fecth(options: .init(page: page, limit: limit))
        self.page = reponse.data.offset / limit
        isLoading = false
        return reponse.data.results
    }
}