//
//  HomeViewModel.swift
//  MyMovie
//
//  Created by Ricardo Prestes on 20/10/25.
//

import Foundation

class HomeViewModel {
    private let service = MovieService()
    var movies: [Movie] = []

    func fetchNowPlaying(completion: @escaping () -> Void) {
        service.fetchNowPlaying { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    completion()
                case .failure(let error):
                    print("Erro ao buscar filmes: \(error)")
                    completion()
                }
            }
        }
    }
}
