//
//  GetMovieDetailsData.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 25/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import Foundation

class GetMovieDetailsData {
    
    static let shared = GetMovieDetailsData()
    
    var isRequestPending = false
    
    private init() {
    }
    
    func getMovieDetailsData(movieID: Int, completed: @escaping (MovieDetails) -> ()) -> () {
        
        if isRequestPending { return }
        
        isRequestPending = true
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=4e88b625dbac297482453ff84cc7f44a&language=en-US&page=1") else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                let movieDetailsData = try decoder.decode(MovieDetails.self, from: data)
                
                DispatchQueue.main.async {
                    completed(movieDetailsData)
                }
                
                self.isRequestPending = false
                
                return
                
            } catch let err {
                print("Err", err)
            }
        }
        
        task.resume()
        
    }
    
}
