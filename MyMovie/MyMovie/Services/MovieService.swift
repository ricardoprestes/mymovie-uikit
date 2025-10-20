//
//  MovieService.swift
//  MyMovie
//
//  Created by Ricardo Prestes on 20/10/25.
//

import Foundation

class MovieService {
    private let apiKey = "e5996014250e452a74605becd8a43494"
    private let baseURL = "https://api.themoviedb.org/3"

    func fetchNowPlaying(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/now_playing?api_key=\(apiKey)&language=pt-BR&page=1"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
