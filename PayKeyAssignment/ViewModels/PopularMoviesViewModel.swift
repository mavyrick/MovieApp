//
//  PopularMoviesViewModel.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 27/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import Foundation

//Paging only implemented for popular movie request, not search request.

protocol PopularMoviesViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    //  func onFetchFailed(with reason: String)
}

final class PopularMoviesViewModel {
    private weak var delegate: PopularMoviesViewModelDelegate?
    
    private var movieResults: [Movie] = []
//    private var searchResults: [SearchResult] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let popularMoviesClient = GetPopularMovieData()
    
    let searchClient = GetMovieSearchData()
      let request: PopularMoviesRequest
    
    init(request: PopularMoviesRequest, delegate: PopularMoviesViewModelDelegate) {
            self.request = request
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return movieResults.count
    }
    
    func movieResult(at index: Int) -> Movie {
        return movieResults[index]
    }
    
//    func searchResult(at index: Int) -> SearchResult {
//        return searchResults[index]
//    }
    
    func fetchPopularMovies() {
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        popularMoviesClient.fetchPopularMovies(with: request, page: currentPage) { response in
            
            DispatchQueue.main.async {
                
                self.currentPage += 1
                self.isFetchInProgress = false
                
                self.total = response.totalResults
                self.movieResults.append(contentsOf: response.results)
                
                if response.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReloadForPopular(from: response.results)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
    
    private func calculateIndexPathsToReloadForPopular(from newResults: [Movie]) -> [IndexPath] {
        let startIndex = movieResults.count - newResults.count
        let endIndex = startIndex + newResults.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
    
//    func fetchSearchResults(query: String) {
//
//        guard !isFetchInProgress else {
//            return
//        }
//
//        isFetchInProgress = true
//
//        searchClient.fetchPopularMovies(query: query, page: currentPage) { response in
//
//            DispatchQueue.main.async {
//
//                self.currentPage += 1
//                self.isFetchInProgress = false
//
//                self.total = response.totalResults
//                self.searchResults.append(contentsOf: response.results)
//
//                if response.page > 1 {
//                    let indexPathsToReload = self.calculateIndexPathsToReloadForSearch(from: response.results)
//                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
//                } else {
//                    self.delegate?.onFetchCompleted(with: .none)
//                }
//            }
//        }
//    }
    
//    private func calculateIndexPathsToReloadForSearch(from newResults: [SearchResult]) -> [IndexPath] {
//        let startIndex = results.count - newResults.count
//        let endIndex = startIndex + newResults.count
//        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
//    }
