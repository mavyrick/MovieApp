//
//  GetMovieData.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 24/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import Foundation

final class GetPopularMovieData {
    private lazy var baseURL: URL = {
        return URL(string: "https://api.themoviedb.org/3/movie/popular?")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchPopularMovies(with request: PopularMoviesRequest, page: Int, completion: @escaping (PopularMovies) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL)
        let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(PopularMovies.self, from: data) else {
                return
            }
            
            print(decodedResponse)
            
            completion(decodedResponse)
        }).resume()
    }
}
