//
//  ViewController.swift
//  PayKeyAssignment
//
//  Created by Josh Sorokin on 24/11/2019.
//  Copyright © 2019 Enjeera Interactive. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var mainSpinner: UIActivityIndicatorView!
    
    var searchResults: [SearchResult] = []
    
    var movieDetails: MovieDetails?
    
    private var viewModel: PopularMoviesViewModel!
    
    private var shouldShowLoadingCell = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.prefetchDataSource = self
        moviesCollectionView.isPrefetchingEnabled = true

        moviesCollectionView.isHidden = true
        
        let request = PopularMoviesRequest.from()
        viewModel = PopularMoviesViewModel(request: request, delegate: self)
                
        self.title = "Movies"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        mainSpinner.isHidden = true
        
        viewModel.fetchPopularMovies()
        
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
//    Resets search API request each time the user enters a character. Results load after 0.5 seconds of no activity in the search bar.
    private func throttledSearch(for searchText: String) {
        
        guard searchText.count > 0 else {
            self.moviesCollectionView.reloadData()
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(MovieListViewController.reload), object: nil)
        self.perform(#selector(MovieListViewController.reload), with: nil, afterDelay: 0.5)
    }
    
    @objc func reload(searchText: String) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        mainSpinner.isHidden = false
        
        GetMovieSearchData().fetchPopularMovies(query: searchText, page: 1) { (movieSearchData) -> Void in
            
            DispatchQueue.main.async {
                self.mainSpinner.isHidden = true
                self.searchResults = movieSearchData.results
                self.moviesCollectionView.reloadData()
            }
            
        }
    }
    
    private func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MovieDetailsViewController
        {
            let vc = segue.destination as! MovieDetailsViewController
            vc.movieDetails = self.movieDetails
        }
    }
    
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSearching() {
            return searchResults.count
        } else {
            // First 5 pages (20 movies per page * 5)
            return 100
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        if isSearching() {
            cell.searchedMovie = searchResults[indexPath.row]
        } else {
            if isLoadingCell(for: indexPath) {
                cell.updateUIPopular(with: .none)
            } else {
                cell.updateUIPopular(with: viewModel.movieResult(at: indexPath.row))
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var movieID: Int
        if isSearching() {
            movieID = searchResults[indexPath.row].id
        } else {
            movieID = viewModel.movieResult(at: indexPath.row).id
        }
        
        GetMovieDetailsData.shared.getMovieDetailsData(movieID: movieID) { (movieDetailsData) -> Void in
            
            self.movieDetails = movieDetailsData
            
            self.performSegue(withIdentifier: "ShowMovieDetails", sender: indexPath)
            
        }
    }
}

extension MovieListViewController: UICollectionViewDataSourcePrefetching {
//    Can't seem to get this to trigger. The paging should work if this works.
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if isSearching() {
            return
        } else {
            if indexPaths.contains(where: isLoadingCell) {
                viewModel.fetchPopularMovies()
            }
        }
    }
}

extension MovieListViewController: PopularMoviesViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
                        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            moviesCollectionView.isHidden = false
            moviesCollectionView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        moviesCollectionView.reloadItems(at: indexPathsToReload)
    }
    
}

private extension MovieListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = moviesCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        throttledSearch(for: searchController.searchBar.text!)
    }
}
