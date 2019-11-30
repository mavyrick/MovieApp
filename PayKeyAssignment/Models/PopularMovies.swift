//
//  PopularMovie.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 24/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import Foundation

// MARK: - PopularMovie
struct PopularMovies: Codable {
    let page, totalResults, totalPages: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Movie: Codable {
    let popularity: Double
    let posterPath: String
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case popularity
        case posterPath = "poster_path"
        case id
        case title
    }
}
