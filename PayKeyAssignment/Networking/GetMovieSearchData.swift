//
//  GetMovieSearchData.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 26/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import Foundation

final class GetMovieSearchData {
    private lazy var baseURL: URL = {
        return URL(string: "https://api.themoviedb.org/3/search/movie?")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchPopularMovies(query: String, page: Int, completion: @escaping (MovieSearch) -> Void) {
        
        let urlRequest = URLRequest(url: baseURL)
        
        let parameters: Parameters = ["api_key": AppConstants.apiKey, "language": "en-US", "query": query, "page": "\(page)", "include_adult": "false"]
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            
            guard let data = data else {
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(MovieSearch.self, from: data) else {
                return
            }
            
            completion(decodedResponse)
        }).resume()
    }
}
